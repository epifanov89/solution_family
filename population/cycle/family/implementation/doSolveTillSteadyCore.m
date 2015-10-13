function doSolveTillSteadyCore( solno,tf,getFilename,getFileDir,...
  exists,getInitialDataToSolveTillSteady,loadVars,makeDir,saveVars,...  
  getParams,solver,getFirstPointWithExtremeVarValues,getLastRow,...
  getPeriod,getDirpath,getResultsFilepath,getSolutionTillMaxPredatorDensities )

[rightPartsOfEquations,~,~,nprey,npredator,X,tstep] = getParams();

filename = getFilename('fullpath');
curFileDir = getFileDir(filename);

intermediateSolutionsDirpath = getDirpath(curFileDir,...
  'intermediate_solutions\\');
intermediateSolutionFilepath = getResultsFilepath(...
  intermediateSolutionsDirpath,...
  strcat('tillsteady',char('A'+solno-1),'.mat'));

doesIntermediateSolutionExist = false;

N = length(X);

if exists(intermediateSolutionFilepath,'file')
  doesIntermediateSolutionExist = true;
  loaded = loadVars(intermediateSolutionFilepath,'w0');
  w0 = loaded.w0;
else  
  h = X(2)-X(1);
  w0 = getInitialDataToSolveTillSteady(solno,N,h);
end

% »ндекс средней точки разбиени€
centerPointIndex = fix((N+2)/2);

% »ндексы переменных, отвечающих плотност€м попул€ций в средней
% точке ареала
preyCenterPointVarIndex = centerPointIndex;
firstPredatorCenterPointVarIndex = N+centerPointIndex;

% Ќомера переменных проективной плоскости дл€ фазовых траекторий
firstPhasVarIndex = preyCenterPointVarIndex;
secondPhasVarIndex = firstPredatorCenterPointVarIndex;

% Ќомер переменной, котора€ фигурирует в уравнении секущей плоскости
% отображени€ ѕуанкаре
fixedVarIndex = preyCenterPointVarIndex;
% «начение этой переменной в уравнении 
% секущей плоскости отображени€ ѕуанкаре
fixedVarValue = 0.5;

nspecies = nprey+npredator;
nvar = N*nspecies;
% —начала просто решаем систему до некоторого момента времени
[~,w,tpoincare,~] = ...
    solver(rightPartsOfEquations,0:tstep:tf,w0,...
           odeset('NonNegative',1:nvar,...
                  'OutputFcn',@odephas2,...
                  'OutputSel',[firstPhasVarIndex,secondPhasVarIndex]),...
           fixedVarIndex,fixedVarValue);

makeDir(intermediateSolutionsDirpath);
         
w0 = getLastRow(w);
saveVars(intermediateSolutionFilepath,'w0');

minpreypt = getFirstPointWithExtremeVarValues(w,preyCenterPointVarIndex,'min');
saveVars(intermediateSolutionFilepath,'minpreypt');

if length(tpoincare) >= 3
  % Ќаходим разницу между последними двум€ временами пересечени€ 
  % секущей плоскости отображени€ ѕуанкаре 
  % (дл€ периодического решени€ это будет период)
  T = getPeriod(tpoincare);
  saveVars(intermediateSolutionFilepath,'T');
end

if ~doesIntermediateSolutionExist
  finalSolutionsDirpath = getDirpath(curFileDir,'final_solutions\\');
  finalSolutionFilepath = getResultsFilepath(finalSolutionsDirpath,...
    strcat('tillsteady',char('A'+solno-1),'.mat'));

  makeDir(finalSolutionsDirpath);
  
  w = getSolutionTillMaxPredatorDensities(w);
  saveVars(finalSolutionFilepath,'w');
end
end

