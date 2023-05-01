function [] = opcao_3(Vs, Rs, RL_CC, RL_CA, Td, n_iteracoes, tolerancia)

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
    end
end

% ponto 1
fprintf("\n\t Configuração definida: ");
fprintf("\n\t\t Vs = %d V\tRs = %d", Vs, Rs);
fprintf("\n\t\t RL_CC = %d \t RL_CA = %d", RL_CC, RL_CA);
fprintf("\n\t\t Td = %f s", Td);
fprintf("\n\t\t Número iterações = %d", n_iteracoes);
fprintf("\n\t\t Tolerância = %f\n", tolerancia);
fprintf("************************************************\n");

%pause(10);  %para o programa por 10 segundos

%carga: reta de declive RL que passa na origem: V = RI + 0

%com valores arbitrários
x = linspace(0, 1, 100);
y = RL_CC * x;
figure(1);
plot(x, y);
hold on;

%com valores corretos (previamente definidos)
ca = [0 Vs];
I = Vs / Rs;
cc = [I 0];
line(cc, ca);   %une 2 pontos

grafico_v_t;

end