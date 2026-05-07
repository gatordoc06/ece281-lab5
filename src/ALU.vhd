----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is
begin

process(i_A, i_B, i_op)
    variable A_s, B_s : signed(7 downto 0);
    variable result_s : signed(7 downto 0);
    variable result_u : unsigned(8 downto 0); -- for carry
    variable N, Z, C, V : std_logic;
begin
    -- Convert inputs
    A_s := signed(i_A);
    B_s := signed(i_B);

    -- Defaults
    result_s := (others => '0');
    result_u := (others => '0');
    N := '0'; Z := '0'; C := '0'; V := '0';

    case i_op is
        when "000" => -- ADD
            result_u := unsigned('0' & i_A) + unsigned('0' & i_B);
            result_s := signed(result_u(7 downto 0));

            C := result_u(8);
            if (i_A(7) = i_B(7)) and (result_s(7) /= i_A(7)) then
                V := '1';
            else
                V := '0';
            end if;

        when "001" => -- SUB
        result_s := A_s - B_s;
    
        -- Carry
        if unsigned(i_A) >= unsigned(i_B) then
            C := '1';
        else
            C := '0';
        end if;
    
        -- Overflow
        if (i_A(7) /= i_B(7)) and (result_s(7) /= i_A(7)) then
            V := '1';
        else
            V := '0';
        end if;

        when "010" => -- AND
            result_s := signed(i_A and i_B);

        when "011" => -- OR
            result_s := signed(i_A or i_B);

        when others =>
            result_s := (others => '0');
    end case;

    -- Flags
    N := result_s(7);

    if result_s = 0 then
        Z := '1';
    else
        Z := '0';
    end if;

    -- Outputs
    o_result <= std_logic_vector(result_s);
    o_flags  <= N & Z & C & V;

end process;

end Behavioral;
