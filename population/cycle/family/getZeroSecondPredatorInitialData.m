function w0 = getZeroSecondPredatorInitialData(N)

nspecies = 3;
nvar = N*nspecies;

L = 1;
h = L/N;

w0 = zeros(1,nvar);
for pt = 1:N
  w0(pt) = u10((pt-1)*h);
  w0(N+pt) = u20((pt-1)*h);
  w0(2*N+pt) = 0;
end


  function u = u10( x )
    if x >= 0 && x <= 0.4*L
      u = 0.2*sin(x*pi/0.4/L);
    else
      u = 0;
    end
  end
  % -----------------------------------------------------------------------
  
  function u = u20( x )
    if x >= L/2 && x <= 0.9*L
      u = max(0, 0.2*sin((x-L/2)*pi/0.4/L));
    else
      u = 0;
    end
  end
  % -----------------------------------------------------------------------

end

