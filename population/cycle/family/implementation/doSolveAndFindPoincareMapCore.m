function doSolveAndFindPoincareMapCore( solutionResultsFilename,...
  preyDiffusionCoeff,secondPredatorDiffusionCoeff,resourceDeviation,...
  N,tf,getInitialData,currentDirName,exists,loadVars,makeDir,saveVars,...
  getParams,solver )

[rightPartsOfEquations,~,~,nprey,npredator,tstep] = ...
  getParams(preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
    resourceDeviation,N);

curFileDir = currentDirName();

solutionResultsDirpath = strcat(curFileDir,'solution_results\');
solutionResultsFilepath = strcat(solutionResultsDirpath,...
  solutionResultsFilename);

if exists(solutionResultsFilepath,'file')
  loaded = loadVars(solutionResultsFilepath,'w');
  w = loaded.w;
  w0 = w(end,:);
else
  a = 1;
  h = a/N;
  w0 = getInitialData(N,h);
  w = [];
end

% ������ ������� ����� ���������
centerPointIndex = fix((N+2)/2);

% ������� ����������, ���������� ���������� ��������� � �������
% ����� ������
preyCenterPointVarIndex = centerPointIndex;
firstPredatorCenterPointVarIndex = N+centerPointIndex;
secondPredatorCenterPointVarIndex = 2*N+centerPointIndex;

% ������ ���������� ����������� ��������� ��� ������� ����������
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

% ����� ����������, ������� ���������� � ��������� ������� ���������
% ����������� ��������
fixedVarIndex = preyCenterPointVarIndex;
% �������� ���� ���������� � ��������� 
% ������� ��������� ����������� ��������
fixedVarValue = 0.5;

nspecies = nprey+npredator;
nvar = N*nspecies;
% ������� ������ ������ ������� �� ���������� ������� �������
[~,sol,tpoincare,wpoincare] = ...
    solver(rightPartsOfEquations,0:tstep:tf,w0,...
           odeset('NonNegative',1:nvar,...
                  'OutputFcn',@odephas2,...
                  'OutputSel',[firstPhasVarIndex,secondPhasVarIndex]),...
           fixedVarIndex,fixedVarValue);
         
varsToSave = struct;
varsToSave.w = [w;sol];
varsToSave.wpoincareend = wpoincare(end,:);

if length(tpoincare) >= 3 
  varsToSave.T = tpoincare(end)-tpoincare(end-2);    
end

makeDir(solutionResultsDirpath);
saveVars(solutionResultsFilepath,varsToSave);
end

