function doSolveAllCore( preyDiffusionCoeff,firstPredatorMortality,...
  resourceDeviation,N,tspan,solver,nsol,famName,currentDirName,dir,...
  solveOne )

curDirName = currentDirName();
solutionResultsDirname = strcat(curDirName,'solution_results\');
famDirname = strcat('families\',famName);
listing = dir(strcat(solutionResultsDirname,famDirname,'*.mat'));

wereAllSolsStarted = false;
isNoFilesInDir = isempty(listing);
if ~isNoFilesInDir
  filenames = {listing(:).name};

  % Выбираем только файлы с результатами решений семейства
  [~,matches] = regexp(filenames,'\.mat','tokens','match');
  nStandaloneSol = 2;
  wereAllSolsStarted = ...
    (length(getArrayIndices(@(m) ~isempty(m),matches)) == ...
      nsol+nStandaloneSol+1);
end

getInitialData = @getZeroFirstPredatorInitialData;

if wereAllSolsStarted
  solNo = 0;
  filename = getFamSolFilename(solNo);
  isStopped = findFamSol(filename,getInitialData);
    
  while solNo < nsol && ~isStopped
    solNo = solNo+1;
    filename = getFamSolFilename(solNo);
    getInitialData = @(~) getCombinedPredatorDensitiesInitialData(...
      strcat(famDirname,'0.mat'),nsol,solNo);
    isStopped = findFamSol(filename,getInitialData);
  end
  
  if ~isStopped
    filename = getSolFilename('zeroFirstPredator.mat');
    getInitialData = @getZeroFirstPredatorInitialData;
    findZeroOnePredatorSol(filename,getInitialData);
  end
  
  if ~isStopped
    filename = getSolFilename('zeroSecondPredator.mat');
    getInitialData = @getZeroSecondPredatorInitialData;
    findZeroOnePredatorSol(filename,getInitialData);
  end
else
  solNo = 0;
  isStopped = checkAndFindFamSol(solNo,getInitialData);
  
  while solNo < nsol && ~isStopped
    solNo = solNo+1;
    getInitialData = @(~) getCombinedPredatorDensitiesInitialData(...
      strcat(famDirname,'0.mat'),nsol,solNo);
    isStopped = checkAndFindFamSol(solNo,getInitialData);
  end
  
  if ~isStopped
    getInitialData = @getZeroFirstPredatorInitialData;
    filename = getSolFilename('zeroFirstPredator.mat');
    isStopped = checkAndSolve(@findZeroOnePredatorSol,filename,...
      getInitialData);
  end
  
  if ~isStopped
    getInitialData = @getZeroSecondPredatorInitialData;
    filename = getSolFilename('zeroSecondPredator.mat');
    checkAndSolve(@findZeroOnePredatorSol,filename,getInitialData);
  end
end

  function isStopped = checkAndFindFamSol(solNo,getInitialData)    
    filename = getFamSolFilename(solNo);
    isStopped = checkAndSolve(@findFamSol,filename,getInitialData);
  end

  function isStopped = checkAndSolve(solve,filename,getInitialData)    
    isStopped = false;
    if isNoFilesInDir...
        || ~contains(@(name) ~isempty(strfind(name,filename)),filenames)
      isStopped = solve(filename,getInitialData);    
    end
  end

  function isStopped = findFamSol(filename,getInitialData)
    secondPredatorDiffusionCoeff = 0.24;
    isStopped = findSol(filename,secondPredatorDiffusionCoeff,...
      getInitialData);
  end

  function isStopped = findZeroOnePredatorSol(filename,getInitialData)
    secondPredatorDiffusionCoeff = 0.12;
    isStopped = findSol(filename,secondPredatorDiffusionCoeff,...
      getInitialData);
  end

  function isStopped = findSol(filename,secondPredatorDiffusionCoeff,...
      getInitialData)
    isStopped = solveOne(filename,preyDiffusionCoeff,...
      secondPredatorDiffusionCoeff,firstPredatorMortality,...
      resourceDeviation,N,tspan,getInitialData,solver);    
  end

  function filename = getFamSolFilename(solNo)    
    filename = getSolFilename(sprintf('%d.mat',solNo));
  end

  function filename = getSolFilename(filename)
    filename = strcat(famDirname,filename);
  end

end

