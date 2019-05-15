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
--		ram8x8(1) <= "00000011"; -- ENDERE�O 3
--		ram8x8(2) <= "00000000"; 
--		ram8x8(3) <= "10100110"; -- LOAD A DIRETO
--		ram8x8(4) <= "00000001";	
--		ram8x8(5) <= "00111011"; -- JMP SE 0
--		ram8x8(6) <= "00000010"; 
--		ram8x8(7) <= "01001100"; -- INC A

-- TESTE JMP INCONDICIONAL E DEC
	--   TESTE JMP SE 0
		ram8x8(0) <= "01001100"; -- INC A
		ram8x8(1) <= "00111010"; -- JMP INCONDICIONAL ENDERE�O 3
		ram8x8(2) <= "00000101"; 
		ram8x8(3) <= "10100110"; 
		ram8x8(4) <= "00000001";	
		ram8x8(5) <= "01111010"; -- DEC A
		ram8x8(6) <= "00111011"; -- JMP SE A = 0
		ram8x8(7) <= "00000000"; -- ENDERE�O = 0
		
	elsif clk'event and clk = '1' then
		-- Opera��o de escrita
		if rw = '1' then
			ram8x8(to_integer(unsigned(addr))) <= din;
		end if;
	end if;
	
end process;
dout <= ram8x8(to_integer(unsigned(addr)));
end Behavioral;

