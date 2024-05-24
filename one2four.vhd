library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity one2four  is
  port (d: in std_logic ; s: in std_logic_vector(1 downto 0) ; y: out std_logic_vector(3 downto 0));
end entity one2four;

architecture Struct of one2four is
begin
process(d,s)
begin
    y(0) <= (not s(0)) and (not s(1)) and d;
    y(1) <= s(0) and (not s(1)) and d;
    y(2) <= s(1) and (not s(0)) and d;
    y(3) <= s(1) and s(0) and d;
end process;
end Struct;