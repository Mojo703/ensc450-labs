mod common_types;

use clap::Parser;
use common_types::{EnumLogicVec, LogicVal};
use std::{
    collections::BTreeSet,
    fs,
    io::{self, Write},
    path::{Path, PathBuf},
};

/// Select which test categories to generate.
#[derive(Debug, Parser)]
pub struct Args {
    /// Output file path to write the generated test cases
    #[arg(long, value_name = "FILE", required = true)]
    pub output: PathBuf,
}

#[derive(Debug, Clone, Copy, Hash, Eq, PartialEq, PartialOrd, Ord)]
struct AdderIn {
    a: Option<i128>,
    b: Option<i128>,
    cin: Option<bool>,
}

#[derive(Debug, Clone, Copy, Hash, Eq, PartialEq, PartialOrd, Ord)]
struct AdderOut {
    s: Option<i128>,
    cout: Option<bool>,
    ovfl: Option<bool>,
}

impl AdderOut {
    fn none() -> Self {
        Self {
            s: None,
            cout: None,
            ovfl: None,
        }
    }
}

impl AdderIn {
    fn new(a: i128, b: i128, cin: bool) -> Self {
        Self {
            a: Some(a),
            b: Some(b),
            cin: Some(cin),
        }
    }

    fn perform(self) -> AdderOut {
        let AdderIn { a, b, cin } = self;

        let (Some(a), Some(b), Some(cin)) = (a, b, cin) else {
            return AdderOut::none();
        };

        // Convert to unsigned for addition
        let ua = a.cast_unsigned();
        let ub = b.cast_unsigned();
        let cin_val = if cin { 1u128 } else { 0u128 };

        // Perform addition with carry
        let (sum_low, carry1) = ua.overflowing_add(ub);
        let (sum_final, carry2) = sum_low.overflowing_add(cin_val);
        let cout = carry1 | carry2;

        // Calculate overflow for signed addition
        // Overflow occurs when:
        // - Adding two positive numbers gives a negative result
        // - Adding two negative numbers gives a positive result
        let sa = a;
        let sb = b;
        let s_signed = sum_final.cast_signed();

        let ovfl =
            ((sa >= 0) && (sb >= 0) && (s_signed < 0)) || ((sa < 0) && (sb < 0) && (s_signed >= 0));

        AdderOut {
            s: Some(sum_final.cast_signed()),
            cout: Some(cout),
            ovfl: Some(ovfl),
        }
    }
}

#[derive(Debug, Clone, Copy, Hash, Eq, PartialEq, PartialOrd, Ord)]
struct AdderState {
    input: AdderIn,
    output: AdderOut,
}

impl AdderState {
    fn new(input: AdderIn) -> Self {
        let output = input.perform();
        Self { input, output }
    }

    fn to_vhdl(self) -> String {
        // Defaults for input and output
        const I_D: LogicVal = LogicVal::ForceUnknown;
        const O_D: LogicVal = LogicVal::NotCare;

        let AdderState { input, output } = self;
        let AdderIn { a, b, cin } = input;
        let AdderOut { s, cout, ovfl } = output;

        // Input
        let a = i128::as_logic_vec(a, I_D).to_hex_string();
        let b = i128::as_logic_vec(b, I_D).to_hex_string();
        let cin = bool::as_logic_vec(cin, I_D).to_bits_string();

        // Output
        let s = i128::as_logic_vec(s, O_D).to_hex_string();
        let cout = bool::as_logic_vec(cout, O_D).to_bits_string();
        let ovfl = bool::as_logic_vec(ovfl, O_D).to_bits_string();

        format!(
            r#"(
  a    => x"{a}",
  b    => x"{b}",
  cin  => '{cin}',
  s    => x"{s}",
  cout => '{cout}',
  ovfl => '{ovfl}'
)"#,
        )
    }
}

fn main() -> io::Result<()> {
    let Args { output } = Args::parse();

    let i128_tests = test_i128();

    let cin_tests = [true, false];

    let cases = itertools::iproduct!(i128_tests, cin_tests)
        .map(|((a, b), cin)| AdderIn::new(a, b, cin))
        .map(AdderState::new)
        .collect();

    write_vhdl_package(&output, cases)?;

    Ok(())
}

fn vhdl_entity_name(path: &Path) -> String {
    path.file_stem().unwrap().to_string_lossy().to_string()
}

fn write_vhdl_package(path: &Path, cases: BTreeSet<AdderState>) -> io::Result<()> {
    let entity = vhdl_entity_name(path);

    let file = fs::File::create(path)?;
    let mut w = io::BufWriter::new(file);

    writeln!(w, "library ieee;")?;
    writeln!(w, "use ieee.std_logic_1164.all;")?;
    writeln!(w, "package {entity} is")?;

    // Type declaration
    writeln!(w, "  type AdderCase is record")?;
    writeln!(w, "    a, b, s : std_logic_vector(127 downto 0);")?;
    writeln!(w, "    cin, cout, ovfl : std_logic;")?;
    writeln!(w, "  end record;")?;

    writeln!(
        w,
        "  type AdderCaseArray is array (natural range <>) of AdderCase;"
    )?;
    writeln!(w, "  constant AdderVectors : AdderCaseArray := (")?;

    // All test cases
    let mut count = 0;
    for (i, case) in cases.into_iter().enumerate() {
        let comma = if i == 0 { "  " } else { ", " };
        writeln!(w, "{comma}{case}", case = case.to_vhdl())?;
        count += 1;
    }

    writeln!(w, ");")?;
    writeln!(w, "  constant AdderVectorCount : natural := {count};")?;
    writeln!(w, "end package {entity};")?;

    w.flush()?;
    println!("All {count} test cases written successfully to {path:?}");
    Ok(())
}

fn test_i128() -> Vec<(i128, i128)> {
    const ONES: i128 = !0i128;
    let mut tests = Vec::new();

    tests.push((0, 0));
    tests.push((ONES, 0));
    tests.push((0, ONES));

    for bit in 0..i128::BITS {
        // Single bits
        let v = 1i128 << bit;
        tests.push((v, 0));
        tests.push((0, v));

        // Pair bits
        tests.push((v, v));

        // Chain Carry
        tests.push((v, ONES));
        tests.push((ONES, v));
    }

    for bit in 0..i128::BITS - 1 {
        let x = 1i128 << bit;
        let y = 3i128 << bit;

        // Triple bits
        tests.push((x, y));
        tests.push((y, x));

        // Four bits
        tests.push((y, y));
        tests.push((y, y));
    }

    for bit in 0..i128::BITS - 2 {
        // Five bits
        let x = 5i128 << bit;
        let y = 7i128 << bit;

        tests.push((x, y));
        tests.push((y, x));
    }

    // Alternating bits
    let repeating: [u128; _] = [
        0xAAAA_AAAA_AAAA_AAAA,
        0x5555_5555_5555_5555,
        0xFFFF_FFFF_FFFF_FFFF,
    ];
    for (&a, &b) in itertools::iproduct!(&repeating, &repeating) {
        tests.push((a.cast_signed(), b.cast_signed()));
    }

    // Contiguous
    for n in 0..u128::BITS {
        let a: u128 = ((1 << n) - 1) + (1 << n);
        let b: u128 = ((1 << n) - 1) + ((1 << n) - 1);
        tests.push((a.cast_signed(), b.cast_signed()));
        tests.push((b.cast_signed(), a.cast_signed()));
    }

    tests
}
