function [Vs, Rs, RL_CC, RL_CA, Td, L, v] = opcao_1
% função que é executada quando é escolhida
% a 1a opção do menu

clc;
opcao = 0;

while opcao ~= 7
    clc;
    opcao = 0;
    fprintf("\n********************* Parâmetros do circuito *********************\n");
    fprintf("\n\t Fonte de Alimentação:\n");
    fprintf("\n\t\t Prima 1 - Definir tensão da fonte");
    fprintf("\n\t\t Prima 2 - Definir impedância da fonte\n");
    
    fprintf("\n\t Impedância da Carga:\n");
    fprintf("\n\t\t Prima 3 - Definir em curto circuito");
    fprintf("\n\t\t Prima 4 - Definir em circuito aberto\n");
    
    fprintf("\n\t Linha de Transmissão:\n");
    fprintf("\n\t\t Prima 5 - Definir tempo de propagação");
    fprintf("\n\t\t Prima 6 - ou definir comprimento e velocidade de propagação\n");

    fprintf("\n\t Prima 7 - Voltar ao Menu Principal\n\n")
    fprintf("******************************************************************");
    
    while opcao < 1 || opcao > 7
        opcao = input('\n\n \t Opção Escolhida: ');
    end
    
    fprintf("\n\t");

    switch opcao
        case 1
            Vs = input('Vs (V) = ');
        case 2
            Rs = input('Rs (\ohms) = ');
        case 3
            RL_CC = input('RL em CC (\ohms) = ');
        case 4
            RL_CA = input('RL_CA (\ohms) = ');
        case 5
            Td = input('Td (s) = ');
        case 6
            [L, v] = input('L (m), v (m/s) = ');
        case 7
            menu;   %para menu ou para main? ver isto mais tarde...!
        otherwise
            fprintf("erro?");
    end
end
end