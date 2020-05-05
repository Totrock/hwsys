library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FULL_ADDER is
  port (a, b, c: in std_logic; 
  sum, carry: out std_logic);
end FULL_ADDER;

architecture BEHAVIOR of FULL_ADDER is
begin

  process (a, b, c)
    variable a2, b2, c2, result: unsigned (1 downto 0);
  begin
    a2 := '0' & a;      -- extend 'a' to 2 bit
    b2 := '0' & b;      -- extend 'b' to 2 bit
    c2 := '0' & c;      -- extend 'c' to 2 bit
    result := a2 + b2 + c2;  -- add them
    sum <= result(0);   -- output 'sum' = lower bit
    carry <= result(1); -- output 'carry' = upper bit
  end process;

end BEHAVIOR;

--architecture DATAFLOW of FULL_ADDER is
--begin
--  sum <= a xor b xor c;
--  carry <= (a and b) or (a and c) or (b and c);
--end DATAFLOW;

architecture STRUCTURE of FULL_ADDER is

  SIGNAL S1,S2,S3:STD_LOGIC;

  component HALF_ADDER
    port (a, b: in std_logic; sum, carry: out std_logic);
  end component;

  component OR2
    port (x, y: in std_logic; z: out std_logic);
  end component;

  for I0: HALF_ADDER use entity WORK.HALF_ADDER(STRUCTURE);
  for I1: HALF_ADDER use entity WORK.HALF_ADDER(STRUCTURE);
  for I2: OR2 use entity WORK.OR2(DATAFLOW);

begin
  I0: HALF_ADDER port map(a => b, b => c, sum => S1,carry => S2);
  I1: HALF_ADDER port map(a => a, b => S1, sum => sum,carry => S3);
  I2: OR2 port map(x => S2, y => S3, z => carry);
end STRUCTURE;
