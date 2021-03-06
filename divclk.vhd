----------------------------------------------------------------------------------
-- Author:  Bruno Passos
-- Module:  Top
-- Version: 0.1 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divclk is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clkdiv : out  STD_LOGIC);
end divclk;

architecture Behavioral of divclk is
signal cont : integer range 0 to 4;

begin
--Div para 25MHZ
process(clk,rst)
begin
	if rst = '1' then
		cont <= 0;
		
	elsif clk'event and clk = '1' then
		cont <= cont + 1;
		
		if cont <= 2 then
			clkdiv <= '0';
		else
			clkdiv <= '1';
		end if;
		
		if cont = 3 then
			cont <= 0;
		end if;
	end if;
end process;
end Behavioral;

