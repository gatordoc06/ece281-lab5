----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:42:49 PM
-- Design Name: 
-- Module Name: controller_fsm - FSM
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_fsm is
    Port ( i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture FSM of controller_fsm is
    type sm_state is (s_CLR, s_LOADa, s_LOADb, s_DISPLAY);
    
    signal f_Q, f_Q_next: sm_state;
begin
    
    --Next State Logic
f_Q_next <= s_LOADa when f_Q = s_CLR else
            s_LOADb when f_Q = s_LOADa else
            s_DISPLAY when f_Q = s_LOADb else
            s_CLR when f_Q = s_DISPLAY else
            f_Q;
            
    --Output logic
with f_Q select
    o_cycle <= "0001" when s_CLR,
               "0010" when s_LOADa,
               "0100" when s_LOADb,
               "1000" when s_DISPLAY,
               "0001" when others;

    --Processes
register_proc : process (i_adv)
begin
    if (rising_edge(i_adv)) then
        if (i_reset = '1') then
            f_Q <= s_CLR;
        else
            f_Q <= f_Q_next;
        end if;
    end if;
end process register_proc;
            

end FSM;
