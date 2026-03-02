#!/usr/bin/env python3
"""
Extract synthesis sweep results from Synopsys Design Compiler reports.

Files parsed per sweep point (e.g. syn_045/results_sweep/x1+x2/30/):
  Adder.rpt          - Total Area, Slack (timing)
  power_estimate.log - Total Power, Leakage, Dynamic [SAIF-annotated, last report]

One CSV is written per combination key (e.g. x1+x2 → sweep_results_x1+x2.csv).

Clock Period is taken from the numeric sub-directory name (ns).
Gate Count  = Total Area / NAND2_X1_area / 1000  [Kgates]
              NangateOpenCellLibrary 45nm: NAND2_X1 = 0.8 um^2
Efficiency  = Total Power (uW) / Frequency (MHz)
"""

import os, re, csv, glob

# NangateOpenCellLibrary 45nm NAND2_X1 area in um^2 — used as the unit gate
NAND2_AREA_UM2 = 0.8  # um^2

BASE_DIR   = os.path.dirname(os.path.abspath(__file__))
SWEEP_DIR  = os.path.join(BASE_DIR, "syn_045", "results_sweep")


# ---------------------------------------------------------------------------
# Adder.rpt parsers
# ---------------------------------------------------------------------------

def parse_total_area(lines):
    """
    Reference report line:
        Total 3 references                                  29803.703727
    """
    for line in lines:
        m = re.search(r"^Total\s+\d+\s+references\s+([\d.]+)", line)
        if m:
            return float(m.group(1))
    return None


def parse_slack(lines):
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

            tail = line[m.end():]

            # Try to read the number directly from this line (handles negatives).
            # A full decimal number (with dot) is unambiguous.
            full_num = re.search(r"-?\d+\.\d+", tail)
            if full_num:
                return float(full_num.group(0))

            # No decimal on this line — may be split: "...  0\n.78\n"
            end_int = re.search(r"(-?\d+)\s*$", tail.rstrip("\n"))
            next_line = lines[i + 1] if i + 1 < len(lines) else ""
            dot_cont = re.match(r"\s*(\.\d+)", next_line)
            if end_int and dot_cont:
                # Reconstruct the number; apply sign from VIOLATED/MET keyword
                # because the integer fragment may not carry a minus sign
                return sign * float(end_int.group(1) + dot_cont.group(1))

            # Plain integer on this line
            nums = re.findall(r"-?\d+", tail)
            if not nums:
                return None
            return float(nums[-1])
    return None


def parse_rpt(rpt_path):
    with open(rpt_path) as f:
        lines = f.readlines()
    return {
        "total_area": parse_total_area(lines),
        "slack":      parse_slack(lines),
    }


# ---------------------------------------------------------------------------
# power_estimate.log parsers
# ---------------------------------------------------------------------------

def _to_uW(value, unit):
    """Convert a power value to uW given its unit string."""
    unit = unit.strip().lower()
    if unit == "uw":
        return value
    if unit == "nw":
        return value / 1000.0
    if unit == "mw":
        return value * 1000.0
    raise ValueError(f"Unknown power unit: {unit!r}")


def parse_power_log(log_path):
    """
    Use the LAST 'Report : power' section (SAIF-annotated, high-effort).
    """
    with open(log_path) as f:
        content = f.read()

    sections = content.split("Report : power")
    section = sections[-1] if len(sections) > 1 else content

    m = re.search(
        r"Total Dynamic Power\s+=\s+([\d.]+(?:e[+\-]?\d+)?)\s+(uW|mW|nW)",
        section, re.IGNORECASE)
    dynamic_uW = _to_uW(float(m.group(1)), m.group(2)) if m else None

    m = re.search(
        r"Cell Leakage Power\s+=\s+([\d.]+(?:e[+\-]?\d+)?)\s+(uW|mW|nW)",
        section, re.IGNORECASE)
    leakage_uW = _to_uW(float(m.group(1)), m.group(2)) if m else None

    # Summary table total row — units vary per column, e.g.:
    #   Total   0.0000 mW   50.1159 mW   4.9787e+04 uW   99.9029 mW
    total_uW = None
    unit_pat = r"(?:uW|mW|nW)"
    val_pat  = r"[\d.e+\-]+"
    for m in re.finditer(
        r"^Total\s+"
        + val_pat + r"\s+" + unit_pat + r"\s+"
        + val_pat + r"\s+" + unit_pat + r"\s+"
        + val_pat + r"\s+" + unit_pat + r"\s+"
        + r"(" + val_pat + r")\s+(" + unit_pat + r")",
        section,
        re.MULTILINE,
    ):
        total_uW = _to_uW(float(m.group(1)), m.group(2))

    return {
        "dynamic_uW": dynamic_uW,
        "leakage_uW": leakage_uW,
        "total_uW":   total_uW,
    }


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

FIELDNAMES = [
    "Clock Period (ns)", "Frequency (MHz)", "Total Area (um2)",
    "Gate Count (Kgates)", "Total Power (uW)", "Slack (ns)",
    "Leakage (uW)", "Dynamic (mW)", "Efficiency uW/MHz",
]


def fmt(v, decimals=4):
    return round(v, decimals) if v is not None else ""


def process_period_dir(period_dir, period_ns):
    """Parse one period directory and return a result row, or None on failure."""
    rpt_path = os.path.join(period_dir, "Adder.rpt")
    log_path = os.path.join(period_dir, "power_estimate.log")

    missing = [p for p in (rpt_path, log_path) if not os.path.exists(p)]
    if missing:
        print(f"  Skipping {period_dir}: missing {[os.path.basename(p) for p in missing]}")
        return None

    rpt = parse_rpt(rpt_path)
    pwr = parse_power_log(log_path)

    total_area = rpt["total_area"]
    slack      = rpt["slack"]
    dynamic_uW = pwr["dynamic_uW"]
    leakage_uW = pwr["leakage_uW"]
    total_uW   = pwr["total_uW"]

    if total_area is None:
        print(f"  Warning [{period_ns}ns]: could not parse Total Area")

    freq_MHz      = 1000.0 / period_ns
    gate_count_Kg = (total_area / NAND2_AREA_UM2 / 1000.0) if total_area else None
    dynamic_mW    = (dynamic_uW / 1000.0)                   if dynamic_uW is not None else None
    efficiency    = (total_uW  / freq_MHz)                   if total_uW  is not None else None

    return {
        "Clock Period (ns)":   period_ns,
        "Frequency (MHz)":     round(freq_MHz, 4),
        "Total Area (um2)":    fmt(total_area, 3),
        "Gate Count (Kgates)": fmt(gate_count_Kg, 3),
        "Total Power (uW)":    fmt(total_uW, 4),
        "Slack (ns)":          fmt(slack, 4),
        "Leakage (uW)":        fmt(leakage_uW, 4),
        "Dynamic (mW)":        fmt(dynamic_mW, 6),
        "Efficiency uW/MHz":   fmt(efficiency, 6),
    }


def write_csv(output_csv, rows):
    with open(output_csv, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=FIELDNAMES)
        writer.writeheader()
        writer.writerows(rows)

    print(f"\nWrote {len(rows)} rows → {output_csv}")
    col_w = [max(len(h), 14) for h in FIELDNAMES]
    header = "  ".join(f"{h:<{w}}" for h, w in zip(FIELDNAMES, col_w))
    print(header)
    print("-" * len(header))
    for r in rows:
        print("  ".join(f"{str(r[h]):<{w}}" for h, w in zip(FIELDNAMES, col_w)))


def main():
    # Discover combination-key directories (e.g. "x1+x2", "x3+x4")
    combo_dirs = sorted(
        d for d in glob.glob(os.path.join(SWEEP_DIR, "*"))
        if os.path.isdir(d)
    )

    if not combo_dirs:
        print(f"No subdirectories found in {SWEEP_DIR}")
        return

    for combo_dir in combo_dirs:
        combo_key = os.path.basename(combo_dir)

        # Discover numeric period sub-directories
        period_dirs = sorted(
            glob.glob(os.path.join(combo_dir, "*")),
            key=lambda d: float(os.path.basename(d))
                          if os.path.basename(d).replace(".", "", 1).isdigit()
                          else float("inf"),
        )

        rows = []
        print(f"\n=== Processing combo: {combo_key} ===")
        for period_dir in period_dirs:
            if not os.path.isdir(period_dir):
                continue
            period_str = os.path.basename(period_dir)
            try:
                period_ns = float(period_str)
            except ValueError:
                print(f"  Skipping {period_str}: not a numeric period")
                continue

            row = process_period_dir(period_dir, period_ns)
            if row:
                rows.append(row)

        if not rows:
            print(f"  No valid data found, skipping CSV.")
            continue

        # Sanitise combo_key for use in a filename (replace + with _ etc.)
        safe_key = re.sub(r"[^\w\-.]", "_", combo_key)
        output_csv = os.path.join(BASE_DIR, f"sweep_results_{safe_key}.csv")
        write_csv(output_csv, rows)


if __name__ == "__main__":
    main()