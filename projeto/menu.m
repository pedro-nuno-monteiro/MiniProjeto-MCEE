function [Vs, Rs, RL_CC, RL_CA, Td, L, v, n_iteracoes, tolerancia] = menu

% função que apresenta o menu ao user
% e retorna a opção escolhida

clc;

fprintf("********************* MENU *********************\n");
fprintf("\n\t Prima 1 - Definir parâmetros do circuito");
fprintf("\n\t Prima 2 - Definir o número de iterações");
fprintf("\n\t Prima 3 - Executar Método de Bergeron");
fprintf("\n\t Prima 4 - Sair do programa\n\n");
fprintf("************************************************");

opcao = input("\n\n\t Opção Escolhida: ");

switch opcao
    case 1
        [Vs, Rs, RL_CC, RL_CA, Td, L, v] = opcao_1;
    case 2
        [n_iteracoes, tolerancia] = opcao_2;
    case 3
        opcao_3;
end

end