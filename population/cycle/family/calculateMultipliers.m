function calculateMultipliers()

resultsFilename = 'families\p=1+0.5sin(2 pi x)\l2=1.1\1.mat';
preyDiffusionCoeff = 0.2;
secondPredatorDiffusionCoeff = 0.24;
firstPredatorMortality = 1.1;
resourceDeviation = 0.5;
solver = @myode4;

doCalculateMultipliers(@doCalculateMultipliersCore,resultsFilename,...
  preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
  firstPredatorMortality,resourceDeviation,solver);
end

