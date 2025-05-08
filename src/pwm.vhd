
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm is
    Port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        duty    : in  unsigned(7 downto 0);
        pwm_out : out std_logic
    );
end pwm;

architecture Behavioral of pwm is
    signal counter : unsigned(7 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            counter <= (others => '0');
        elsif rising_edge(clk) then
            counter <= counter + 1;
        end if;
    end process;

    pwm_out <= '1' when counter < duty else '0';
end Behavioral;
