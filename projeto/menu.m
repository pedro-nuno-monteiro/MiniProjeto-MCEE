function opcao = menu

% função que apresenta o menu ao user
% e retorna a opção escolhida

clc;
opcao = 0;
fprintf("********************* MENU *********************\n");
fprintf("\n\t Prima 1 - Definir parâmetros do circuito");
fprintf("\n\t Prima 2 - Definir o número de iterações");
fprintf("\n\t Prima 3 - Executar Método de Bergeron");
fprintf("\n\t Prima 4 - Sair do programa\n\n");
fprintf("************************************************");

while opcao < 1 || opcao > 4 || ~isscalar(opcao)
    opcao = input("\n\n  Opção Escolhida: ");
end
end