library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

entity rf_file is 
	port (rf_a1, rf_a2, rf_a3: in std_logic_vector(2 downto 0); rf_d3: in std_logic_vector(15 downto 0);
		 rf_d1, rf_d2: out std_logic_vector(15 downto 0); rf_write_in, clk,rst: in std_logic);
end entity;

architecture basic of rf_file is

component register1 is
        port(Clk        : in  std_logic;
			 Reset      : in  std_logic;
             data_in    : in  std_logic_vector(15 downto 0);
             data_out   : out std_logic_vector(15 downto 0);
				 a : in std_logic);
    end component;
	 
component Mux_8 is
	port(I0, I1, I2, I3, I4, I5, I6, I7: in std_logic;
			S: out std_logic;
			sel0, sel1, sel2: in  std_logic);
end component;

component one2eight  is
  port (d: in std_logic_vector(15 downto 0);s: in std_logic_vector(2 downto 0); y0: out std_logic_vector(15 downto 0); y1: out std_logic_vector(15 downto 0); y2: out std_logic_vector(15 downto 0); y3: out std_logic_vector(15 downto 0); y4: out std_logic_vector(15 downto 0); y5: out std_logic_vector(15 downto 0); y6: out std_logic_vector(15 downto 0); y7: out std_logic_vector(15 downto 0));
end component;

begin

signal r0,r1,r2,r3,r4,r5,r6,r7: std_logic_vector(15 downto 0);
type regarray is array(7 downto 0) of std_logic_vector(15 downto 0);
signal a0,a1,a2,a3,a4,a5,a6,a7 :std_logic;


signal rout : regarray ;

reg0 : register1 port map (clk,rst,r0,rout(0),a0);
reg1 : register1 port map (clk,rst,r1,rout(1),a1);
reg2 : register1 port map (clk,rst,r2,rout(2),a2);
reg3 : register1 port map (clk,rst,r3,rout(3),a3);
reg4 : register1 port map (clk,rst,r4,rout(4),a4);
reg5 : register1 port map (clk,rst,r5,rout(5),a5);
reg6 : register1 port map (clk,rst,r6,rout(6),a6);
reg7 : register1 port map (clk,rst,r7,rout(7),a7);


demux1 : one2eight port map (d => rf_d3,rf_a3, r0,r1,r2,r3,r4,r5,r6,r7);
demux2 : one2eight port map (d => "1111111111111111", rf_a3,a0,a1,a2,a3,a4,a5,a6,a7);


g1 : for i in 0 to 15 generate 
mux0 : mux_8 port map (rout(i), rout(i), rout(i), rout(i), rout(i), rout(i), rout(i), rout(i),rf_d1(i),rf_a1);
end generate;


g2 : for i in 0 to 15 generate 
mux1 : mux_8 port map (rout(i), rout(i), rout(i), rout(i), rout(i), rout(i), rout(i), rout(i),rf_d2(i),rf_a2);
end generate;



end basic;