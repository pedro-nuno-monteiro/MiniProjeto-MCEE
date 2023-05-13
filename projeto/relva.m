clc; clear; close all;

dlgtitle='Pulso triangiular';
perguntas={'Insira a Amplitude: ', 'Insira o tempo de subida: ', 'Insira o tempo de descida: '};
dims=[1 40];
definput={'0', '0', '0'};


dados=inputdlg(perguntas, dlgtitle, dims, definput);
dados_num = cellfun(@str2num, dados);

A = dados_num(1);
ts = dados_num(2) *1e-3;
td = dados_num(3)*1e-3;


%% Grafico do Pulso Triangular

N=10000; %numero de pontos
x=linspace(0, ts + td, N); 
d=(ts+td)/N; % distancia entre cada ponto

%% Primeiro lado do grafico

x1= 0 : d : ts-d;
n_pontos_ate_ts=size(x1); % dá uma matriz do tipo [1 1000] logo temos de ir buscar o segundo elemento
n_pontos_ate_ts=n_pontos_ate_ts(2);

y(1:n_pontos_ate_ts) = x1 .* A/ts; % y=mx onde m=A/ts


%% Segundo lado

x2=ts : d : td+ts;

if(size(x2)~=N-n_pontos_ate_ts) % ns porque, mas tenho de colocar este if se nao, às vezes nao dá
    x2=ts : d : td+ts-d;
end

y(n_pontos_ate_ts+1:N)= x2.* (-A/td) + A*(1 + ts/td); % y=mx+b onde m=-A/td  e b= A*(1+ts/td)
                                                      % fiz as contas à mão


%% Plot do grafico
figure(1);
plot(x.*1e3, y, 'LineWidth',2);
title('Pulso Triangular');

%% Reta da fonte

Rs=100;

f = @(x) y - Rs .* x;
efe = f(x);
figure(2);
plot(x.*1e3, f(x), 'LineWidth',2);
title('Reta da fonte');
hold on;
RL_CC = 25;


c = @(x) RL_CC .* x;
ce = c(x);
plot(x.*1e3, c(x), 'b', LineWidth = 2);
grid on;
title('Diagrama V(I)');
xlabel('Corrente (A)'); ylabel('Tensão (V)');
hold off;

zero_x = fzero(@(x) f(x) - c(x), 2);
zero_y = f(zero_x);
po = plot(zero_x, zero_y, 'o', 'MarkerFaceColor','k');

%% pulso retangular

clear;
clc;

%dlgtitle = 'Pulso triangular';
%perguntas = {'Amplitude: ', 'Duração (mA): '};
%dims = [1 40];
%definput = {'0', '0'};
        
%dados = inputdlg(perguntas, dlgtitle, dims, definput);
%dados_num = cellfun(@str2num, dados);

%A = dados_num(1);
%tau = dados_num(2);
A = 3; tau = 6; t_inicial = 0; t_final = tau;

t = linspace(-1, tau + 1, 1000);

y = A * rectpuls(t - tau/2, tau);
figure(1)
plot(t, y, 'b', LineWidth = 2);
xlim([-2 tau + 2]); ylim([-0.5 A + 2])

Rs = 100; I = A / Rs;
x = linspace(0, I, 1000);

f = @(x) A - Rs .* x;
figure(2);
plot(x.*1e3, f(x), 'LineWidth',2);
title('Reta da fonte');
hold on;
RL_CC = 25;



%% Pulso digital

dlgtitle='Pulso digital';
perguntas={'Insira a Amplitude: ', 'Insira o tempo de subida: ', 'Insira o tempo de descida: ', 'Duração do pulso: '};
dims=[1 40];
definput={'0', '0', '0', '0'};


dados=inputdlg(perguntas, dlgtitle, dims, definput);
dados_num = cellfun(@str2num, dados);

A = dados_num(1);
ts = dados_num(2) *1e-3;
td = dados_num(3)*1e-3;
t_dur=dados_num(4)*1e-3;

% ----------------------------------------------------------------------- %
N=10000; %numero de pontos
x=linspace(0, t_dur, N); 
d=(t_dur)/N;
% ----------------------------------------------------------------------- %

x1= 0 : d : ts-d;
tam=size(x1); % dá uma matriz do tipo [1 1000] logo temos de ir buscar o segundo elemento
pontos_ts=tam(2);

y(1:pontos_ts) = x1 .* A/ts; % y=mx onde m=A/ts

% ----------------------------------------------------------------------- %

x2 = ts : d : t_dur - td -d; 
tam1=size(x2);
pontos_tf=tam1(2);

y(pontos_ts+1:pontos_tf+pontos_ts)=A;

% ----------------------------------------------------------------------- %

x3= t_dur - td : d : t_dur - d;

if(size(x3)~=N-pontos_ts-pontos_tf) % ns porque, mas tenho de colocar este if se nao, às vezes nao dá
    x3=t_dur - td : d : t_dur;
end

y(pontos_ts + pontos_tf +1 : N) = -A/td.*x3 + A * t_dur /td;


figure('Name', 'Pulso Digital');
plot(x*1e3, y, LineWidth = 2); 
title('Pulso Digital');
ylim([0 A+1]);

f = @(x) y - Rs .* x;
figure('Name', 'Diagrama V(I)');
plot(x.*1e3, f(x), LineWidth = 2);
title('Diagrama V(I)');
hold on;

c = @(x) RL_CC .* x;
plot(x .* 1e3, c(x), 'b', LineWidth = 2);
grid on;
xlabel('Corrente (A)'); ylabel('Tensão (V)');
ylim([0 A + 10]);
hold off;

zero_x = fzero(@(x) f(x) - c(x), 2);
zero_y = f(zero_x);
po = plot(zero_x, zero_y, 'o', 'markerfacecolor','k');


