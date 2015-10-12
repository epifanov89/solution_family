function solve()

preyDiffusionCoeff = 0.2;
secondPredatorDiffusionCoeff = 0.12;
firstPredatorMortality = 1.2;
resourceVariation = 0.5;
N = 24;
tspan = [0,2000];
getInitialData = @getZeroFirstPredatorInitialData;
solver = @ode15s;
solutionResultsFilename = sprintf(...
  'families\\p=1+%.1fsin(2 pi x)\\l2=%.1f\\zeroFirstPredator.mat',...
  resourceVariation,firstPredatorMortality);

solveOne(solutionResultsFilename,preyDiffusionCoeff,...
  secondPredatorDiffusionCoeff,firstPredatorMortality,resourceVariation,...
  N,tspan,getInitialData,solver);
end

