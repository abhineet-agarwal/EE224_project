library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity iitb_cpu is
	port (clk, rst: in std_logic; final_out: out std_logic_vector(15 downto 0));
end entity iitb_cpu;

architecture main of iitb_cpu is

	component alu is
	port (a, b: in std_logic_vector(15 downto 0);
		  control : in std_logic_vector(3 downto 0);
		  z: out std_logic;
		  out_alu: out std_logic_vector(15 downto 0));
	end component alu;

	component rf_file is
	port (rf_a1, rf_a2, rf_a3: in std_logic_vector(2 downto 0);
		  rf_d3: in std_logic_vector(15 downto 0);
		  rf_d1, rf_d2: out std_logic_vector(15 downto 0);
		  rf_write_in, clk: in std_logic);
	end component rf_file;

	component memory_unit is
	port (address,Mem_datain: in std_logic_vector(15 downto 0); 
		  clk,write_signal, read_signal: in std_logic;
		  Mem_dataout: out std_logic_vector(15 downto 0));
	end component memory_unit;

	component sign_extend6 is
	port (inp: in std_logic_vector(5 downto 0); extended: out std_logic_vector(15 downto 0));
end component sign_extend6;

	component sign_extend8 is
	port (inp: in std_logic_vector(7 downto 0); extended: out std_logic_vector(15 downto 0));
end component sign_extend8;

	component sign_extend9 is
	port (inp: in std_logic_vector(8 downto 0); extended: out std_logic_vector(15 downto 0));
end component sign_extend9;

	type FSMState is (M0, M1, M2,m21, M3,m31, M4, M5, M6,m61, M7, M8, M9, M10, M11, M12, M13, M14,m141,m142,m143, M15, M16 
		);
	signal next_fsm_state ,fsm_state: FSMState := M1;
	signal instr_reg, instr_pointer, tempbs: std_logic_vector(15 downto 0):="0000000000000000";
	signal mem_A, mem_Din, MEM_DOUT, ALU_A, ALU_B, ALU_O, RF_D1, RF_D2, RF_D3, SIGN_EXTENDER_6_OUTPUT, SIGN_EXTENDER_9_OUTPUT, SIGN_EXTENDER_8_OUTPUT : std_logic_vector(15 downto 0) :="0000000000000000";
	signal MEM_WRITE_BAR_ENABLE, MEM_READ, ALU_Z, Z_FLAG, RF_WRITE_IN : std_logic;
	signal RF_A1, RF_A2, RF_A3 : std_logic_vector(2 downto 0);
	signal T1, T2, T3,temp_out : std_logic_vector(15 downto 0):="0000000000000000";
	signal ALU_CONTROL : std_logic_vector(3 downto 0);
	signal SIGN_extender_6_INPUT : std_logic_vector(5 downto 0) := "000000";
	signal SIGN_extender_8_INPUT : std_logic_vector(7 downto 0) := "00000000";
	signal SIGN_extender_9_INPUT : std_logic_vector(8 downto 0) := "000000000";

	
	begin
		
		Memory : memory_unit port map (
			mem_A, mem_Din, clk, MEM_WRITE_BAR_ENABLE, mem_read,MEM_DOUT
		);
		
		Arithmetic_Logical_Unit : alu port map (
			ALU_A, ALU_B, ALU_CONTROL, ALU_Z, ALU_O
		);

		Register_file : rf_file port map (
			RF_A1, RF_A2, RF_A3, RF_D3, RF_D1, RF_D2, RF_WRITE_IN, clk
		);

		SE6 : sign_extend6 port map (
			SIGN_extender_6_INPUT, SIGN_EXTENDER_6_OUTPUT
		);

		SE8 : sign_extend8 port map (
			SIGN_extender_8_INPUT, SIGN_EXTENDER_8_OUTPUT
		);
		
		SE9 : sign_extend9 port map (
			SIGN_extender_9_INPUT, SIGN_EXTENDER_9_OUTPUT
		);
		
		Mux2s: Mux_2 port map ("0000000000000"&instr_reg(11 downto 9), "0000000000000"&"111", s, so);
		Mux2l: Mux_2 port map (RF_D1, ALU_C, l, lo);
		Mux2r: Mux_2 port map (RF_D3, T3, r, ro);
		Mux2n: Mux_2 port map (ALU_C, Mem_Data, n, no);
		Mux2y: Mux_2 port map (SIGN_EXTENDER_9_OUTPUT, SIGN_EXTENDER_9_OUTPUT, y, yo);
		Mux

		-- ALU_CONTROL "0000" Adder, "0001" SUB, "0010" AND
		
		
		--clk_process : process(clk,rst)
		--begin
			--if (clk = '1' and clk'event) then
				--if(rst = '1') then
					--fsm_state <= m1;
--					instr_pointer <= "0000000000000000";    													-
				--else
					--fsm_state <= next_fsm_state;
				--end if;
			--end if;
		--end process;

		state_transition_process : process(clk, fsm_state)

		variable next_fsm_state_var : FSMState;
		--variable RF_WRITE_IN_var : std_logic;
		--next_fsm_state := fsm_state;
		--variable next_IP,temp_T1, temp_T2, temp_T3, instr_reg_var : std_logic_vector(15 downto 0);       -
		--next_IP := instr_pointer;
--		variable TZ_TEMP: std_logic;                                                                     -
		variable temp_T1, temp_T2, temp_T3, instr_reg_var ,se6, tempb : std_logic_vector(15 downto 0);
		variable next_ip : std_logic_vector(15 downto 0) := instr_pointer ;
		variable TZ_TEMP: std_logic;
		begin
		
--	next_IP := instr_pointer;              
	next_fsm_state_var :=  fsm_state;	
	temp_T1 := T1;                         
	temp_T2 := T2;                                                
	temp_T3 := T3;                        
			tempb:=tempbs;
		TZ_TEMP := Z_FLAG;                     
		instr_reg_var := instr_reg;   
		

		--MEM_WRITE_BAR_ENABLE_var := MEM_WRITE_BAR_ENABLE;
		--RF_WRITE_IN_var := RF_WRITE_IN;

		case( fsm_state ) is
			
				when M1 =>
					MEM_WRITE_BAR_ENABLE<='0';
					RF_WRITE_IN <= '0';
					MEM_READ<='1';
					MEM_A <= instr_pointer;
					next_fsm_state_var:= M0;
--					instr_reg_var	:= MEM_DOUT;          -- changing instr_reg_var to instr_reg
--					case(instr_reg_var (15 downto 14))is
--						when "11" =>
--							next_fsm_state_var := M2;
--						when others =>
--							next_fsm_state_var := M6;
--					end case;
			
				when M0 =>
				   
					MEM_WRITE_BAR_ENABLE<='0';
					RF_WRITE_IN <= '0';
					MEM_READ<='0';
					--MEM_A <= instr_pointer;
					instr_reg_var	:= MEM_DOUT;          -- changing instr_reg_var to instr_reg
					case(instr_reg_var (15 downto 14))is
						when "11" =>
							next_fsm_state_var := M2;
						when others =>
							next_fsm_state_var := M6;
					end case;
--			
				when M2 =>
					MEM_WRITE_BAR_ENABLE<='0';
					RF_WRITE_IN <= '0';
					MEM_READ<='0';
					RF_A1 <= instr_reg(11 downto 9);
					RF_A2 <= instr_reg(8 downto 6);
--					temp_T1 := RF_D1; temp_T2 := RF_D2;
					next_fsm_state_var := M21;
--					case (instr_reg(15 downto 12)) is
--						when "0000" =>
--							next_fsm_state_var := M3;
--						when "0010" =>
--							next_fsm_state_var := M3;
--						when "0011" =>
--							next_fsm_state_var := M3;
--						when "0100" =>
--							next_fsm_state_var := M3;
--						when "0101" =>
--							next_fsm_state_var := M3;
--						when "0110" =>
--							next_fsm_state_var := M3;
--						when "1001" =>
--							next_fsm_state_var := M8;
--						when ("1101" or "1111") =>
--							next_fsm_state_var := M13;
--						when "1100" =>
--							next_fsm_state_var := M11;
--						when "1000" =>
--							next_fsm_state_var := M7;
--						when ("1011" or "1010" or "0001") =>
--							next_fsm_state_var := M5;
--						when others =>
--							null;
--					end case;
				
				when m21 =>
					MEM_WRITE_BAR_ENABLE<='0';
					RF_WRITE_IN <= '0';
					MEM_READ<='0';
					temp_T1 := RF_D1; temp_T2 := RF_D2;
					case (instr_reg_var(15 downto 12)) is
						when "0000" =>
							next_fsm_state_var := M3;
						when "0010" =>
							next_fsm_state_var := M3;
						when "0011" =>
							next_fsm_state_var := M3;
						when "0100" =>
							next_fsm_state_var := M3;
						when "0101" =>
							next_fsm_state_var := M3;
						when "0110" =>
							next_fsm_state_var := M3;
						when "1001" =>
							next_fsm_state_var := M8;
						when ("1101" or "1111") =>
							next_fsm_state_var := M13;
						when "1100" =>
							next_fsm_state_var := M11;
						when "1000" =>
							next_fsm_state_var := M7;
						when ("1011" or "1010" or "0001") =>
							next_fsm_state_var := M5;
						when others =>
							null;
					end case;
				
				when M3 =>
					MEM_WRITE_BAR_ENABLE<='0';
					MEM_READ<='0';
					RF_WRITE_IN <= '0';
					ALU_A <= T1; ALU_B <= T2;
					ALU_CONTROL <= instr_reg(15 downto 12);
				
--					temp_T3 := ALU_O;
--					temp_out <= temp_T3;
					next_fsm_state_var := M31;
				
				when m31 =>
					MEM_WRITE_BAR_ENABLE<='0';
					MEM_READ<='0';
					RF_WRITE_IN <= '0';
					temp_T3 := ALU_O;
					temp_out <= temp_T3;
					next_fsm_state_var := M4;
					
				when M4 =>
					MEM_WRITE_BAR_ENABLE<='0';
					MEM_READ<='0';
					RF_WRITE_IN <= '1';
					RF_D3<=T3;
					RF_A3<=instr_reg(5 downto 3);
--					final_out <=T3;
					next_fsm_state_var := m1;
					
					
				when M5 =>
					RF_WRITE_IN <= '0';
					MEM_WRITE_BAR_ENABLE<='0';
					MEM_READ<='0';
					ALU_A<=T1;
				   SIGN_extender_6_INPUT<= instr_reg(5 downto 0);
					ALU_B<= SIGN_EXTENDER_6_OUTPUT;
					ALU_CONTROL<="0000";
					temp_T3:=ALU_O;
					case (instr_reg(15 downto 12)) is
						when "1011" =>
							next_fsm_state_var := M10;
						when "1010" =>
							next_fsm_state_var := M9;
						when "0001" =>
							next_fsm_state_var := M4;
						when others =>
							null;
					end case;

				when M6 =>
					RF_WRITE_IN <= '0';
					MEM_WRITE_BAR_ENABLE<='0';
					MEM_READ<='0';
					ALU_A <= instr_pointer;
					aLU_B <= "0000000000000001";
					ALU_CONTROL<="0000";
--					next_IP := ALU_O;
					next_fsm_state_var := M61;
					
				when m61 =>
					RF_WRITE_IN <= '0';
					MEM_WRITE_BAR_ENABLE<='0';
					MEM_READ<='0';
					next_IP := ALU_O;
					next_fsm_state_var := M2;
				
				when M7 =>
					RF_WRITE_IN <= '0';
					MEM_WRITE_BAR_ENABLE<='0';
					MEM_READ<='0';
				   SIGN_extender_8_INPUT<= instr_reg(7 downto 0);
					ALU_A <= SIGN_EXTENDER_8_OUTPUT;
					ALU_B <= "0000000000000000";
					ALU_CONTROL <= "0001";
					temp_T3:=ALU_O;
					next_fsm_state_var:= M4;

				when M8 =>
					RF_WRITE_IN <= '1';
					MEM_WRITE_BAR_ENABLE<='0';
					MEM_READ<='0';
               SIGN_extender_8_INPUT<= instr_reg(7 downto 0);
					RF_D3<= SIGN_EXTENDER_8_OUTPUT;
					RF_A3<= instr_reg(11 downto 9);
--					final_out <= T3;
					next_fsm_state_var := m1;

				when M9 =>
					RF_WRITE_IN <= '0';
					MEM_WRITE_BAR_ENABLE<='0';
					MEM_READ<='1';
					mem_A<=T3;
				   temp_T3:=mem_DOUT;
					next_fsm_state_var:=M4;

				when M10 =>
					MEM_WRITE_BAR_ENABLE<='1';
					RF_WRITE_IN <= '0';
					Mem_READ<='0';
					Mem_A<=T3;
					mem_Din<= T2;						--out changed to in
--					final_out <= T3;
					next_fsm_state_var := m1;

				when M11 =>
					RF_WRITE_IN <= '0';
					MEM_WRITE_BAR_ENABLE<='0';
					Mem_READ<='0';
					ALU_A<=T1;
					ALU_B <= T2;
					ALU_CONTROL<="0010";
					TZ_TEMP:=ALU_Z;
					next_fsm_state_var := M12;

				when M12 =>
					RF_WRITE_IN <= '0';
					MEM_WRITE_BAR_ENABLE<='0';
					Mem_READ<='0';
					ALU_A<=instr_pointer;
					SIGN_extender_6_INPUT<=instr_reg(5 downto 0);
					ALU_CONTROL<="0000";
					ALU_B<=SIGN_EXTENDER_6_OUTPUT;
					temp_T3:=ALU_O;
					next_fsm_state_var:= M16;

				when M13 =>
					MEM_WRITE_BAR_ENABLE<='0';
					RF_WRITE_IN <= '1';
					RF_D3 <= instr_pointer;
					RF_A3 <= instr_reg(11 downto 9);

					case (instr_reg(13)) is
						when '0' =>
							next_fsm_state_var := M14;
						when '1' =>
							next_fsm_state_var := M15;
						when others =>
							null;
					end case;
				
				when M14 =>
					MEM_WRITE_BAR_ENABLE<='0';
					RF_WRITE_IN <= '0';
					Mem_READ<='0';
					                                                               -- ye wala part thoda doubtful lagrha hai...
					SIGN_extender_9_INPUT<=instr_reg(8 downto 0);
					next_fsm_state_var := m141;
					
				when M141=>
					ALU_A<= SIGN_EXTENDER_9_OUTPUT;
					ALU_B<= "0000000000000010";
					ALU_CONTROL<="0011";
					next_fsm_state_var := m142;
					
				when M142=>
					tempb := ALU_O;
					ALU_B <= tempb;
					ALU_A <= instr_pointer;
					ALU_CONTROL<="0000";
					next_fsm_state_var := m143;
					
				when m143=>
					next_IP := alu_o;
					next_fsm_state_var := m1;
				
				when M15 =>
					MEM_WRITE_BAR_ENABLE<='0';
					RF_WRITE_IN <= '0';
					Mem_READ<='0';
					
					RF_A2<=instr_reg(8 downto 6);
					next_IP := RF_D2;
--					final_out <= T3;
					next_fsm_state_var := m1;
					
					
				when M16 =>
					MEM_WRITE_BAR_ENABLE<='0';
					RF_WRITE_IN <= '0';
					MEM_READ<='0';
					ALU_A<= instr_pointer;
					ALU_B<= "0000000000000001";
					ALU_CONTROL<="0000";
					temp_T1 := ALU_O;
					if (Z_flag <= '1') then
					instr_pointer <= T3;
					else instr_pointer <= T1;
					end if;
--					final_out <= T3;
				next_fsm_state_var := m1;	
					


				when others =>
					null;
			end case ;

			T1 <= temp_T1; T2 <= temp_T2; T3 <= temp_T3;														
			instr_reg <= instr_reg_var;																			
			Z_FLAG <= TZ_TEMP;	
			tempbs<=tempb;
			--RF_WRITE_IN <= RF_WRITE_IN_var;
			--MEM_WRITE_BAR_ENABLE <= MEM_WRITE_BAR_ENABLE_var;

				--T1 <= temp_T1; T2 <= temp_T2; T3 <= temp_T3; T4 <= temp_T4;
				--instr_reg <= instr_reg_var;
--				if (rst = '1') then                                                              -
--					instr_pointer <= x"0000";                                                     -
--					fsm_state <= M1;                                                              -
--					MEM_WRITE_BAR_ENABLE <= '1';
					--RF_WRITE_IN_var := '0';
					--MEM_WRITE_BAR_ENABLE <= '1';
					--RF_WRITE_IN <= '0';
					--T1 <= x"0000";
					--T2 <= x"0000";
					--T3 <= x"0000";
					--T4 <= x"0000";
					--instr_reg <= x"0000";
--				else                                                                             -
--					fsm_state <= next_fsm_state;                                                  -
--					next_IP:= instr_pointer;													               - 
					--instr_reg <= instr_reg_var;
					--T1 <= temp_T1; T2 <= temp_T2; T3 <= temp_T3; T4 <= temp_T4;
					--instr_reg <= instr_reg_var;
					--RF_WRITE_IN <= RF_WRITE_IN_var;
					--MEM_WRITE_BAR_ENABLE <= MEM_WRITE_BAR_ENABLE_var;
					
--				end if;                                                                           -

			--T1 <= temp_T1; T2 <= temp_T2; T3 <= temp_T3; T4 <= temp_T4;
			--instr_reg <= instr_reg_var;
			--RF_WRITE_IN <= RF_WRITE_IN_var;
			--MEM_WRITE_BAR_ENABLE <= MEM_WRITE_BAR_ENABLE_var;

			--RF_WRITE_IN <= RF_WRITE_IN_var;
			--MEM_WRITE_BAR_ENABLE <= MEM_WRITE_BAR_ENABLE_var;
    
		
			--next_fsm_state <= next_fsm_state_var;
				
			if(rising_edge(clk)) then
				--T1 <= temp_T1; T2 <= temp_T2; T3 <= temp_T3; T4 <= temp_T4;
				--instr_reg <= instr_reg_var;
				if (rst = '1') then
					instr_pointer <= "0000000000000000";
					fsm_state <= M1;

				else
					fsm_state <= next_fsm_state_var;
					instr_pointer <= next_IP;
					final_out <= temp_out;
				end if;
				
			else
				fsm_state<=fsm_state;
				instr_pointer<=instr_pointer;
			end if;
					
		end process;
		
		--output_process : process(fsm_state,clk)
		--begin
			--final_out <= temp_out;
		--end process;
	
	
end main;