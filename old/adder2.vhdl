library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADDER2 is
  port  (  a: in std_logic_vector (1 downto 0);
           b: in std_logic_vector (1 downto 0);
         sum: out std_logic_vector (1 downto 0)
        );
end ADDER2;

architecture RTL of ADDER2 is 
begin 
  sum <= std_logic_vector (unsigned(a) + unsigned(b));
end RTL;
