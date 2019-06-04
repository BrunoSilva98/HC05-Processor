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
           dout : out  STD_LOGIC_VECTOR (7 downto 0));
end ram;

architecture Behavioral of ram is
type type_ram is array (0 to 255) of STD_LOGIC_VECTOR (7 downto 0);
signal ram8x8: type_ram;

begin

process(clk, rst)
begin
	if rst = '1' then
--	   TESTE JMP SE 0
--		ram8x8(0) <= "00111011"; -- JMP SE A = 0
--		ram8x8(1) <= "00000011"; -- ENDEREÇO 3
--		ram8x8(2) <= "00000000"; 
--		ram8x8(3) <= "10100110"; -- LOAD A DIRETO
--		ram8x8(4) <= "00000001";	
--		ram8x8(5) <= "00111011"; -- JMP SE 0
--		ram8x8(6) <= "00000010"; 
--		ram8x8(7) <= "01001100"; -- INC A

-- TESTE JMP INCONDICIONAL E DEC
--	--   TESTE JMP SE 0
--		ram8x8(0) <= "01001100"; 
--		ram8x8(1) <= "00111010"; 
--		ram8x8(2) <= "00000101"; 
--		ram8x8(3) <= "10100110"; 
--		ram8x8(4) <= "00000001";	
--		ram8x8(5) <= "01111010"; 
--		ram8x8(6) <= "00111011";
--		ram8x8(7) <= "00000000"; 

-- TESTE SWA
--		ram8x8(0) <= "10101010"; -- SWA
--		ram8x8(1) <= "01111010"; -- DEC
--		ram8x8(2) <= "00111010"; -- JMP 
--		ram8x8(3) <= "00000001"; -- END 01
--		ram8x8(4) <= "00000001";	
--		ram8x8(5) <= "01111010"; 
--		ram8x8(6) <= "00111011";
--		ram8x8(7) <= "00000000"; 


-- INSTRUCOES PARA GEAR UM NUMERO NO DISPLAY
		RAM8X8(0) <= "11111111";
		RAM8X8(1) <= "10101010";
		RAM8X8(2) <= "11111111";
		RAM8X8(3) <= "10101010";
		RAM8X8(4) <= "11111111";
		RAM8X8(5) <= "10101010";
		RAM8X8(6) <= "11111111";
		RAM8X8(7) <= "10101010";
		RAM8X8(8) <= "11111111";
		RAM8X8(9) <= "10101010";
		RAM8X8(10) <= "11111111";
		RAM8X8(11) <= "10101010";
		RAM8X8(12) <= "11111111";
		RAM8X8(11) <= "00111010";
		RAM8X8(12) <= "00000000";
		

	elsif clk'event and clk = '1' then
		-- Operação de escrita
		if rw = '1' then
			ram8x8(to_integer(unsigned(addr))) <= din;
		end if;
	end if;
	
end process;
dout <= ram8x8(to_integer(unsigned(addr)));
end Behavioral;

