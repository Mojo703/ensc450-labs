-- fcampi@sfu.ca July 2013
-- rbg2gray Testbench

library ieee;
use ieee.std_logic_1164.all;

entity E is
end E;

architecture A of E is

  component rgb2gray
    port (
      clk, resetn : in std_logic;
      r, g, b     : in std_logic_vector(7 downto 0);
      gray        : out std_logic_vector(7 downto 0));
  end component;

  signal clk, resetn, en : std_logic;
  signal r, g, b, gray   : std_logic_vector(7 downto 0);

begin

  UUT : rgb2grayPORT
  map (clk, resetn, r, g, b, gray);

  en <= '1';

  xsclock_engine : process
  begin
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
  end process;

  reset_engine : process
  begin
    wait for 5 ns;
    resetn <= '0';
    wait for 20 ns;
    resetn <= '1';
    wait;
  end process;

  -- Non realistic data, just to check the math
  input_data : process
  begin
    wait for 45 ns;
    r <= X"15";
    g <= X"23";
    b <= X"45"; -- res=2D
    wait for 20 ns;
    r <= X"54";
    g <= X"12";
    b <= X"32"; -- res=33
    wait for 20 ns;
    r <= X"54";
    g <= X"12";
    b <= X"22"; -- res=33
    wait for 20 ns;
    r <= X"40";
    g <= X"82";
    b <= X"12"; -- res=4A
    wait for 20 ns;
    r <= X"55";
    g <= X"22";
    b <= X"01"; -- res=2B
    wait for 20 ns;
    r <= X"12";
    g <= X"28";
    b <= X"36"; -- res=24
    wait;
  end process;
end A;
