function w0 = getInitialDataToSolveTillSteady( solno,N )

nspecies = 3;
nvar = nspecies*N;

w0 = zeros(1,nvar);

L = 1;
h = L/N;

if solno == 1
  for pt = 1:N
    w0(pt) = u10((pt-1)*h);
    w0(N+pt) = u20((pt-1)*h);
    w0(2*N+pt) = u30((pt-1)*h);
  end
elseif solno == 2
  for pt = 1:N
    w0(pt) = u10((pt-1)*h);
    w0(N+pt) = u40((pt-1)*h);
    w0(2*N+pt) = u50((pt-1)*h);
  end
end

  function u = u10( x )
    u = 1+0.2*sin(2*pi*x);
  end
  % -----------------------------------------------------------------------

  function u = u20( x )
    u = 0.1+0.02*sin(2*pi*x);
  end
  % -----------------------------------------------------------------------

  function u = u30( x )
    u = 0.2-0.02*cos(2*pi*x);
  end
  % -----------------------------------------------------------------------
  
  function u = u40( x )
    u = 0.2+0.02*cos(2*pi*x);
  end
  % -----------------------------------------------------------------------

  function u = u50( x )
    u = 0.1-0.02*sin(2*pi*x);
  end
  % -----------------------------------------------------------------------

end

