----------------------------------------------------------------------------------
-- Author:  Bruno Passos
-- Module:  Top
-- Version: 0.1 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (7 downto 0);
           din : in  STD_LOGIC_VECTOR (7 downto 0);
           rw : in  STD_LOGIC;
           dout : out  STD_LOGIC_VECTOR (7 downto 0);
		   memout : out STD_LOGIC_VECTOR (7 downto 0)
		 );
end ram;

architecture Behavioral of ram is
type type_ram is array (0 to 255) of STD_LOGIC_VECTOR (7 downto 0);
signal ram8x8: type_ram;

begin

process(clk, rst)
begin
	if rst = '1' then

-- INSTRUCOES PARA GERAR UM NUMERO NO DISPLAY
		RAM8X8(0) <= "11111111"; -- Gera o número
		RAM8X8(1) <= "10101010"; -- Input do switch
		RAM8X8(2) <= "00001111"; -- Compara resultado do switch com número correto
		RAM8X8(3) <= "00111011"; -- Jmp se zero, caso tenha acertado o número
		RAM8X8(4) <= "00000000"; -- endereço 7
		RAM8X8(5) <= "00111010"; -- JMP incondicional caso tenha errado o número
		RAM8X8(6) <= "00000001"; -- Endereço 1
		RAM8X8(7) <= "10101100"; -- Escrever no endereço 240
		RAM8X8(8) <= "00000001"; -- Valor 1
		RAM8X8(9) <= "00111011"; -- Escrever no endereço 240
		RAM8X8(10) <= "00000000"; -- Valor 0

		--RAM8X8(9) <= "10101100"; -- Escrever no endereço 240
		--RAM8X8(10) <= "00000000"; -- Valor 0
		RAM8X8(11) <= "00111011"; -- Jmp incondicional
		RAM8X8(12) <= "00000000"; -- Endereço 0
		RAM8X8(240) <= "00000001"; -- Valor verificado no jogo
		
	elsif clk'event and clk = '1' then
		-- Operação de escrita
		if rw = '1' then
			ram8x8(to_integer(unsigned(addr))) <= din;
		end if;
	end if;
	
end process;
dout <= ram8x8(to_integer(unsigned(addr)));
memout <= RAM8X8(240);
end Behavioral;

