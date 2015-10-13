function doSolveOneCore( solutionResultsFilename,preyDiffusionCoeff,...
  secondPredatorDiffusionCoeff,firstPredatorMortality,...
  resourceDeviation,N,tspan,getInitialData,getFilename,getFileDirname,...
  exists,loadVars,makeDir,saveVars,getParams,solver )

[rightPartsOfEquations,~,~,nprey,npredator] = getParams(...
  preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
  firstPredatorMortality,resourceDeviation,N);

filename = getFilename('fullpath');
curFileDir = getFileDirname(filename);

solutionResultsDirpath = strcat(curFileDir,'solution_results\');
solutionResultsFilepath = strcat(solutionResultsDirpath,...
  solutionResultsFilename);

if exists(solutionResultsFilepath,'file')
  loaded = loadVars(solutionResultsFilepath,'t','w');
  t = loaded.t;
  w = loaded.w;
  w0 = w(end,:);
else
  w0 = getInitialData(N);
  t = [];
  w = [];  
end

% Индекс средней точки разбиения
centerPointIndex = fix((N+2)/2);

% Индексы переменных, отвечающих плотностям популяций в средней
% точке ареала
preyCenterPointVarIndex = centerPointIndex;
firstPredatorCenterPointVarIndex = N+centerPointIndex;
secondPredatorCenterPointVarIndex = 2*N+centerPointIndex;

% Номера переменных проективной плоскости для фазовых траекторий
firstPhasVarIndex = preyCenterPointVarIndex;

isFirstPredatorZero = true;
for varIndex = 1:N
  if w0(N+varIndex) > 0
    isFirstPredatorZero = false;
  end
end

if ~isFirstPredatorZero
  secondPhasVarIndex = firstPredatorCenterPointVarIndex;
else  
  secondPhasVarIndex = secondPredatorCenterPointVarIndex;
end

nspecies = nprey+npredator;
nvar = N*nspecies;

[tsol,sol] = solver(rightPartsOfEquations,tspan,w0,...
  odeset('NonNegative',1:nvar,'OutputFcn',@odephas2,...
    'OutputSel',[firstPhasVarIndex,secondPhasVarIndex],...
    'RelTol',1e-6,'AbsTol',1e-9));
         
varsToSave = struct;
varsToSave.w = [w;sol];
varsToSave.t = [t;tsol];

if ~exists(solutionResultsDirpath,'dir')
  makeDir(solutionResultsDirpath);
end
saveVars(solutionResultsFilepath,varsToSave);
end

