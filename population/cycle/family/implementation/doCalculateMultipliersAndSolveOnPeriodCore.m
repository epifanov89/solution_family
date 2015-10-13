function doCalculateMultipliersAndSolveOnPeriodCore(solno,getFilename,...
  getFileDir,getResultsFilepathForMFileAtPath,getResultsFilepath,...
  exists,loadVars,saveVars,getParams,calculateMultipliers,solver,...
  fig,print,display )

filename = getFilename('fullpath');
curFileDir = getFileDir(filename);

intermediateSolutionFilepath = getResultsFilepath(...
  curFileDir,'intermediate_solutions\\',strcat('tillsteady',char('A'+solno-1),'.mat'));

if ~exists(intermediateSolutionFilepath)
  error('doCalculateMultipliersAndSolveOnPeriodCore:FileMustExist',...
    'Файл с промежуточными результатами решения не существует.');
end

loadedVars = loadVars(intermediateSolutionFilepath,'wpoincareend',...
  'minpreypt','T');

[rightPartsOfEquations,linearizedSystem,~,nprey,npredator,X,tstep] = ...
  getParams();

N = length(X);
nspecies = nprey+npredator;
nvar = N*nspecies;

% Индекс средней точки разбиения
centerPointIndex = fix((N+1)/2);

% Индексы переменных, отвечающих плотностям популяций в средней
% точке ареала
preyCenterPointVarIndex = centerPointIndex;
firstPredatorCenterPointVarIndex = N+centerPointIndex;

% Номера переменных проективной плоскости для фазовых траекторий
firstPhasVarIndex = preyCenterPointVarIndex;
secondPhasVarIndex = firstPredatorCenterPointVarIndex;

% Номер переменной, которая фигурирует в уравнении секущей плоскости
% отображения Пуанкаре
fixedVarIndex = preyCenterPointVarIndex;
% Значение этой переменной в уравнении 
% секущей плоскости отображения Пуанкаре
fixedVarValue = 0.5;

intermediateMonodromyMatrixFilepath = getResultsFilepathForMFileAtPath(...
  filename,'intermediate_monodromy_matrix');

T = loadedVars.T;

tf = 2*T;

[multipliers,computationTime] = calculateMultipliers(...
    rightPartsOfEquations,linearizedSystem,solver,0:tstep:tf,...
    loadedVars.wpoincareend,nvar,intermediateMonodromyMatrixFilepath,...
    fixedVarIndex,fixedVarValue,odeset('NonNegative',1:nvar),...
    odeset('OutputFcn',@odephas2,...
           'OutputSel',[firstPhasVarIndex,secondPhasVarIndex]));

if ~isempty(multipliers)
  print('Вычисление мультипликаторов завершено за %d секунд\n\n',...
    round(computationTime));
  
  print('Мультипликаторы:\n\n');
  for multiplierIndex = 1:length(multipliers)
    display(multipliers(multiplierIndex));
  end
  
  multipliersFilepath = getResultsFilepath(curFileDir,'multipliers\\',...
    strcat('tillsteady',char('A'+solno-1),'.mat'));
  
  saveVars(multipliersFilepath,'multipliers','computationTime');
  
  print('\n');
  
  fig();
  [~,w] = solver(rightPartsOfEquations,0:tstep:T,...
                 loadedVars.minpreypt,...
                 odeset('NonNegative',1:nvar,...
                        'OutputFcn',@odephas2,...
                        'OutputSel',[firstPhasVarIndex,...
                                     secondPhasVarIndex]));
                
  finalSolutionFilepath = getResultsFilepath(...
    curFileDir,'final_solutions\\',strcat('tillsteady',char('A'+solno-1),'.mat'));

  saveVars(finalSolutionFilepath,'w');
end
end

