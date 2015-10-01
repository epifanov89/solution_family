function solve()

preyDiffusionCoeff = 0.2;
secondPredatorDiffusionCoeff = 0.12;
firstPredatorMortality = 1.1;
resourceDeviation = 0.5;
N = 24;
tspan = 0:0.002:100;
getInitialData = @getZeroSecondPredatorInitialData;
solver = @myode4;
solutionResultsFilename = ...
  'families\p=1+0.5sin(2 pi x)\l2=1.1\zeroSecondPredator.mat';

solveOne(solutionResultsFilename,preyDiffusionCoeff,...
  secondPredatorDiffusionCoeff,firstPredatorMortality,resourceDeviation,...
  N,tspan,getInitialData,solver);
end

