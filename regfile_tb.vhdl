library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity REGFILE_TB is
end REGFILE_TB;


architecture TESTBENCH of REGFILE_TB is

  -- Component declaration
  component REGFILE is
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
  end component;

  -- Configuration...
  for IMPL: REGFILE use entity WORK.REGFILE(RTL);

  -- Internal signals...
  
  constant c_clk_per : time := 10 ns;
  
  signal clk:  std_logic;
  signal  in_data: std_logic_vector (15 downto 0);
  signal  in_sel:  std_logic_vector (2 downto 0);
   signal out0_data:  std_logic_vector (15 downto 0);
  signal  out0_sel:  std_logic_vector (2 downto 0);
   signal out1_data:  std_logic_vector (15 downto 0);
   signal out1_sel:  std_logic_vector (2 downto 0);
   signal load_lo, load_hi:  std_logic;
   
 --  procedure run_cycle is
  --   variable period: time := 10 ns;
 --    begin 
 ---      clk <= '0';
 --      wait for period / 2;
  --    clk <= '1';
  --    wait for period / 2;
   -- end procedure;

begin


  IMPL: REGFILE port map (clk => clk, 
  in_data => in_data,
  in_sel => in_sel,
  out0_data => out0_data,
  out0_sel => out0_sel,
  out1_data => out1_data,
  out1_sel => out1_sel,
  load_lo => load_lo, 
  load_hi => load_hi
  );

  -- Main process...
  process
  begin
  --for i in 0 to 7 loop
   -- end loop
    wait for 5 ns;
    clk <= '0';
    wait for 5 ns;
    in_data <= "0000000000000000";
    in_sel <= "000";
    load_lo <= '1';
    load_hi <= '0';
    out0_sel <= "000";
    out1_sel <= "001";
    

    clk <= not clk;
    wait for c_clk_per/2;
    clk <= not clk;
    wait for c_clk_per/2;
    
    load_lo <= '0';
    load_hi <= '1';
    clk <= not clk;
    wait for c_clk_per/2;
    clk <= not clk;
    wait for c_clk_per/2;
    
    assert out0_data = "0000000000000000"  report "genatzt!";



    -- Print a note & finish simulation now
    assert false report "Simulation finished" severity note;
    wait;               -- end simulation

  end process;
  
  

end architecture;


