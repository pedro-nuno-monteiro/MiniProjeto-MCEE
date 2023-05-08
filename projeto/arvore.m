clc; clear; close all;

Vs = 75; Rs = 100; RL_CC = 200; Td = 2e-3; Z0=50; tolerancia = -20.05;
%Vs=24; Rs=5; RL_CC=25; Z0=100; Td=5e-3; tolerancia = -20;

n_iteracoes=4;
%% Fonte

I=Vs/Rs;
x = linspace(0, I, 1000);
f = @(x) Vs - Rs .* x .* (1 + 2 * x.^2);
plot(x, f(x), 'r', 'LineWidth', 2); hold on;

%% Carga

%c = @(x) RL_CC .* x .* (1 + 2 * x.^2);
c = @(x) (100) * log(1 + x/I);
plot(x, c(x), 'b', 'LineWidth', 2); grid on;

xlim([0 0.6]);

%% Ponto de operaçao

zero_x = fzero(@(x) f(x) - c(x), 2);
zero_y = f(zero_x);

plot(zero_x, zero_y, 'o', 'MarkerFaceColor','k');
xlabel('Corrente (A)'); ylabel('Tensao (V)');
%legend('Fonte', 'Carga', 'Ponto de operacao', 'Location','best');

%%

% tensão na carga + fonte
zer_x = 0;
zer_y = 0;

pontos_x = zeros(1, n_iteracoes);
pontos_y = zeros(1, n_iteracoes);
terminado = false;
for k = 0:n_iteracoes

    if mod(k, 2) == 0
        b = zer_y - Z0 * zer_x;
        y1 = @(x) Z0.*x + b;
        
        pontos_x(k + 1) = zer_x;
        pontos_y(k + 1) = zer_y;
        
        zer_x = fzero(@(x) f(x) - y1(x), 1);
        zer_y = y1(zer_x);
        
        if (abs(zer_x - pontos_x(k + 1)) < tolerancia) || (abs(zer_y - pontos_y(k + 1)) < tolerancia)
            fprintf("O método foi interrompido pois atingiu o valor da tolerância.");
            terminado = true;
            break;
        end

        plot(x, y1(x), 'k--');
        hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
        
    else
        b = zer_y + Z0 * zer_x;
        y2 = @(x) -Z0.*x + b;

        pontos_x(k + 1) = zer_x;
        pontos_y(k + 1) = zer_y;

        zer_x = fzero(@(x) c(x) - y2(x), 1);
        zer_y = y2(zer_x);
        
        if (abs(zer_x - pontos_x(k + 1)) < tolerancia) || (abs(zer_y - pontos_y(k + 1)) < tolerancia)
            fprintf("O método foi interrompido pois atingiu o valor da tolerância.");
            terminado = true;
            break;
        end

        plot(x, y2(x), 'k--');
        hold on;
        plot(zer_x, zer_y, 'o', 'MarkerFaceColor','y');
    end

    if I > 4 * zer_x
        ylim([0 Vs+1]); xlim([0 2*zer_x]);
    else
        ylim([0 Vs+1]); xlim([0 I]);
    end
end