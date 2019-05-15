----------------------------------------------------------------------------------
-- Author:  Bruno Passos
-- Module:  Top
-- Version: 0.1 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity hc05 is
    Port ( clk  : in   STD_LOGIC;
           rst  : in   STD_LOGIC;
           dout : in   STD_LOGIC_VECTOR (7 downto 0);
           din  : out  STD_LOGIC_VECTOR (7 downto 0);
           addr : out  STD_LOGIC_VECTOR (7 downto 0);
           rw   : out  STD_LOGIC;
			  led	 : out  STD_LOGIC_VECTOR (7 downto 0)
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
signal A  		: STD_LOGIC_VECTOR (7 downto 0);
signal PC 		: STD_LOGIC_VECTOR (7 downto 0);
SIGNAL OPCODE  : STD_LOGIC_VECTOR (7 downto 0);
SIGNAL FASE 	: STD_LOGIC_VECTOR (1 downto 0);
SIGNAL REGAUX  : STD_LOGIC_VECTOR (7 downto 0);

begin

addr <= PC;
led <= A;

process(clk, rst)
begin

	if rst = '1' then
		A  	 <= "00000000";
		PC 	 <= "00000000";
		FASE   <= "00";
		ESTADO <= RESET1;
		
	elsif clk'event and clk = '1' then
		case ESTADO is
			when RESET1  =>
								PC   <= "00000000"; -- Primeiro endereço
								RW   <= '0'; 		   -- Modo leitura RAM
								FASE <= "00"; 
								ESTADO <= RESET2; -- Próximo estado
								
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

									when "00111011" => -- JMP Condicional zero - Codigo Operação 3B
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
															
									when "01111010" => -- DEC A - Codigo operação 7A
															A <= A - 1;
															ESTADO <= EXECUTA;		
									
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

