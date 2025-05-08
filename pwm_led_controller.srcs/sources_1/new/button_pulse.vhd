library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity button_pulse is
    generic (
        DB_TIME : time := 25 ms
    );
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        btn_in     : in  std_logic;
        pulse_out  : out std_logic
    );
end entity button_pulse;

architecture Behavioral of button_pulse is
    -- Internal signals
    signal btn_sync  : std_logic;
    signal edge      : std_logic;
    signal rise      : std_logic;
    signal fall      : std_logic;
    
    constant CLK_PERIOD : time     := 10 ns;
    constant MAX_COUNT  : natural  := DB_TIME / CLK_PERIOD;
    constant SYNC_BITS  : positive := 2;

    signal sync_buffer : std_logic_vector(SYNC_BITS - 1 downto 0);
    alias  sync_input  : std_logic is sync_buffer(SYNC_BITS - 1);
    signal sig_count   : natural range 0 to MAX_COUNT - 1 := 0;
    signal sig_btn     : std_logic := '0';
begin

    process(clk)
        variable edge_internal : std_logic;
        variable rise_internal : std_logic;
        variable fall_internal : std_logic;
    begin
        if rising_edge(clk) then
            sync_buffer <= sync_buffer(SYNC_BITS - 2 downto 0) & btn_in;

            edge <= '0';
            rise <= '0';
            fall <= '0';

            edge_internal := sync_input xor sig_btn;
            rise_internal := sync_input and not sig_btn;
            fall_internal := not sync_input and sig_btn;

            if sig_count = MAX_COUNT - 1 then
                sig_btn   <= sync_input;
                edge      <= edge_internal;
                rise      <= rise_internal;
                fall      <= fall_internal;
                sig_count <= 0;
            elsif sync_input /= sig_btn then
                sig_count <= sig_count + 1;
            else
                sig_count <= 0;
            end if;

            btn_sync <= sig_btn;
        end if;
    end process;

    pulse_out <= rise;

end architecture Behavioral;
