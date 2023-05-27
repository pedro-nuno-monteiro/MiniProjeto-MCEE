function [] = opcao_3(Vs, Rs, RL, circuito_aberto, Td_ma, Z0, n_iteracoes, tolerancia, ir_para_tarefa, reta_fonte, reta_carga, tau)

% função que é executada quando é escolhida
% a 3a opção do menu

% apresentar a seguinte info:
% 1. parâmetros
% 2. gráfico V(I) - figura 3
% 3. gráfico da tensão na f3onte/carga
% 4. gráfico da corrente na fonte/carga
% 5. tabela com valores de tensão/corrente 
% 6. tensão e corrente no ponto de operação
clc;
fprintf("\n******************** Método de Bergeron ********************\n");

if ir_para_tarefa ~= 2
    if (Vs == 0 || Rs == 0 || Td_ma == 0 || Z0 == 0 || n_iteracoes == 0) && ir_para_tarefa == 0   % confirmar valores
        fprintf("\n\tAinda não acabou de definir a configuração do circuito.");
        fprintf("\n\tEscolha uma das seguintes opções:");
        fprintf("\n\n\t\t Prima 1 - Terminar a configuração");
        fprintf("\n\n\t\t Prima 2 - Utilizar a configuração predefinida\n");
        fprintf("\n************************************************************")
    
        opcao = 0;
        while opcao < 1 || opcao > 2 || ~isscalar(opcao)
            opcao = input('\n\t Opção escolhida: ');
        end
        
        if opcao == 1
            return
        else
            clc;
            opcao = 0;
            fprintf("\n******************** Método de Bergeron ********************\n");
            fprintf("\n\tQual das configurações pretende utilizar?");
            fprintf("\n\n\t\t Opção 1:");
            fprintf("\n\t\t\t\tVs = 75"); fprintf("\n\t\t\t\tRs = 100"); fprintf("\n\t\t\t\tRL = 200");
            fprintf("\n\t\t\t\tTd = 0.002"); fprintf("\n\t\t\t\tZ0 = 100"); fprintf("\n\t\t\t\tNúmero de iterações = 4");
            fprintf("\n\t\t\t\tTolerância = 2");
            
            fprintf("\n\n\t\t Opção 2:");
            fprintf("\n\t\t\t\tVs = 24"); fprintf("\n\t\t\t\tRs = 200"); fprintf("\n\t\t\t\tRL = 100");
            fprintf("\n\t\t\t\tTd = 0.005"); fprintf("\n\t\t\t\tZ0 = 50"); fprintf("\n\t\t\t\tNúmero de iterações = 10");
            fprintf("\n\t\t\t\tTolerância = 2\n");
            fprintf("\n************************************************************")
    
            while opcao < 1 || opcao > 2 || ~isscalar(opcao)
                opcao = input("\n\t Opção escolhida: ");
            end
            
            if opcao == 1
                Vs = 75;
                Rs = 100;
                RL = 200;
                Td_ma = 2e-3;
                Z0 = 50;
                n_iteracoes = 4;
                tolerancia = 2;
            else
                Vs = 24; 
                Rs = 5; 
                RL = 0; 
                Z0 = 100; 
                Td_ma = 5e-3; 
                tolerancia = 2; 
                n_iteracoes = 10;
            end
        end
    end
    
    clc;
    fprintf("\n******************** Método de Bergeron *******************\n");
    fprintf("\n\t Configuração definida: \n");
    if ir_para_tarefa == 0
        fprintf("\n\t Vs \t\t\t\t %d V", Vs);
        fprintf("\n\t Rs \t\t\t\t %d %c", Rs, char(216));
    elseif ir_para_tarefa == 1
        fprintf("\n\t Reta da Fonte = %s", reta_fonte);
        fprintf("\n\t Reta da Carga = %s", reta_carga);
    end
    fprintf("\n\t RL_CC \t\t\t\t %d %c", RL, char(216));
    fprintf("\n\t Td \t\t\t\t %f s", Td_ma);
    fprintf("\n\t Z0 \t\t\t\t %f %c", Z0, char(216));
    fprintf("\n\t Número iterações \t %d", n_iteracoes);
    fprintf("\n\t Tolerância \t\t %0.2f\n", tolerancia);
    fprintf("\n***********************************************************\n");

end

% Método

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
subplot(1, 3, 1);
grafico_fonte = plot(x, f(x), 'r', 'LineWidth', 2);
hold on;

% reta da carga
if ir_para_tarefa == 1
    c = str2func(['@(x) ' reta_carga]);
else
    c = @(x) RL .* x;
end

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

        %if ((100 - tolerancia) < pontos_x(k + 1) * 100 / zer_x) || ((100 - tolerancia) < razao) && pontos_x(k + 1) ~= 0
        %    fprintf("O método foi interrompido pois atingiu o valor da tolerância.");
        %    terminado = true;
        %    break;
        %end
        
        %if (tau * 1e-3 < k * Td_ma) && ir_para_tarefa == 2
        %    fprintf("O método terminou pois a fonte se desligou.\n");
        %    fprintf("A duração do pulso é menor que o tempo total necessário para realizar o método\n\n");
        %    terminado = true;
        %    break;
        %end

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

        if pontos_y(k + 1) > zer_y
            razao = zer_y * 100 / pontos_y(k + 1);
        else 
            razao =  pontos_y(k + 1) * 100 / zer_y;
        end

        %if ((100 - tolerancia) < pontos_x(k + 1) * 100 / zer_x) || ((100 - tolerancia) < razao) && pontos_x(k + 1) ~= 0
        %    fprintf("O método foi interrompido pois atingiu o valor da tolerância.");
        %    terminado = true;
        %    break;
        %end

        %if (tau * 1e-3 < k * Td_ma) && ir_para_tarefa == 2
        %    fprintf("O método terminou pois a fonte se desligou.\n");
        %    fprintf("A duração do pulso é menor que o tempo total necessário para realizar o método\n\n");
        %    terminado = true;
        %    break;
        %end

        plot(x, y2(x), 'k--');
        hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
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
end
legend([grafico_fonte, grafico_carga, po], {'Fonte', 'Carga', 'Ponto de operação'}, 'Location', 'best');
hold off;

% gráfico tensão - tempo e corrente - tempo
Td = Td_ma*1e3;

if ~terminado

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

    % gráfico tensão - tempo
    subplot(1, 3, 2);
    stairs(x_tensao_fonte, vb, 'r', LineWidth = 2);
    hold on;
    stairs(x_tensao_carga, va, 'b', LineWidth = 2);
    xlabel("t(ms)"); ylabel("V");
    title('Tensão');
    ylim([0 max(pontos_y) + 1]); xlim([0 n_iteracoes * Td + 2 * Td]);
    if RL == 0
        ylim([-50 50]);
    end
    legend('Tensão na fonte', 'Tensão na carga', 'Location', 'best');
    grid on;

    % gráfico corrente - tempo
    subplot(1, 3, 3);
    stairs(x_corrente_fonte, ib, 'r', LineWidth = 2);
    hold on;
    stairs(x_corrente_carga, ia, 'b', LineWidth = 2);
    xlabel("t(ms)"); ylabel("A");
    title('Corrente');
    ylim([0 max(pontos_x)]); xlim([0 n_iteracoes* Td + 2 * Td]);
    legend('Corrente na fonte', 'Corrente na carga', 'Location', 'best');
    grid on;

    hold off;
    
    % Tabela com valores de Tensão e Corrente
    fprintf("\n\tTabela dos valores da tensão:\n");
    fprintf("\n\tIteração\t\tTempo\t\tTensão\t\t   Corrente");
    for k = 0:n_iteracoes
        tempo = Td * k - Td;
        fprintf("\n\t%d\t\t\t\t%2.2d s\t\t%2.3f V \t\t%2.3f A", k + 1, tempo, pontos_y(k + 1), pontos_x(k + 1));
    end
    
    % Ponto de Operação
    fprintf("\n\n***********************************************************\n");
    fprintf("\t\nPonto de Operação:");
    fprintf("\n\n\t\tV = %0.3f V", zero_x);
    fprintf("\n\n\t\tI = %0.3f A", zero_y);
    fprintf("\n\n***********************************************************\n");

end

input("\Prima uma tecla para voltar ao menu ");

end