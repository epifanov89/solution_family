function doPlotFamilyCore( getMFilename,getFileDir,...
  getDirListing,loadVars,getLastRowWithExtremeElementValue,...
  getSolutionPartForTrajectoryPlot,subplot,plot,hold,lbl,xlbl,ylbl,set)
%	DOPLOTFAMILYCORE Изображает графики двух семейств и отмечает по два
%	решения семейства
%   На графике выводятся максимальные плотности популяций хищников,
%   соединенные сплошной линией, и по два разных режима для двух семейств

filename = getMFilename('fullpath');
curFileDir = getFileDir(filename);
familyNameStart = 'p=1+0.5sin(2 pi x)\l2=';

nrow = 1;
ncol = 2;
maxExtremeValueKind = 'max';
nLabeledSol = 4;

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

famNo = 1;
firstPredatorMortality = 1.1;
XTick = [0 0.5 1];
YTick = [0 0.5 1];
solNo = 2;
label = 'C';
plotFam(@(h,solArr,maxPredatorDensitiesPointIndices,...
      firstPredatorCenterPointVarIndex,...
      secondPredatorCenterPointVarIndex) plotSolTrajectory(h,solArr,...
    maxPredatorDensitiesPointIndices,solNo,label,...
    firstPredatorCenterPointVarIndex,secondPredatorCenterPointVarIndex),...
  XTick,YTick);

famNo = 2;
firstPredatorMortality = 1.2;
XTick = [0 0.4 0.8];
YTick = [0 0.4 0.8];
plotFam(@plotSteadyState,XTick,YTick);

  function plotFam(secondSolPlotFcn,XTick,YTick)
    familyPath = sprintf('%ssolution_results\\families\\%s%.1f\\',...
      curFileDir,familyNameStart,firstPredatorMortality);
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

    h = subplot(nrow,ncol,famNo);

    plot(h,wpredatormax(1,:),wpredatormax(2,:),familyLineSpec,...
      lineWidthKey,lineWidthVal);

    hold(h,'on');

    lblCodeOffset = 'A'+(famNo-1)*nLabeledSol;
    
    filename = 'zeroFirstPredator.mat';
    predatorCenterPointVarIndex = secondPredatorCenterPointVarIndex;    
    label = char(lblCodeOffset);
    plotZeroOnePredatorMaxAnotherPredator();

    filename = 'zeroSecondPredator.mat';
    predatorCenterPointVarIndex = firstPredatorCenterPointVarIndex;
    label = char(lblCodeOffset+1);
    plotZeroOnePredatorMaxAnotherPredator();
    
    secondSolPlotFcn(h,solArr,maxPredatorDensitiesPointIndices,...
      firstPredatorCenterPointVarIndex,secondPredatorCenterPointVarIndex);
    
    solNo = length(solArr)-1;
    label = char(lblCodeOffset+3);
    plotSolTrajectory(h,solArr,maxPredatorDensitiesPointIndices,solNo,...
      label,firstPredatorCenterPointVarIndex,...
      secondPredatorCenterPointVarIndex);
    
    set(h,fontNameKey,fontNameVal,fontSizeKey,fontSizeVal);
    
    if nargin >= 2
      set(h,'XTick',XTick);
      if nargin == 3
        set(h,'YTick',YTick);
      end
    end

    xlbl('$V$',fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
      interpreterKey,interpreterVal);
    ylbl('$W$','rot',0,fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
      interpreterKey,interpreterVal);
    
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
  end

  function plotSolTrajectory(h,solArr,maxPredatorDensitiesPointIndices,...
      solNo,label,firstPredatorCenterPointVarIndex,...
      secondPredatorCenterPointVarIndex)
    solPart = getSolutionPartForTrajectoryPlot(...
      solArr{solNo},maxPredatorDensitiesPointIndices(solNo));
    l1 = plot(h,solPart(:,firstPredatorCenterPointVarIndex),...
      solPart(:,secondPredatorCenterPointVarIndex),...
      tillSteadyLineSpec,lineWidthKey,lineWidthVal);
    labelWithFont(l1,label);
  end

  function plotSteadyState(h,solArr,~,firstPredatorCenterPointVarIndex,...
      secondPredatorCenterPointVarIndex)
    steadyStatePtWidthVal = 5;
    solNo = 2;
    sol = solArr{solNo};
    l = plot(h,sol(end,firstPredatorCenterPointVarIndex),...
      sol(end,secondPredatorCenterPointVarIndex),...
      'ko',lineWidthKey,steadyStatePtWidthVal);
    steadyStateLbl = 'G';
    labelWithFont(l,steadyStateLbl);
  end

  function labelWithFont(h,name)
    lbl(h,name,fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
      interpreterKey,interpreterVal);
  end

end

