function [Vs, Rs, RL, circuito_aberto, Td, Z0, ir_para_tarefa, reta_fonte, reta_carga] = opcao_1(first_time)
% função que é executada quando é escolhida
% a 1a opção do menu

clc;

%a var persistent ficam local para a função. Ou seja, da próxima vez que
%entrar nesta função, o valor das variáveis vai ser o mesmo de quando sai

persistent Vs_p Rs_p RL_p Td_p Z0_p L_p v_p reta_fonte_p reta_carga_p circuito_aberto_p ir_para_tarefa_p;
%ir_para_tarefa = 0;     % 1 - Tarefa A
                         % 2 - Tarefa B

%inicialiar variáveis na 1a vez que corre
if first_time
    Vs_p = 0;
    Rs_p = 0;
    RL_p = 0;
    Td_p = 0;
    circuito_aberto_p = 0;
    Z0_p = 0;
    L_p = 0;
    v_p = 0;
    reta_fonte_p = 0;
    reta_carga_p = 0;
    ir_para_tarefa_p = 0;
end

opcao = 0;  %tem de ser inicializada sempre por isso fica fora
while opcao ~= 11
    clc;
    opcao = 0;
    fprintf("\n********************* Parâmetros do circuito *********************\n");
    fprintf("\n\t Fonte de Alimentação:\n");
    fprintf("\n\t\t Prima 1 - Definir tensão da fonte     | Vs = %d V", Vs_p);%ideia do cabaço, ir mostrando qual o valor atual para o user não se perder
    fprintf("\n\t\t Prima 2 - Definir reta da fonte       | f = %s", reta_fonte_p);
    fprintf("\n\t\t Prima 3 - Definir impedância da fonte | Rs = %d\n", Rs_p);
    
    fprintf("\n\t Impedância da Carga:\n");
    fprintf("\n\t\t Prima 4 - Definir resistência         | RL = %d", RL_p);
    fprintf("\n\t\t Prima 5 - Definir em circuito aberto  | Opção atual: ");
    if circuito_aberto_p
        fprintf("Sim");
    else
        fprintf("Não");
    end

    fprintf("\n\t\t Prima 6 - Definir reta da carga       | c = %s\n", reta_carga_p);
    
    fprintf("\n\t Linha de Transmissão:\n");
    fprintf("\n\t\t Prima 7 - Definir tempo de propagação | Td = %d", Td_p);
    fprintf("\n\t\t Prima 8 - Definir impedância de linha | Z0 = %d", Z0_p);
    fprintf("\n\t\t Prima 9 - ou definir comprimento e velocidade de propagação | L = %d | v = %d\n", L_p, v_p);
    
    fprintf("\n\t Prima 10 - Utilizar um dos gráficos da tarefa B | Opção atual: ");
    if ir_para_tarefa_p == 2
        fprintf("Sim");
    else
        fprintf("Não");
    end

    fprintf("\n\n\t Prima 11 - Voltar ao Menu Principal\n\n")
    fprintf("******************************************************************");
    
    while opcao < 1 || opcao > 11 || ~isscalar(opcao)
        opcao = input('\n\n  Opção Escolhida: ');
    end
    
    fprintf("\n\t");

    switch opcao
        case 1
            Vs_p = -1;
            while Vs_p < 0 || ~isscalar(Vs_p)
                Vs_p = input('Vs (V) = ');
                fprintf("\n\t");
            end
        case 2
            reta_fonte_p = input('Escreva a reta da fonte não linear: ', 's');
            ir_para_tarefa_p = 1;
        case 3
            Rs_p = -1;
            while Rs_p < 0 || ~isscalar(Rs_p)
                Rs_p = input('Rs (\Omega) = ');
                fprintf("\n\t");
            end
        case 4
            RL_p = -1;
            while RL_p < 0 || ~isscalar(RL_p)
                RL_p = input('RL (\Omega) = ');
                fprintf("\n\t");
            end
        case 5
            if circuito_aberto_p
                circuito_aberto_p = false;
            else
                circuito_aberto_p = true;
            end
        case 6
            reta_carga_p = input('Escreva a reta da carga não linear: ', 's');
            ir_para_tarefa_p = 1;
        case 7
            Td_p = -1;
            while Td_p < 0 || ~isscalar(Td_p)
                Td_p = input('Td (s) = ');
                fprintf("\n\t");
            end
        case 8
            Z0_p = -1;
            while Z0_p < 0 || ~isscalar(Z0_p)
                Z0_p = input('Z0 (\Omega) = ');
                fprintf("\n\t");
            end
        case 9
            valores = input('L(m), v(m/s) = ', 's');
            valores = strsplit(valores, ' ');
            L_p = str2double(valores{1});
            v_p = str2double(valores{2});
            Td_p = L_p / v_p;
        case 10
            if ir_para_tarefa_p == 0 || ir_para_tarefa_p == 1
                ir_para_tarefa_p = 2;
            else
                ir_para_tarefa_p = 0;
            end
                
        case 11
            % caso o user saia quando entra na função pela 1a vez
            Vs = Vs_p;
            Rs = Rs_p;
            RL = RL_p;
            circuito_aberto = circuito_aberto_p;
            ir_para_tarefa = ir_para_tarefa_p;
            Td = Td_p;
            Z0 = Z0_p;
            reta_fonte = reta_fonte_p;
            reta_carga = reta_carga_p;
            break;
        otherwise
            fprintf("erro?");
    end

    %igualar as variáveis para return
    Vs = Vs_p;
    Rs = Rs_p;
    RL = RL_p;
    ir_para_tarefa = ir_para_tarefa_p;
    circuito_aberto = circuito_aberto_p;
    Td = Td_p;
    Z0 = Z0_p;
    reta_fonte = reta_fonte_p;
    reta_carga = reta_carga_p;

end
end