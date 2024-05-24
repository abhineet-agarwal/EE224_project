library ieee;
use ieee.std_logic_1164.all;

entity Mux_8 is
	port(I0, I1, I2, I3, I4, I5, I6, I7: in std_logic;
			S: out std_logic);
			sel0, sel1, sel2: in  std_logic);
end entity Mux_8;

architecture struct of Mux_8 is
	component Mux_2 is
		port (I0, I1: in std_logic; S: out std_logic;
				sel: in  std_logic);
	end component Mux_2;
	
	component Mux_4 is
	port(I0, I1, I2, I3: in std_logic;
			S: out std_logic;
			sel0, sel1: in  std_logic);
end component Mux_4;


	signal  s1, s2 : std_logic;
begin
	m1: Mux_4
		port map (
			I0 => I0, I1 => I1, I2 => I2,I3 => I3, sel0 => sel0, sel1 => sel1, S => s1
		);
	m2: Mux_4
		port map (
			I0 => I4, I1 => I5, I2 => I6,I3 => I7, sel0 => sel0, sel1 => sel1, S => s2
		);
	m3: Mux_2
		port map (
			I0 => s1, I1 => s2, sel => sel2, S => S
		);
	
end architecture struct;