library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity one2two  is
  port (d,s: in std_logic; y: out std_logic_vector(1 downto 0));
end entity one2two;

architecture Struct of one2two is
begin
process(d,s)
begin
    y(0) <= (not s) and d;
    y(1) <= s and d;
end process;
end Struct;