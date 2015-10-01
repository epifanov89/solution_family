function doFindAndSavePointWithMaxPredatorDensitiesCore(...
  resultsFilename,secondPredatorDiffusionCoeff,...
  getFilename,getFileDir,getDirpath,getResultsFilepath,exists,...
  loadVars,saveVars,...
  getParams,fig,solver,getFirstPointWithExtremeVarValues)

filename = getFilename('fullpath');
curFileDir = getFileDir(filename);

intermediateResultsDirpath = getDirpath(curFileDir,...
  'intermediate_results\\');
intermediateResultsFilepath = getResultsFilepath(...
  intermediateResultsDirpath,resultsFilename);
finalResultsDirpath = getDirpath(curFileDir,'final_results\\');
finalResultsFilepath = getResultsFilepath(finalResultsDirpath,...
  resultsFilename);

if ~exists(intermediateResultsFilepath,'file')
  error('doFindAndSavePointWithMaxPredatorDensitiesCore:IntermediateSolutionFileMustExist',...
    'Файл с промежуточными результатами решения не существует');
end

intermediateLoadedVars = loadVars(intermediateResultsFilepath,'w0','T');
[rightPartsOfEquations,~,~,nprey,npredator,X,tstep] = getParams(secondPredatorDiffusionCoeff);

N = length(X);
nspecies = nprey+npredator;
nvar = N*nspecies;

% Индекс средней точки разбиения
centerPointIndex = fix((N+2)/2);

% Индексы переменных, отвечающих плотностям популяций в средней
% точке ареала
preyCenterPointVarIndex = centerPointIndex;
firstPredatorCenterPointVarIndex = N+centerPointIndex;
secondPredatorCenterPointVarIndex = 2*N+centerPointIndex;

% Номера переменных проективной плоскости для фазовых траекторий
firstPhasVarIndex = preyCenterPointVarIndex;

w0 = intermediateLoadedVars.w0;

isFirstPredatorZero = true;
for varIndex = 1:N
  if w0(N+varIndex)>0
    isFirstPredatorZero = false;
  end
end

if ~isFirstPredatorZero
  secondPhasVarIndex = firstPredatorCenterPointVarIndex;
else
  secondPhasVarIndex = secondPredatorCenterPointVarIndex;
end

% Решаем систему на времени, кратном предполагаемому периоду, 
% для построения графика семейства
fig();
[~,w] = solver(rightPartsOfEquations,0:tstep:intermediateLoadedVars.T,...
               w0,...
               odeset('NonNegative',1:nvar,'OutputFcn',@odephas2,...
                      'OutputSel',[firstPhasVarIndex,secondPhasVarIndex]));

varsToSave = struct;
varsToSave.maxPredatorDensitiesPoint = getFirstPointWithExtremeVarValues(w,...
  [firstPredatorCenterPointVarIndex,...
   secondPredatorCenterPointVarIndex],'max');
 
if exists(finalResultsFilepath,'file')
  saveVars(finalResultsFilepath,varsToSave,true);
else
  saveVars(finalResultsFilepath,varsToSave,false);
end

end

