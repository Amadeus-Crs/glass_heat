lambda_glass = 0.4;      % 玻璃导热系数 (W/(m·K))
lambda_air   = 0.025;    % 空气导热系数 (W/(m·K))
T_in  = 20;              % 室内温度 (°C)
T_out = -10;             % 室外温度 (°C)
d     = 0.003;           % 单层玻璃厚度 (m)
L     = 0.012;           % 空气层厚度 (m)

Q_single = single_glass_heat_loss(T_in, T_out, lambda_glass, d);
Q_double = double_glass_heat_loss(T_in, T_out, lambda_glass, lambda_air, L, d);
Q_equiv  = Q_single / 2;

fprintf('热损失计算结果:\n');
fprintf('  单层玻璃 (厚度 %.0f mm 玻璃): %.2f W\n', d*1000, Q_single);
fprintf('  双层玻璃 (厚度 %.0f mm 玻璃 + %.0f mm 空气 + 厚度 %.0f mm 玻璃): %.2f W\n', ...
    d*1000, L*1000, d*1000, Q_double);
fprintf('  等效单层玻璃 (厚度 %.0f mm 玻璃 *2): %.2f W\n', d*1000, Q_equiv);

doublesaving_vs_single = (Q_single - Q_double) / Q_single * 100;
doublesaving_vs_equiv  = (Q_equiv - Q_double) / Q_equiv * 100;

fprintf('\n保温效果比较:\n');
fprintf('  比单层玻璃节省: %.1f%%\n', doublesaving_vs_single);
fprintf('  比等效厚度单层节省: %.1f%%\n', doublesaving_vs_equiv);

air_thicknesses = linspace(0.001, 0.05, 100); 
Q_values = zeros(size(air_thicknesses)); 

for i = 1:length(air_thicknesses)
    Q_values(i) = double_glass_heat_loss(T_in, T_out, lambda_glass, lambda_air, ...
                                          air_thicknesses(i), d);
end

figure('Position', [100, 100, 1200, 400]);  

subplot(1, 3, 1);
plot(air_thicknesses*1000, Q_values, 'b-', 'LineWidth', 2); hold on;
yline(Q_single, 'r--', 'LineWidth', 1.5, 'DisplayName', 'single glass');
yline(Q_equiv,  'm--', 'LineWidth', 1.5, 'DisplayName', 'equivalent single glass');
hold off;
xlabel('Air thickness (mm)');
ylabel('Heat loss (W)');
title('Heat loss variation with air layer thickness');
grid on;
legend('Location', 'best');

subplot(1, 3, 2);
saving_single = (Q_single - Q_values) ./ Q_single * 100;
plot(air_thicknesses*1000, saving_single, 'g-', 'LineWidth', 2);
xlabel('Air thickness (mm)');
ylabel('Saving (%)');
title('Saving compared to single glass');
grid on;

subplot(1, 3, 3);
saving_equiv = (Q_equiv - Q_values) ./ Q_equiv * 100;
plot(air_thicknesses*1000, saving_equiv, 'g-', 'LineWidth', 2);
xlabel('Air thickness (mm)');
ylabel('Saving (%)');
title('Saving compared to equivalent single glass');
grid on;

tightfig();  

function Q_single = single_glass_heat_loss(T_in, T_out, lambda_glass, d)
    Q_single = lambda_glass * (T_in - T_out) / d;
end

function Q_double = double_glass_heat_loss(T_in, T_out, lambda_glass, lambda_air, L, d)
    h = L / d;
    s = h * lambda_glass / lambda_air;
    Q_double = lambda_glass * (T_in - T_out) / (2*d + s*d);
end