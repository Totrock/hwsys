library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity REGFILE is
  port (
    clk: in std_logic;
    in_data: in std_logic_vector (15 downto 0);
    in_sel: in std_logic_vector (2 downto 0);
    out0_data: out std_logic_vector (15 downto 0);
    out0_sel: in std_logic_vector (2 downto 0);
    out1_data: out std_logic_vector (15 downto 0);
    out1_sel: in std_logic_vector (2 downto 0);
    load_lo, load_hi: in std_logic
  );
end REGFILE;

architecture RTL of REGFILE is
  type t_regfile is array (0 to 7) of std_logic_vector(15 downto 0);
  signal reg: t_regfile;
  signal reg_idx : std_logic_vector (15 downto 0);
  
  begin
  process (reg, out0_sel, out1_sel)
	begin
		out0_data <= reg(to_integer(unsigned(out0_sel)));
		out1_data <= reg(to_integer(unsigned(out1_sel)));
		reg_idx <= reg(to_integer(unsigned (in_sel)));
  end process;
  process (clk)
  variable load_hilo: std_logic_vector (1 downto 0);
    begin
    if rising_edge (clk) then
	  load_hilo := load_hi & load_lo;
	  case load_hilo is
		 when "10" => reg(to_integer(unsigned (in_sel))) <= in_data(15 downto 8) & reg_idx(7 downto 0);
		 when "01" => reg(to_integer(unsigned (in_sel))) <= reg_idx(15 downto 8) & in_data(7 downto 0);
		 when "11" => reg(to_integer(unsigned (in_sel))) <= in_data(15 downto 0);
		 when others => null;
	  end case;
    end if;
  end process;
end RTL;
