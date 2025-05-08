library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rgb_led_controller_top is
    Port (
        CLK100MHZ : in  std_logic;
        BTNC      : in  std_logic;
        BTNL      : in  std_logic;
        BTNR      : in  std_logic;
        BTNU      : in  std_logic;
        BTND      : in  std_logic;
        LED16_R   : out std_logic;
        LED16_G   : out std_logic;
        LED16_B   : out std_logic
    );
end rgb_led_controller_top;

architecture Structural of rgb_led_controller_top is

    component button_pulse
        generic (
            DB_TIME : time := 25 ms
        );
        port (
            clk       : in  std_logic;
            rst       : in  std_logic;
            btn_in    : in  std_logic;
            pulse_out : out std_logic
        );
    end component;

    component rgb_led_controller
        Port (
            clk       : in  std_logic;
            clk_en    : in  std_logic;
            rst       : in  std_logic;
            btn_left  : in  std_logic;
            btn_right : in  std_logic;
            btn_up    : in  std_logic;
            btn_down  : in  std_logic;
            duty_r    : out unsigned(7 downto 0);
            duty_g    : out unsigned(7 downto 0);
            duty_b    : out unsigned(7 downto 0)
        );
    end component;

    component pwm
        Port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            duty     : in  unsigned(7 downto 0);
            pwm_out  : out std_logic
        );
    end component;

    signal clk_en : std_logic := '1';

    signal duty_r, duty_g, duty_b : unsigned(7 downto 0);

    signal btn_left_pulse, btn_right_pulse, btn_up_pulse, btn_down_pulse : std_logic;

begin

    btn_left: button_pulse
        generic map (DB_TIME => 25 ms)
        port map (
            clk        => CLK100MHZ,
            rst        => BTNC,
            btn_in     => BTNL,
            pulse_out  => btn_left_pulse
        );

    btn_right: button_pulse
        generic map (DB_TIME => 25 ms)
        port map (
            clk        => CLK100MHZ,
            rst        => BTNC,
            btn_in     => BTNR,
            pulse_out  => btn_right_pulse
        );

    btn_up: button_pulse
        generic map (DB_TIME => 25 ms)
        port map (
            clk        => CLK100MHZ,
            rst        => BTNC,
            btn_in     => BTNU,
            pulse_out  => btn_up_pulse
        );

    btn_down: button_pulse
        generic map (DB_TIME => 25 ms)
        port map (
            clk        => CLK100MHZ,
            rst        => BTNC,
            btn_in     => BTND,
            pulse_out  => btn_down_pulse
        );

    controller: rgb_led_controller
        port map (
            clk       => CLK100MHZ,
            clk_en    => clk_en,
            rst       => BTNC,
            btn_left  => btn_left_pulse,
            btn_right => btn_right_pulse,
            btn_up    => btn_up_pulse,
            btn_down  => btn_down_pulse,
            duty_r    => duty_r,
            duty_g    => duty_g,
            duty_b    => duty_b
        );

    pwm_r: pwm
        port map (
            clk      => CLK100MHZ,
            rst      => BTNC,
            duty     => duty_r,
            pwm_out  => LED16_R
        );

    pwm_g: pwm
        port map (
            clk      => CLK100MHZ,
            rst      => BTNC,
            duty     => duty_g,
            pwm_out  => LED16_G
        );

    pwm_b: pwm
        port map (
            clk      => CLK100MHZ,
            rst      => BTNC,
            duty     => duty_b,
            pwm_out  => LED16_B
        );

end Structural;
