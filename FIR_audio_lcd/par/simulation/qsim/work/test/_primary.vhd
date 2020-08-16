library verilog;
use verilog.vl_types.all;
entity test is
    port(
        aud_lrc         : in     vl_logic;
        aud_bclk        : in     vl_logic;
        lrc_edge        : out    vl_logic;
        aud_lrc_d0      : out    vl_logic;
        rst_n           : in     vl_logic;
        start_flag      : out    vl_logic
    );
end test;
