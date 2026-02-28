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

    /// Create a LogicVec filled with a single default value.
    pub fn new_default(default: LogicVal) -> Self {
        Self([default; N])
    }

    /// Create a LogicVec from a function mapping bit index to bool.
    pub fn from_bool_fn(mut f: impl FnMut(usize) -> bool) -> Self {
        Self(std::array::from_fn(|i| LogicVal::Val(f(i))))
    }

    pub fn to_bits_string(&self) -> String {
        String::from_iter(self.0.map(LogicVal::as_char).iter().rev())
    }

    // Convert a LogicVector to a string of hex bits. N must be a multiple of 4.
    pub fn to_hex_string(&self) -> String {
        assert!(N.is_multiple_of(4), "N must be a multiple of 4");
        String::from_iter(self.0.chunks_exact(4).map(LogicVal::as_hex_char).rev())
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
            vals[i * 4] = a;
            vals[i * 4 + 1] = b;
            vals[i * 4 + 2] = c;
            vals[i * 4 + 3] = d;
        }

        Self(vals)
    }
}

pub trait EnumLogicVec<const N: usize>: Sized {
    fn into_logic_vec(self) -> LogicVec<N>;

    fn as_logic_vec(val: Option<Self>, default: LogicVal) -> LogicVec<N> {
        match val {
            Some(v) => v.into_logic_vec(),
            None => LogicVec::<N>::new_default(default),
        }
    }
}

impl EnumLogicVec<1> for bool {
    fn into_logic_vec(self) -> LogicVec<1> {
        LogicVec::from_bool_fn(|_| self)
    }
}

/// A fixed-width bit vector of `N` bits, stored as `WORDS` packed `u64` words
/// in little-endian word order (words[0] holds the LSB).
///
/// # Invariant
/// `WORDS` must equal `(N + 63) / 64`.
#[derive(Debug, Clone, Copy, Hash, Eq, PartialEq, PartialOrd, Ord)]
pub struct BitVec<const N: usize, const WORDS: usize> {
    pub words: [u64; WORDS],
}

impl<const N: usize, const WORDS: usize> BitVec<N, WORDS> {
    /// The mask for the topmost word: clears bits above bit `N-1`.
    const TOP_MASK: u64 = if N.is_multiple_of(64) {
        u64::MAX
    } else {
        (1u64 << (N % 64)) - 1
    };

    /// All zeros.
    pub fn zero() -> Self {
        Self { words: [0; WORDS] }
    }

    /// All ones (`N` bits set).
    pub fn ones() -> Self {
        let mut words = [u64::MAX; WORDS];
        words[WORDS - 1] &= Self::TOP_MASK;
        Self { words }
    }

    /// A single bit set at position `pos` (0-indexed from LSB).
    pub fn single_bit(pos: usize) -> Self {
        assert!(pos < N);
        let mut bv = Self::zero();
        bv.words[pos / 64] |= 1u64 << (pos % 64);
        bv
    }

    /// Create from a `u64` value (placed in the lowest 64 bits).
    pub fn from_u64(val: u64) -> Self {
        let mut bv = Self::zero();
        bv.words[0] = val;
        bv.mask_top();
        bv
    }

    /// Return a `BitVec` with the lowest `count` bits set (`count <= N`).
    pub fn low_bits_set(count: usize) -> Self {
        assert!(count <= N);
        let mut bv = Self::zero();
        let full_words = count / 64;
        let remaining = count % 64;
        for w in bv.words.iter_mut().take(full_words) {
            *w = u64::MAX;
        }
        if remaining > 0 && full_words < WORDS {
            bv.words[full_words] = (1u64 << remaining) - 1;
        }
        bv
    }

    /// Create by repeating a 64-bit pattern across all words.
    pub fn from_repeating_u64(pattern: u64) -> Self {
        let mut bv = Self {
            words: std::array::from_fn(|_| pattern),
        };
        bv.mask_top();
        bv
    }

    /// Shift left by `amount` bits. Bits shifted beyond `N` are lost.
    pub fn shl(self, amount: usize) -> Self {
        if amount >= N {
            return Self::zero();
        }
        let word_shift = amount / 64;
        let bit_shift = amount % 64;
        let mut result = Self::zero();
        for i in word_shift..WORDS {
            result.words[i] = self.words[i - word_shift] << bit_shift;
            if bit_shift > 0 && i > word_shift {
                result.words[i] |= self.words[i - word_shift - 1] >> (64 - bit_shift);
            }
        }
        result.mask_top();
        result
    }

    /// Bitwise OR.
    pub fn bitor(self, other: Self) -> Self {
        let words = std::array::from_fn(|i| self.words[i] | other.words[i]);
        Self { words }
    }

    /// Get bit at position `idx` (0-indexed from LSB).
    pub fn get_bit(&self, idx: usize) -> bool {
        (self.words[idx / 64] >> (idx % 64)) & 1 != 0
    }

    /// Mask the topmost word to clear any unused high bits.
    pub fn mask_top(&mut self) {
        self.words[WORDS - 1] &= Self::TOP_MASK;
    }

    /// Full adder: `self + other + cin`.
    /// Returns `(sum, carry_out, signed_overflow)`.
    pub fn add_with_carry(self, other: Self, cin: bool) -> (Self, bool, bool) {
        let mut sum = Self::zero();
        let mut carry = cin;
        let mut carry_into_msb = false;

        for i in 0..N {
            if i == N - 1 {
                carry_into_msb = carry;
            }
            let a = self.get_bit(i);
            let b = other.get_bit(i);
            let s = a ^ b ^ carry;
            carry = a && (b || carry) || (b && carry);
            if s {
                sum.words[i / 64] |= 1u64 << (i % 64);
            }
        }

        let cout = carry;
        let ovfl = carry_into_msb ^ cout;

        (sum, cout, ovfl)
    }
}

impl<const N: usize, const WORDS: usize> EnumLogicVec<N> for BitVec<N, WORDS> {
    fn into_logic_vec(self) -> LogicVec<N> {
        LogicVec::from_bool_fn(|i| self.get_bit(i))
    }
}
