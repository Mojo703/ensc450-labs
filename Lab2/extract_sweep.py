#!/usr/bin/env python3
"""
Extract synthesis sweep results from Synopsys Design Compiler reports.

Files parsed per sweep point (e.g. syn_045/results_sweep/4/):
  Adder.rpt          - Total Area, Slack (timing)
  power_estimate.log - Total Power, Leakage, Dynamic [SAIF-annotated, last report]

Clock Period is taken from the sweep directory name (ns).
Gate Count  = Total Area / NAND2_X1_area / 1000  [Kgates]
              NangateOpenCellLibrary 45nm: NAND2_X1 = 1.064 um^2
Efficiency  = Total Power (uW) / Frequency (MHz)
"""

import os, re, csv, glob

# NangateOpenCellLibrary 45nm NAND2_X1 area in um^2 — used as the unit gate
NAND2_AREA_UM2 = 0.8 # um^2

SWEEP_DIR  = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                           "syn_045", "results_sweep")
OUTPUT_CSV = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                           "sweep_results.csv")


# ---------------------------------------------------------------------------
# Adder.rpt parsers
# ---------------------------------------------------------------------------

def parse_total_area(lines: list[str]) -> float | None:
    """
    Reference report line:
        Total 3 references                                  29803.703727
    """
    for line in lines:
        m = re.search(r"^Total\s+\d+\s+references\s+([\d.]+)", line)
        if m:
            return float(m.group(1))
    return None


def parse_slack(lines: list[str]) -> float | None:
    """
    Timing report line (fixed-width, value may be split across two lines):
        slack (MET)                                                   0
    .00

    Returns positive for MET, negative for VIOLATED.
    """
    for i, line in enumerate(lines):
        m = re.search(r"slack\s+\((MET|VIOLATED)\)", line)
        if m:
            sign = 1 if m.group(1) == "MET" else -1

            # Text after "slack (MET|VIOLATED)" on the same line
            tail = line[m.end():]

            # The number may be split: "...  0\n.00\n"
            # Check if tail ends with an integer and the next line starts with '.'
            end_int = re.search(r"(\d+)\s*$", tail.rstrip("\n"))
            next_line = lines[i + 1] if i + 1 < len(lines) else ""
            dot_cont = re.match(r"\s*(\.\d+)", next_line)

            if end_int and dot_cont:
                val_str = end_int.group(1) + dot_cont.group(1)
            else:
                # Value is fully on this line — take the last number
                nums = re.findall(r"-?[\d]+(?:\.\d+)?", tail)
                if not nums:
                    return None
                val_str = nums[-1]

            return sign * float(val_str)
    return None


def parse_rpt(rpt_path: str) -> dict:
    with open(rpt_path) as f:
        lines = f.readlines()
    return {
        "total_area": parse_total_area(lines),
        "slack":      parse_slack(lines),
    }


# ---------------------------------------------------------------------------
# power_estimate.log parsers
# ---------------------------------------------------------------------------

def _to_uW(value: float, unit: str) -> float:
    """Convert a power value to uW given its unit string."""
    unit = unit.strip().lower()
    if unit == "uw":
        return value
    if unit == "nw":
        return value / 1000.0
    if unit == "mw":
        return value * 1000.0
    raise ValueError(f"Unknown power unit: {unit!r}")


def parse_power_log(log_path: str) -> dict:
    """
    Use the LAST 'Report : power' section (SAIF-annotated, high-effort).

    Extracts:
      - total_dynamic_uW : from  'Total Dynamic Power  = X  uW'
      - leakage_uW       : from  'Cell Leakage Power   = X  uW'
      - total_power_uW   : from  the summary table row
                           'Total  A uW  B uW  C nW  D uW'
    """
    with open(log_path) as f:
        content = f.read()

    # Split into report sections; keep the last one
    sections = content.split("Report : power")
    section = sections[-1] if len(sections) > 1 else content

    # Total Dynamic Power
    m = re.search(
        r"Total Dynamic Power\s+=\s+([\d.]+(?:e[+\-]?\d+)?)\s+(uW|mW|nW)",
        section, re.IGNORECASE)
    dynamic_uW = _to_uW(float(m.group(1)), m.group(2)) if m else None

    # Cell Leakage Power
    m = re.search(
        r"Cell Leakage Power\s+=\s+([\d.]+(?:e[+\-]?\d+)?)\s+(uW|mW|nW)",
        section, re.IGNORECASE)
    leakage_uW = _to_uW(float(m.group(1)), m.group(2)) if m else None

    # Summary table total row:
    # Total  A uW  B uW  C nW  D uW
    total_uW = None
    for m in re.finditer(
        r"Total\s+"
        r"([\d.e+\-]+)\s+uW\s+"
        r"([\d.e+\-]+)\s+uW\s+"
        r"([\d.e+\-]+)\s+nW\s+"
        r"([\d.e+\-]+)\s+uW",
        section,
    ):
        total_uW = float(m.group(4))   # last column is total in uW

    return {
        "dynamic_uW": dynamic_uW,
        "leakage_uW": leakage_uW,
        "total_uW":   total_uW,
    }


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    sweep_dirs = sorted(
        glob.glob(os.path.join(SWEEP_DIR, "*")),
        key=lambda d: float(os.path.basename(d))
    )

    rows = []
    for d in sweep_dirs:
        if not os.path.isdir(d):
            continue
        period_str = os.path.basename(d)
        try:
            period_ns = float(period_str)
        except ValueError:
            print(f"Skipping {period_str}: directory name is not a number")
            continue

        rpt_path = os.path.join(d, "Adder.rpt")
        log_path = os.path.join(d, "power_estimate.log")

        missing = [p for p in (rpt_path, log_path) if not os.path.exists(p)]
        if missing:
            print(f"Skipping {period_str}: missing {missing}")
            continue

        rpt  = parse_rpt(rpt_path)
        pwr  = parse_power_log(log_path)

        total_area  = rpt["total_area"]
        slack       = rpt["slack"]
        dynamic_uW  = pwr["dynamic_uW"]
        leakage_uW  = pwr["leakage_uW"]
        total_uW    = pwr["total_uW"]

        if total_area is None:
            print(f"Warning [{period_str}]: could not parse Total Area")

        freq_MHz        = 1000.0 / period_ns
        gate_count_Kg   = (total_area / NAND2_AREA_UM2 / 1000.0) if total_area else None
        dynamic_mW      = (dynamic_uW / 1000.0)                   if dynamic_uW is not None else None
        efficiency      = (total_uW  / freq_MHz)                   if total_uW  is not None else None

        def fmt(v, decimals=4):
            return round(v, decimals) if v is not None else ""

        rows.append({
            "Clock Period (ns)":    period_ns,
            "Frequency (MHz)":      round(freq_MHz, 4),
            "Total Area (um2)":     fmt(total_area, 3),
            "Gate Count (Kgates)":  fmt(gate_count_Kg, 3),
            "Total Power (uW)":     fmt(total_uW, 4),
            "Slack (ns)":           fmt(slack, 4),
            "Leakage (uW)":         fmt(leakage_uW, 4),
            "Dynamic (mW)":         fmt(dynamic_mW, 6),
            "Efficiency uW/MHz":    fmt(efficiency, 6),
        })

    fieldnames = [
        "Clock Period (ns)", "Frequency (MHz)", "Total Area (um2)",
        "Gate Count (Kgates)", "Total Power (uW)", "Slack (ns)",
        "Leakage (uW)", "Dynamic (mW)", "Efficiency uW/MHz",
    ]

    with open(OUTPUT_CSV, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    print(f"\nWrote {len(rows)} rows → {OUTPUT_CSV}\n")
    # Pretty-print to terminal
    col_w = [max(len(h), 14) for h in fieldnames]
    header = "  ".join(f"{h:<{w}}" for h, w in zip(fieldnames, col_w))
    print(header)
    print("-" * len(header))
    for r in rows:
        print("  ".join(f"{str(r[h]):<{w}}" for h, w in zip(fieldnames, col_w)))


if __name__ == "__main__":
    main()
