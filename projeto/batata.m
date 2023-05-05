clc; clear; close all;

Vs = 75; Rs = 100; RL_CC = 200; Td = 2e-3; Z0=50;
%Vs=24; Rs=5; RL_CC=25; Z0=100; Td=5e-3;

n_iteracoes=4;

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

pontos_x = zeros(1, n_iteracoes);
pontos_y = zeros(1, n_iteracoes);

for k = 0:n_iteracoes

    if mod(k, 2) == 0
        b = zer_y - Z0 * zer_x;
        y1 = @(x) Z0.*x + b;
        
        pontos_x(k + 1) = zer_x;
        pontos_y(k + 1) = zer_y;

        zer_x = fzero(@(x) f(x) - y1(x), 1);
        zer_y = y1(zer_x);

        plot(x, y1(x), 'k--'); hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
        
    else
        b = zer_y + Z0 * zer_x;
        y2 = @(x) -Z0.*x + b;

        pontos_x(k + 1) = zer_x;
        pontos_y(k + 1) = zer_y;

        zer_x = fzero(@(x) c(x) - y2(x), 1);
        zer_y = y2(zer_x);
        
        plot(x, y2(x), 'k--'); hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
    end
end
        if I>4*zer_x
            ylim([0 Vs+1]); xlim([0 2*zer_x]);
        else
            ylim([0 Vs+1]); xlim([0 I]);
        end

hold off;

%% Gráfico com as curvas das tensões à saída da fonte e aos terminais da carga

x_tensao_fonte=0:2*Td*10^3:n_iteracoes*Td*1e3;
x_tensao_carga=[0, Td*1e3:2*Td*1e3:n_iteracoes*Td*1e3 - Td*1e3, n_iteracoes*Td*1e3];

vb = zeros(1, round(n_iteracoes/2+1));
a = 0;
va = zeros(1, round(n_iteracoes/2+2));
co = 0;
for j=0:n_iteracoes 
        
    if mod(j, 2) == 0
        va(a + 1) = pontos_y(j + 1);
        fprintf("\naqui e va(a) = %f e a = %d pontosy(j +1) = %f", va(a + 1), a, pontos_y(j + 1))
        a = a +1;
    else
        vb(co + 1) = pontos_y(j + 1);
        fprintf("\naqui e vb(co) = %f e co = %d pontosy(j +1) = %f", vb(co + 1), co, pontos_y(j + 1))
        co = co + 1;
    end
end

va(end) = va(end-1);
vb(end) = vb(end-1);

figure(2);
stairs(x_tensao_fonte, vb, 'LineWidth',2);
hold on;
stairs(x_tensao_carga, va, 'LineWidth',2);
ylim([0 Vs+1]); xlim([0 n_iteracoes*Td*1e3]);
grid on;
hold off;


%% Gráfico com as curvas das correntes na fonte e na carga







