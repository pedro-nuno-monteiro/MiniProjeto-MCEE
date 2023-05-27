clc; clear; close all;

Vs = 75;
Rs = 100;
circuito_aberto=true;
Td_ma = 2e-3;
Z0 = 50;
n_iteracoes = 4;

I = Vs/Rs;
x = linspace(0, I, 10000);
f = @(x) Vs - Rs .* x;

if circuito_aberto 
    verticalLine = @(c)0*ones(size(c));
    c = linspace(0, 2*Vs, 10000);
    verticalLine(c);
    plot(verticalLine(c), c); hold on;
    plot(x, f(x));
    plot(0, Vs, 'o');
end


zer_x = 0;
zer_y = 0;

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

        if pontos_y(k + 1) > zer_y
            razao = zer_y * 100 / pontos_y(k + 1);
        else 
            razao =  pontos_y(k + 1) * 100 / zer_y;
        end
        plot(x, y1(x), 'k--');
        hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
        
    else
        b = zer_y + Z0 * zer_x;
        y2 = @(x) -Z0.*x + b;

        pontos_x(k + 1) = zer_x;
        pontos_y(k + 1) = zer_y;

        zer_x = 0;
        zer_y = b;

        if pontos_y(k + 1) > zer_y
            razao = zer_y * 100 / pontos_y(k + 1);
        else 
            razao =  pontos_y(k + 1) * 100 / zer_y;
        end

        plot(x, y2(x), 'k--');
        hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
    end
    
    %if ir_para_tarefa == 0 || ir_para_tarefa == 2
    %    if I > 4 * zer_x
    %        ylim([0 Vs+1]); xlim([0 2*zer_x]);
    %    else
    %        ylim([0 Vs+1]); xlim([0 I]);
    %    end
    %else
    %    ylim([0 75]); xlim([0 10]);
    %end
end
%legend([grafico_fonte, grafico_carga, po], {'Fonte', 'Carga', 'Ponto de operação'}, 'Location', 'best');
hold off;


%%
clc; clear; close all;
% Método


Vs = 75;
Rs = 100;
circuito_aberto=true;
Td_ma = 2e-3;
Z0 = 50;
n_iteracoes = 4;



figure('Name', 'Diagrama V(I)', 'NumberTitle', 'off', 'ToolBar', 'none', 'MenuBar', 'none');
I = Vs/Rs;
x = linspace(0, I, 10000);

% reta da fonte

    f = @(x) Vs - Rs .* x;


% gráfico da fonte
subplot(1, 3, 1);
grafico_fonte = plot(x, f(x), 'r', 'LineWidth', 2);
hold on;

% reta da carga

    if circuito_aberto
        verticalLine = @(c)0*ones(size(c));
        c = linspace(0, Vs+1, 10000);
    
    end

% gráfico da carga

    grafico_carga = plot(verticalLine(c), c, 'b', 'LineWidth', 2);
grid on;


title('Diagrama V(I)');
xlabel('Corrente (A)'); ylabel('Tensão (V)');
grid on;

% ponto de operação
    zero_x=0;
    zero_y=Vs;


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

        plot(x, y1(x), 'k--');
        hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
        
    else
        b = zer_y + Z0 * zer_x;
        y2 = @(x) -Z0.*x + b;

        pontos_x(k + 1) = zer_x;
        pontos_y(k + 1) = zer_y;

        zer_x = 0;
        zer_y = b;
    
        if pontos_y(k + 1) > zer_y
            razao = zer_y * 100 / pontos_y(k + 1);
        else 
            razao =  pontos_y(k + 1) * 100 / zer_y;
        end

        plot(x, y2(x), 'k--');
        hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
    end
    
end
        if circuito_aberto
            zer_x=1;
        end

        if I > 4 * zer_x
            ylim([0 Vs+1]); xlim([0 2*zer_x]);
        else
            ylim([0 Vs+1]); xlim([0 I]);
        end


legend([grafico_fonte, grafico_carga, po], {'Fonte', 'Carga', 'Ponto de operação'}, 'Location', 'best');
hold off;

% gráfico tensão - tempo e corrente - tempo
Td = Td_ma*1e3;



    x_tensao_fonte = 0 : 2*Td : n_iteracoes*Td;
    x_tensao_carga = [0, Td : 2*Td : n_iteracoes*Td - Td, n_iteracoes*Td];

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
















