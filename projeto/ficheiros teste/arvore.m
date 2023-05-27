
clear; clc;

Vs = 24;
Rs = 5;
RL = 25;
Z0 = 100;
Td_ma = 5e-3;
tolerancia = 98;
n_iteracoes = 14;

ir_para_tarefa = 0;
circuito_aberto = false;

figure('Name', 'Diagrama V(I)', 'NumberTitle', 'off', 'ToolBar', 'none', 'MenuBar', 'none');
I = Vs/Rs;
x = linspace(0, I, 10000);

% reta da fonte
if ir_para_tarefa == 1
    f = str2func(['@(x) ' reta_fonte]);
    x = linspace(0, 10, 10000);
else
    f = @(x) Vs - Rs .* x;
end

% gráfico da fonte
grafico_fonte = plot(x, f(x), 'r', 'LineWidth', 2);
hold on;

% reta da carga
if ir_para_tarefa == 1
    c = str2func(['@(x) ' reta_carga]);
else
    if circuito_aberto
        verticalLine = @(c) 0 * ones(size(c));
        c = linspace(0, Vs + 1, 10000);
    else
        c = @(x) RL .* x;
    end
end

% gráfico da carga

if circuito_aberto
    grafico_carga = plot(verticalLine(c), c, 'b', 'LineWidth', 2);
else
    grafico_carga = plot(x, c(x), 'b', 'LineWidth', 2);
end
grid on;

title('Diagrama V(I)');
xlabel('Corrente (A)'); ylabel('Tensão (V)');
grid on;

% ponto de operação
if circuito_aberto
    zero_x = 0;
    zero_y = Vs;
else
    zero_x = fzero(@(x) f(x) - c(x), 2);
    zero_y = f(zero_x);
end

po = plot(zero_x, zero_y, 'o', 'MarkerFaceColor','k');

xlabel('Corrente (A)'); ylabel('Tensao (V)');
legend([grafico_fonte, grafico_carga, po], {'Fonte', 'Carga', 'Ponto de operação'}, 'Location', 'best');

% obter valores de tensão e corrente na carga e fonte
zer_x = 0;
zer_y = 0;

pontos_x = zeros(1, n_iteracoes);
pontos_y = zeros(1, n_iteracoes);
terminado = false;
for k = 0:n_iteracoes

    if mod(k, 2) == 0
        b = zer_y - Z0 * zer_x;
        y1 = @(x) Z0.*x + b;

        pontos_x(k + 1) = zer_x;
        pontos_y(k + 1) = zer_y;

        zer_x = fzero(@(x) f(x) - y1(x), 1);
        zer_y = y1(zer_x);

        if pontos_y(k + 1) > zer_y
            razao = zer_y * 100 / pontos_y(k + 1);
        else
            razao =  pontos_y(k + 1) * 100 / zer_y;
        end

        if ((tolerancia < pontos_x(k + 1) * 100 / zer_x) || (tolerancia < razao)) && pontos_x(k + 1) ~= 0
            fprintf("O método foi interrompido pois atingiu o valor da tolerância.\n");
            terminado = true;
            break;
        end

        plot(x, y1(x), 'k--');
        hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');

    else
        b = zer_y + Z0 * zer_x;
        y2 = @(x) -Z0.*x + b;

        pontos_x(k + 1) = zer_x;
        pontos_y(k + 1) = zer_y;

        if circuito_aberto
            zer_x = 0;
            zer_y = b;
        else
            zer_x = fzero(@(x) c(x) - y2(x), 1);
            zer_y = y2(zer_x);
        end

        if pontos_y(k + 1) > zer_y
            razao = zer_y * 100 / pontos_y(k + 1);
        else
            razao =  pontos_y(k + 1) * 100 / zer_y;
        end

        if ((tolerancia < pontos_x(k + 1) * 100 / zer_x) || tolerancia < razao) && pontos_x(k + 1) ~= 0
            fprintf("O método foi interrompido pois atingiu o valor da tolerância.\n");
            terminado = true;
            break;
        end

        plot(x, y2(x), 'k--');
        hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
    end
end

if ir_para_tarefa == 0 || ir_para_tarefa == 2
    if I > 4 * zer_x
        ylim([0 Vs+1]); xlim([0 2*zer_x]);
    else
        ylim([0 Vs+1]); xlim([0 I]);
    end
else
    ylim([0 75]); xlim([0 10]);
end

legend([grafico_fonte, grafico_carga, po], {'Fonte', 'Carga', 'Ponto de operação'}, 'Location', 'best');
hold off;