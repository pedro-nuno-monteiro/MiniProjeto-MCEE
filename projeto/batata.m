clc; clear; close all;

% Vs = 75; Rs = 100; RL_CC = 200; Td = 2e-3; Z0=50; tolerancia = 0.05;
Vs=24; Rs=5; RL_CC=20; Z0=100; Td_ma=5e-3; tolerancia = -20;
n_iteracoes=9;

% fonte + carga
figure('Name', 'Diagrama V(I)', 'NumberTitle', 'off', 'ToolBar', 'none', 'MenuBar', 'none');
I = Vs/Rs;
x = linspace(0, I, 10000);
f = @(x) Vs - Rs .* x;

subplot(1, 3, 1);
grafico_fonte = plot(x, f(x), 'r', 'LineWidth', 2);
hold on;

c = @(x) zeros(size(x));
yval = linspace(0, Vs, 10000)
grafico_carga = plot(0 * ones(size(x)), yval, 'b', LineWidth=2);
grid on;
xlabel('Corrente (A)'); ylabel('Tensão (V)');
grid on;

% ponto de operação
zero_x = fzero(@(x) f(x) - c(x), 2);
zero_y = f(zero_x);

po = plot(zero_x, zero_y, 'o', 'MarkerFaceColor','k');

title('Diagrama V(I)');
xlabel('Corrente (A)'); ylabel('Tensao (V)');

% tensão na carga + fonte
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
        
        if (abs(zer_x - pontos_x(k + 1)) < tolerancia) || (abs(zer_y - pontos_y(k + 1)) < tolerancia)
            fprintf("O método foi interrompido pois atingiu o valor da tolerância.");
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

        zer_x = fzero(@(x) c(x) - y2(x), 1);
        zer_y = y2(zer_x);
        
        if (abs(zer_x - pontos_x(k + 1)) < tolerancia) || (abs(zer_y - pontos_y(k + 1)) < tolerancia)
            fprintf("O método foi interrompido pois atingiu o valor da tolerância.");
            terminado = true;
            break;
        end

        plot(x, y2(x), 'k--');
        hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
    end

    if I > 4 * zer_x
        ylim([0 Vs+1]); xlim([0 2*zer_x]);
    else
        ylim([0 Vs+1]); xlim([0 I]);
    end
end
hold off;

% gráfico tensão
Td_ma = Td_ma*1e3;

if ~terminado
    x_tensao_fonte = 0 : 2*Td_ma : n_iteracoes*Td_ma;
    x_tensao_carga = [0, Td_ma : 2*Td_ma : n_iteracoes*Td_ma - Td_ma, n_iteracoes*Td_ma];

    x_corrente_fonte = x_tensao_fonte;
    x_corrente_carga = x_tensao_carga;
    
    if mod(n_iteracoes, 2) == 0
        va = zeros(1, n_iteracoes/2 + 2);  %tensão na carga
        ia = zeros(1, n_iteracoes/2 + 2);  %corrente na carga

        vb = zeros(1, n_iteracoes/2 + 1);  %tensão na fonte
        ib = zeros(1, n_iteracoes/2 + 1);  %tensão na fonte

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

    for k = 0:n_iteracoes
        if mod(k, 2) == 0
            va(aux_va + 1) = pontos_y(k + 1);
            aux_va = aux_va + 1;
            ia(aux_ia + 1) = pontos_x(k + 1);
            aux_ia = aux_ia + 1;
        else
            vb(aux_vb + 1) = pontos_y(k + 1);
            aux_vb = aux_vb + 1;
            ib(aux_ib + 1) = pontos_x(k + 1);
            aux_ib = aux_ib + 1;
        end
    end
    
    va(end) = va(end-1);
    vb(end) = vb(end-1);

    ia(end) = ia(end-1);
    ib(end) = ib(end-1);

    subplot(1, 3, 2);
    stairs(x_tensao_fonte, vb, 'r', LineWidth = 2);
    hold on;
    stairs(x_tensao_carga, va, 'b', LineWidth = 2);
    xlabel("t(ms)"); ylabel("V");
    title('Tensão');
    ylim([0 max(pontos_y) + 1]); xlim([0 n_iteracoes * Td_ma + 2 * Td_ma]);
    legend('Tensão na fonte', 'Tensão na carga', 'Location', 'best');
    grid on;
    hold off;

    subplot(1, 3, 3);
    stairs(x_corrente_fonte, ib, 'r', LineWidth = 2);
    hold on;
    stairs(x_corrente_carga, ia, 'b', LineWidth = 2);
    xlabel("t(ms)"); ylabel("A");
    title('Corrente');
    ylim([0 max(pontos_x)]); xlim([0 n_iteracoes* Td_ma + 2 * Td_ma]);
    legend('Corrente na fonte', 'Corrente na carga', 'Location', 'best');
    grid on;
    hold off;

end
