library verilog;
use verilog.vl_types.all;
entity data_modulus is
    port(
        altera_reserved_tms: in     vl_logic;
        altera_reserved_tck: in     vl_logic;
        altera_reserved_tdi: in     vl_logic;
        altera_reserved_tdo: out    vl_logic;
        clk_50m         : in     vl_logic;
        rst_n           : in     vl_logic;
        source_real     : in     vl_logic_vector(15 downto 0);
        source_imag     : in     vl_logic_vector(15 downto 0);
        source_sop      : in     vl_logic;
        source_eop      : in     vl_logic;
        source_valid    : in     vl_logic;
        data_modulus    : out    vl_logic_vector(15 downto 0);
        data_sop        : out    vl_logic;
        data_eop        : out    vl_logic;
        data_valid      : out    vl_logic
    );
end data_modulus;
