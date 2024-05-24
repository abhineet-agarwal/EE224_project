library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

entity memory_unit is 
	port (address, Mem_datain: in std_logic_vector(15 downto 0); clk, write_signal, read_signal: in std_logic; Mem_dataout: out std_logic_vector(15 downto 0));
end entity;

architecture Form of memory_unit is

	type regarray is array(255 downto 0) of std_logic_vector(15 downto 0);   -- defining a new type

	signal Memory: regarray := (
	0 => x"0050", 1 => x"2210", 2 => x"3050", 3 => x"4050", 4 => x"5050", 5 => x"6050", 6 => x"4050", 7 => x"5050",
	8 => x"9450", 9 => x"a050", 10 => x"b050", 11 => x"8450", 12 => x"1090", 13 => x"d050", 14 => x"f040", 15 => x"91c0",
	128 => x"ffff", 129 => x"0002", 130 => x"0000", 131 => x"0000", 132 => x"0001", 133 => x"0000",
	others => x"0000"
	);
	-- you can use the above mentioned way to initialise the memory with the instructions and the data as required to test your processor
	begin
	Mem_read:
	process (read_signal, address, clk)
	begin
	if(write_signal = '0') then
			if(rising_edge(clk)) then
	Mem_dataout <= Memory(conv_integer(address));
	end if;
	end if;
	end process;
	
	Mem_write:
	process (write_signal, Mem_datain, address, clk)
		begin
		if(write_signal = '1') then
			if(rising_edge(clk)) then
				Memory(conv_integer(address)) <= Mem_datain;
			end if;
		end if;
	end process;

end Form;