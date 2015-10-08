function doPlotFamilyCore( getMFilename,getFileDir,...
  getDirListing,loadVars,getLastRowWithExtremeElementValue,...
  getSolutionPartForTrajectoryPlot,subplot,plot,hold,lbl,xlbl,ylbl,gca,set)
%	DOPLOTFAMILYCORE Изображает графики двух семейств с установлениями из 
% двух начальных данных
%   На графике выводятся максимальные плотности популяций хищников,
%   соединенные сплошной линией, и пунктиром установление из двух
%   начальных данных к разным режимам для двух семейств

filename = getMFilename('fullpath');
curFileDir = getFileDir(filename);
familyNameStart = 'p=1+0.5sin(2 pi x)\l2=';
family1FirstPredatorMortality = 1.1;
family1Path = sprintf('%ssolution_results\\families\\%s%.1f\\',...
  curFileDir,familyNameStart,family1FirstPredatorMortality);
listing = getDirListing(strcat(family1Path,'*.mat'));

% Отбрасываем папки
files = listing(arrayfun(@(entry) ~entry.isdir,listing));
filenames = {files(:).name};

% Выбираем только файлы с результатами решений семейства
[tokens,matches] = regexp(filenames,'(\d+).mat','tokens','match');

notAllFilesExistMsgIdent = 'plotFamily:AllFilesMustExist';
notAllFilesExistMsgString = 'Не все файлы существуют';

if isempty(find(~cellfun(@isempty,matches),1))
  error(notAllFilesExistMsgIdent,notAllFilesExistMsgString);
end

numbers = [];
for tokenIndex = 1:length(tokens)
  token = tokens{tokenIndex};
  if ~isempty(token)
    numbers = [numbers,str2double(token{1})];
  end
end

nnumber = length(numbers);

[sortedNumbers,sortedNumbersIX] = sort(numbers);
sortedMatches = cell(1,nnumber);
for sortedNumberIXIndex = 1:nnumber
  match = matches{sortedNumbersIX(sortedNumberIXIndex)};
  if ~isempty(match)
    sortedMatches{sortedNumberIXIndex} = match{1};
  end
end

if sortedNumbers(1) ~= 0
  error(notAllFilesExistMsgIdent,notAllFilesExistMsgString);
end

for numIndex = 2:length(sortedNumbers)
  if sortedNumbers(numIndex)-sortedNumbers(numIndex-1) ~= 1
    error(notAllFilesExistMsgIdent,notAllFilesExistMsgString);
  end
end

maxExtremeValueKind = 'max';

matchIndex = 1;
while isempty(sortedMatches{matchIndex})
  matchIndex = matchIndex+1;
end

match = sortedMatches{matchIndex};

loadedVars = loadVars(strcat(family1Path,match),'w');

solArr = {};

sol = loadedVars.w;

solArr = [solArr,sol];

sz = size(sol);
N = sz(2)/3;

centerPointIndex = fix((N+2)/2);

firstPredatorCenterPointVarIndex = N+centerPointIndex;
secondPredatorCenterPointVarIndex = 2*N+centerPointIndex;

[maxPredatorDensitiesPoint,maxPredatorDensitiesPointIndices] = ...
  getLastRowWithExtremeElementValue(sol,...
    secondPredatorCenterPointVarIndex,maxExtremeValueKind);
wpredatormax(1,1) = maxPredatorDensitiesPoint(N+centerPointIndex);
wpredatormax(2,1) = maxPredatorDensitiesPoint(2*N+centerPointIndex);
solNo = 2;

prevN = N;

matchIndex = matchIndex+1;

while matchIndex <= length(sortedMatches)
  match = sortedMatches{matchIndex};
  if ~isempty(match)
    loadedVars = loadVars(strcat(family1Path,match),'w');
    
    sol = loadedVars.w;
    
    solArr = [solArr,sol];
    
    sz = size(sol);
    N = sz(2)/3;

    if matchIndex > 1 && N ~= prevN
      error('plotFamily:GridsMustBeConsistent',...
        'Сетки должны быть одинаковыми');
    end
        
    [maxPredatorDensitiesPoint,maxPredatorDensitiesPointIndex] = ...
      getLastRowWithExtremeElementValue(sol,...
        firstPredatorCenterPointVarIndex,maxExtremeValueKind);
    maxPredatorDensitiesPointIndices = ...
      [maxPredatorDensitiesPointIndices,maxPredatorDensitiesPointIndex];
    wpredatormax(1,solNo) = maxPredatorDensitiesPoint(N+centerPointIndex);
    wpredatormax(2,solNo) = maxPredatorDensitiesPoint(2*N+centerPointIndex);
                  
    solNo = solNo+1;
    
    prevN = N;
  end
  matchIndex = matchIndex+1;
end

nrow = 1;
ncol = 2;

pos = 1;
h1 = subplot(nrow,ncol,pos);

familyLineSpec = 'ko-';
tillSteadyLineSpec = 'k--';
zeroOnePredatorLineSpec = 'ko';
lineWidthKey = 'LineWidth';
lineWidthVal = 2;
fontNameKey = 'FontName';
fontNameVal = 'Times';
fontSizeKey = 'FontSize';
fontSizeVal = 18;
interpreterKey = 'Interpreter';
interpreterVal = 'latex';

plot(h1,wpredatormax(1,:),wpredatormax(2,:),familyLineSpec,...
  lineWidthKey,lineWidthVal);

hold(h1,'on');

zeroFirstPredatorSolution = loadVars(strcat(family1Path,...
  'zeroFirstPredator.mat'),'w');
maxSecondPredatorDensities = getLastRowWithExtremeElementValue(...
  zeroFirstPredatorSolution.w,secondPredatorCenterPointVarIndex,...
  maxExtremeValueKind);
l3 = plot(h1,...
  maxSecondPredatorDensities(firstPredatorCenterPointVarIndex),...
  maxSecondPredatorDensities(secondPredatorCenterPointVarIndex),...
  zeroOnePredatorLineSpec,lineWidthKey,lineWidthVal);
labelWithFont(l3,'A');

zeroSecondPredatorSolution = loadVars(strcat(family1Path,...
  'zeroSecondPredator.mat'),'w');
maxFirstPredatorDensities = getLastRowWithExtremeElementValue(...
  zeroSecondPredatorSolution.w,firstPredatorCenterPointVarIndex,...
  maxExtremeValueKind);
l4 = plot(h1,...
  maxFirstPredatorDensities(firstPredatorCenterPointVarIndex),...
  maxFirstPredatorDensities(secondPredatorCenterPointVarIndex),...
  zeroOnePredatorLineSpec,lineWidthKey,lineWidthVal);
labelWithFont(l4,'B');


solNo = 2;
firstSolForTrajectoryPlot = getSolutionPartForTrajectoryPlot(...
  solArr{solNo},maxPredatorDensitiesPointIndices(solNo));

l1 = plot(h1,...
  firstSolForTrajectoryPlot(:,firstPredatorCenterPointVarIndex),...
  firstSolForTrajectoryPlot(:,secondPredatorCenterPointVarIndex),...
  tillSteadyLineSpec,lineWidthKey,lineWidthVal);
labelWithFont(l1,'C');

solNo = length(solArr)-1;
secondSolForTrajectoryPlot = getSolutionPartForTrajectoryPlot(...
  solArr{solNo},maxPredatorDensitiesPointIndices(solNo));

l2 = plot(h1,...
  secondSolForTrajectoryPlot(:,firstPredatorCenterPointVarIndex),...
  secondSolForTrajectoryPlot(:,secondPredatorCenterPointVarIndex),...
  tillSteadyLineSpec,lineWidthKey,lineWidthVal);
labelWithFont(l2,'D');

set(gca(),fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
  'XTick',[0 0.5 1],'YTick',[0 0.5 1]);

xlbl('$V$',fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
  interpreterKey,interpreterVal);
ylbl('$W$','rot',0,fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
  interpreterKey,interpreterVal);


familyFirstPredatorMortality = 1.2;
familyPath = sprintf('%ssolution_results\\families\\%s%.1f\\',...
  curFileDir,familyNameStart,familyFirstPredatorMortality);
listing = getDirListing(strcat(familyPath,'*.mat'));
filenames = {listing(:).name};

% Выбираем только файлы с результатами решений семейства
[tokens,matches] = regexp(filenames,'(\d+).mat','tokens','match');

numbers = [];
for tokenIndex = 1:length(tokens)
  token = tokens{tokenIndex};
  if ~isempty(token)
    numbers = [numbers,str2double(token{1})];
  end
end

nnumber = length(numbers);

[~,sortedNumbersIX] = sort(numbers);
sortedMatches = cell(1,nnumber);
for sortedNumberIXIndex = 1:nnumber
  match = matches{sortedNumbersIX(sortedNumberIXIndex)};
  if ~isempty(match)
    sortedMatches{sortedNumberIXIndex} = match{1};
  end
end

matchIndex = 1;
while isempty(sortedMatches{matchIndex})
  matchIndex = matchIndex+1;
end

match = sortedMatches{matchIndex};

loadedVars = loadVars(strcat(familyPath,match),'w');

solArr = {};

sol = loadedVars.w;

solArr = [solArr,sol];

[maxPredatorDensitiesPoint,maxPredatorDensitiesPointIndices] = ...
  getLastRowWithExtremeElementValue(sol,...
    secondPredatorCenterPointVarIndex,maxExtremeValueKind);
wpredatormax(1,1) = maxPredatorDensitiesPoint(N+centerPointIndex);
wpredatormax(2,1) = maxPredatorDensitiesPoint(2*N+centerPointIndex);

solNo = 2;

matchIndex = matchIndex+1;

while matchIndex <= length(sortedMatches)
  match = sortedMatches{matchIndex};
  if ~isempty(match)
    loadedVars = loadVars(strcat(familyPath,match),'w');
    
    sol = loadedVars.w;    
     
    solArr = [solArr,sol];
    
    [maxPredatorDensitiesPoint,maxPredatorDensitiesPointIndex] = ...
      getLastRowWithExtremeElementValue(sol,...
        firstPredatorCenterPointVarIndex,maxExtremeValueKind);
    maxPredatorDensitiesPointIndices = ...
      [maxPredatorDensitiesPointIndices,maxPredatorDensitiesPointIndex];
    wpredatormax(1,solNo) = maxPredatorDensitiesPoint(N+centerPointIndex);
    wpredatormax(2,solNo) = maxPredatorDensitiesPoint(...
      2*N+centerPointIndex);
    
    solNo = solNo+1;
  end
  matchIndex = matchIndex+1;
end

pos = 2;
h = subplot(nrow,ncol,pos);

plot(h,wpredatormax(1,:),wpredatormax(2,:),familyLineSpec,...
  lineWidthKey,lineWidthVal);

hold(h,'on');

filename = 'zeroFirstPredator.mat';
predatorCenterPointVarIndex = secondPredatorCenterPointVarIndex;
label = 'E';
plotZeroOnePredatorMaxAnotherPredator();

filename = 'zeroSecondPredator.mat';
predatorCenterPointVarIndex = firstPredatorCenterPointVarIndex;
label = 'F';
plotZeroOnePredatorMaxAnotherPredator();

solNo = 2;
label = 'G';
plotSolTrajectory();

solNo = length(solArr)-1;
label = 'H';
plotSolTrajectory();

  function plotZeroOnePredatorMaxAnotherPredator()
    zeroOnePredatorSolution = loadVars(strcat(familyPath,...
      filename),'w');
    [maxPredatorDensities,~] = getLastRowWithExtremeElementValue(...
      zeroOnePredatorSolution.w,predatorCenterPointVarIndex,...
      maxExtremeValueKind);
    l = plot(h,...
      maxPredatorDensities(firstPredatorCenterPointVarIndex),...
      maxPredatorDensities(secondPredatorCenterPointVarIndex),...
      zeroOnePredatorLineSpec,lineWidthKey,lineWidthVal);
    labelWithFont(l,label);
  end

  function plotSolTrajectory()
    solPart = getSolutionPartForTrajectoryPlot(...
      solArr{solNo},maxPredatorDensitiesPointIndices(solNo));
    l1 = plot(h,solPart(:,firstPredatorCenterPointVarIndex),...
      solPart(:,secondPredatorCenterPointVarIndex),...
      tillSteadyLineSpec,lineWidthKey,lineWidthVal);
    labelWithFont(l1,label);
  end

  function labelWithFont(h,name)
    lbl(h,name,fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
      interpreterKey,interpreterVal);
  end

end

