library verilog;
use verilog.vl_types.all;
entity test_vlg_check_tst is
    port(
        aud_lrc_d0      : in     vl_logic;
        lrc_edge        : in     vl_logic;
        start_flag      : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end test_vlg_check_tst;
