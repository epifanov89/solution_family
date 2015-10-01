function solveAndFindPoincareMap()

familyName = 'family_k1=0,2_2';
solno = 10;
solutionResultsFilename = sprintf('%s_%d.mat',familyName,solno);
preyDiffusionCoeff = 0.2;
secondPredatorDiffusionCoeff = 0.24;
resourceDeviation = 0.2;
N = 24;
tf = 100;
nsol = 10;
getInitialData = @(~,~) getCombinedPredatorDensitiesInitialData(...
  sprintf('%s_0.mat',familyName),nsol,solno);

doSolveAndFindPoincareMap(@doSolveAndFindPoincareMapCore,...
  solutionResultsFilename,preyDiffusionCoeff,...
  secondPredatorDiffusionCoeff,resourceDeviation,N,tf,getInitialData);
end

