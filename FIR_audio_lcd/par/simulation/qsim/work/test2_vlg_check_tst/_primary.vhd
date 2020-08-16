library verilog;
use verilog.vl_types.all;
entity test2_vlg_check_tst is
    port(
        data_imag       : in     vl_logic_vector(15 downto 0);
        data_real       : in     vl_logic_vector(15 downto 0);
        source_data     : in     vl_logic_vector(15 downto 0);
        sampler_rx      : in     vl_logic
    );
end test2_vlg_check_tst;
