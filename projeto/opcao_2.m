function [n_iteracoes, tolerancia] = opcao_2

% função que é executada quando é escolhida
% a 2a opção do menu
clc;
opcao = 0;
n_iteracoes = 0; tolerancia = 0;
while opcao ~= 4
    clc;
    opcao = 0;
    fprintf("********************* Número de Iterações *********************\n");
    fprintf("\n\t Prima 1 - Definir número de iterações a realizar");
    fprintf("\n\n\t Prima 2 - Definir valor de tolerância");
    fprintf("\n\t\t ou Prima 3 - Valor de tolerância padrão");
    
    fprintf("\n\n\t Prima 4 - Voltar ao Menu Principal\n\n");
    fprintf("************************************************");
    
    while opcao < 1 || opcao > 4
        opcao = input("\n\n\t Opção Escolhida: ");
    end

    fprintf("\n\t");
    
    switch opcao
        case 1
            n_iteracoes = input('Número iterações = ');
        case 2
            tolerancia = input("Tolerância = ");
        case 3
            tolerancia = 10;    %não faço ideia que valor colocar ainda
        case 4
            break;
        otherwise
            fprintf("erro?");
    end
end
end