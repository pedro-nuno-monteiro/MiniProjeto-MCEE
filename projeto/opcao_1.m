function [Vs, Rs, RL_CC, RL_CA, Td, L, v] = opcao_1(first_time)
% função que é executada quando é escolhida
% a 1a opção do menu

clc;

%a var persistent ficam local para a função. Ou seja, da próxima vez que
%entrar nesta função, o valor das variáveis vai ser o mesmo de quando saí

%outra opção é fazer este código na função main, assim os valores ficam lá
%sempre :)
persistent Vs_p Rs_p RL_CC_p RL_CA_p Td_p L_p v_p;

%inicialiar variáveis na 1a vez que corre
if first_time
    Vs_p = 0;
    Rs_p = 0;
    RL_CC_p = 0;
    RL_CA_p = 0;
    Td_p = 0;
    L_p = 0;
    v_p = 0;
end

opcao = 0;  %tem de ser inicializada sempre por isso fica fora
while opcao ~= 7
    clc;
    opcao = 0;
    fprintf("\n********************* Parâmetros do circuito *********************\n");
    fprintf("\n\t Fonte de Alimentação:\n");
    fprintf("\n\t\t Prima 1 - Definir tensão da fonte | Vs = %d", Vs_p);%ideia do cabaço, ir mostrando qual o valor atual para o user não se perder
    fprintf("\n\t\t Prima 2 - Definir impedância da fonte | Rs = %d\n", Rs_p);
    
    fprintf("\n\t Impedância da Carga:\n");
    fprintf("\n\t\t Prima 3 - Definir em curto circuito");
    fprintf("\n\t\t Prima 4 - Definir em circuito aberto\n");
    
    fprintf("\n\t Linha de Transmissão:\n");
    fprintf("\n\t\t Prima 5 - Definir tempo de propagação | Td = %d", Td_p);
    fprintf("\n\t\t Prima 6 - ou definir comprimento e velocidade de propagação | L = %d | v = %d\n", L_p, v_p);

    fprintf("\n\t Prima 7 - Voltar ao Menu Principal\n\n")
    fprintf("******************************************************************");
    
    while opcao < 1 || opcao > 7
        opcao = input('\n\n \t Opção Escolhida: ');
    end
    
    fprintf("\n\t");

    switch opcao
        case 1
            Vs_p = input('Vs (V) = ');
        case 2
            Rs_p = input('Rs (\ohms) = ');
        case 3
            RL_CC_p = input('RL em CC (\ohms) = ');
        case 4
            RL_CA_p = input('RL_CA (\ohms) = ');
        case 5
            Td_p = input('Td (s) = ');
        case 6
            [L_p, v_p] = input('L (m), v (m/s) = ');
            Td_p = L_p / v_p;
        case 7
            break;
        otherwise
            fprintf("erro?");
    end

    %igualar as variáveis para return
    Vs = Vs_p;
    Rs = Rs_p;
    RL_CC = RL_CC_p;
    RL_CA = RL_CA_p;
    Td = Td_p;
    L = L_p;
    v = v_p;

end
end