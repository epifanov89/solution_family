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
    '���� � �������������� ������������ ������� �� ����������.');
end

loadedVars = loadVars(intermediateSolutionFilepath,'wpoincareend',...
  'minpreypt','T');

[rightPartsOfEquations,linearizedSystem,~,nprey,npredator,X,tstep] = ...
  getParams();

N = length(X);
nspecies = nprey+npredator;
nvar = N*nspecies;

% ������ ������� ����� ���������
centerPointIndex = fix((N+1)/2);

% ������� ����������, ���������� ���������� ��������� � �������
% ����� ������
preyCenterPointVarIndex = centerPointIndex;
firstPredatorCenterPointVarIndex = N+centerPointIndex;

% ������ ���������� ����������� ��������� ��� ������� ����������
firstPhasVarIndex = preyCenterPointVarIndex;
secondPhasVarIndex = firstPredatorCenterPointVarIndex;

% ����� ����������, ������� ���������� � ��������� ������� ���������
% ����������� ��������
fixedVarIndex = preyCenterPointVarIndex;
% �������� ���� ���������� � ��������� 
% ������� ��������� ����������� ��������
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
  print('���������� ���������������� ��������� �� %d ������\n\n',...
    round(computationTime));
  
  print('���������������:\n\n');
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

