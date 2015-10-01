function calculateMultipliers()

resultsFilename = 'blablabla.mat';
preyDiffusionCoeff = 0.2;
secondPredatorDiffusionCoeff = 0.24;
firstPredatorMortality = 1;
resourceDeviation = 0.2;

doCalculateMultipliers(@doCalculateMultipliersCore,resultsFilename,...
  preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
  firstPredatorMortality,resourceDeviation);
end

