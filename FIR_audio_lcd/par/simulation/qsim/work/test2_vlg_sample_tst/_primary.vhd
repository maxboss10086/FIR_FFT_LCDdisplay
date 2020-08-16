library verilog;
use verilog.vl_types.all;
entity test2_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        source_imag     : in     vl_logic_vector(15 downto 0);
        source_real     : in     vl_logic_vector(15 downto 0);
        sampler_tx      : out    vl_logic
    );
end test2_vlg_sample_tst;
