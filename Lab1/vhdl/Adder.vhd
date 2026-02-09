library ieee;
use ieee.std_logic_1164.all;

entity Adder is
  generic (N : natural := 512);
  port (
    clk        : in std_logic;
    A, B       : in std_logic_vector(N - 1 downto 0);
    S          : out std_logic_vector(N - 1 downto 0);
    Cin        : in std_logic;
    Cout, Ovfl : out std_logic);
end entity;

architecture RTL of Adder is
  -- Internal signals for latched inputs
  signal A_reg, B_reg : std_logic_vector(N - 1 downto 0);
  signal Cin_reg      : std_logic;

  component LadnerFischer is
    generic (N : natural := 512);
    port (
      A, B       : in std_logic_vector(N - 1 downto 0);
      S          : out std_logic_vector(N - 1 downto 0);
      Cin        : in std_logic;
      Cout, Ovfl : out std_logic);
  end component;

  
begin
  -- Input latching process
  input_latch : process(clk)
  begin
    if rising_edge(clk) then
      A_reg   <= A;
      B_reg   <= B;
      Cin_reg <= Cin;
    end if;
  end process;
  
  -- Instantiate the LadnerFischer adder
  adder_inst : LadnerFischer
    generic map (N => N)
    port map (
      A    => A_reg,
      B    => B_reg,
      S    => S,
      Cin  => Cin_reg,
      Cout => Cout,
      Ovfl => Ovfl
    );
    
end architecture;