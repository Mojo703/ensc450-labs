library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.standard.all;

entity LadnerFischer is
  generic (N : natural := 1024);
  port (
    A, B       : in std_logic_vector(N - 1 downto 0);
    S          : out std_logic_vector(N - 1 downto 0);
    Cin        : in std_logic;
    Cout, Ovfl : out std_logic);
end entity;

architecture behavioral of LadnerFischer is
  component LFRecursive is
    generic (N : natural := 1024);
    port (
      Gen, Prop           : in std_logic_vector(N - 1 downto 0);
      blockGen, blockProp : out std_logic_vector(N - 1 downto 0)
    );
  end component;
  -- Connect the generate and propagate signals to the LFRecursive component
  constant NLength   : natural := natural(integer(2 ** ceil(log2(real(N)))));
  signal generateIn  : std_logic_vector(NLength - 1 downto 0);
  signal propagateIn : std_logic_vector(NLength - 1 downto 0);
  -- Connect the Brent Kung component to the summing network
  signal blockPropagate : std_logic_vector(NLength - 1 downto 0);
  signal blockGenerate  : std_logic_vector(NLength - 1 downto 0);
  -- Holds the carry signals 
  signal carry : std_logic_vector(N downto 0);

begin
  -- add the input carry to the carry signal
  carry(0) <= Cin;

  genInput : for i in 0 to N - 1 generate
    -- Create the generate and propagate signals for all inputs
    generateIn(i)  <= A(i) and B(i);
    propagateIn(i) <= A(i) xor B(i);
  end generate;

  blockGen : if N > 1 generate
    blockgeneration : LFRecursive generic map
    (
      N => NLength
    ) port map
    (
    Gen       => generateIn,
    Prop      => propagateIn,
    blockGen  => blockGenerate,
    blockProp => blockPropagate
    );
  end generate;
  blockGen1 : if N = 1 generate
    blockGenerate  <= GenerateIn;
    blockPropagate <= PropagateIn;
  end generate;
  genSumNetwork : for i in 0 to N - 1 generate
    -- Create the summing network - all carry signals are generated
    carry(i + 1) <= blockGenerate(i) or (blockPropagate(i) and Cin);
  end generate;

  -- Create each of the outputs S using the carry and block propagate signals
  finalXOR : for i in 0 to N - 1 generate
    S(i) <= propagateIn(i) xor carry(i);
  end generate;
  -- The output carry is the carry result from the last carry generated
  Cout <= carry(N);

  -- Placeholder: Missing Ovfl:
  Ovfl <= carry(N) xor carry(N - 1);
end architecture;

-- There are still a bunch of things I have to add: 
-- -- right now it doesn't even try to get to a power of 2
-- -- It doesn't have overflow
