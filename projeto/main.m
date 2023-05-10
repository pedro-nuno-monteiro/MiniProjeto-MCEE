clear;
clc;

% projetozinho de matilabi

% FICHEIRO PRINCIPAL 

%inicialiar tudinho
[Vs, Rs, RL_CC, RL_CA, Td, L, v, n_iteracoes, tolerancia, Z0, ir_para_tarefa_B] = deal(0);

first_time_1 = true;  %será boa ideia usar isto?
first_time_2 = true;
opcao = 0;
while opcao ~= 4
    opcao = menu;
    
    switch opcao
        case 1
            [Vs, Rs, RL_CC, RL_CA, Td, Z0, L, v, ir_para_tarefa_B] = opcao_1(first_time_1);
            first_time_1 = false;
        case 2
            [n_iteracoes, tolerancia] = opcao_2(first_time_2);
            first_time_2 = false;
        case 3
            opcao_3(Vs, Rs, RL_CC, RL_CA, Z0, Td, n_iteracoes, tolerancia, ir_para_tarefa_B);
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