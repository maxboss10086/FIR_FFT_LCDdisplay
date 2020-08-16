library verilog;
use verilog.vl_types.all;
entity audio_receive_vlg_check_tst is
    port(
        adc_data        : in     vl_logic_vector(31 downto 0);
        rx_done         : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end audio_receive_vlg_check_tst;
