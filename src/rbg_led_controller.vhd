library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rgb_led_controller is
    Port ( 
        clk       : in std_logic;
        clk_en    : in std_logic;
        rst       : in std_logic;
        btn_left  : in std_logic;
        btn_right : in std_logic;
        btn_up    : in std_logic;
        btn_down  : in std_logic;
        duty_r    : out unsigned(7 downto 0);
        duty_g    : out unsigned(7 downto 0);
        duty_b    : out unsigned(7 downto 0)
    );
end rgb_led_controller;

architecture Behavioral of rgb_led_controller is

    type color_state_type is (
        RED, ORANGE, YELLOW, LIGHT_GREEN, GREEN, TURQUOISE,
        CYAN, OCEAN, BLUE, VIOLET, MAGENTA, RASPBERRY
    );
    signal color_state : color_state_type := RED;
    signal brightness : unsigned(7 downto 0) := "00000001";

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                color_state <= RED;
                brightness <= to_unsigned(1, 8);
            elsif clk_en = '1' then
                if btn_right = '1' then
                    case color_state is
                        when RED        => color_state <= ORANGE;
                        when ORANGE     => color_state <= YELLOW;
                        when YELLOW     => color_state <= LIGHT_GREEN;
                        when LIGHT_GREEN=> color_state <= GREEN;
                        when GREEN      => color_state <= TURQUOISE;
                        when TURQUOISE  => color_state <= CYAN;
                        when CYAN       => color_state <= OCEAN;
                        when OCEAN      => color_state <= BLUE;
                        when BLUE       => color_state <= VIOLET;
                        when VIOLET     => color_state <= MAGENTA;
                        when MAGENTA    => color_state <= RASPBERRY;
                        when RASPBERRY  => color_state <= RED;
                    end case;
                elsif btn_left = '1' then
                    case color_state is
                        when RED        => color_state <= RASPBERRY;
                        when RASPBERRY  => color_state <= MAGENTA;
                        when MAGENTA    => color_state <= VIOLET;
                        when VIOLET     => color_state <= BLUE;
                        when BLUE       => color_state <= OCEAN;
                        when OCEAN      => color_state <= CYAN;
                        when CYAN       => color_state <= TURQUOISE;
                        when TURQUOISE  => color_state <= GREEN;
                        when GREEN      => color_state <= LIGHT_GREEN;
                        when LIGHT_GREEN=> color_state <= YELLOW;
                        when YELLOW     => color_state <= ORANGE;
                        when ORANGE     => color_state <= RED;
                    end case;
                end if;

                if btn_up = '1' then       
                    if brightness = to_unsigned(0, 8) then
                        brightness <= to_unsigned(2, 8);
                    elsif brightness < to_unsigned(128, 8) then
                        brightness <= brightness(6 downto 0) & "0";
                    elsif brightness = to_unsigned(128, 8) then
                        brightness <= to_unsigned(255, 8);
                    end if;
                
                elsif btn_down = '1' then
                    if brightness = to_unsigned(255, 8) then
                        brightness <= to_unsigned(128, 8);
                    elsif brightness > to_unsigned(2, 8) then
                        brightness <= "0" & brightness(7 downto 1);
                    elsif brightness = to_unsigned(2, 8) then
                        brightness <= to_unsigned(0, 8);
                    end if;
                end if;
            end if;
        end if;
    end process;

    process(color_state, brightness)
    begin
        case color_state is
            when RED =>
                duty_r <= brightness;
                duty_g <= (others => '0');
                duty_b <= (others => '0');
            when ORANGE =>
                duty_r <= brightness;
                duty_g <= "0" & brightness(7 downto 1);
                duty_b <= (others => '0');
            when YELLOW =>
                duty_r <= brightness;
                duty_g <= brightness;
                duty_b <= (others => '0');
            when LIGHT_GREEN =>
                duty_r <= "0" & brightness(7 downto 1);
                duty_g <= brightness;
                duty_b <= (others => '0');
            when GREEN =>
                duty_r <= (others => '0');
                duty_g <= brightness;
                duty_b <= (others => '0');
            when TURQUOISE =>
                duty_r <= (others => '0');
                duty_g <= brightness;
                duty_b <= "0" & brightness(7 downto 1);
            when CYAN =>
                duty_r <= (others => '0');
                duty_g <= brightness;
                duty_b <= brightness;
            when OCEAN =>
                duty_r <= (others => '0');
                duty_g <= "0" & brightness(7 downto 1);
                duty_b <= brightness;
            when BLUE =>
                duty_r <= (others => '0');
                duty_g <= (others => '0');
                duty_b <= brightness;
            when VIOLET =>
                duty_r <= "0" & brightness(7 downto 1);
                duty_g <= (others => '0');
                duty_b <= brightness;
            when MAGENTA =>
                duty_r <= brightness;
                duty_g <= (others => '0');
                duty_b <= brightness;
            when RASPBERRY =>
                duty_r <= brightness;
                duty_g <= (others => '0');
                duty_b <= "0" & brightness(7 downto 1);
        end case;
    end process;

end Behavioral;
