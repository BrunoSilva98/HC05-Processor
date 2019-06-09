----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:49:08 06/05/2019 
-- Design Name: 
-- Module Name:    vga - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  din : in STD_LOGIC_VECTOR (7 downto 0);
			  red_out : out STD_LOGIC;
			  green_out : out STD_LOGIC;
			  blue_out : out STD_LOGIC;
			  hs_out : out STD_LOGIC;
			  vs_out : out STD_LOGIC;
			  memout : in STD_LOGIC_VECTOR (7 downto 0)
			);
end vga;

architecture Behavioral of vga is

signal clk50, clk25 		: STD_LOGIC;
signal horizontal_counter   : STD_LOGIC_VECTOR (9 downto 0);
signal vertical_counter     : STD_LOGIC_VECTOR (9 downto 0);
signal VerticalA   			: STD_LOGIC_VECTOR (9 downto 0);
signal VerticalB   			: STD_LOGIC_VECTOR (9 downto 0);
signal HorizontalA 			: STD_LOGIC_VECTOR (9 downto 0);
signal HorizontalB 			: STD_LOGIC_VECTOR (9 downto 0);
signal count 		 		: INTEGER range 0 to 500001;
signal countOK				: INTEGER range 0 to 50001;

begin

process (clk)
begin		
	if CLK'EVENT and CLK = '1' then
		if (clk50 = '0') then
			clk50 <= '1';
		else
			clk50 <= '0';
		end if;
	
		
	end if;
end process;

process (clk50)
begin
	if clk50'event and clk50='1' then
		if (clk25 = '0') then
			clk25 <= '1';
		else
			clk25 <= '0';
		end if;
	end if;
end process;

process (clk25,rst)

variable printa: integer range 0 to 10;
variable ganhou: STD_LOGIC;
variable perdeu: STD_LOGIC;

begin
	if rst = '1' then
		VerticalA <= "0011011100"; -- 220
		VerticalB <= "0011110000"; -- 240
		HorizontalA <= "0101111100";
		HorizontalB <= "0110010000";
		count <= 0;
		countOK <= 0;
		ganhou <= '0';
		perdeu <= '0';
		
	elsif clk25'event and clk25 = '1' then
		if (horizontal_counter >= "0001111000" ) and (horizontal_counter < "1100001100" ) and -- 120 e 780 
		   (vertical_counter >= "0000101000" ) and (vertical_counter < "1000001000" ) then -- 40 e 520
			printa := 1;
		
			if VerticalA < "0000100111" then -- Se a borda do quadrado for menor que a parte superior, ganhou
				ganhou <= '1';
			end if;
			
			if VerticalB > "‭1000000111‬" then -- Se a borda do quadrado for maior que a parte inferior, perdeu
				perdeu <= '1';
			end if;
			
			if (horizontal_counter >= HorizontalA) and (horizontal_counter < HorizontalB) and
			   (vertical_counter >= VerticalA) and (vertical_counter < VerticalB) then
					printa := 0;
			end if;
			
			if ganhou = '1' then
				printa := 2;
			end if;
			
			if perdeu = '1' then
				printa := 3;
			end if;
			
			if printa = 0 then
				red_out <= '0';
				green_out <= '0';
				blue_out <= '0';
				
			elsif printa = 1 then
				red_out <= '0';
				green_out <= '0';
				blue_out <= '1';
				
			elsif printa = 2 then
				red_out <= '0';
				green_out <= '1';
				blue_out <= '0';
			
			elsif printa = 3 then
				red_out <= '1';
				green_out <= '0';
				blue_out <= '0';
			end if;
			
		end if;
		
		if memout = "00000001" and countOK = 50000 then
			VerticalA <= VerticalA - "0000000111";
			VerticalB <= VerticalB - "0000000111";
		
		elsif memout = "00000001" then
			countOK <= countOK + 1;
		end if;
		
		if memout = "00000000" and count = 500000 then
			VerticalA <= VerticalA + "0000000011";
			VerticalB <= VerticalB + "0000000011";
			count <= 0;
		
		elsif memout = "00000000" then
			count <= count + 1;
		end if;
	
	--	if (VerticalB = 520) then
	--		VerticalA <= "0011011100";
	--		VerticalB <= "0011110000";
	--	end if;
		
		if (horizontal_counter > "0000000000")	and (horizontal_counter < "0001100001") then --96+1
			hs_out <= '0';
		else
			hs_out <= '1';
		end if;
		
		if (vertical_counter > "0000000000" )and (vertical_counter < "0000000011" ) then -- 2+1
			vs_out <= '0';
		else
			vs_out <= '1';
		end if;

		horizontal_counter <= horizontal_counter+"0000000001";
		
		if (horizontal_counter="1100100000") then
			vertical_counter <= vertical_counter+"0000000001";
			horizontal_counter <= "0000000000";
		end if;
		
		if (vertical_counter="1000001001") then
			vertical_counter <= "0000000000";
		end if;
	
	end if;
	
end process;

end Behavioral;

