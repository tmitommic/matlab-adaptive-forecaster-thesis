function [ e, y, ff, MSE ] = nlms1_d( x, L, alpha, delta )
% x     ci�g pr�bek sygna�u wej�ciowego
% d     ci�g pr�bek sygna�u wzorcowego
% L     rz�d filtru
% alpha stala adaptacji
% e     sygnal bledu
% y     sygnal wyj�ciowy filtru
% ff    L � M wymiarowa macierz wsp�czynnik�w
% M     liczba pr�bek sygna��w x(n) i d(n)
M=length(x);
ff=zeros(L,M);
ff_act=ff(:,1);
x_n=zeros(L,1);
d=x;
MSE=0;
for n=1:M
    if (n-delta)<0
        x_n = zeros(L,1);
    elseif (n-delta)<L
    	x_n = [ x(n-delta:-1:1), zeros(1,L-n+delta) ]';
    else
        x_n = [ x(n-delta:-1:n-delta-L+1) ]';
    end
    y(n) = ff_act' * x_n;
    e(n) = d(n) - y(n);
    if x_n'*x_n == 0        % aby uniknac dzielenia przez zero na poczatku dzialania algorytmu
        ff_act=ff_act+alpha*e(n)*x_n;   % zachowuj sie jak LMS 
    else
        ff_act=ff_act+alpha*e(n)*x_n/(x_n'*x_n);
    end
    ff(:,n)=ff_act;
    MSE=MSE+(e(n))^2;
end
MSE=MSE/M;
end

