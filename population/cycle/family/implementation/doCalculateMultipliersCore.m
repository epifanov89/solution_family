function doCalculateMultipliersCore( resultsFilename,preyDiffusionCoeff,...
  secondPredatorDiffusionCoeff,firstPredatorMortality,resourceDeviation,...
  mfilename,getFileDirname,getResultsFilenameForMFile,exists,loadVars,...
  makeDir,saveVars,getPoincareMapLastPoint,getPeriod,getParams,...
  calculateMultipliers,solver,print,dispVal )

filename = mfilename('fullpath');
curFileDir = getFileDirname(filename);

solutionResultsFilename = strcat(curFileDir,...
  'solution_results\',resultsFilename);

loadedVars = loadVars(solutionResultsFilename,'t','w');
w = loadedVars.w;
sz = size(w);

nspecies = 3;
N = sz(2)/nspecies;

% ������ ������� ����� ���������
centerPointIndex = fix((N+2)/2);

% ������� ����������, ���������� ���������� ��������� � �������
% ����� ������
preyCenterPointVarIndex = centerPointIndex;
firstPredatorCenterPointVarIndex = N+centerPointIndex;
secondPredatorCenterPointVarIndex = 2*N+centerPointIndex;

% ����� ����������, ������� ���������� � ��������� ������� ���������
% ����������� ��������
fixedVarIndex = preyCenterPointVarIndex;
% �������� ���� ���������� � ��������� 
% ������� ��������� ����������� ��������
fixedVarValue = 0.5;

[rightPartsOfEquations,linearizedSystem,~,~,~,tstep] = getParams(...
  preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
  firstPredatorMortality,resourceDeviation,N);

nvar = N*nspecies;

% ������ ���������� ����������� ��������� ��� ������� ����������
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

intermediateMonodromyMatrixFilename = getResultsFilenameForMFile(...
  filename,'monodromy_matrix');

[multipliers,computationTime] = calculateMultipliers(...
    rightPartsOfEquations,linearizedSystem,solver,0:tstep:tf,...
    poincareMapLastPoint,nvar,intermediateMonodromyMatrixFilename,...
    fixedVarIndex,fixedVarValue,odeset('NonNegative',1:nvar),...
    odeset('OutputFcn',@odephas2,...
           'OutputSel',[firstPhasVarIndex,secondPhasVarIndex]));

if ~isempty(multipliers)
  print('���������� ���������������� ��������� �� %d ������\n\n',...
    round(computationTime));
  
  print('���������������:\n\n');
  for multiplierIndex = 1:length(multipliers)
    dispVal(multipliers(multiplierIndex));
  end
  
  multipliersDirname = strcat(curFileDir,'multipliers\');    
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

