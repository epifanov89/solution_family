function doPlotFamilyCore( getMFilename,getFileDir,...
  getDirListing,load,getLastRowWithExtremeElementValue,...
  getSolutionPartForTrajectoryPlot,plot,hold,lbl,xlbl,ylbl,gca,set)
%	DOPLOTFAMILYCORE Изображает график семейства и отмечает два
%	решения семейства
%   На графике выводятся максимальные плотности популяций хищников,
%   соединенные сплошной линией, и два разных режима для семейства

filename = getMFilename('fullpath');
curFileDir = getFileDir(filename);

maxExtremeValueKind = 'max';

lineWidthKey = 'LineWidth';
lineWidthVal = 2;
fontNameKey = 'FontName';
fontNameVal = 'Times';
fontSizeKey = 'FontSize';
fontSizeVal = 18;
interpreterKey = 'Interpreter';
interpreterVal = 'latex';

familyPath = sprintf(...
  '%ssolution_results\\families\\p=1+0.5sin(2 pi x)\\l2=1.1\\',curFileDir);
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

loadedVars = load(strcat(familyPath,match),'w');

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

matchIndex = matchIndex+1;

while matchIndex <= length(sortedMatches)
  match = sortedMatches{matchIndex};
  if ~isempty(match)
    loadedVars = load(strcat(familyPath,match),'w');

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

plot(wpredatormax(1,:),wpredatormax(2,:),'ko-',lineWidthKey,lineWidthVal);

hold('on');

labelCharCode = 'A';

filenameArr = {'zeroFirstPredator.mat','zeroSecondPredator.mat'};
predatorCenterPointVarIndexArr = [secondPredatorCenterPointVarIndex,...
  firstPredatorCenterPointVarIndex];    
labelPosArr = [0.007 0.987
               1.233 0.023];
for zeroOnePredatorSolNo = 1:length(filenameArr)
  labelStr = char(labelCharCode);
  plotZeroOnePredatorMaxAnotherPredator(...
    filenameArr{zeroOnePredatorSolNo},...
    predatorCenterPointVarIndexArr(zeroOnePredatorSolNo),labelStr,...
    labelPosArr(zeroOnePredatorSolNo,:));
  labelCharCode = labelCharCode+1;
end

solNoArr = [2,(length(solArr)+1)/2,length(solArr)-1];
labelPosArr = [0.098 1.065
               0.593 0.61
               1.124 0.12];             
for trajectoryNo = 1:length(solNoArr) 
  labelStr = char(labelCharCode);
  plotSolTrajectory(solNoArr(trajectoryNo),labelStr,...
    labelPosArr(trajectoryNo,:));
  labelCharCode = labelCharCode+1;
end

set(gca(),fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
  'XTick',[0 0.5 1],'YTick',[0 0.5 1]);

h = xlbl('$V$',fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
  interpreterKey,interpreterVal);
labelPos = [1.398 -0.021];
setPos(h,labelPos);
h = ylbl('$W$','rot',0,fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
  interpreterKey,interpreterVal);
labelPos = [-0.027 1.348];
setPos(h,labelPos);
    
  function plotZeroOnePredatorMaxAnotherPredator(filename,...
      predatorCenterPointVarIndex,labelStr,labelPos)
    zeroOnePredatorSolution = load(strcat(familyPath,filename),'w');
    [maxPredatorDensities,~] = getLastRowWithExtremeElementValue(...
      zeroOnePredatorSolution.w,predatorCenterPointVarIndex,...
      maxExtremeValueKind);
    l = plot(maxPredatorDensities(firstPredatorCenterPointVarIndex),...
      maxPredatorDensities(secondPredatorCenterPointVarIndex),...
      'ko',lineWidthKey,lineWidthVal);
    h = lbl(l,labelStr,fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
      interpreterKey,interpreterVal);
    setPos(h,labelPos);
  end

  function plotSolTrajectory(solNo,labelStr,labelPos)
    solPart = getSolutionPartForTrajectoryPlot(solArr{solNo},...
      maxPredatorDensitiesPointIndices(solNo));
    l = plot(solPart(:,firstPredatorCenterPointVarIndex),...
      solPart(:,secondPredatorCenterPointVarIndex),...
      'k--',lineWidthKey,lineWidthVal);
    h = lbl(l,labelStr,fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
      interpreterKey,interpreterVal);
    setPos(h,labelPos);
  end

  function setPos(h,pos)
    set(h,'Position',pos);
  end

end

