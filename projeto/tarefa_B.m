function tarefa_B(Rs, RL, Td, Z0)

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
            fprintf("\n\n\t\t Prima 2 - Indique a duração (mA)   | Tau = %d", tau);

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
        [A, ts, td, t_dur] = deal(0);
        while A == 0 || ts == 0 || td == 0 || t_dur == 0
            opcao = 0;
            clc;
            fprintf("\n***************** Pulso Digital *****************\n");
            fprintf("\n\t Parâmetros: ");
            fprintf("\n\n\t\t Prima 1 - Indique a amplitude | A = %d", A);
            fprintf("\n\n\t\t Prima 2 - Indique o tempo de subida (mA)   | Ts = %d", ts);
            fprintf("\n\n\t\t Prima 3 - Indique o tempo de descida (mA)  | Td = %d", td);
            fprintf("\n\n\t\t Prima 4 - Indique a duração (mA)  | D = %d\n\n", t_dur);

            while opcao < 1 || opcao > 4 || ~isscalar(opcao)
                opcao = input("  Opção escolhida: ");
            end
            
            if opcao == 1
                A = -1;
                while A < 0 || ~isscalar(A)
                    A = input("\n\n  A = ");
                end
            elseif opcao == 2
                ts = -1;
                while ts < 0 || ~isscalar(ts)
                    ts = input("\n\n  Ts = ");
                end
            elseif opcao == 3
                td = -1;
                while td < 0 || ~isscalar(td)
                    td = input("\n\n  Td = ");
                end
            else
                t_dur = -1;
                while t_dur < 0 || ~isscalar(t_dur)
                    t_dur = input("\n\n Duração = ");
                end
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
        [A, ts, td] = deal(0);
        while A == 0 || ts == 0 || td == 0
            opcao = 0;
            clc;
            fprintf("\n***************** Pulso Triangular *****************\n");
            fprintf("\n\t Parâmetros: ");
            fprintf("\n\n\t\t Prima 1 - Indique a amplitude | A = %d", A);
            fprintf("\n\n\t\t Prima 2 - Indique o tempo de subida (mA)   | Ts = %d", ts);
            fprintf("\n\n\t\t Prima 3 - Indique o tempo de descida (mA)  | Td = %d", td);

            while opcao < 1 || opcao > 3 || ~isscalar(opcao)
                opcao = input("  Opção escolhida: ");
            end
            
            if opcao == 1
                A = -1;
                while A < 0 || ~isscalar(A)
                    A = input("\n\n  A = ");
                end
            elseif opcao == 2
                ts = -1;
                while ts < 0 || ~isscalar(ts)
                    ts = input("\n\n  Ts = ");
                end
            else
                td = -1;
                while td < 0 || ~isscalar(td)
                    td = input("\n\n  Td = ");
                end
            end
        end
        
        ts = ts * 1e-3;
        td = td * 1e-3;

        N = 10000;
        x = linspace(0, ts + td, N);
        d = (ts + td)/N;        % distancia entre cada ponto

        x1 = 0 : d : ts - d;
        pontos_ts = size(x1);   % matriz do tipo [1 1000]
        pontos_ts = pontos_ts(2);
        
        y(1:pontos_ts) = x1 .* A/ts; % y=mx onde m=A/ts

        x2 = ts : d : td + ts;

        if (size(x2) ~= N - pontos_ts)
            x2 = ts : d : td + ts - d;
        end
        
        y(pontos_ts+1 : N) = x2 .* (-A/td) + A*(1 + ts/td); % m = -A/td  e b = A*(1+ts/td)
         
    case 4

        clc;
        [A, tau, T, n_graficos] = deal(0);
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
                opcao = input("  Opção escolhida: ");
            end
            
            switch opcao
                case 1 
                    A = -1;
                    while A < 0 || ~isscalar(A)
                        A = input("\n\n  A = ");
                    end
                case 2
                    tau = -1;
                    while tau < 0 || ~isscalar(tau)
                        tau = input("\n\n  Tau = ");
                    end
                case 3
                    T = input("\n\n  T = ");
                    while T < tau
                        fprintf("\n Tem de introduzir um período maior que a duração do sinal! T = ")
                        T = input("");
                    end
                case 4
                    n_graficos = -1;
                    while n_graficos < 0 || ~isscalar(n_graficos)
                        n_graficos = input("\n\n Número de Impulsos = ");
                    end
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
            fprintf("\n\t\t Prima 2 - Definir resistência         | RL = %d", RL);
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
                    Rs = -1;
                    while Rs < 0 || ~isscalar(Rs)
                        Rs = input('Rs = ');
                    end
                case 2
                    RL = -1;
                    while RL < 0 || ~isscalar(RL)
                        RL = input('RL = ');
                    end
                case 3
                    Td = -1;
                    while Td < 0 || ~isscalar(Td)
                        Td = input('Td (s) = ');
                    end
                case 4
                    Z0 = -1;
                    while Z0 < 0 || ~isscalar(Z0)
                        Z0 = input('Z0 = ');
                    end
                case 5
                    valores = input('L(m), v(m/s) = ', 's');
                    valores = strsplit(valores, ' ');
                    L = str2double(valores{1});
                    v = str2double(valores{2});
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
            Rs = 5; RL = 25; Td = 0.005; Z0 = 100; n_iteracoes = 10; tolerancia = 2;
        end
    end

end

%desenho do gráfico
switch grafico

    case 1    
        figure('Name', 'Pulso Retangular');
        plot(t, y, 'b', LineWidth = 2);
        xlim([-2 tau + 2]); ylim([-0.5 A + 2]);
        
        figure('Name', 'Diagrama V(I)', 'NumberTitle', 'off', 'ToolBar', 'none', 'MenuBar', 'none');
        I = A/Rs;
        x = linspace(0, I, 10000);
        
        % reta da fonte
        f = @(x) A - Rs .* x;
                
        % gráfico da fonte
        subplot(1, 3, 1);
        grafico_fonte = plot(x, f(x), 'r', 'LineWidth', 2);
        hold on;
        
        % reta da carga
        c = @(x) RL .* x;
        
        % gráfico da carga
        grafico_carga = plot(x, c(x), 'b', 'LineWidth', 2);
        grid on;
        title('Diagrama V(I)');
        xlabel('Corrente (A)'); ylabel('Tensão (V)');
        grid on;
        
        % ponto de operação
        zero_x = fzero(@(x) f(x) - c(x), 2);
        zero_y = f(zero_x);
        
        po = plot(zero_x, zero_y, 'o', 'MarkerFaceColor','k');
        
        xlabel('Corrente (A)'); ylabel('Tensao (V)');
        legend([grafico_fonte, grafico_carga, po], {'Fonte', 'Carga', 'Ponto de operação'}, 'Location', 'best');

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

    case 4

        figure('Name', 'Trem de Impulsos');
        plot(x, y, LineWidth = 2);
        ylim([0 A + 2]);
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