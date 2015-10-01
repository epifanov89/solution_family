function res = approximate( w, npointnew )
%APPROXIMATE Summary of this function goes here
%   Detailed explanation goes here
  sz = size(w);
  npointold = sz(2);
  res = zeros(1,npointnew);
  for new_point_index = 1:npointnew
    prev_point_index = fix((new_point_index-1)*npointold/npointnew)+1;
    next_point_index = mod(prev_point_index,npointold)+1;
    ratio = mod((new_point_index-1)*npointold,npointnew);
    difference = w(next_point_index)-w(prev_point_index);
    res(new_point_index) = w(prev_point_index)+difference*ratio/npointnew;     
  end

  %sz = size(w);
  %n_old = sz(2);  
  %if N > n_old
  %  res = zeros(1, N);
  %  nintermediate = N / n_old;
  %  for step_index = 1:n_old
  %    space = linspace(w(step_index), w(mod(step_index, n_old) + 1), nintermediate + 1);
  %    res((step_index - 1) * nintermediate + 1:step_index * nintermediate) = space(1:end - 1);
  %  end
  %else
  %  res = w;
  %end
end

