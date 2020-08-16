library verilog;
use verilog.vl_types.all;
entity data_modulus_vlg_sample_tst is
    port(
        clk_50m         : in     vl_logic;
        rst_n           : in     vl_logic;
        source_eop      : in     vl_logic;
        source_imag     : in     vl_logic_vector(15 downto 0);
        source_real     : in     vl_logic_vector(15 downto 0);
        source_sop      : in     vl_logic;
        source_valid    : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end data_modulus_vlg_sample_tst;
