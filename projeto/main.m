clear;
clc;

% projetozinho de matilabi


% FICHEIRO PRINCIPAL 

opcao = 0;
while opcao ~= 4
    opcao = menu;
    
    switch opcao
        case 1
            [Vs, Rs, RL_CC, RL_CA, Td, L, v] = opcao_1
        case 2
            [n_iteracoes, tolerancia] = opcao_2
        case 3
            opcao_3(Vs, Rs, RL_CC, RL_CA, Td, L, v, n_iteracoes, tolerancia);
        case 4
            validate = opcao_4;
            if validate
                opcao = 4;
                fprintf("\nObrigado! Volte sempre!\n\n\n");
            else
                opcao = 3;
            end
    end
end