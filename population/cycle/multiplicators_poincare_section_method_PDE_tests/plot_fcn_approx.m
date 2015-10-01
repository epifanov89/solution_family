function plot_fcn_approx( X,f )
%PLOT_FCN_APPROX Выводит график сеточной дискретизации функции
%   Detailed explanation goes here
N = length(X);
h = X(2)-X(1);
L = N*h;

if X(1) == 0
  newlen = N+1;
  Xout = zeros(1,newlen);
  Xout(end) = L;
  valvect = zeros(1,newlen);
  valvect(end) = f(X(1));
  start_point_index = 1;
else
  newlen = N+2;
  Xout = zeros(1,newlen);
  Xout(1) = 0;
  Xout(end) = L;
  valvect = zeros(1,newlen);
  interpval = (f(X(1))+f(X(N)))/2;
  valvect(1) = interpval;
  valvect(N+2) = interpval;

  start_point_index = 2;
end
for pt = 1:N
  Xout(pt+start_point_index-1) = X(pt);
  valvect(pt+start_point_index-1) = f(X(pt));
end

figure
hold on
fplot(f,[0 L]);
plot(Xout,valvect,'r-o');
title('Carrying capacity');
xlabel('x');
ylabel('P(x)','rot',0);
hold off

end

