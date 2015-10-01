function getInitialDataSolveAndSaveResults( getFilename,getFileDir,...
  concat,fileExists,getZeroFirstPredatorInitialData,loadVars,...
  solveAndSaveResults )
%GETINITIALDATASOLVEANDSAVERESULTS Summary of this function goes here
%   Detailed explanation goes here

% Номер решения на семействе
solno = 4;

filename = getFilename('fullpath');
curFileDir = getFileDir(filename);

intermediateSolutionsFilename = concat(curFileDir,sprintf('intermediate_solutions\\family_%d.mat',solno));

finalSolutionsFilename = concat(curFileDir,sprintf('final_solutions\\family_%d.mat',solno));

if fileExists(intermediateSolutionsFilename)
  loadVars(intermediateSolutionsFilename,'w0');
else
  w0 = getZeroFirstPredatorInitialData();
end

solveAndSaveResults(@myode4,w0,@save,@predator_prey_2x1_params,...
  @getLastRow,@getPeriod,...
  intermediateSolutionsFilename,finalSolutionsFilename);

end

