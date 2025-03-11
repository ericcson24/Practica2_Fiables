library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use std.textio.ALL;

entity tb_divisor_3 is
end tb_divisor_3;

architecture testbench of tb_divisor_3 is
    -- Señales de prueba
    signal clk       : std_logic := '0';
    signal ena       : std_logic := '0';
    signal f_div_2_5 : std_logic;
    signal f_div_1_25: std_logic;
    signal f_div_500 : std_logic;

    -- Período del reloj de 100 MHz (10 ns)
    constant clk_period : time := 10 ns;

begin
    -- Instancia del módulo divisor
    uut: entity work.divisor_3
        port map (
            clk       => clk,
            ena       => ena,
            f_div_2_5 => f_div_2_5,
            f_div_1_25=> f_div_1_25,
            f_div_500 => f_div_500
        );

    -- Generación del reloj de 100 MHz
    process
    begin
        while now < 2000 ns loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Proceso de simulación
    process
    begin
        -- Esperar unos ciclos antes de habilitar
        wait for 20 ns;
        ena <= '1';
        wait for 2000 ns;  -- Simulación total de 2000 ns
        ena <= '0';
        wait;
    end process;
end testbench;
