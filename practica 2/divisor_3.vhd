library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Necesario para usar to_unsigned

entity divisor_3 is
    Port (
        clk       : in STD_LOGIC;  -- Reloj del sistema (100 MHz)
        ena       : in STD_LOGIC;  -- Habilitación
        f_div_2_5 : out STD_LOGIC := '0'; -- Salida 25 MHz (inicializada)
        f_div_1_25: out STD_LOGIC := '0'; -- Salida 12.5 MHz (inicializada)
        f_div_500 : out STD_LOGIC := '0'  -- Salida 5 MHz (inicializada)
    );
end divisor_3;

architecture Behavioral of divisor_3 is
    -- Contadores para la generación de señales
    signal count4 : unsigned(1 downto 0) := (others => '0');  -- Divide entre 4
    signal count2 : unsigned(0 downto 0) := (others => '0');  -- Divide entre 2
    signal count5 : unsigned(2 downto 0) := (others => '0');  -- Divide entre 5

    signal pulse_div4 : std_logic := '0'; -- Pulso generado por count4
    signal pulse_div2 : std_logic := '0'; -- Pulso generado por count2
    signal pulse_div5 : std_logic := '0'; -- Pulso generado por count5

begin
    process (clk)
    begin
        if rising_edge(clk) then
            if ena = '1' then
                -- Contador de módulo 4 (para generar 25 MHz)
                if count4 = to_unsigned(3, count4'length) then
                    count4 <= (others => '0');
                    pulse_div4 <= '1';
                else
                    count4 <= count4 + 1;
                    pulse_div4 <= '0';
                end if;

                -- Contador de módulo 2 (para 12.5 MHz)
                if pulse_div4 = '1' then
                    if count2 = to_unsigned(1, count2'length) then
                        count2 <= (others => '0');
                        pulse_div2 <= '1';
                    else
                        count2 <= count2 + 1;
                        pulse_div2 <= '0';
                    end if;
                else
                    pulse_div2 <= '0';
                end if;

                -- Contador de módulo 5 (para 5 MHz)
                if pulse_div4 = '1' then
                    if count5 = to_unsigned(4, count5'length) then
                        count5 <= (others => '0');
                        pulse_div5 <= '1';
                    else
                        count5 <= count5 + 1;
                        pulse_div5 <= '0';
                    end if;
                else
                    pulse_div5 <= '0';
                end if;

                -- Asignación correcta de los valores de salida
                f_div_2_5 <= pulse_div4;
                f_div_1_25 <= pulse_div2;
                f_div_500 <= pulse_div5;
                
            else
                -- Cuando ena = 0, las salidas deben mantenerse en 0 para evitar X
                f_div_2_5 <= '0';
                f_div_1_25 <= '0';
                f_div_500 <= '0';
                pulse_div4 <= '0';
                pulse_div2 <= '0';
                pulse_div5 <= '0';
            end if;
        end if;
    end process;

end Behavioral;