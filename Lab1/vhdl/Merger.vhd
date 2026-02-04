library ieee;
use ieee.std_logic_1164.all;

entity Merger is
  port (
    GLow, PLow, GHi, PHi : in std_logic;
    Gout, Pout           : out std_logic
  );
end entity;

architecture Behavioral of Merger is
begin
  Gout <= GHi or (Phi and GLow);
  Pout <= Phi and Plow;
end architecture;
