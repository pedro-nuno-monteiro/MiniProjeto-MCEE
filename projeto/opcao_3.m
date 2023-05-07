function [] = opcao_3(Vs, Rs, RL_CC, RL_CA, Td_ma, Z0, n_iteracoes, tolerancia)

% função que é executada quando é escolhida
% a 3a opção do menu

% apresentar a seguinte info:
% 1. parâmetros
% 2. gráfico V(I) - figura 3
% 3. gráfico da tensão na fonte/carga
% 4. gráfico da corrente na fonte/carga
% 5. tabela com valores de tensão/corrente 
% 6. tensão e corrente no ponto de operação
clc;
fprintf("\n******************** Método de Bergeron ********************\n");

if Vs == 0 || Rs == 0 || RL_CC == 0 || Td_ma == 0 || Z0 == 0 || n_iteracoes == 0  %não funciona se usar isempty()
    fprintf("\n\tAinda não acabou de definir a configuração do circuito.");
    fprintf("\n\tEscolha uma das seguintes opções:");
    fprintf("\n\n\t\t Prima 1 - Terminar a configuração");
    fprintf("\n\n\t\t Prima 2 - Utilizar a configuração predefinida\n");
    fprintf("\n************************************************************")

    opcao = 0;
    while opcao < 1 || opcao > 2
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
        fprintf("\n\t\t\t\tTolerância = 0.005");
        
        fprintf("\n\n\t\t Opção 2:");
        fprintf("\n\t\t\t\tVs = 24"); fprintf("\n\t\t\t\tRs = 200"); fprintf("\n\t\t\t\tRL = 100");
        fprintf("\n\t\t\t\tTd = 0.005"); fprintf("\n\t\t\t\tZ0 = 50"); fprintf("\n\t\t\t\tNúmero de iterações = 10");
        fprintf("\n\t\t\t\tTolerância = 0.005\n");
        fprintf("\n************************************************************")

        while opcao < 1 || opcao > 2
            opcao = input("\n\t Opção escolhida: ");
        end
        
        if opcao == 1
            Vs = 75;
            Rs = 100;
            RL_CC = 200;
            Td_ma = 2e-3;
            Z0 = 50;
            n_iteracoes = 4;
            tolerancia = 0.005;
        else
            Vs = 24; 
            Rs = 5; 
            RL_CC = 25; 
            Z0 = 100; 
            Td_ma = 5e-3; 
            tolerancia = -20; 
            n_iteracoes = 10;
        end
    end
end

% ponto 1
clc;
fprintf("\n******************** Método de Bergeron *******************\n");
fprintf("\n\t Configuração definida: \n");
fprintf("\n\t Vs \t\t\t\t %d V", Vs);
fprintf("\n\t Rs \t\t\t\t %d %c", Rs, char(216));
fprintf("\n\t RL_CC \t\t\t\t %d %c", RL_CC, char(216));
fprintf("\n\t Td \t\t\t\t %f s", Td_ma);
fprintf("\n\t Z0 \t\t\t\t %f %c", Z0, char(216));
fprintf("\n\t Número iterações \t %d", n_iteracoes);
fprintf("\n\t Tolerância \t\t %0.2f\n", tolerancia);
fprintf("\n***********************************************************\n");

% fonte + carga
figure('Name', 'Diagrama V(I)', 'NumberTitle', 'off', 'ToolBar', 'none', 'MenuBar', 'none');
I = Vs/Rs;
x = linspace(0, I, 10000);
f = @(x) Vs - Rs .* x;

subplot(2, 4, [1 6]);
plot(x, f(x), 'r', LineWidth = 2);
hold on;

c = @(x) RL_CC .* x;
plot(x, c(x), 'b', LineWidth = 2);
grid on;
xlabel('Corrente (A)'); ylabel('Tensão (V)');
grid on;

% ponto de operação
zero_x = fzero(@(x) f(x) - c(x), 2);
zero_y = f(zero_x);

plot(zero_x, zero_y, 'o', 'MarkerFaceColor','k');

xlabel('Corrente (A)'); ylabel('Tensao (V)');
%legend('Fonte', 'Carga', 'Ponto de operação', 'Location','best');

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
Td = Td_ma*1e3;

if ~terminado
    x_tensao_fonte = 0 : 2*Td : n_iteracoes*Td;
    x_tensao_carga = [0, Td : 2*Td : n_iteracoes*Td - Td, n_iteracoes*Td];
    
    va = zeros(1, round(n_iteracoes/2+2));  %tensão na carga
    aux_va = 0;
    
    vb = zeros(1, round(n_iteracoes/2+1));  %tensão na fonte
    aux_vb = 0;
    
    for k = 0:n_iteracoes
        if mod(k, 2) == 0
            va(aux_va + 1) = pontos_y(k + 1);
            aux_va = aux_va + 1;
        
        else
            vb(aux_vb + 1) = pontos_y(k + 1);
            aux_vb = aux_vb + 1;
        end
    end
    
    va(end) = va(end-1);
    vb(end) = vb(end-1);
    
    subplot(2, 4, [3 8]);
    stairs(x_tensao_fonte, vb, 'r', LineWidth = 2);
    hold on;
    stairs(x_tensao_carga, va, 'b', LineWidth = 2);
    ylim([0 Vs+1]); xlim([0 n_iteracoes*Td]);
    legend('Tensão na fonte', 'Tensão na carga', 'Location', 'best');
    grid on;
    hold off;
end

fprintf("\n\tTabela dos valores da tensão:\n");
fprintf("\n\tIteração\t\tTempo\t\tTensão\t\t   Corrente");
for k = 0:n_iteracoes
    tempo = Td * k;
    fprintf("\n\t%d\t\t\t\t%2.2d s\t\t%2.3f V \t\t%2.3f A", k + 1, tempo, pontos_y(k + 1), pontos_x(k + 1));
end

fprintf("\n\n***********************************************************\n");
fprintf("\t\nPonto de Operação:");
fprintf("\n\n\t\tV = %0.3f V", zero_x);
fprintf("\n\n\t\tI = %0.3f A", zero_y);
fprintf("\n\n***********************************************************\n");

fprintf(" Prima 1 - Voltar ao menu principal");
opcao = 0;
while opcao ~= 1
    opcao = input("\nOpção escolhida: ");
end
end