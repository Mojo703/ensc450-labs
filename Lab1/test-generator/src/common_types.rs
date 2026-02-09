#![allow(unused)]

use std::fmt::Display;

#[derive(Debug, Clone, Copy)]
pub enum LogicVal {
    // Uninitialized,
    ForceUnknown,
    Val(bool),
    // HighZ,
    // WeakUnknown,
    // WeakVal(bool),
    NotCare,
}

impl LogicVal {
    pub fn as_char(self) -> char {
        match self {
            // Self::Uninitialized => 'U',
            Self::ForceUnknown => 'X',
            Self::Val(true) => '1',
            Self::Val(false) => '0',
            // Self::HighZ => 'Z',
            // Self::WeakUnknown => 'W',
            // Self::WeakVal(true) => 'H',
            // Self::WeakVal(false) => 'L',
            Self::NotCare => '-',
        }
    }

    pub fn try_from_char(chr: char) -> Option<Self> {
        Some(match chr {
            'X' => Self::ForceUnknown,
            '1' => Self::Val(true),
            '0' => Self::Val(false),
            '-' => Self::NotCare,
            _ => return None,
        })
    }

    pub fn as_hex_char(val: &[Self]) -> char {
        match val {
            [
                LogicVal::Val(a),
                LogicVal::Val(b),
                LogicVal::Val(c),
                LogicVal::Val(d),
            ] => match (*a as u8) + 2 * (*b as u8) + 4 * (*c as u8) + 8 * (*d as u8) {
                0 => '0',
                1 => '1',
                2 => '2',
                3 => '3',
                4 => '4',
                5 => '5',
                6 => '6',
                7 => '7',
                8 => '8',
                9 => '9',
                10 => 'A',
                11 => 'B',
                12 => 'C',
                13 => 'D',
                14 => 'E',
                15 => 'F',
                _ => unreachable!(""),
            },
            _ => 'X',
        }
    }

    pub fn try_from_hex_char(chr: char) -> Option<[Self; 4]> {
        use LogicVal::ForceUnknown as FU;
        use LogicVal::NotCare as NC;
        use LogicVal::Val as V;
        Some(match chr {
            '0' => [V(false), V(false), V(false), V(false)],
            '1' => [V(true), V(false), V(false), V(false)],
            '2' => [V(false), V(true), V(false), V(false)],
            '3' => [V(true), V(true), V(false), V(false)],
            '4' => [V(false), V(false), V(true), V(false)],
            '5' => [V(true), V(false), V(true), V(false)],
            '6' => [V(false), V(true), V(true), V(false)],
            '7' => [V(true), V(true), V(true), V(false)],
            '8' => [V(false), V(false), V(false), V(true)],
            '9' => [V(true), V(false), V(false), V(true)],
            'A' | 'a' => [V(false), V(true), V(false), V(true)],
            'B' | 'b' => [V(true), V(true), V(false), V(true)],
            'C' | 'c' => [V(false), V(false), V(true), V(true)],
            'D' | 'd' => [V(true), V(false), V(true), V(true)],
            'E' | 'e' => [V(false), V(true), V(true), V(true)],
            'F' | 'f' => [V(true), V(true), V(true), V(true)],
            'X' => [FU, FU, FU, FU],
            '-' => [NC, NC, NC, NC],
            _ => return None,
        })
    }
}

impl Eq for LogicVal {}

impl PartialEq for LogicVal {
    fn eq(&self, other: &Self) -> bool {
        use LogicVal as L;
        match (self, other) {
            (L::NotCare, _) | (_, L::NotCare) => true,
            (L::Val(a), L::Val(b)) if a == b => true,
            (L::ForceUnknown, L::ForceUnknown) => true,
            (_, _) => false,
        }
    }
}

impl Display for LogicVal {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.as_char())
    }
}

#[derive(Debug, PartialEq, Eq)]
pub struct LogicVec<const N: usize>([LogicVal; N]);

impl<const N: usize> LogicVec<N> {
    #[allow(unused)] // Used by Display
    pub const UNKNOWN: [char; N] = ['X'; N];

    pub fn new_or(value: Option<i128>, other: LogicVal) -> Self {
        Self(match value {
            Some(value) => std::array::from_fn(|i| LogicVal::Val((value & (1 << i)) != 0)),
            None => std::array::from_fn(|_| other),
        })
    }

    pub fn to_bits_string(&self) -> String {
        String::from_iter(self.0.map(LogicVal::as_char).iter().rev())
    }

    // Convert a LogicVector to a string of hex bits. N must be a multiple of 4.
    pub fn to_hex_string(&self) -> String {
        assert!(N % 4 == 0, "N must be a multiple of 4");
        String::from_iter(
            self.0
                .chunks_exact(4)
                .into_iter()
                .map(LogicVal::as_hex_char)
                .rev(),
        )
    }

    pub fn from_hex_chars(value: &[char]) -> Self {
        assert!(
            value.len() == N / 4,
            "value length must match LogicVec<N> size"
        );
        let mut vals = [LogicVal::NotCare; N];
        for (i, [a, b, c, d]) in value
            .iter()
            .map(|&chr| {
                LogicVal::try_from_hex_char(chr).expect("from_hex_chars char must be valid")
            })
            .enumerate()
        {
            vals[i * 4 + 0] = a;
            vals[i * 4 + 1] = b;
            vals[i * 4 + 2] = c;
            vals[i * 4 + 3] = d;
        }

        Self(vals)
    }
}

pub trait EnumLogicVec<const N: usize>: Sized {
    fn as_i128(self) -> i128;

    fn as_logic_vec(val: Option<Self>, default: LogicVal) -> LogicVec<N> {
        LogicVec::<N>::new_or(val.map(Self::as_i128), default)
    }
}

impl EnumLogicVec<64> for i128 {
    fn as_i128(self) -> i128 {
        self
    }
}

impl EnumLogicVec<1> for bool {
    fn as_i128(self) -> i128 {
        if self { 1 } else { 0 }
    }
}
