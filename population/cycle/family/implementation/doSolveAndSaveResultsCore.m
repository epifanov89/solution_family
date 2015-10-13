function doSolveAndSaveResultsCore( solno,tf,getFilename,getFileDir,...
  getResultsFilepath,exists,getZeroFirstPredatorInitialData,...
  getCombinedPredatorDensitiesInitialData,loadVars,saveVars,...
  getSystemParams,solver,getLastRow,getPeriod )
%DOSOLVEANDSAVERESULTSCORE Summary of this function goes here
%   Detailed explanation goes here

[rightPartsOfEquations,~,nprey,npredator,X,tstep] = getSystemParams();

h = X(2)-X(1);
L = X(end)-X(1)+h;
N = length(X);
nspecies = nprey+npredator;
nvar = N*nspecies;

filename = getFilename('fullpath');
curFileDir = getFileDir(filename);

intermediateSolutionFilepath = getResultsFilepath(...
  curFileDir,'intermediate_solutions\\',sprintf('family_%d.mat',solno));
finalSolutionFilepath = getResultsFilepath(...
  curFileDir,'final_solutions\\',sprintf('family_%d.mat',solno));

if exists(intermediateSolutionFilepath,'file')
  loaded = loadVars(intermediateSolutionFilepath,'w0');
  w0 = loaded.w0;
elseif solno == 0
  w0 = getZeroFirstPredatorInitialData(L,N);
else
  w0 = getCombinedPredatorDensitiesInitialData(...
    curFileDir,getResultsFilepath,exists,loadVars,solno,10);
end

% »ндекс средней точки разбиени€
centerPointIndex = fix((N+1)/2);

% »ндекс переменной, отвечающей плотности попул€ции жертвы в средней
% точке ареала
preyCenterPointVarIndex = centerPointIndex;

% Ќомера переменных проективной плоскости дл€ фазовых траекторий
firstPhasVarIndex = preyCenterPointVarIndex;
if solno == 0
  secondPhasVarIndex = 2*N+centerPointIndex;
else
  secondPhasVarIndex = N+centerPointIndex;
end

% Ќомер переменной, котора€ фигурирует в уравнении секущей плоскости
% отображени€ ѕуанкаре
fixedVarIndex = preyCenterPointVarIndex;
% «начение этой переменной в уравнении 
% секущей плоскости отображени€ ѕуанкаре
fixedVarValue = 0.5;

% —начала просто решаем систему до некоторого момента времени
[~,w,tpoincare,~] = ...
    solver(rightPartsOfEquations,0:tstep:tf,w0,...
           odeset('NonNegative',1:nvar,...
                  'OutputFcn',@odephas2,...
                  'OutputSel',[firstPhasVarIndex,secondPhasVarIndex]),...
           fixedVarIndex,fixedVarValue);

w0 = getLastRow(w);
saveVars(intermediateSolutionFilepath,'w0');

if length(tpoincare) >= 3
  % Ќаходим разницу между последними двум€ временами пересечени€ 
  % секущей плоскости отображени€ ѕуанкаре 
  % (дл€ периодического решени€ это будет период)
  T = getPeriod(tpoincare);
  saveVars(finalSolutionFilepath,'T');
end

end

