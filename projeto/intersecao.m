function [x0, y0]=intersecao(c, f)

    y=f-c;

    y(y<0)=10;

    x0=min(y);
    



    %y0=f(x0);

end