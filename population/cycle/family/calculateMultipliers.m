function calculateMultipliers()

resultsFilename = 'families\p=1+0.5sin(2 pi x)\l2=1.2\10.mat';
preyDiffusionCoeff = 0.2;
secondPredatorDiffusionCoeff = 0.24;
firstPredatorMortality = 1.2;
resourceDeviation = 0.5;

doCalculateMultipliers(@doCalculateMultipliersCore,resultsFilename,...
  preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
  firstPredatorMortality,resourceDeviation);
end

