library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rgb_led_controller_tb is
end rgb_led_controller_tb;

architecture Behavioral of rgb_led_controller_tb is

    signal clk        : std_logic := '0';
    signal clk_en     : std_logic := '0';
    signal rst        : std_logic := '0';
    
    signal btn_left   : std_logic := '0';
    signal btn_right  : std_logic := '0';
    signal btn_up     : std_logic := '0';
    signal btn_down   : std_logic := '0';
    
    signal duty_r     : unsigned(7 downto 0);
    signal duty_g     : unsigned(7 downto 0);
    signal duty_b     : unsigned(7 downto 0);
    
    signal pwm_r      : std_logic;
    signal pwm_g      : std_logic;
    signal pwm_b      : std_logic;
    
    signal pulse_left  : std_logic;
    signal pulse_right : std_logic;
    signal pulse_up    : std_logic;
    signal pulse_down  : std_logic;

begin

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    
    clk_en_process : process
    begin
        while true loop
            clk_en <= '1';
            wait for 500 us;
            clk_en <= '0';
            wait for 500 us;
        end loop;
    end process;

    left_pulse_gen: entity work.button_pulse
        port map (
            clk => clk,
            rst => rst,
            btn_in => btn_left,
            pulse_out => pulse_left
        );

    right_pulse_gen: entity work.button_pulse
        port map (
            clk => clk,
            rst => rst,
            btn_in => btn_right,
            pulse_out => pulse_right
        );

    up_pulse_gen: entity work.button_pulse
        port map (
            clk => clk,
            rst => rst,
            btn_in => btn_up,
            pulse_out => pulse_up
        );

    down_pulse_gen: entity work.button_pulse
        port map (
            clk => clk,
            rst => rst,
            btn_in => btn_down,
            pulse_out => pulse_down
        );

    led_ctrl: entity work.rgb_led_controller
        port map (
            clk => clk,
            clk_en => clk_en,
            rst => rst,
            btn_left => pulse_left,
            btn_right => pulse_right,
            btn_up => pulse_up,
            btn_down => pulse_down,
            duty_r => duty_r,
            duty_g => duty_g,
            duty_b => duty_b
        );

    
    pwm_r_inst: entity work.pwm
        port map (
            clk => clk,
            rst => rst,
            duty => duty_r,
            pwm_out => pwm_r
        );

    pwm_g_inst: entity work.pwm
        port map (
            clk => clk,
            rst => rst,
            duty => duty_g,
            pwm_out => pwm_g
        );

    pwm_b_inst: entity work.pwm
        port map (
            clk => clk,
            rst => rst,
            duty => duty_b,
            pwm_out => pwm_b
        );

    
    stimulus: process
    begin
        
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 2 ms;
        
        for i in 0 to 2 loop
            btn_up <= '1';
            wait for 2 ms;   
            btn_up <= '0';
            wait for 2 ms;  
        end loop;
        
        for i in 0 to 5 loop
            btn_right <= '1';
            wait for 2 ms;
            btn_right <= '0';
            wait for 2 ms;
        end loop;

        
        for i in 0 to 5 loop
            btn_down <= '1';
            wait for 2 ms;
            btn_down <= '0';
            wait for 2 ms;
        end loop;
        
         for i in 0 to 20 loop
            btn_up <= '1';
            wait for 1 ms;   
            btn_up <= '0';
            wait for 1 ms; 
        end loop;

        for i in 0 to 7 loop
            btn_left <= '1';
            wait for 2 ms;
            btn_left <= '0';
            wait for 2 ms;
        end loop;
        
        rst <= '1';
        wait for 2 ms;
        rst <= '0';
        
        wait for 100 ms;
        assert false report "Simulation finished." severity failure;
    end process;

end Behavioral;
