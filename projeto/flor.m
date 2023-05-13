clc; clear;
Rs = 100; RL_CC = 200; Td = 0.002; Z0 = 50; n_iteracoes = 4; tolerancia = 0.005;

A = 75; tau = 5;
T = 8; %(tau + um pouco);

n_graficos = 4;
y = [];
for k = 0:n_graficos - 1
    t = linspace(k*T, (k+1)*T, 1000);
    
    y = [y, A * rectpuls(t - k*T, tau)];
end

x = linspace(0, n_graficos * T, length(y));

x_2 = linspace(0, A/Rs, 4000);

figure('Name', 'Trem de Impulsos');
plot(x, y, LineWidth = 2);
title('Trem de Impulsos');

f(y ~= 0) = @(x) A - Rs.*x;
figure(2);
plot(x_2, f(x_2), LineWidth = 2);
title('Diagrama V(I)');
hold on;

