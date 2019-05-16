----------------------------------------------------------------------------------
-- Author:  Bruno Passos
-- Module:  Top
-- Version: 0.1 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( clk   : in  STD_LOGIC;
           rst   : in  STD_LOGIC;
			  enter : in STD_LOGIC; -- SW7
			  dado  : in STD_LOGIC_VECTOR (3 downto 0); --SW4:1
			  an    : out  STD_LOGIC_VECTOR (3 downto 0);
			  seg   : out  STD_LOGIC_VECTOR (7 downto 0);
           led   : out  STD_LOGIC_VECTOR (7 downto 0));
end top;

architecture Behavioral of top is
--Components

--RAM
component ram is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (7 downto 0);
           din : in  STD_LOGIC_VECTOR (7 downto 0);
           rw : in  STD_LOGIC;
           dout : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

--CPU
component hc05 is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           dout : in  STD_LOGIC_VECTOR (7 downto 0);
           din : out  STD_LOGIC_VECTOR (7 downto 0);
           addr : out  STD_LOGIC_VECTOR (7 downto 0);
           rw : out  STD_LOGIC;
			  led	 : out  STD_LOGIC_VECTOR (7 downto 0);
			  enter : in STD_LOGIC; -- SW7
			  dado  : in STD_LOGIC_VECTOR (3 downto 0); --SW4:1
			  an : out  STD_LOGIC_VECTOR (3 downto 0);
			  seg : out  STD_LOGIC_VECTOR (7 downto 0)
			 );
end component;

--Clock div
component divclk is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clkdiv : out  STD_LOGIC);
end component;

signal sclkdiv  : STD_LOGIC;
signal srw   : STD_LOGIC;
signal sdin  : STD_LOGIC_VECTOR (7 downto 0);
signal sdout : STD_LOGIC_VECTOR (7 downto 0);
signal saddr : STD_LOGIC_VECTOR (7 downto 0);

begin

--Instancias RAM, HC05 e DIVCLK
divclk1 : divclk  port map (clk, rst, sclkdiv); 
ram1    : ram     port map (sclkdiv, rst, saddr, sdin, srw, sdout);
hc051   : hc05    port map (sclkdiv, rst, sdout, sdin, saddr, srw, led, enter, dado, an, seg);


end Behavioral;

