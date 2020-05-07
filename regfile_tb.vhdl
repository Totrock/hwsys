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
   signal in_data: std_logic_vector (15 downto 0);
   signal in_sel:  std_logic_vector (2 downto 0);
   signal out0_data:  std_logic_vector (15 downto 0);
   signal out0_sel:  std_logic_vector (2 downto 0);
   signal out1_data:  std_logic_vector (15 downto 0);
   signal out1_sel:  std_logic_vector (2 downto 0);
   signal load_lo, load_hi:  std_logic;
   
   

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
  
  procedure cycle is 
	begin 
		clk <= '0';
		wait for c_clk_per/2;
		clk <= '1';
		wait for c_clk_per/2;
	end procedure;
  
  begin
    wait for 5 ns;
    clk <= '0';
    wait for 5 ns;
    in_data <= "0000000000000000";
    in_sel <= "000";
    load_lo <= '1';
    load_hi <= '0';
    out0_sel <= "000";
    out1_sel <= "001";
    -- fill all registers with from 0000000110000000 to 1000000000000001
    for i in 0 to 7 loop
		in_sel <= std_logic_vector(to_unsigned(i, 3)); 
		in_data <= std_logic_vector(to_unsigned(2**(8+i)+2**(7-i), 16)); 
		load_lo <= '1';
		load_hi <= '0';    
		cycle;
		load_lo <= '0';
		load_hi <= '1';
		cycle;
    end loop;

    load_lo <= '0';
	load_hi <= '0';
    -- check all registers were written with: 0000000110000000 to 1000000000000001
    for i in 0 to 7 loop
		out0_sel <= std_logic_vector(to_unsigned(i,3)); 
		wait for c_clk_per/2;
		--report("round " & integer'image(i) & 
		--" expected: " & integer'image(2**(8+i)+2**(7-i)) & 
		--" out0_data: " & integer'image(to_integer(unsigned (out0_data))));
        assert out0_data = std_logic_vector(to_unsigned(2**(8+i) + 2**(7-i),16)) report "out0_data wrong!";
    end loop;

    --check load lo
    in_data <= "0000000010101010";
    in_sel <= "000"; 
	load_lo <= '1';
	load_hi <= '0'; 
    out0_sel <= "000"; 
    cycle;
    assert out0_data = "0000000110101010" report "lo1hi0 fail!";
    --... and that no other register changed
	for i in 1 to 7 loop
		out0_sel <= std_logic_vector(to_unsigned(i,3)); 
		wait for c_clk_per/2;
        assert out0_data = std_logic_vector(to_unsigned(2**(8+i) + 2**(7-i),16)) report "out0_data wrong!";
    end loop;

    --check load hi
	in_data <= "1111000000000000";
    in_sel <= "000"; 
	load_lo <= '0';
	load_hi <= '1'; 
    out1_sel <= "000"; 
    cycle;
    --... and that no other register changed
    assert out1_data = "1111000010101010" report "lo0hi1 fail!";
    for i in 1 to 7 loop
		out1_sel <= std_logic_vector(to_unsigned(i,3)); 
		wait for c_clk_per/2;
        assert out1_data = std_logic_vector(to_unsigned(2**(8+i) + 2**(7-i),16)) report "out0_data wrong!";
    end loop;
    
    
    --check load hi/lo = 0
    load_lo <= '0';
	load_hi <= '0'; 
	out1_sel <= "000";
	cycle;
    assert out1_data = "1111000010101010" report "lo0hi0 fail!";
    --... and that no other register changed
    for i in 1 to 7 loop
		out1_sel <= std_logic_vector(to_unsigned(i,3)); 
		wait for c_clk_per/2;
        assert out1_data = std_logic_vector(to_unsigned(2**(8+i) + 2**(7-i),16)) report "out0_data wrong!";
    end loop;
    
    
    --check load hi/lo = 1
    in_data <= "1100110011001100";
    in_sel <= "111"; 
	load_lo <= '1';
	load_hi <= '1'; 
    out1_sel <= "111"; 
    cycle;
    assert out1_data = "1100110011001100" report "lo1hi1 fail!";
    
    
    -- check that reg_idx always points to the correct reg(idx)
    in_data <= "0000000000000000";
    in_sel <= "110"; 
	load_lo <= '0';
	load_hi <= '1'; 
    cycle;
    assert out1_data = "1100110011001100" report "1fail!";
    out1_sel <= "110";
    wait for c_clk_per/2;
    assert out1_data = "0000000000000010" report "2fail!";

    assert false report "Simulation finished" severity note;
    wait;               -- end simulation

  end process;
end architecture;
