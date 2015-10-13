function doSolveAllCore( preyDiffusionCoeff,...
  secondPredatorDiffusionCoeff,firstPredatorMortality,resourceDeviation,...
  N,tspan,solver,nsol,famName,currentDirName,dir,solveOne )

curDirName = currentDirName();
solutionResultsDirname = strcat(curDirName,'solution_results\');
famDirname = strcat('families\',famName);
listing = dir(strcat(solutionResultsDirname,famDirname,'*.mat'));
filenames = {listing(:).name};

% Выбираем только файлы с результатами решений семейства
[~,matches] = regexp(filenames,'(\d+).mat','tokens','match');

getInitialData = @getZeroFirstPredatorInitialData;

if length(getArrayIndices(@(m) ~isempty(m),matches)) == nsol+1  
  filename = sprintf('%s0.mat',famDirname);
  solone();
  
  for solno = 1:nsol
    filename = sprintf('%s%d.mat',famDirname,solno);
    getInitialData = @(~) getCombinedPredatorDensitiesInitialData(...
      strcat(famDirname,'0.mat',nsol,solno));
    solone();
  end
else
  solno = 0;
  checkAndSolve();
  
  for solno = 1:nsol
    getInitialData = @(~) getCombinedPredatorDensitiesInitialData(...
      strcat(famDirname,'0.mat'),nsol,solno);
    checkAndSolve();
  end
end

  function checkAndSolve()
    filename = sprintf('%s%d.mat',famDirname,solno);
    if ~contains(@(m) ~isempty(m)...
        && strcmp(m{1},sprintf('%d.mat',solno)),matches)
      solone();    
    end
  end

  function solone()
    solveOne(filename,preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
      firstPredatorMortality,resourceDeviation,N,tspan,...
      getInitialData,solver);    
  end

end

