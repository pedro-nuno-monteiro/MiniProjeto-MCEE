function x = opcao_3(Vs, Rs, RL_CC, RL_CA, Td, L, v, n_iteracoes, tolerancia)

% função que é executada quando é escolhida
% a 3a opção do menu

fprintf("************** Método de Bergeron **************\n");
fprintf("\n\t Configuração definida: ");
fprintf("\n\t\t Vs = %d V\tRs = %d", Vs, Rs);
fprintf("\n\t\t RL_CC = %d \t RL_CA = %d", RL_CC, RL_CA);
fprintf("\n\t\t Td = %f s", Td);
fprintf("\n\t\t Número iterações = %d", n_iteracoes);
fprintf("\n\t\t Tolerância = %f", tolerancia);
fprintf("************************************************\n");

pause(10);  %para o programa por 10 segundos

end