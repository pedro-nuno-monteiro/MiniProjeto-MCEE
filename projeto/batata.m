clc; clear; close all;

Vs = 75; Rs = 100; RL_CC = 200; Td = 2e-3; Z0=50;
%Vs=24; Rs=5; RL_CC=25; Z0=100; Td=5e-3;

n_iteracoes=3;

%% Fonte

I=Vs/Rs;
x = linspace(0, I, 10000);
f = @(x) Vs - Rs .* x;
plot(x, f(x), 'r', 'LineWidth', 2); hold on;


%% Carga

c = @(x) RL_CC .* x;
plot(x, c(x), 'b', 'LineWidth', 2); grid on;

%% Ponto de operaçao

zero_x = fzero(@(x) f(x) - c(x), 2);
zero_y = f(zero_x);

plot(zero_x, zero_y, 'o', 'MarkerFaceColor','k');
xlabel('Corrente (A)'); ylabel('Tensao (V)');
%legend('Fonte', 'Carga', 'Ponto de operacao', 'Location','best');


%% Tensao na fonte e carga

ponto_i = [0 0];
zer_x = 0;
zer_y= 0;

for k=0:n_iteracoes

    if mod(k, 2) == 0
        b = zer_y - Z0 * zer_x;
        y1 = @(x) Z0.*x + b;
        
        zer_x = fzero(@(x) f(x) - y1(x), 1);
        zer_y = y1(zer_x);

        plot(x, y1(x), 'k--'); hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
        
    
    else
        b = zer_y + Z0 * zer_x;
        y2 = @(x) -Z0.*x + b;
        
        zer_x = fzero(@(x) c(x) - y2(x), 1);
        zer_y = y2(zer_x);
        
        plot(x, y2(x), 'k--'); hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
    end
end

hold off;