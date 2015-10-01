function y = myode(odefun,y0,tspan)
%MYODE Summary of this function goes here
%   Detailed explanation goes here
  alpha = [0,0.25,0.5,1];
  bt = [0    0   0
        0.25 0   0
        0    0.5 0
        1   -2   2];
  p = [1,-2,2,0];
  y = zeros(length(tspan),length(y0));
  y(1,:) = y0;
  for timept = 2:length(tspan)
    h = tspan(timept)-tspan(timept-1);
    y(timept,:) = y(timept-1,:);
    k = zeros(1,4);
    for i = 1:4
      sum = 0;
      for j = 1:i-1
        sum = sum + bt(i,j)*k(j);
      end
      k(i) = h*odefun(tspan(timept)+alpha(i)*h,y(timept-1)+sum);
      y(timept,:) = y(timept,:) + k(i)*p(i);
    end
  end
end

