function [] = tarefa_B(Rs, RL_CC, Td, Z0)

%função que permite ao user definir o gráfico da fonte

clc;
fprintf("\n***************************************\n");
fprintf("\n\tEscolha um dos seguintes gráficos:");
fprintf("\n\t\tPrima 1 - Pulso retangular");
fprintf("\n\t\tPrima 2 - Pulso digital");
fprintf("\n\t\tPrima 3 - Pulso triangular");
fprintf("\n\t\tPrima 4 - Trem de impulsos");
fprintf("\n\t\tPrima 5 - Regressar\n");
fprintf("\n***************************************\n");

grafico = 0;
while grafico < 1 || grafico > 5
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
            fprintf("\n\n\t\t Prima 2 - Indique a duração   | Tau = %d\n\n", tau);

            while opcao < 1 || opcao > 2
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

        dlgtitle = 'Pulso digital';
        perguntas = {'Amplitude: ', 'Tempo de subida: ', 'Tempo de descida: ', 'Duração do pulso: '};
        dims = [1 40];
        definput = {'0', '0', '0', '0'};
        
        dados = inputdlg(perguntas, dlgtitle, dims, definput);
        dados_num = cellfun(@str2num, dados);
        
        A = dados_num(1);
        ts = dados_num(2) * 1e-3;
        td = dados_num(3) * 1e-3;
        t_dur=dados_num(4) * 1e-3;

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

        dlgtitle = 'Pulso triangular';
        perguntas = {'Amplitude: ', 'Tempo de subida: ', 'Tempo de descida: '};
        dims = [1 40];
        definput = {'0', '0', '0'};
        
        dados = inputdlg(perguntas, dlgtitle, dims, definput);
        dados_num = cellfun(@str2num, dados);
        
        A = dados_num(1);
        ts = dados_num(2) * 1e-3;
        td = dados_num(3) * 1e-3;

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

            while opcao < 1 || opcao > 4
                opcao = input("  Opção escolhida: ");
            end
            
            switch opcao
                case 1 
                    A = input("\n\n  A = ");
                case 2
                    tau = input("\n\n  Tau = ");
                case 3
                    T = input("\n\n  T = ");
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
        fprintf("opcao 5 - bazar");
        return;
end

opcao = 0;
if Rs == 0 || RL_CC == 0 || Td == 0 || Z0 == 0
    fprintf("\n\tAinda não acabou de definir a configuração do circuito.");
    fprintf("\n\tEscolha uma das seguintes opções:");
    fprintf("\n\n\t\t Prima 1 - Terminar a configuração");
    fprintf("\n\n\t\t Prima 2 - Utilizar a configuração predefinida\n");

    while opcao < 1 || opcao > 2
        opcao = input('\n  Opção Escolhida: ');
    end
    
    if opcao == 1

        while Rs == 0 || RL_CC == 0
            clc;
            [Vs, Rs, RL_CC, Td, Z0] = opcao_1();
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
        
        while opcao < 1 || opcao > 2
            opcao = input('\n\n  Opção escolhida: ');
        end
            
        if opcao == 1
            Rs = 100; RL_CC = 200; Td = 0.002; Z0 = 50; n_iteracoes = 4; tolerancia = 0.005;
        else
            Rs = 200; RL_CC = 100; Td = 0.005; Z0 = 50; n_iteracoes = 10; tolerancia = 0.005;
        end
    end

end

switch grafico
    case 1

        figure('Name', 'Pulso Retangular');
        plot(t, y, 'b', LineWidth = 2);
        xlim([-2 tau + 2]); ylim([-0.5 A + 2])

        I = A / Rs;
        x = linspace(0, I, 10000);
        
        f = @(x) A - Rs .* x;
        figure(2);
        plot(x, f(x), LineWidth = 2);
        title('Diagrama V(I)');
        hold on;
        
        c = @(x) RL_CC .* x;
        plot(x, c(x), 'b', LineWidth = 2);
        grid on;
        xlabel('Corrente (A)'); ylabel('Tensão (V)');
        ylim([0 A + 2]);
        hold on;

        zero_x = fzero(@(x) f(x) - c(x), 2);
        zero_y = f(zero_x);
        po = plot(zero_x, zero_y, 'o', 'markerfacecolor','k');
        
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
                ylim([0 A+1]); xlim([0 2*zer_x]);
            else
                ylim([0 A+1]); xlim([0 I]);
            end
        end
        %legend([grafico_fonte, grafico_carga, po], {'Fonte', 'Carga', 'Ponto de operação'}, 'Location', 'best');
        %hold off;
        pause(10);
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

        c = @(x) RL_CC .* x;
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
        
        c = @(x) RL_CC .* x;
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

        c = @(x) RL_CC .* x;
        plot(x, c(x), 'b', LineWidth = 2);
        grid on;
        title('Diagrama V(I)');
        xlabel('Corrente (A)'); ylabel('Tensão (V)');
        ylim([0 A + 10]);
end

end