library verilog;
use verilog.vl_types.all;
entity test2 is
    port(
        altera_reserved_tms: in     vl_logic;
        altera_reserved_tck: in     vl_logic;
        altera_reserved_tdi: in     vl_logic;
        altera_reserved_tdo: out    vl_logic;
        rst_n           : in     vl_logic;
        clk             : in     vl_logic;
        source_data     : out    vl_logic_vector(15 downto 0);
        data_imag       : out    vl_logic_vector(15 downto 0);
        data_real       : out    vl_logic_vector(15 downto 0);
        source_real     : in     vl_logic_vector(15 downto 0);
        source_imag     : in     vl_logic_vector(15 downto 0)
    );
end test2;
