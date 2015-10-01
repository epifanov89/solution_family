function solveall()

preyDiffusionCoeff = 0.2;
secondPredatorDiffusionCoeff = 0.24;
firstPredatorMortality = 1.1;
resourceDeviation = 0.5;
N = 24;
tspan = 0:0.002:100;
solver = @myode4;
nsol = 10;
familyName = 'families\p=1+0.5sin(2 pi x)\l2=1.1\';
doSolveAll(@doSolveAllCore,preyDiffusionCoeff,...
  secondPredatorDiffusionCoeff,firstPredatorMortality,resourceDeviation,...
  N,tspan,solver,nsol,familyName);
end

