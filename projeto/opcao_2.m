function [n_iteracoes, tolerancia] = opcao_2(first_time)

% função que é executada quando é escolhida
% a 2a opção do menu
clc;

persistent n_iteracoes_p tolerancia_p;

if first_time
    n_iteracoes_p = 0; 
    tolerancia_p = 0;
end
opcao = 0;
while opcao ~= 4
    clc;
    opcao = 0;
    fprintf("********************* Número de Iterações *********************\n");
    fprintf("\n\t Prima 1 - Definir número de iterações a realizar | Iterações  = %d", n_iteracoes_p);
    fprintf("\n\n\t Prima 2 - Definir valor de tolerância | Tolerância   = %d", tolerancia_p);
    fprintf("\n\t\t ou Prima 3 - Valor de tolerância padrão | Valor Padrão = 0.05");
    
    fprintf("\n\n\t Prima 4 - Voltar ao Menu Principal\n\n");
    fprintf("************************************************");
    
    while opcao < 1 || opcao > 4 || ~isscalar(opcao)
        opcao = input("\n\n\t Opção Escolhida: ");
    end

    fprintf("\n\t");
    
    switch opcao
        case 1
            n_iteracoes_p = input('Número iterações = ');
        case 2
            tolerancia_p = input("Tolerância = ");
        case 3
            tolerancia_p = 0.05;
        case 4
            n_iteracoes = n_iteracoes_p;
            tolerancia = tolerancia_p;
            break;
        otherwise
            fprintf("erro?");
    end

    n_iteracoes = n_iteracoes_p;
    tolerancia = tolerancia_p;
    
end
end