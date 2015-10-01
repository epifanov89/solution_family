function doSolveAllCore( preyDiffusionCoeff,...
  secondPredatorDiffusionCoeff,firstPredatorMortality,resourceDeviation,...
  N,tspan,solver,nsol,familyName,currentDirName,exist,solveOne )

curDirName = currentDirName();
solutionResultsDirname = strcat(curDirName,'solution_results\');

solno = 0;
checkAndSolve(solno,@getZeroFirstPredatorInitialData);

for solno = 1:nsol
  checkAndSolve(solno,@(~) getCombinedPredatorDensitiesInitialData(...
    strcat(familyName,'0.mat'),nsol,solno));
end

  function checkAndSolve(solno,getInitialData)
    filename = sprintf('%s%d.mat',familyName,solno);
    if ~exist(strcat(solutionResultsDirname,filename),'file')
      solveOne(filename,preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
        firstPredatorMortality,resourceDeviation,N,tspan,...
        getInitialData,solver);    
    end
  end

end

