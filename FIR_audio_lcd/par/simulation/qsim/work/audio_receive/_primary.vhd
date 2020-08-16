library verilog;
use verilog.vl_types.all;
entity audio_receive is
    port(
        rst_n           : in     vl_logic;
        aud_bclk        : in     vl_logic;
        aud_lrc         : in     vl_logic;
        aud_adcdat      : in     vl_logic;
        rx_done         : out    vl_logic;
        adc_data        : out    vl_logic_vector(31 downto 0)
    );
end audio_receive;
