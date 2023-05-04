clc; clear; close all;

Vs = 75; Rs = 100; RL_CC = 200; Td = 2e-3; Z0=50;
%Vs=24; Rs=5; RL_CC=25; Z0=100; Td=5e-3;

n_iteracoes=3;

%% Fonte

I=Vs/Rs;
x = linspace(0, I, 10000);
fonte_y= Vs - Rs * x;
plot(x, fonte_y, 'r', 'LineWidth', 2); hold on;


%% Carga

carga_y = RL_CC * x;
plot(x, carga_y, 'b', 'LineWidth', 2); grid on;

%% Ponto de operaçao



y= carga_y - fonte_y;
zer = find(y==0);
if isempty(zer)
            disp('FDS');
            y=round(y, 1);
            zer=find(y==0);
            zer=zer(1);
        end

P=[zer*I/(10000), carga_y(zer)]

plot(P(1), P(2), 'o', 'MarkerFaceColor','k');

xlabel('Corrente (A)'); ylabel('Tensao (V)');
%legend('Fonte', 'Carga', 'Ponto de operacao', 'Location','best');


%% Tensao na fonte e carga

ponto_i = [0 0];
for k=0:n_iteracoes

    if mod(k, 2) == 0
        b=ponto_i(2) - Z0*ponto_i(1)
        y1= Z0*x + b; 
        
        aux=fonte_y-y1;
        zer1=find(aux==0);
        if isempty(zer1)
            disp('FDS');
            aux=round(aux, 1);
            zer1=find(aux==0);
            zer1=zer1(1);
        end
        
        ponto_i=[zer1*I/10000, y1(zer1)]
        plot(x, y1, 'k--'); hold on;
        plot(ponto_i(1), ponto_i(2), 'o', 'MarkerFaceColor','y');
        
    
    else
        b=ponto_i(2) + Z0*ponto_i(1)
        y2=-Z0*x + b;
        plot(x, y2, 'k--'); hold on;
        aux= y2 - carga_y;
        zer1=find(aux==0)
        
        if isempty(zer1)
            disp('FDS');
            aux=round(aux, 1);
            zer1=find(aux==0);
            zer1=zer1(1);
        end

        ponto_i=[zer1*I/10000, y2(zer1)]
        plot(ponto_i(1), ponto_i(2), 'o', 'MarkerFaceColor','y');
    end
end

hold off;