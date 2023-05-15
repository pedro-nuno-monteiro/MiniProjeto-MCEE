clc; clear; close all;

prima_1=false; 
prima_2=false; 
opcao=0; 
linear_1=0; 
linear_2=0; 
carga_definida=false; 
fonte_definida=false;
x=linspace(0, 10, 10000); %totalmente ao calhas

while prima_1 == false || prima_2 == false

    fprintf('Prima 1: Definir reta da carga ');
    fprintf('\nPrima 2: Definir reta da fonte ');
    
    while opcao < 1 || opcao > 2 || ~isscalar(opcao)
        opcao = input("\n\n Opção Escolhida: ");
    end
    
    if opcao == 1 && carga_definida==false
        prima_1 = true; 
        carga_definida = true;
        clc;
        fprintf('Prima 1: Linear ');
        fprintf('\nPrima 2 : Não Linear ');

        while linear_1 < 1 || linear_1 > 2 || ~isscalar(linear_1)
            linear_1 = input("\n\n Opção Escolhida: ");
        end
        
        if linear_1 == 2 
            aux=[];
           
            clc;
            carga=input('Escreva a reta da carga não linear: ', 's');
            c=@(x) carga;

            clc;
            %c=strcat('@(x)',['(' c ')']);

        end

        if linear_1 == 1
            clc;
            RL_CC=input('Insira o valor de RL: ');
            disp('merda');
            c = @(x) RL_CC .* x;
            clc;
        end

    end
    
    
    if opcao ==2 && fonte_definida==false
        prima_2=true; 
        fonte_definida=true;
        clc;
        fprintf('Prima 1: Linear ');
        fprintf('\nPrima 2 : Não Linear ');

        while linear_2 < 1 || linear_2 > 2 || ~isscalar(linear_2)
            linear_2 = input("\n\n Opção Escolhida: ");
        end

        if linear_2 == 2 
            clc;
            fonte=input('Escreva a reta da fonte não linear: ', 's');
            f=@(x) fonte;
            clc;
            %f=strcat('@(x)', ['(' f ')']);
            %f=eval(f);
            

        end

        if linear_2 == 1
            clc;
            Rs=input('Insira o valor de Rs: ');
            Vs=input('Insira o valor de Vs: ');
            f = @(x) Vs - Rs*x;
            clc;
        end

    end

    opcao=0;
end

plot(x, c(x), 'LineWidth', 2); hold on;
plot(x, f(x), 'LineWidth', 2);
ylim([0 14]); 

zero_x = fzero(@(x) f(x) - c(x), 2);
zero_y = f(zero_x);
po = plot(zero_x, zero_y, 'o', 'MarkerFaceColor','k'); hold off;


Z0 = 50;

