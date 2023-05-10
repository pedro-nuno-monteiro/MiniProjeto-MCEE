function [] = tarefa_B(Rs, RL_CC)

%função que permite ao user definir o gráfico da fonte

clc;
fprintf("\n***************************************\n");
fprintf("\n\tEscolha um dos seguintes gráficos:");
fprintf("\n\n\t\tPrima 1 - Pulso retangular");
fprintf("\n\n\t\tPrima 2 - Pulso digital");
fprintf("\n\n\t\tPrima 3 - Pulso triangular");
fprintf("\n\n\t\tPrima 4 - Trem de impulsos");
fprintf("\n\n\t\tPrima 5 - Regressa\n");
fprintf("\n***************************************\n");

grafico = 0;
while grafico < 1 || grafico > 5
    grafico = input('\n\tOpção escolhida: ');
end

switch grafico
    case 1
        dlgtitle = 'Pulso triangular';
        perguntas = {'Amplitude: ', 'Duração (mA): '};
        dims = [1 40];
        definput = {'0', '0'};
        
        dados = inputdlg(perguntas, dlgtitle, dims, definput);
        dados_num = cellfun(@str2num, dados);

        A = dados_num(1);
        tau = dados_num(2) * 1e-3;
        
        y = rectangularPulse(0, td, A);

    case 2
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
        
        opcao = 0;
        if Rs == 0 || RL_CC == 0
            fprintf("\n\tAinda não acabou de definir a configuração do circuito.");
            fprintf("\n\tEscolha uma das seguintes opções:");
            fprintf("\n\n\t\t Prima 1 - Terminar a configuração");
            fprintf("\n\n\t\t Prima 2 - Utilizar a configuração predefinida\n");
            fprintf("\n************************************************************");
            
            while opcao < 1 || opcao > 2
                opcao = input('\n\t Opção Escolhida: ');
            end
            
            if opcao == 1

                while Rs == 0 || RL_CC == 0
                    menu = 0;
                    fprintf("\n\n\t Prima 1 - Impedância da fonte | Rs = %d", Rs);
                    fprintf("\n\n\t Prima 2 - Impedância da Carga: | RL = %d\n", RL_CC);
                    
                    while menu < 1 || menu > 2
                        menu = input('\n\t Opção escolhida: ');
                    end

                    switch menu
                        case 1
                            Rs = input('\n\tRs = ');
                        case 2
                            RL_CC = input('\n\tRL = ');
                    end
                end

            else
                opcao = 0;
                fprintf("\n\tQual das configurações pretende utilizar?");
                fprintf("\n\n\t\t Opção 1:");
                fprintf("\n\t\t\t\tRs = 100"); fprintf("\n\t\t\t\tRL = 200");
                fprintf("\n\t\t\t\tTd = 0.002"); fprintf("\n\t\t\t\tZ0 = 100"); fprintf("\n\t\t\t\tNúmero de iterações = 4");
                fprintf("\n\t\t\t\tTolerância = 0.005");
                
                fprintf("\n\n\t\t Opção 2:");
                fprintf("\n\t\t\t\tRs = 200"); fprintf("\n\t\t\t\tRL = 100");
                fprintf("\n\t\t\t\tTd = 0.005"); fprintf("\n\t\t\t\tZ0 = 50"); fprintf("\n\t\t\t\tNúmero de iterações = 10");
                fprintf("\n\t\t\t\tTolerância = 0.005\n");
                fprintf("\n************************************************************")
                
                while opcao < 1 || opcao > 2
                    opcao = input('\n\t Opção escolhida: ');
                end
                    
                if opcao == 1
                    Rs = 100; RL_CC = 200;
                else
                    Rs = 200; RL_CC = 100;
                end
            end

        end

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
    case 5
        fprintf("opcao 5 - bazar");
end

end