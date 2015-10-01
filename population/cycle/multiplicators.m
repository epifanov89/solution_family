function rho = multiplicators( monodromy_matrix, f, system_jacobian, solver, tspan, w0, nvar, options, outputopts )
%MULTIPLICATORS Summary of this function goes here
%   Detailed explanation goes here  
  M = monodromy_matrix(f, system_jacobian, solver, tspan, w0, nvar, options, outputopts);
  rho = eig(M);
end