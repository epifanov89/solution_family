function solveall()

preyDiffusionCoeff = 0.2;
secondPredatorDiffusionCoeff = 0.24;
firstPredatorMortality = 1.2;
resourceVariation = 0.5;
N = 24;
tspan = [0,1000];
solver = @ode15s;
nsol = 10;
familyName = sprintf('p=1+%.1fsin(2 pi x)\\l2=%.1f\\',...
  resourceVariation,firstPredatorMortality);
doSolveAll(@doSolveAllCore,preyDiffusionCoeff,...
  secondPredatorDiffusionCoeff,firstPredatorMortality,resourceVariation,...
  N,tspan,solver,nsol,familyName);
end

