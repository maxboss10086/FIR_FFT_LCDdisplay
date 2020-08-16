library verilog;
use verilog.vl_types.all;
entity FIR_audio_lcd_top is
    port(
        altera_reserved_tms: in     vl_logic;
        altera_reserved_tck: in     vl_logic;
        altera_reserved_tdi: in     vl_logic;
        altera_reserved_tdo: out    vl_logic;
        aud_dacdat      : out    vl_logic;
        sys_clk         : in     vl_logic;
        aud_bclk        : in     vl_logic;
        rst_n           : in     vl_logic;
        aud_lrc         : in     vl_logic;
        aud_adcdat      : in     vl_logic;
        aud_sda         : inout  vl_logic;
        aud_mclk        : out    vl_logic;
        lcd_hs          : out    vl_logic;
        lcd_vs          : out    vl_logic;
        lcd_de          : out    vl_logic;
        lcd_bl          : out    vl_logic;
        lcd_rst         : out    vl_logic;
        lcd_pclk        : out    vl_logic;
        aud_scl         : out    vl_logic;
        adc_data        : out    vl_logic_vector(31 downto 16);
        data            : out    vl_logic_vector(17 downto 0);
        lcd_rgb         : out    vl_logic_vector(15 downto 0)
    );
end FIR_audio_lcd_top;
