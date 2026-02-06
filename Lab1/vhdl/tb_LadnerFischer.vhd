library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.string_ops.all; -- split and string functions
use work.test_cases_64.all;

entity TestBench is
  generic (
    N                : integer := 64;
    ResultVectorPath : string  := "..\Documentation\OutputFiles\test_results.rvs"
  );
end entity;

architecture sim of TestBench is
  constant PreStimTime  : time   := 50 ns;
  constant PostStimTime : time   := 50 ns;
  constant StableTime   : time   := 100 ns;
  constant Separator    : string := string'(", ");

  -- Helper: string to std_logic_vector
  function string_to_slv(s : in string; width : integer)
    return std_logic_vector is
    variable vec : std_logic_vector(width - 1 downto 0);
  begin
    for i in 1 to width loop
      case s(i) is
        when '0'       => vec(width - i)       := '0';
        when '1'       => vec(width - i)       := '1';
        when '-'       => vec(width - i)       := '-';
        when 'X' | 'x' => vec(width - i) := 'X';
        when others    => vec(width - i)    := 'U';
      end case;
    end loop;
    return vec;
  end function;

  -- Helper: string to std_logic
  function string_to_sl(s : in string) return std_logic is
    variable c              : character;
    variable sl             : std_logic;
  begin
    c := s(1);
    case c is
      when '0'       => sl       := '0';
      when '1'       => sl       := '1';
      when '-'       => sl       := '-';
      when 'X' | 'x' => sl := 'X';
      when others    => sl    := 'U';
    end case;
    return sl;
  end function;

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
  component LadnerFischer is
    generic (N : natural := 64);
    port (
      A, B       : in std_logic_vector(N - 1 downto 0);
      S          : out std_logic_vector(N - 1 downto 0);
      Cin        : in std_logic;
      Cout, Ovfl : out std_logic
    );
  end component;

  -- Signals
  signal A, B : std_logic_vector(N - 1 downto 0);
  signal Cin  : std_logic := '0';
  signal S    : std_logic_vector(N - 1 downto 0);
  signal Cout : std_logic;
  signal Ovfl : std_logic;

  signal PropDelay : time := 0 ns;

begin

  DUT : LadnerFischer
  generic map(N => N)
  port map
  (
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
    for i in AdderVectors'range loop
      -- Extract inputs from test vectors
      A_test   := AdderVectors(i).a;
      B_test   := AdderVectors(i).b;
      Cin_test := AdderVectors(i).cin;

      -- Extract expected outputs from test vectors
      S_exp    := AdderVectors(i).s;
      Cout_exp := AdderVectors(i).cout;
      Ovfl_exp := AdderVectors(i).ovfl;

      -- Apply PreStim
      A   <= (others => 'X');
      B   <= (others => 'X');
      Cin <= 'X';

      wait for PreStimTime;

      -- Apply stimulus
      A   <= A_test;
      B   <= B_test;
      Cin <= Cin_test;

      -- Wait for all output signals to be stable
      StartTime_v := now;
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
    wait;
  end process;

end architecture;