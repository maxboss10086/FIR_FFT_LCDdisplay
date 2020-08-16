library verilog;
use verilog.vl_types.all;
entity audio_receive_vlg_sample_tst is
    port(
        aud_adcdat      : in     vl_logic;
        aud_bclk        : in     vl_logic;
        aud_lrc         : in     vl_logic;
        rst_n           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end audio_receive_vlg_sample_tst;
