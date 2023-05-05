function [] = opcao_3(Vs, Rs, RL_CC, RL_CA, Td, n_iteracoes, tolerancia)

Z0 = 50;    %não esquecer de pedir isto ao user (ou calcular?)
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

if Vs == 0 || Rs == 0 || RL_CC == 0 || Td == 0 || n_iteracoes == 0  %não funciona se usar isempty()
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
        Vs = 75;
        Rs = 100;
        RL_CC = 200;
        Td = 2e-3;
        n_iteracoes = 3;
    end
end

% ponto 1
clc;
fprintf("\n************************************\n");
fprintf("\n\t Configuração definida: \n");
fprintf("\n\t Vs \t\t\t\t %d V", Vs);
fprintf("\n\t Rs \t\t\t\t %d %c", Rs, char(216));
fprintf("\n\t RL_CC \t\t\t\t %d %c", RL_CC, char(216));
fprintf("\n\t Td \t\t\t\t %f s", Td);
fprintf("\n\t Número iterações \t %d", n_iteracoes);
fprintf("\n\t Tolerância \t\t %0.2f\n", tolerancia);
fprintf("\n************************************\n");

% fonte + carga
figure('Name', 'Diagrama V(I)', 'NumberTitle', 'off');
I = Vs/Rs;
x = linspace(0, I, 10000);
f = @(x) Vs - Rs .* x;
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

for k = 0:n_iteracoes

    if mod(k, 2) == 0
        b = zer_y - Z0 * zer_x;
        y1 = @(x) Z0.*x + b;
        
        zer_x = fzero(@(x) f(x) - y1(x), 1);
        zer_y = y1(zer_x);

        plot(x, y1(x), 'k--');
        hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
        
    
    else
        b = zer_y + Z0 * zer_x;
        y2 = @(x) -Z0.*x + b;
        
        zer_x = fzero(@(x) c(x) - y2(x), 1);
        zer_y = y2(zer_x);
        
        plot(x, y2(x), 'k--');
        hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
    end
end

hold off;
pause(10);
end