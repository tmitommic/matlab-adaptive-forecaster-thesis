function [ e, y, ff, MSE ] = nlms1_d( x, L, alpha, delta )
% x     ci¹g próbek sygna³u wejœciowego
% d     ci¹g próbek sygna³u wzorcowego
% L     rz¹d filtru
% alpha stala adaptacji
% e     sygnal bledu
% y     sygnal wyjœciowy filtru
% ff    L × M wymiarowa macierz wspó³czynników
% M     liczba próbek sygna³ów x(n) i d(n)
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

