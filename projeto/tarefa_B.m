function [] = tarefa_B(Rs, RL, Td, Z0)

%função que permite ao user definir o gráfico da fonte

clc;
fprintf("\n********************************************\n");
fprintf("\n\tEscolha um dos seguintes gráficos:\n");
fprintf("\n\t\tPrima 1 - Pulso retangular");
fprintf("\n\t\tPrima 2 - Pulso digital");
fprintf("\n\t\tPrima 3 - Pulso triangular");
fprintf("\n\t\tPrima 4 - Trem de impulsos");
fprintf("\n\t\tPrima 5 - Regressar\n");
fprintf("\n********************************************\n");

grafico = 0;
while grafico < 1 || grafico > 5 || ~isscalar(grafico)
    grafico = input('\n  Opção escolhida: ');
end

switch grafico
    case 1
        clc;
        A = 0;
        tau = 0;
        while A == 0 || tau == 0
            opcao = 0;
            clc;
            fprintf("\n***************** Pulso Retangular *****************\n");
            fprintf("\n\t Parâmetros: ");
            fprintf("\n\n\t\t Prima 1 - Indique a amplitude | A = %d", A);
            fprintf("\n\n\t\t Prima 2 - Indique a duração (mA)   | Tau = %d\n\n", tau);

            while opcao < 1 || opcao > 2 || ~isscalar(opcao)
                opcao = input("  Opção escolhida: ");
            end
            
            if opcao == 1
                A = input("\n\n  A = ");
            else
                tau = input("\n\n  Tau = ");
            end
        end
        
        t = linspace(-1, tau + 1, 1000);
        y = A * rectpuls(t - tau/2, tau);
        
    case 2
        clc;
        A = 0;
        ts = 0;
        td = 0;
        t_dur = 0;
        while A == 0 || ts == 0 || td == 0 || t_dur == 0
            opcao = 0;
            clc;
            fprintf("\n***************** Pulso Digital *****************\n");
            fprintf("\n\t Parâmetros: ");
            fprintf("\n\n\t\t Prima 1 - Indique a amplitude | A = %d", A);
            fprintf("\n\n\t\t Prima 2 - Indique o tempo de subida (mA)   | Ts = %d\n\n", ts);
            fprintf("\n\n\t\t Prima 3 - Indique o tempo de descida (mA)  | Td = %d\n\n", td);
            fprintf("\n\n\t\t Prima 4 - Indique a duração (mA)  | D = %d\n\n", t_dur);

            while opcao < 1 || opcao > 4 || ~isscalar(opcao)
                opcao = input("  Opção escolhida: ");
            end
            
            if opcao == 1
                A = input("\n\n  A = ");
            elseif opcao == 2
                ts = input("\n\n  Ts = ");
            elseif opcao == 3
                td = input("\n\n  Td = ");
            else
                t_dur = input("\n\n Duração = ");
            end
        end

        ts = ts * 1e-3;
        td = td * 1e-3;
        t_dur = t_dur * 1e-3;

        N = 10000;
        x = linspace(0, t_dur, N); 
        d = (t_dur)/N;
        
        % 1.a parte
        x1 = 0 : d : ts-d;
        tam1 = size(x1);
        pontos_ts = tam1(2);
        
        y(1:pontos_ts) = x1 .* A/ts; % y=mx onde m=A/ts
        
        % 2.a parte
        x2 = ts : d : t_dur - td - d; 
        tam2 = size(x2);
        pontos_tf = tam2(2);
        
        y(pontos_ts + 1 : pontos_tf + pontos_ts) = A;
        
        % 3.a parte
        x3 = t_dur - td : d : t_dur - d;

        if (size(x3) ~= N - pontos_ts - pontos_tf)
            x3 = t_dur - td : d : t_dur;
        end
        
        y(pontos_ts + pontos_tf + 1 : N) = -A/td .* x3 + A * t_dur /td;

    case 3
        clc;
        A = 0;
        ts = 0;
        td = 0;
        while A == 0 || ts == 0 || td == 0
            opcao = 0;
            clc;
            fprintf("\n***************** Pulso Triangular *****************\n");
            fprintf("\n\t Parâmetros: ");
            fprintf("\n\n\t\t Prima 1 - Indique a amplitude | A = %d", A);
            fprintf("\n\n\t\t Prima 2 - Indique o tempo de subida (mA)   | Ts = %d\n\n", ts);
            fprintf("\n\n\t\t Prima 3 - Indique o tempo de descida (mA)  | Td = %d\n\n", td);

            while opcao < 1 || opcao > 3 || ~isscalar(opcao)
                opcao = input("  Opção escolhida: ");
            end
            
            if opcao == 1
                A = input("\n\n  A = ");
            elseif opcao == 2
                ts = input("\n\n  Ts = ");
            else
                td = input("\n\n  Td = ");
            end
        end
        
        ts = ts * 1e-3;
        td = td * 1e-3;

        N = 10000;
        x = linspace(0, ts + td, N);
        d = (ts+td)/N; % distancia entre cada ponto

        x1 = 0 : d : ts - d;
        pontos_ts = size(x1); % matriz do tipo [1 1000]
        pontos_ts = pontos_ts(2);
        
        y(1:pontos_ts) = x1 .* A/ts; % y=mx onde m=A/ts

        x2 = ts : d : td + ts;

        if (size(x2) ~= N - pontos_ts) % ns porque, mas tenho de colocar este if se nao, às vezes nao dá
            x2 = ts : d : td + ts - d;
        end
        
        y(pontos_ts+1 : N) = x2 .* (-A/td) + A*(1 + ts/td); % m = -A/td  e b = A*(1+ts/td)
         
    case 4

        clc;
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
            fprintf("\n\n\t\t Prima 2 - Indique a duração   | Tau = %d\n\n", tau);
            fprintf("\n\n\t\t Prima 3 - Indique o período   | T = %d\n\n", T);
            fprintf("\n\n\t\t Prima 4 - Número de impulsos  | N = %d\n\n", n_graficos);

            while opcao < 1 || opcao > 4 || ~isscalar(opcao)
                opcao = input("  Opção escolhida: ");
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

    case 5
        return;
end

opcao = 0;
if Rs == 0 || RL == 0 || Td == 0 || Z0 == 0
    fprintf("\n\tAinda não acabou de definir a configuração do circuito.");
    fprintf("\n\tEscolha uma das seguintes opções:");
    fprintf("\n\n\t\t Prima 1 - Terminar a configuração");
    fprintf("\n\n\t\t Prima 2 - Utilizar a configuração predefinida\n");

    while opcao < 1 || opcao > 2 || ~isscalar(opcao)
        opcao = input('\n  Opção Escolhida: ');
    end
    
    if opcao == 1

        while Rs == 0 || RL == 0 || Td == 0 || Z0 == 0
            clc;
            opcao = 0;
            fprintf("\n********************* Parâmetros do circuito *********************\n");
            fprintf("\n\t Fonte de Alimentação:\n");
            fprintf("\n\t\t Prima 1 - Definir impedância da fonte | Rs = %d\n", Rs);
            fprintf("\n\t Impedância da Carga:\n");
            fprintf("\n\t\t Prima 2 - Definir em curto circuito   | RL = %d", RL);
            fprintf("\n\t Linha de Transmissão:\n");
            fprintf("\n\t\t Prima 3 - Definir tempo de propagação | Td = %d", Td);
            fprintf("\n\t\t Prima 4 - Definir impedância de linha | Z0 = %d", Z0);
            fprintf("\n\t\t Prima 5 - ou definir comprimento e velocidade de propagação | L = %d | v = %d\n", L, v);
            fprintf("******************************************************************");
            
            while opcao < 1 || opcao > 5 || ~isscalar(opcao)
                opcao = input('\n\n  Opção Escolhida: ');
            end
            
            fprintf("\n\t");
        
            switch opcao
                case 1
                    Rs = input('Rs (\ohms) = ');
                case 2
                    RL = input('RL em CC (\ohms) = ');
                case 3
                    Td = input('Td (s) = ');
                case 4
                    Z0 = input('Z0 (\ohms) = ');
                case 5
                    [L, v] = input('L (m), v (m/s) = ');
                    Td = L / v;
            end
        end

    else
        clc;
        opcao = 0;
        fprintf("\n********* Utilizar a configuração predefinida *********\n");
        fprintf("\n\tQual das configurações pretende utilizar?");
        fprintf("\n\n\t\t Opção 1:");
        fprintf("\n\t\t\t\tRs = 100"); fprintf("\n\t\t\t\tRL = 200");
        fprintf("\n\t\t\t\tTd = 0.002"); fprintf("\n\t\t\t\tZ0 = 100"); fprintf("\n\t\t\t\tNúmero de iterações = 4");
        fprintf("\n\t\t\t\tTolerância = 0.005");
        
        fprintf("\n\n\t\t Opção 2:");
        fprintf("\n\t\t\t\tRs = 200"); fprintf("\n\t\t\t\tRL = 100");
        fprintf("\n\t\t\t\tTd = 0.005"); fprintf("\n\t\t\t\tZ0 = 50"); fprintf("\n\t\t\t\tNúmero de iterações = 10");
        fprintf("\n\t\t\t\tTolerância = 0.005\n");
        fprintf("\n\n*********************************************************");
        
        while opcao < 1 || opcao > 2 || ~isscalar(opcao)
            opcao = input('\n\n  Opção escolhida: ');
        end
            
        if opcao == 1
            Rs = 100; RL = 200; Td = 0.002; Z0 = 50; n_iteracoes = 4; tolerancia = 2;
        else
            Rs = 200; RL = 100; Td = 0.005; Z0 = 50; n_iteracoes = 10; tolerancia = 2;
        end
    end

end

%desenho do gráfico
switch grafico

    case 1    
        figure('Name', 'Pulso Retangular');
        plot(t, y, 'b', LineWidth = 2);
        xlim([-2 tau + 2]); ylim([-0.5 A + 2]);
        
        ir_para_tarefa = 2;
        opcao_3(A, Rs, RL, Td, Z0, n_iteracoes, tolerancia, ir_para_tarefa, [], [], tau);
        return;

    case 2
    
        figure('Name', 'Pulso Digital');
        plot(x*1e3, y, LineWidth = 2); 
        title('Pulso Digital');
        ylim([0 A+1]);

        f = @(x) y - Rs .* x;
        figure('Name', 'Diagrama V(I)');
        plot(x.*1e3, f(x), LineWidth = 2);
        title('Diagrama V(I)');
        hold on;

        c = @(x) RL .* x;
        plot(x .* 1e3, c(x), 'b', LineWidth = 2);
        grid on;
        xlabel('Corrente (A)'); ylabel('Tensão (V)');
        ylim([0 A + 10]);
        hold off;

    case 3

        figure('Name', 'Pulso Triangular');
        plot(x.*1e3, y, LineWidth = 2);
        title('Pulso Triangular');
        
        f = @(x) y - Rs .* x;
        figure('Name', 'Diagrama V(I)');
        plot(x.*1e3, f(x), LineWidth = 2);
        hold on;
        
        c = @(x) RL .* x;
        plot(x .* 1e3, c(x), 'b', LineWidth = 2);
        grid on;
        title('Diagrama V(I)');
        xlabel('Corrente (A)'); ylabel('Tensão (V)');
        ylim([0 A + 10]);
        hold off;

        %zero_x = fzero(@(x) f(x) - c(x), 2);
        %zero_y = f(zero_x);
        %po = plot(zero_x, zero_y, 'o', 'markerfacecolor','k');
    case 4

        figure('Name', 'Trem de Impulsos');
        plot(x, y, LineWidth = 2);
        title('Trem de Impulsos');

        I = A / Rs;
        
        f = @(x) y - Rs .* x;
        figure(2);
        plot(x, f(x), LineWidth = 2);
        title('Diagrama V(I)');
        hold on;

        c = @(x) RL .* x;
        plot(x, c(x), 'b', LineWidth = 2);
        grid on;
        title('Diagrama V(I)');
        xlabel('Corrente (A)'); ylabel('Tensão (V)');
        ylim([0 A + 10]);
end

end