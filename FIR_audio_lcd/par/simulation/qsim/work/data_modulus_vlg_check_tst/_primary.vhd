library verilog;
use verilog.vl_types.all;
entity data_modulus_vlg_check_tst is
    port(
        data_eop        : in     vl_logic;
        data_modulus    : in     vl_logic_vector(15 downto 0);
        data_sop        : in     vl_logic;
        data_valid      : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end data_modulus_vlg_check_tst;
