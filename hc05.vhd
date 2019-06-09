----------------------------------------------------------------------------------
-- Author:  Bruno Passos
-- Module:  HC05
-- Version: 0.1 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity hc05 is
    Port ( clk   : in   STD_LOGIC;
           rst   : in   STD_LOGIC;
           dout  : in   STD_LOGIC_VECTOR (7 downto 0);
           din   : out  STD_LOGIC_VECTOR (7 downto 0);
           addr  : out  STD_LOGIC_VECTOR (7 downto 0);
           rw    : out  STD_LOGIC;
			  led	  : out  STD_LOGIC_VECTOR (7 downto 0);
			  enter : in STD_LOGIC; -- SW7
			  dado  : in STD_LOGIC_VECTOR (3 downto 0); --SW4:1
			  an : out  STD_LOGIC_VECTOR (3 downto 0);
			  seg : out  STD_LOGIC_VECTOR (7 downto 0)
			 );
end hc05;

architecture Behavioral of hc05 is
--Controle de estados
signal ESTADO : STD_LOGIC_VECTOR (2 downto 0);

--Declaração dos Estados
constant RESET1  : STD_LOGIC_VECTOR (2 downto 0) := "000";
constant RESET2  : STD_LOGIC_VECTOR (2 downto 0) := "001";
constant BUSCA   : STD_LOGIC_VECTOR (2 downto 0) := "010";
constant DECODE  : STD_LOGIC_VECTOR (2 downto 0) := "011";
constant EXECUTA : STD_LOGIC_VECTOR (2 downto 0) := "100";

--Registradores
SIGNAL A  		: STD_LOGIC_VECTOR (7 downto 0);
SIGNAL PC 		: STD_LOGIC_VECTOR (7 downto 0);
SIGNAL OPCODE  : STD_LOGIC_VECTOR (7 downto 0);
SIGNAL FASE 	: STD_LOGIC_VECTOR (1 downto 0);
SIGNAL REGAUX  : STD_LOGIC_VECTOR (7 downto 0);

SIGNAL DISPLAY_7    : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL NUMERO_GUESS : integer range 0 to 16;
SIGNAL CONT_GUESS   : integer range 0 to 16;



begin
an   <= "1110";
addr <= PC;
led  <= pc;




process(clk, rst)
begin

--case DISPLAY_7 is
--			   when "00000000" =>   seg <= "11000000";--0
--			   when "00000001" =>   seg <= "11111001";--1
--			   when "00000010" =>   seg <= "10100100";--2
--		      when "00000011" =>   seg <= "10110000";--3
--				when "00000100" =>   seg <= "10011001";--4
--				when "00000101" =>   seg <= "10010010";--5
--				when "00000110" =>   seg <= "10000010";--6
--				when "00000111" =>   seg <= "11111000";--7
--				when "00001000" =>   seg <= "10000000";--8
--				when "00001001" =>   seg <= "10011000";--9
--				when "00001010" =>   seg <= "10001000";--A
--				when "00001011" =>   seg <= "10000011";--B
--				when "00001100" =>   seg <= "11000110";--C
--				when "00001101" =>   seg <= "10100001";--d
--				when "00001110" =>   seg <= "10000110";--E
--				when others =>   		seg <= "10001110";--F
--end case;

case NUMERO_GUESS is
			   when 0 =>   seg <= "11000000";--0
			   when 1 =>   seg <= "11111001";--1
			   when 2 =>   seg <= "10100100";--2
		      when 3 =>   seg <= "10110000";--3
				when 4 =>   seg <= "10011001";--4
				when 5 =>   seg <= "10010010";--5
				when 6 =>   seg <= "10000010";--6
				when 7 =>   seg <= "11111000";--7
				when 8 =>   seg <= "10000000";--8
				when 9 =>   seg <= "10011000";--9
				when 10 =>   seg <= "10001000";--A
				when 11 =>   seg <= "10000011";--B
				when 12 =>   seg <= "11000110";--C
				when 13 =>   seg <= "10100001";--d
				when 14 =>   seg <= "10000110";--E
				when others =>   		seg <= "10001110";--F
end case;



	if rst = '1' then
		A  	 <= "00000000";
		PC 	 <= "00000000";
		FASE   <= "00";
		ESTADO <= RESET1;
		DISPLAY_7 <= (OTHERS => '0');
		NUMERO_GUESS <= 0;
		CONT_GUESS <= 0;
		
	elsif clk'event and clk = '1' then	
		
		IF CONT_GUESS = 15 THEN
			CONT_GUESS <= 0;
		ELSE
			CONT_GUESS <= CONT_GUESS + 1;
		END IF;

		case ESTADO is
			when RESET1  =>
								PC   <= "00000000"; -- Primeiro endereço
								RW   <= '0'; 		   -- Modo leitura RAM
								FASE <= "00"; 
								ESTADO <= RESET2; -- Próximo estado
								DISPLAY_7 <= (OTHERS => '0');
								NUMERO_GUESS <= 0;
								CONT_GUESS <= 0;
								
			when RESET2  =>
								ESTADO <= BUSCA;
								
			when BUSCA 	 =>
								OPCODE <= dout; -- Guardar código da instrução que está na memória
								ESTADO <= DECODE;
								
			when DECODE  =>
								case OPCODE is
									when "01001100" =>	-- Operação de Incremento (Código da operação 4C)
															A <= A + 1;
															ESTADO <= EXECUTA;
									
									when "10100110" =>  -- (LDA # - IMEDIATO) Codigo Operação A6
															  -- LDA tem 2 fases
															if FASE = "00"  then
																PC <= PC + 1;
																FASE <= FASE + 1;
																
															elsif FASE = "01" then
																A <= dout;
																ESTADO <= EXECUTA;
															end if;
									
									when "10100111" => -- (LDA [#] - Modo direto - Contém endereço do dado) Codigo Operação A7
															if FASE = "00" then
																PC <= PC + 1;
																FASE <= FASE + 1;
															
															elsif FASE = "01" then
																REGAUX <= PC;
																PC <= dout;
																FASE <= FASE + 1;
																
															elsif FASE = "10" then
																A <= dout;
																PC <= REGAUX;
																ESTADO <= EXECUTA;
															end if;
															
									when "00111010" => -- Jump incondicional - Codigo Operação 3A
															if FASE  = "00" then
																PC <= PC + 1;
																FASE <= FASE + 1;
																														
															elsif FASE = "01" then
																PC <= dout - 1;
																ESTADO <= EXECUTA;
															end if;	

									when "00111011" => -- JMP Condicional se zero - Codigo Operação 3B
															if FASE = "00" then 
																PC <= PC + 1;
																
																if A = "00000000" then 
																	FASE <= FASE + 1;												
																else
																	ESTADO <= EXECUTA;
																end if;
																
															elsif FASE = "01" then
																PC <= dout - 1 ;
																ESTADO <= EXECUTA;
															end if;
															
									WHEN "00111100" => -- JMP Condicional se nao zero - Codigo Operação 3C
															if FASE = "00" then
																PC <= PC + 1;
																
																if A = "00000000" then
																	ESTADO <= EXECUTA;
																else
																	FASE <= FASE + 1;
																end if;
															
															elsif FASE = "01" then
																PC <= dout - 1;
																ESTADO <= EXECUTA;
															end if;
									
									when "01111010" => -- DEC A - Codigo operação 7A
															A <= A - 1;
															ESTADO <= EXECUTA;	

									when "10101010" => -- SW A - Codigo operação AA
															if FASE = "00" then
																if enter = '1' then
																	A <= "00000000" + dado;
																	FASE <= FASE + 1;
																end if;
															
															elsif FASE = "01" then
																if enter = '0' then
																	ESTADO <= EXECUTA;
																end if;
																
															end if;
									WHEN "00001111" => 
															if A = NUMERO_GUESS then
																A <= "00000000";	
															else															
																A <= "00000001";
															end if;	
															ESTADO <= EXECUTA;
									
									WHEN "11111111" =>
															NUMERO_GUESS <= CONT_GUESS;
															ESTADO <= EXECUTA;
													
									WHEN "10101100" => -- Escrever na memória (endereco 240) -  OPCODE AC						
														if FASE = "00" then
															PC <= PC + 1;
															FASE <= FASE + 1;
														elsif FASE = "01" then
															REGAUX <= PC;
															din <= dout;
															PC <= "11110000";
															rw <= '1';
															fase <= FASE + 1;
														elsif FASE = "10" then
															rw <= '0';
															PC <= REGAUX;
															ESTADO <= EXECUTA;
														end if;
															
									when others => null;
								end case;
								
			when EXECUTA =>
								PC <= PC + 1;
								ESTADO <= BUSCA;  
								FASE <= "00";
			
			when others  => estado <= RESET1;
		end case;
		--Maquina de Estados
	end if;
end process;

end Behavioral;

