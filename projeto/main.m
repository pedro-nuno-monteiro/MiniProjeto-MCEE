clear;
clc;

% projetozinho de matilabi

% FICHEIRO PRINCIPAL 

%inicialiar tudinho
[Vs, Rs, RL_CC, RL_CA, Td, L, v, n_iteracoes, tolerancia, Z0, ir_para_tarefa, reta_fonte, reta_carga] = deal(0);
first_time_1 = true;
first_time_2 = true;
opcao = 0;
while opcao ~= 4
    opcao = menu;
    
    switch opcao
        case 1
            [Vs, Rs, RL_CC, Td, Z0, ir_para_tarefa, reta_fonte, reta_carga] = opcao_1(first_time_1);
            first_time_1 = false;
        
        case 2
            [n_iteracoes, tolerancia] = opcao_2(first_time_2);
            first_time_2 = false;
        
        case 3
            if ir_para_tarefa == 2
                tarefa_B(Rs, RL_CC, Td, Z0);
            else
                opcao_3(Vs, Rs, RL_CC, Z0, Td, n_iteracoes, tolerancia, ir_para_tarefa, reta_fonte, reta_carga, []);
            end

        case 4
            validate = -1;
            while validate < 0 || validate > 1 || ~isscalar(validate)
                validate = input("\n  Vai sair do programa. Tem a certeza? (1 ou 0): ");
            end
            if validate
                fprintf("\n\t Obrigado! Volte Sempre!!\n\n\n");
                break;
            else
                opcao = 3;
            end
    end
end