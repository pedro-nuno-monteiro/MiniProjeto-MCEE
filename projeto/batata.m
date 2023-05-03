clc; clear; close all;

Vs = 75; Rs = 100; RL_CC = 200; Td = 2e-3; Z0=50;

n_iteracoes=3;

%% Fonte

I=Vs/Rs;
fonte_x = linspace(0, I, 10000);

fonte_y= Vs - Rs * fonte_x;
plot(fonte_x, fonte_y, 'r', 'LineWidth', 2); hold on;

%fonte_x = [I 0]; fonte_y = [0 Vs]; plot(fonte_x, fonte_y, 'r', 'LineWidth',2); hold on;

%% Carga

carga_x = linspace(0, I, 10000);

carga_y = RL_CC * carga_x;

plot(carga_x, carga_y, 'b', 'LineWidth', 2); grid on;

%% Ponto de operaçao

P=intersection(carga_y, fonte_y, I, 10000)

plot(P(1), P(2), 'o', 'MarkerFaceColor','k');

xlabel('Corrente (A)'); ylabel('Tensao (V)');
legend('Fonte', 'Carga', 'Ponto de operacao', 'Location','best');


%% Tensao na fonte e carga

ponto_i = [0 0];

x=linspace(0, I, 10000);

for k=0:n_iteracoes

    if mod(k, 2) == 0
        b=ponto_i(2) - Z0*ponto_i(1);
        y= Z0*x + b;
        disp('merda');
        plot(x, y, 'k--'); hold on;
        ponto_i=intersection(y, fonte_y, I, 10000)
    else
        b=ponto_i(2) + Z0*ponto_i(1)
        y=-Z0*x + b;
        disp('merda2');
        plot(x, y, 'k--'); hold on;
        ponto_i=intersection(y, carga_y, I, 10000)
    end

    

end

hold off;