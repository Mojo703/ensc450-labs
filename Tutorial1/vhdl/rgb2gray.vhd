-- fcampi@sfu.ca July 2013
-- rbg2gray 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity rgb2gray is
port( clk,resetn : in  std_logic; 
      r,b,g      : in  std_logic_vector(7 downto 0);
      gray       : out std_logic_vector(7 downto 0)  );
end rgb2gray;

architecture beh of rgb2gray is 

  signal r_int,g_int,b_int,gray_int,max,min : std_logic_vector(7 downto 0);
  signal sum_op1,sum_op2,sum : std_logic_vector(8 downto 0);
  

begin

    sample_io : process(clk,resetn)
      begin
        if resetn='0' then
          r_int<=(others=>'0');
          b_int<=(others=>'0');
          g_int<=(others=>'0');

          gray <=(others=>'0');

        elsif clk'event and clk='1' then
          r_int <= r;
          g_int <= g;
          b_int <= b;

          gray <= gray_int;
        end if;
      end process;

   max_calc:process(r_int,b_int,g_int)
     begin
       if (r_int >= g_int) and (r_int >= b_int)  then
         max <= r_int;
       elsif (g_int >= r_int) and (g_int >= b_int) then
         max <= g_int;
       else
         max <= b_int;
       end if;
     end process;

   min_calc:process(r_int,b_int,g_int)
     begin
       if (r_int <= g_int) and (r_int <= b_int)  then
         min <= r_int;
       elsif (g_int <= r_int) and (g_int <= b_int) then
         min <= g_int;
       else
         min <= b_int;
       end if;
     end process;

     -- Since the division is by constant 2 we can express it
     -- by a simple shift
     sum_op1 <= '0' & max;
     sum_op2 <= '0' & min;
     sum <= unsigned(sum_op1) + unsigned(sum_op2);
     gray_int <= sum(8 downto 1);
     
    end beh;
