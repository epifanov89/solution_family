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
    '���� � �������������� ������������ ������� �� ����������');
end

intermediateLoadedVars = loadVars(intermediateResultsFilepath,'w0','T');
[rightPartsOfEquations,~,~,nprey,npredator,X,tstep] = getParams(secondPredatorDiffusionCoeff);

N = length(X);
nspecies = nprey+npredator;
nvar = N*nspecies;

% ������ ������� ����� ���������
centerPointIndex = fix((N+2)/2);

% ������� ����������, ���������� ���������� ��������� � �������
% ����� ������
preyCenterPointVarIndex = centerPointIndex;
firstPredatorCenterPointVarIndex = N+centerPointIndex;
secondPredatorCenterPointVarIndex = 2*N+centerPointIndex;

% ������ ���������� ����������� ��������� ��� ������� ����������
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

% ������ ������� �� �������, ������� ��������������� �������, 
% ��� ���������� ������� ���������
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

