clear; clc;
A = 24;
tau = 15;
t = linspace(-1, tau + 1, 1000);
y = A * rectpuls(t - tau/2, tau);

Rs = 5; RL = 25; Td = 2; Z0 = 100; n_iteracoes = 10; tolerancia = 2;

figure('Name', 'Diagrama V(I)', 'NumberTitle', 'off', 'ToolBar', 'none', 'MenuBar', 'none');
I = A/Rs;
x = linspace(0, I, 10000);

% reta da fonte
f = @(x) A - Rs .* x;

% gráfico da fonte
grafico_fonte = plot(x, f(x), 'r', 'LineWidth', 2);
hold on;

% reta da carga
c = @(x) RL .* x;

% gráfico da carga
grafico_carga = plot(x, c(x), 'b', 'LineWidth', 2);
grid on;
title('Diagrama V(I)');
xlabel('Corrente (A)'); ylabel('Tensão (V)');
grid on;

% ponto de operação
zero_x = fzero(@(x) f(x) - c(x), 2);
zero_y = f(zero_x);

po = plot(zero_x, zero_y, 'o', 'MarkerFaceColor','k');

xlabel('Corrente (A)'); ylabel('Tensao (V)');
legend([grafico_fonte, grafico_carga, po], {'Fonte', 'Carga', 'Ponto de operação'}, 'Location', 'best');

zer_x = 0;
zer_y = 0;

pontos_x = zeros(1, n_iteracoes);   %corrente
pontos_y = zeros(1, n_iteracoes);   %tensão
terminado = false;
for k = 0:n_iteracoes

    if mod(k, 2) == 0
        b = zer_y - Z0 * zer_x;
        y1 = @(x) Z0.*x + b;

        if k ~= 0
            pontos_x(k) = zer_x;
            pontos_y(k) = zer_y;
        end
        zer_x = fzero(@(x) f(x) - y1(x), 1);
        zer_y = y1(zer_x);

        plot(x, y1(x), 'k--');
        hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');

    else
        b = zer_y + Z0 * zer_x;
        y2 = @(x) -Z0.*x + b;

        pontos_x(k) = zer_x;
        pontos_y(k) = zer_y;

        zer_x = fzero(@(x) c(x) - y2(x), 1);
        zer_y = y2(zer_x);

        plot(x, y2(x), 'k--');
        hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
    end

    if I > 4 * zer_x
        ylim([0 A+1]); xlim([0 2*zer_x]);
    else
        ylim([0 A+1]); xlim([0 I]);
    end

end
legend([grafico_fonte, grafico_carga, po], {'Fonte', 'Carga', 'Ponto de operação'}, 'Location', 'best');
hold off;

if mod(n_iteracoes, 2) == 0
    va = zeros(1, n_iteracoes/2);  %tensão na carga
    ia = zeros(1, n_iteracoes/2);  %corrente na carga

    vb = zeros(1, n_iteracoes/2);  %tensão na fonte
    ib = zeros(1, n_iteracoes/2);  %tensão na fonte

else
    va = zeros(1, round(n_iteracoes/2) + 1);  %tensão na carga
    ia = zeros(1, round(n_iteracoes/2) + 1);  %corrente na carga

    vb = zeros(1, round(n_iteracoes/2));  %tensão na fonte
    ib = zeros(1, round(n_iteracoes/2));  %tensão na fonte
end

aux_va = 0;
aux_ia = 0;
aux_vb = 0;
aux_ib = 0;

for k = 1:n_iteracoes
    if mod(k, 2) == 0
        va(aux_va + 1) = pontos_y(k);
        aux_va = aux_va + 1;
        ia(aux_ia + 1) = pontos_x(k);
        aux_ia = aux_ia + 1;
    else
        vb(aux_vb + 1) = pontos_y(k);
        aux_vb = aux_vb + 1;
        ib(aux_ib + 1) = pontos_x(k);
        aux_ib = aux_ib + 1;
    end
end

u = @(t) 1 * (t >= 0); % degrau
sa = [];

for i = 1:length(va)
    sa = strcat(sa, [' + ' num2str(va(i), 4) ' * u(t - ' num2str(2 * i - 1) ' * td)']);
    sa = strcat(sa, [' - ' num2str(va(i), 4) ' * u(t - ' num2str(2 * td - 1 + tau) ' * td)']);
end

sa = strcat('@(t, td) ', sa) % acrescenta o handle da função
fa = eval(sa); % converte a string numa função anónima
t = linspace(0, 55, 1000); % até 55 ms
figure(2);
plot(t, fa(t, Td), 'linewidth', 2);