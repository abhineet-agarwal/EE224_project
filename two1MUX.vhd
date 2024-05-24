library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity two1MUX is
 port(I0,I1,S:in std_logic; Y:out std_logic);
 end entity two1MUX;
 
 architecture Struct of two1MUX is
  signal I,J,S_BAR:std_logic;
  begin
  INVERTER1:INVERTER port map(A=>S,Y=>S_BAR);
  AND1:AND_2 port map(A=>I0  ,B=>S_BAR , Y=>I);
  AND2:AND_2 port map(A=>I1  ,B=>S , Y=>J);
  OR1:OR_2 port map(A=>I , B=>J , Y=> Y);
  end Struct;