function [] = tarefa_B()

%função que permite ao user definir o gráfico da fonte

clc;
fprintf("\n***********************************\n");
fprintf("\n\tEscolha um dos seguintes gráficos:");
fprintf("\n\n\t\tPrima 1 - Pulso retangular");
fprintf("\n\n\t\tPrima 2 - Pulso digital");
fprintf("\n\n\t\tPrima 3 - Pulso triangular");
fprintf("\n\n\t\tPrima 4 - Trem de impulsos\n");
fprintf("\n***********************************\n");

opcao = 0;
while opcao < 1 || opcao > 4
    opcao = input('\n\tOpção escolhida: ');
end

amp = 0;
while amp < 0
    amp = input("\n\nDefina a amplitude do sinal: ");
end

switch opcao
    case 1
        
    case 2

    case 3

    case 4

end