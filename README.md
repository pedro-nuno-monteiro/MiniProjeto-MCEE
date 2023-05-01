# Projeto MCEE - ANÁLISE DE SINAIS ATRAVÉS DO MÉTODO DE BERGERON

## Objetivo

 - Programa que faz a análise de sinais elétricos com recurso ao método de BERGERON. 
 - Programa solicita ao user toda a info necessária para caracterizar o circuito.
 - Apresentar o gráfico com o diagrama de BERGERON, as curvas de tensão e corrente da fonte e da carga.
 - Apresentar também o valor da tensão e corrente no ponto de operação e uma tabela(s) com os valores em cada iteração.


## Descrição-base:

### O programa deverá disponibilizar um menu que permita ao utilizador configurar:
 1. Os parâmetros do circuito
    - Tensão e impedância da fonte de alimentação à entrada da linha
    - Impedância da carga
        - Deve permitir a definição de situação de carga em curto-circuito (resistência nula) e em circuito aberto.
    - Parâmetros da linha de transmissão
        - Tempo de propagação ou
        - Comprimento e velocidade de propagação (tipicamente 2/3 da velocidade da luz, podendo variar, naturalmente).

 2. Definição do número de iterações a realizar. O utilizador poderá ainda definir um valor de tolerância que leve a interrupção do cálculo, por exemplo, quando a diferença da tensão e da corrente calculadas na iteração atual com os valores obtidos na iteração anterior for inferior a uma tolerância definida pelo utilizador. Pode considerar um valor de tolerância por omissão.

 3. Aplicar/executar o método de Bergeron a partir da configuração presente. Se o utilizador não tiver ainda qualquer configuração definida, o programa deve fazer um alerta. Em alternativa, pode considerar a execução considerando um modelo por omissão (modelo de demonstração).

 4. Sair do programa, sendo requerida a confirmação desta operação.
        
    
### Após a execução do Método de Bergeron (opção 3 do menu), devem ser apresenta a seguinte informação ao utilizador:
 1. Os parâmetros de configuração do modelo.
 2. O diagrama V(I).
 3. Gráfico com as curvas das tensões à saída da fonte e aos terminais da carga.
 4. Gráfico com as curvas das correntes na fonte e na carga.
 5. Tabela com os vários valores de tensão e corrente calculados durante a aplicação do método de Bergeron.
 6. Valores de tensão e corrente no ponto de operação do circuito.


## Extra:

### Tarefa A
Permitir a possibilidade de definir representações não lineares para a fonte e a carga do circuito. Pode considerar a utilização de funções anónimas para este efeito. Ainda, deve ter em conta que as curvas caraterísticas introduzidas devem garantir um ponto de operação, caso contrário o circuito não é viável.

### Tarefa B
Para além do sinal DC constante, o programa poderá possibilitar a definição de sinais de amplitude variável e duração finita. De entre estes sinais, pode considerar:
 - Um pulso retangular, definido pela sua amplitude, A, e duração, tau;
 - Um pulso digital, definido pela sua amplitude, A, e pelo tempo de subida, tr, tempo de descida, tf, e duração de pulso, tau;
 - Um pulso triangular, de amplitude A, com tempo de subida, tr, e tempo de descida, tf;
 - Um trem de impulsos, definido pela amplitude dos impulsos, A, a duração dos pulsos, tau, e o período dos pulsos, T.

## O método de Bergeron

### Introdução

Transmissão de sinais elétricos entre 2 pontos, através de uma linha de transmissão

Circuito: 
 - fonte (fonte Vs + resistência Rs);
 - linha de transmissão de comprimento L e com impedância característica Z0;
 - carga RL (pode ser, por exemplo, a entrada de uma porta lógica).

Com a linha de transmissão, o sinal elétrico pode ser afetado pelas grandes velocidades:
 - sofre um atraso de tempo, Td (por causa da tal velocidade, u), tal que Td = L / u;

Há ainda a impedância característica, Z0, que pode afetar o sinal se for diferente de RL.

O método de Bergeron é uma ferramenta para calcular a tensão e a corrente em qualquer ponto da linha de transmissão para se poder fazer a análise dos tempos de propagação do sinal:
 - v(z, t) = v+ * (z - vt) + v- * (z + ut);
 - i(z, t) = v(z, t) / Z0.   [LEI DE OHM].
 - v+ a onda que viaja no sentido positivo dos zz (da fonte para a carga) (onda incidente);
 - v- a do sentido negativo (onda refletida);
 - u a velocidade de propagação, onde u = 1 / (LC)^1/2;
 - Z0 = (L/C)^1/2.

Num gráfico tensão corrente, se for onda incidente, o declive é -Z0. Numa refletida, o declive é +Z0.

### Passos do método de BERGERON
 1. representar as curvas características da fonte e da carga num gráfico tensão-corrente.
    - no caso da carga, é uma reta de declive RL que passa na origem;
    - no caso da fonte, basta definir 2 pontos de funcionamento para obter a curva.
        - estes pontos podem ser 1 em circuito-aberto (I = 0  e V máx) e outro em curto-circuito (V = 0 e I = V máx / Rs);
        - ou então definir V = Vs - Rs * I.
    - a interseção das 2 curvas é o ponto de operação/funcionamento do circuito em regime permanente (quando t -> +infinito).
    
 2. a fonte é ligada ao circuito em t = 0s (em t < 0s, V = I = 0), começamos na fonte e segue-se a onde refletida (em direção à fonte, onde o declive é +Z0).
    - para determinar o valor de V e I em t = 0 faz-se o seguinte (não esquecer que é um gráfico tensão-corrente! O tempo não está representado):
        - assumir o instante de partida = -TD (ponto B, t = -TD, I = V = 0 <=> origem) (assumimos assim pois começamos na carga e o tempo que demoramos a chegar à fonte é Td, ou seja, quando chegarmos à fonte, t = 0);
        - seguindo o declive +Z0, o ponto A será em t = 0 (ponto de interseção desta reta [BA] com a "curva" característica do circuito);
        - e portanto, os valores de V e I do ponto A são os valores de V e I quando t = 0s.
    
 3. agora, é fazer o inverso:
    - do ponto A seguir uma onde incidente (declive -Z0);
    - a interseção desta reta com a curva da carga será no ponto em que t = Td (novo ponto B);
    - a duração entre A e B é sempre Td (tempo de propagação).
    
 4. repetindo o processo 2 e 3 várias vezes percebe-se que nos estamos a aproximar do ponto de operação do circuito.

 5. com este gráfico concluído conseguimos construir 2 novos gráficos:
    - tensão-tempo, onde representamos as várias tensões em A e em B (fica tido degraus);
    - corrente-tempo, onde é a mesma cena, mas para a corrente.
    - os pontos A e B são, respetivamente, a fonte e a carga;
    - a tensão e corrente na fonte (ponto A) variam a cada 2 * n * Td segundos (n o número de iterações);
    - a tensão e corrente na carga (ponto B) variam a cada (2 * n + 1) * Td segundos (n o número de iterações).

 6. isto tudo é no caso do comportamento da fonte/carga for linear. No caso onde não seja, também é possível fazer o método!
    - tarefa A;
    - tarefa B.