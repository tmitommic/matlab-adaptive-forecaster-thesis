function [ e, y, ff, MSE ] = rls1_d( x, L, lambda, gamma, delta )
% x         ci¹g próbek sygna³u wejœciowego
% d         ci¹g próbek sygna³u wzorcowego
% L         rz¹d filtru
% lambda    stala zapominania
% gamma     parametr wartoœci pocz¹tkowej macierzy P
% e         sygnal bledu
% y         sygnal wyjœciowy filtru
% ff        L × M wymiarowa macierz wspó³czynników
% M         liczba próbek sygna³ów x(n) i d(n)

M=length(x);
ff=zeros(L,M);
x_n=zeros(L,1);
P=gamma*eye(L);
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
    if n==1
        y(n) = ff(:,1)' * x_n;
        e(n) = d(n) - y(n);
        alpha=1/(lambda+x_n'*P*x_n);
        ff(:,n)=ff(:,1)+alpha*e(n)*P*x_n;
        P=(1/lambda)*(P-alpha*P*x_n*x_n'*P);
    else
        y(n) = ff(:,n-1)' * x_n;
        e(n) = d(n) - y(n);
        alpha=1/(lambda+x_n'*P*x_n);
        ff(:,n)=ff(:,n-1)+alpha*e(n)*P*x_n;
        P=(1/lambda)*(P-alpha*P*x_n*x_n'*P);
    end   
    MSE=MSE+(e(n))^2;
end
MSE=MSE/M;
end

