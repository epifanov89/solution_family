function rho = euclidian_norm(w1, w2)
%EUCLIDIAN_NORM Summary of this function goes here
%   Detailed explanation goes here
  rho = 0;
  sz = size(w1);
  nvar = sz(2);
  for var_index = 1:nvar
    rho = rho + (w1(var_index) - w2(var_index))^2;
  end
  rho = sqrt(rho);
end

