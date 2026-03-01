mod common_types;

use clap::Parser;
use common_types::{EnumLogicVec, LogicVal};

use std::{
    collections::BTreeSet,
    fs,
    io::{self, Write},
    path::{Path, PathBuf},
};

// # Configuration
/// Bit width of the adder under test. Must be a positive multiple of 4.
const BIT_WIDTH: usize = 1024;
/// Number of test cases to randomly select for output.
const TEST_COUNT: usize = 1024;
/// Concrete BitVec type for this adder width.
type BitVec = common_types::BitVec<BIT_WIDTH, WORD_COUNT>;

// # Derived constants (do not edit)
const WORD_COUNT: usize = BIT_WIDTH.div_ceil(64);
// Compile-time checks
const _: () = assert!(BIT_WIDTH > 0);
const _: () = assert!(BIT_WIDTH.is_multiple_of(4));

/// Generate adder test vectors for VHDL testbenches.
#[derive(Debug, Parser)]
pub struct Args {
    /// Output file path to write the generated test cases.
    #[arg(long, value_name = "FILE", required = true)]
    pub output: PathBuf,
}

struct SimpleRng {
    state: u64,
}

impl SimpleRng {
    fn new(seed: u64) -> Self {
        Self {
            state: if seed == 0 { 1 } else { seed },
        }
    }

    fn next_u64(&mut self) -> u64 {
        self.state ^= self.state << 13;
        self.state ^= self.state >> 7;
        self.state ^= self.state << 17;
        self.state
    }

    fn shuffle<T>(&mut self, slice: &mut [T]) {
        for i in (1..slice.len()).rev() {
            let j = (self.next_u64() as usize) % (i + 1);
            slice.swap(i, j);
        }
    }
}

#[derive(Debug, Clone, Copy, Hash, Eq, PartialEq, PartialOrd, Ord)]
struct AdderIn {
    a: Option<BitVec>,
    b: Option<BitVec>,
    cin: Option<bool>,
}

#[derive(Debug, Clone, Copy, Hash, Eq, PartialEq, PartialOrd, Ord)]
struct AdderOut {
    s: Option<BitVec>,
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
    fn new(a: BitVec, b: BitVec, cin: bool) -> Self {
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

        let (s, cout, ovfl) = a.add_with_carry(b, cin);

        AdderOut {
            s: Some(s),
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
        let a = BitVec::as_logic_vec(a, I_D).to_hex_string();
        let b = BitVec::as_logic_vec(b, I_D).to_hex_string();
        let cin = bool::as_logic_vec(cin, I_D).to_bits_string();

        // Output
        let s = BitVec::as_logic_vec(s, O_D).to_hex_string();
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

fn generate_test_pairs() -> Vec<(BitVec, BitVec)> {
    let zero = BitVec::zero();
    let ones = BitVec::ones();
    let mut tests = Vec::new();

    // Basic cases
    tests.push((zero, zero));
    tests.push((ones, zero));
    tests.push((zero, ones));

    for bit in 0..BIT_WIDTH {
        let v = BitVec::single_bit(bit);

        // Single bits
        tests.push((v, zero));
        tests.push((zero, v));

        // Pair bits
        tests.push((v, v));

        // Chain carry
        tests.push((v, ones));
        tests.push((ones, v));
    }

    // Triple & four bits: patterns 1 and 3 shifted
    for bit in 0..BIT_WIDTH.saturating_sub(1) {
        let x = BitVec::single_bit(bit);
        let y = BitVec::from_u64(3).shl(bit);

        tests.push((x, y));
        tests.push((y, x));
        tests.push((y, y));
    }

    // Five bits: patterns 5 and 7 shifted
    for bit in 0..BIT_WIDTH.saturating_sub(2) {
        let x = BitVec::from_u64(5).shl(bit);
        let y = BitVec::from_u64(7).shl(bit);

        tests.push((x, y));
        tests.push((y, x));
    }

    // Alternating bit patterns (full width)
    let repeating = [
        BitVec::from_repeating_u64(0xAAAA_AAAA_AAAA_AAAA),
        BitVec::from_repeating_u64(0x5555_5555_5555_5555),
        BitVec::ones(),
    ];
    for &a in &repeating {
        for &b in &repeating {
            tests.push((a, b));
        }
    }

    // Contiguous bit regions
    for n in 0..BIT_WIDTH {
        // a = 2^(n+1) - 1, b = 2^(n+1) - 2
        let a = BitVec::low_bits_set(n + 1);
        let b = if n == 0 {
            zero
        } else {
            BitVec::low_bits_set(n).shl(1)
        };
        tests.push((a, b));
        tests.push((b, a));
    }

    tests
}

fn vhdl_entity_name(path: &Path) -> String {
    path.file_stem().unwrap().to_string_lossy().to_string()
}

fn write_vhdl_package(path: &Path, cases: Vec<AdderState>) -> io::Result<()> {
    let entity = vhdl_entity_name(path);

    let file = fs::File::create(path)?;
    let mut w = io::BufWriter::new(file);

    writeln!(w, "library ieee;")?;
    writeln!(w, "use ieee.std_logic_1164.all;")?;
    writeln!(w, "package {entity} is")?;

    // Type declaration
    writeln!(w, "  type AdderCase is record")?;
    writeln!(
        w,
        "    a, b, s : std_logic_vector({} downto 0);",
        BIT_WIDTH - 1
    )?;
    writeln!(w, "    cin, cout, ovfl : std_logic;")?;
    writeln!(w, "  end record;")?;

    writeln!(
        w,
        "  type AdderCaseArray is array (natural range <>) of AdderCase;"
    )?;
    writeln!(w, "  constant AdderVectors : AdderCaseArray := (")?;

    // All test cases
    let count = cases.len();
    for (i, case) in cases.into_iter().enumerate() {
        let comma = if i == 0 { "  " } else { ", " };
        writeln!(w, "{comma}{case}", case = case.to_vhdl())?;
    }

    writeln!(w, ");")?;
    writeln!(w, "  constant AdderVectorCount : natural := {count};")?;
    writeln!(w, "end package {entity};")?;

    w.flush()?;
    println!("Wrote {count} test cases (BIT_WIDTH={BIT_WIDTH}) to {path:?}");
    Ok(())
}

fn main() -> io::Result<()> {
    let Args { output } = Args::parse();

    let pair_tests = generate_test_pairs();
    let cin_tests = [true, false];

    // Generate all (a, b, cin) input combinations, deduplicate
    let mut inputs: Vec<AdderIn> = itertools::iproduct!(pair_tests, cin_tests)
        .map(|((a, b), cin)| AdderIn::new(a, b, cin))
        .collect::<BTreeSet<_>>()
        .into_iter()
        .collect();

    let total = inputs.len();

    // Randomly sample TEST_COUNT cases (deterministic seed for reproducibility)
    let mut rng = SimpleRng::new(0xDEAD_BEEF_CAFE_BABE);
    rng.shuffle(&mut inputs);
    inputs.truncate(TEST_COUNT);

    // Compute outputs
    let cases: Vec<AdderState> = inputs.into_iter().map(AdderState::new).collect();

    let selected = cases.len();
    write_vhdl_package(&output, cases)?;
    eprintln!("(Sampled {selected} from {total} unique test vectors)");

    Ok(())
}
