library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga is
    Port (    clk : in  STD_LOGIC;
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
signal count 		 		: INTEGER range 0 to 501;

begin

--Processos clk e clk50 utilizados somente para diminuição da frequencia do clock
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

variable printa: integer range 0 to 10; --Define a cor a ser usada
variable ganhou: STD_LOGIC; -- Variaveis utilizadas para travar a tela quando ganhar ou perder
variable perdeu: STD_LOGIC;

begin
	if rst = '1' then
		VerticalA <= "0011011100"; -- Posição da tela onde o quadrado será pintado
		VerticalB <= "0011110000";
		HorizontalA <= "0101111100";
		HorizontalB <= "0110010000";
		count <= 0;
		ganhou := '0';
		perdeu := '0';
		
	elsif clk25'event and clk25 = '1' then
		--Indica a dimensão da tela
		if (horizontal_counter >= "0001111000" ) and (horizontal_counter < "1100001100" ) and -- 120 e 780 
		   (vertical_counter >= "0000101000" ) and (vertical_counter < "1000001000" ) then -- 40 e 520
				printa := 1; --Fundo será pintado de preto
			
			--Comparações para determinar que o quadrado deve ser pintado neste local
			if (horizontal_counter >= HorizontalA) and (horizontal_counter < HorizontalB) and
					(vertical_counter >= VerticalA) and (vertical_counter < VerticalB) then
						printa := 0; --Quadrado de verde
			end if;
			
			if VerticalA < "0000100111" then -- Se a borda do quadrado for menor que a parte superior, ganhou
				ganhou := '1';
					
			elsif VerticalB > "1000000111" then -- Se a borda do quadrado for maior que a parte inferior, perdeu
				perdeu := '1';
			end if;
			
			--travando a tela em preto caso tenha ganhado ou perdido
			if (ganhou = '1') or (perdeu = '1') then
				printa := 1;
			end if;
			
			if printa = 0 then
				red_out <= '0';
				green_out <= '1';
				blue_out <= '0';
				
			elsif printa = 1 then
				red_out <= '0';
				green_out <= '0';
				blue_out <= '0';							
			
			else
				red_out <= '1';
				green_out <= '1';
				blue_out <= '1';
			end if;
		end if;
		--Verificando se a saida da memoria na posição 240 está em 1
		--Caso esteja, o quadrado deve subir na tela
		--Entrará duas vezes na subida, pois levam 2 bordas de subida para que seja escrito o zero novamente na memoria
		if memout = "00000001" then
				VerticalA <= VerticalA - "0000001111";
				VerticalB <= VerticalB - "0000001111";
		end if;
		
		--Caso nao esteja, deve continuar descendo
		if memout = "00000000" then
			if count = 500 then
				VerticalA <= VerticalA + "0000001111";
				VerticalB <= VerticalB + "0000001111";
				count <= 0;
			end if;			
		count <= count + 1;
		end if;
		
		--Trecho de código abaixo para varredura de tela
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
	
		if (horizontal_counter="1100001011") then
			vertical_counter <= vertical_counter+"0000000001";
			horizontal_counter <= "0000000000";
		end if;
		
		if (vertical_counter="1000000111") then
			vertical_counter <= "0000000000";
		end if;
	end if;
	
end process;

end Behavioral;

