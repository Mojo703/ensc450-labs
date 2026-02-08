library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.string_ops.all; -- split and string functions
use work.test_cases_64.all;

entity tb_Adder is
  generic (
    N                : integer := 64;
    ResultVectorPath : string  := "..\Documentation\OutputFiles\test_results.rvs"
  );
end entity;

architecture sim of tb_Adder is
  constant PreStimTime  : time   := 50 ns;
  constant PostStimTime : time   := 50 ns;
  constant StableTime   : time   := 100 ns;
  constant ClkPeriod    : time   := 20 ns;
  constant Separator    : string := string'(", ");

  -- Helper: std_logic to string
  function sl_to_string(s : std_logic) return string is
    variable result         : string(1 to 1);
  begin
    case s is
      when '0'    => result    := "0";
      when '1'    => result    := "1";
      when 'X'    => result    := "X";
      when '-'    => result    := "-";
      when others => result := "?"; -- Unsupported for now.
    end case;
    return result;
  end function;

  -- DUT
  component Adder is
    generic (N : natural := 64);
    port (
      clk        : in std_logic;
      A, B       : in std_logic_vector(N - 1 downto 0);
      S          : out std_logic_vector(N - 1 downto 0);
      Cin        : in std_logic;
      Cout, Ovfl : out std_logic
    );
  end component;

  -- Signals
  signal clk  : std_logic := '0';
  signal A, B : std_logic_vector(N - 1 downto 0);
  signal Cin  : std_logic := '0';
  signal S    : std_logic_vector(N - 1 downto 0);
  signal Cout : std_logic;
  signal Ovfl : std_logic;

  signal PropDelay : time := 0 ns;
  signal sim_done  : boolean := false;

begin

  -- Clock generator
  clk_gen : process
  begin
    while not sim_done loop
      clk <= '0';
      wait for ClkPeriod / 2;
      clk <= '1';
      wait for ClkPeriod / 2;
    end loop;
    wait;
  end process;

  DUT : Adder
  generic map(N => N)
  port map
  (
    clk  => clk,
    A    => A,
    B    => B,
    S    => S,
    Cin  => Cin,
    Cout => Cout,
    Ovfl => Ovfl
  );

  process
    variable StartTime_v, EndTime_v : time;

    file result_file : text open write_mode is ResultVectorPath;

    -- Inputs
    variable A_test   : std_logic_vector(N - 1 downto 0);
    variable B_test   : std_logic_vector(N - 1 downto 0);
    variable Cin_test : std_logic;

    -- Expected outputs
    variable S_exp    : std_logic_vector(N - 1 downto 0);
    variable Cout_exp : std_logic;
    variable Ovfl_exp : std_logic;

    variable output_line : line;
  begin
    -- Wait for initial setup
    wait for PreStimTime;
    
    for i in AdderVectors'range loop
      -- Extract inputs from test vectors
      A_test   := AdderVectors(i).a;
      B_test   := AdderVectors(i).b;
      Cin_test := AdderVectors(i).cin;

      -- Extract expected outputs from test vectors
      S_exp    := AdderVectors(i).s;
      Cout_exp := AdderVectors(i).cout;
      Ovfl_exp := AdderVectors(i).ovfl;

      -- Apply stimulus before clock edge
      A   <= A_test;
      B   <= B_test;
      Cin <= Cin_test;

      -- Wait for rising edge to latch inputs
      wait until rising_edge(clk);
      
      -- Record start time (after inputs are latched)
      StartTime_v := now;
      
      -- Wait for all output signals to be stable
      wait until S'stable(StableTime) and Cout'stable(StableTime) and Ovfl'stable(StableTime);
      EndTime_v := now;
      PropDelay <= EndTime_v - (StartTime_v + StableTime);

      -- Write [tpd, input, expected, output] results
      write(output_line, integer'image(integer(PropDelay / 1 ps)));
      write(output_line, Separator);
      -- INPUT
      write(output_line, hex_image(A_test));
      write(output_line, Separator);
      write(output_line, hex_image(B_test));
      write(output_line, Separator);
      write(output_line, sl_to_string(Cin_test));
      write(output_line, Separator);
      -- EXPECTED
      write(output_line, hex_image(S_exp));
      write(output_line, Separator);
      write(output_line, sl_to_string(Cout_exp));
      write(output_line, Separator);
      write(output_line, sl_to_string(Ovfl_exp));
      write(output_line, Separator);
      -- OUTPUT
      write(output_line, hex_image(S));
      write(output_line, Separator);
      write(output_line, sl_to_string(Cout));
      write(output_line, Separator);
      write(output_line, sl_to_string(Ovfl));

      writeline(result_file, output_line);

      wait for PostStimTime;
    end loop;

    report "Simulation finished, results written to " & ResultVectorPath;
    sim_done <= true;
    wait;
  end process;

end architecture;