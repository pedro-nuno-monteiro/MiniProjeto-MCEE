clear; clc;

Rs = 100; RL_CC = 200; Td = 0.002; Z0 = 50; n_iteracoes = 4; tolerancia = 2;

A = 0;
tau = 0;
T = 0;
n_graficos = 0;
while A == 0 || tau == 0 || T == 0 || n_graficos == 0
    opcao = 0;
    clc;
    fprintf("\n***************** Trem de Impulsos *****************\n");
    fprintf("\n\t Parâmetros: ");
    fprintf("\n\n\t\t Prima 1 - Indique a amplitude | A = %d", A);
    fprintf("\n\n\t\t Prima 2 - Indique a duração   | Tau = %d", tau);
    fprintf("\n\n\t\t Prima 3 - Indique o período   | T = %d", T);
    fprintf("\n\n\t\t Prima 4 - Número de impulsos  | N = %d", n_graficos);

    while opcao < 1 || opcao > 4 || ~isscalar(opcao)
        opcao = input("\n\n  Opção escolhida: ");
    end
    
    switch opcao
        case 1
            A = input("\n\n  A = ");
        case 2
            tau = input("\n\n  Tau = ");
        case 3
            T = input("\n\n  T = ");
            while T < tau
                fprintf("\n Tem de introduzir um período maior que a duração do sinal! T = ")
                T = input("");
            end
        case 4
            n_graficos = input("\n\n Número de Impulsos = ");
    end
end

y = [];
for k = 0:n_graficos - 1
    t = linspace(k * T, (k + 1) * T, 1000);
    y = [y, A * rectpuls(t - k * T, tau)];
end

x = linspace(0, n_graficos * T, length(y));

figure('Name', 'Trem de Impulsos');
plot(x, y, LineWidth = 2);
title('Trem de Impulsos');

I = A / Rs;

f = @(x) y - Rs .* x;
figure(2);
plot(x, f(x), LineWidth = 2);
title('Diagrama V(I)');
hold on;

c = @(x) RL_CC .* x;
plot(x, c(x), 'b', LineWidth = 2);
grid on;
title('Diagrama V(I)');
xlabel('Corrente (A)'); ylabel('Tensão (V)');
ylim([0 A + 10]);