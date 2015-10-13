function ic = doGetCombinedPredatorDensitiesInitialDataCore(...
  zeroFirstPredatorSolutionResultsFilename,nsol,solno,currentDirName,...
  loadVars,getLastRowWithExtremeElementValue )

curFileDir = currentDirName();
zeroFirstPredatorSolutionFilepath = strcat(curFileDir,...
  'solution_results\',zeroFirstPredatorSolutionResultsFilename);

loadedVars = loadVars(zeroFirstPredatorSolutionFilepath,'w');

nprey = 1;
npredator = 2;
nspecies = nprey+npredator;

sz = size(loadedVars.w);
nvar = sz(2);

N = nvar/nspecies;

centerPointIndex = fix((N+2)/2);
secondPredatorCenterPointVarIndex = 2*N+centerPointIndex;

lastMaxPredatorsPoint = getLastRowWithExtremeElementValue(loadedVars.w,...
  secondPredatorCenterPointVarIndex,'max');

ic = zeros(1,nvar);

for pt = 1:N
  ic(1,pt) = lastMaxPredatorsPoint(1,pt);
  ic(1,N+pt) = solno*lastMaxPredatorsPoint(1,2*N+pt)/nsol;
  ic(1,2*N+pt) = (nsol-solno)*lastMaxPredatorsPoint(1,2*N+pt)/nsol;
end

end

