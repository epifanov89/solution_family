function doCalculateMultipliersCore( resultsFilename,preyDiffusionCoeff,...
  secondPredatorDiffusionCoeff,firstPredatorMortality,resourceDeviation,...
  mfilename,getFileDirname,exists,loadVars,makeDir,saveVars,...
  getPoincareMapLastPoint,getPeriod,getParams,calculateMultipliers,...
  solver,print,dispVal )

filename = mfilename('fullpath');
parentDirName = getFileDirname(filename);

solutionResultsFilename = strcat(parentDirName,...
  'solution_results\',resultsFilename);

loadedVars = loadVars(solutionResultsFilename,'t','w');
w = loadedVars.w;
sz = size(w);

nspecies = 3;
N = sz(2)/nspecies;

% Индекс средней точки разбиения
centerPointIndex = fix((N+2)/2);

% Индексы переменных, отвечающих плотностям популяций в средней
% точке ареала
preyCenterPointVarIndex = centerPointIndex;
firstPredatorCenterPointVarIndex = N+centerPointIndex;
secondPredatorCenterPointVarIndex = 2*N+centerPointIndex;

% Номер переменной, которая фигурирует в уравнении секущей плоскости
% отображения Пуанкаре
fixedVarIndex = preyCenterPointVarIndex;
% Значение этой переменной в уравнении 
% секущей плоскости отображения Пуанкаре
fixedVarValue = 0.5;

[rightPartsOfEquations,linearizedSystem,~,~,~,tstep] = getParams(...
  preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
  firstPredatorMortality,resourceDeviation,N);

nvar = N*nspecies;

% Номера переменных проективной плоскости для фазовых траекторий
firstPhasVarIndex = preyCenterPointVarIndex;

poincareMapLastPoint = getPoincareMapLastPoint(w,fixedVarIndex,...
  fixedVarValue);

isFirstPredatorZero = true;
for varIndex = 1:N
  if poincareMapLastPoint(N+varIndex) > 0
    isFirstPredatorZero = false;
  end
end

if ~isFirstPredatorZero
  secondPhasVarIndex = firstPredatorCenterPointVarIndex;
else  
  secondPhasVarIndex = secondPredatorCenterPointVarIndex;
end

period = getPeriod(loadedVars.t,w,fixedVarIndex,fixedVarValue);
tf = 2*period;

intermediateMonodromyMatrixFilename = strcat(parentDirName,...
  'monodromy_matrix\',resultsFilename);

[multipliers,computationTime] = calculateMultipliers(...
    rightPartsOfEquations,linearizedSystem,solver,0:tstep:tf,...
    poincareMapLastPoint,nvar,intermediateMonodromyMatrixFilename,...
    fixedVarIndex,fixedVarValue,odeset('NonNegative',1:nvar),...
    odeset('OutputFcn',@odephas2,...
           'OutputSel',[firstPhasVarIndex,secondPhasVarIndex]));

if ~isempty(multipliers)
  print('Вычисление мультипликаторов завершено за %d секунд\n\n',...
    round(computationTime));
  
  print('Мультипликаторы:\n\n');
  for multiplierIndex = 1:length(multipliers)
    dispVal(multipliers(multiplierIndex));
  end
  
  multipliersDirname = strcat(parentDirName,'multipliers\');    
  if ~exists(multipliersDirname)
    makeDir(multipliersDirname);
  end
  
  multipliersFilename = strcat(multipliersDirname,resultsFilename);
  
  varsToSave = struct;
  varsToSave.multipliers = multipliers;
  varsToSave.computationTime = computationTime;
  saveVars(multipliersFilename,varsToSave);
  
  print('\n');
end
end

