function doPlotCombinedFamSolPhaseTrajectoriesCore( currentDirName,load,...
  getLastRowWithExtremeElementValue,plot3,hold,label,xlabel,ylabel,...
  zlabel,gca,set )

curDirName = currentDirName();
famDirName = strcat(curDirName,...
  'solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\');

firstPlottedEquilibriumNo = 3;

solNo = 1;
vars = load(sprintf('%s%d.mat',famDirName,...
  firstPlottedEquilibriumNo+solNo),'w');

sol = vars.w;

sz = size(sol);
nspecies = 3;
N = sz(2)/nspecies;

centerPointIndex = fix((N+2)/2);

preyCenterPointVarIndex = centerPointIndex;
firstPredatorCenterPointVarIndex = N+centerPointIndex;
secondPredatorCenterPointVarIndex = 2*N+centerPointIndex;
lineWidthKey = 'LineWidth';
lineWidthVal = 2;
fontNameKey = 'FontName';
fontNameVal = 'Times';
fontSizeKey = 'FontSize';
fontSizeVal = 18;
interpreterKey = 'Interpreter';
interpreterVal = 'latex';

posArr = [0.527 0.378 0.365
          0.504 0.481 0.24
          0.485 0.495 0.129
          0.395 0.424 0.04];

nequilibrium = 3;
equilibriumPreyArr = zeros(1,nequilibrium);
equilibriumFirstPredatorArr = zeros(1,nequilibrium);
equilibriumSecondPredatorArr = zeros(1,nequilibrium);
[equilibriumPreyArr,equilibriumFirstPredatorArr,...
    equilibriumSecondPredatorArr] = processEquilibrium(solNo,sol,...
  preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
  secondPredatorCenterPointVarIndex,equilibriumPreyArr,...
  equilibriumFirstPredatorArr,equilibriumSecondPredatorArr);

hold('on');

for solNo = 2:nequilibrium
  sol = loadSol(famDirName,firstPlottedEquilibriumNo,solNo);
  [equilibriumPreyArr,equilibriumFirstPredatorArr,...
      equilibriumSecondPredatorArr] = processEquilibrium(solNo,sol,...
    preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
    secondPredatorCenterPointVarIndex,equilibriumPreyArr,...
    equilibriumFirstPredatorArr,equilibriumSecondPredatorArr);
end

lineSpec = 'k-';
plot3(equilibriumPreyArr,equilibriumFirstPredatorArr,...
  equilibriumSecondPredatorArr,lineSpec,lineWidthKey,lineWidthVal);

nDashedLinePt = 5;
preyMeanArr = zeros(1,nDashedLinePt);
firstPredatorMeanArr = zeros(1,nDashedLinePt);
secondPredatorMeanArr = zeros(1,nDashedLinePt);

preyMeanArr(1) = equilibriumPreyArr(end);
firstPredatorMeanArr(1) = equilibriumFirstPredatorArr(end);
secondPredatorMeanArr(1) = equilibriumSecondPredatorArr(end);

plotptstart = 99;

for dashedLinePtNo = 2:nDashedLinePt
  solNo = nequilibrium+dashedLinePtNo-1;
  sol = loadSol(famDirName,firstPlottedEquilibriumNo,solNo);
  processSol(solNo,sol,preyCenterPointVarIndex,...
    firstPredatorCenterPointVarIndex,secondPredatorCenterPointVarIndex,...
    plotptstart,lineSpec);
  preyMeanArr(dashedLinePtNo) = getMeanVarVal(sol,...
    preyCenterPointVarIndex);
  firstPredatorMeanArr(dashedLinePtNo) = getMeanVarVal(sol,...
    firstPredatorCenterPointVarIndex);
  secondPredatorMeanArr(dashedLinePtNo) = getMeanVarVal(sol,...
    secondPredatorCenterPointVarIndex);
end
  
lineSpec = 'ko--';
plot3(preyMeanArr,firstPredatorMeanArr,secondPredatorMeanArr,lineSpec,...
  lineWidthKey,lineWidthVal);

set(gca(),fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
  'XTick',[0.4 0.5],'YTick',[0.4 0.6],'ZTick',[0 0.2]);

str = '$U$';
pos = [-0.808 -1.725 0.698];
h = lbl(xlabel,str,pos);
str = '$V$';
pos = [-0.955 -1.218 0.679];
h = lbl(ylabel,str,pos);
str = '$W$';
angle = 1;
h = zlabel(str,'rot',angle,fontNameKey,fontNameVal,...
  fontSizeKey,fontSizeVal,interpreterKey,interpreterVal);
pos = [0.326 0.759 0.435];
setPosition(h,pos);

  function [equilibriumPreyArr,equilibriumFirstPredatorArr,...
        equilibriumSecondPredatorArr] = processEquilibrium(solNo,sol,...
      preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
      secondPredatorCenterPointVarIndex,equilibriumPreyArr,...
      equilibriumFirstPredatorArr,equilibriumSecondPredatorArr)
    plotptstart = 0;
    [solLastPtPrey,solLastPtFirstPredator,solLastPtSecondPredator] = ...
      processSol(solNo,sol,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex,plotptstart,'ko');
    equilibriumPreyArr(solNo) = solLastPtPrey;
    equilibriumFirstPredatorArr(solNo) = solLastPtFirstPredator;
    equilibriumSecondPredatorArr(solNo) = solLastPtSecondPredator;
  end

  function [X,Y,Z] = processSol(solNo,sol,...
      preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
      secondPredatorCenterPointVarIndex,plotptstart,lineSpec)
    [X,Y,Z] = getSolPartForPlot(sol,plotptstart,preyCenterPointVarIndex,...
      firstPredatorCenterPointVarIndex,secondPredatorCenterPointVarIndex);
    l = plot3(X,Y,Z,lineSpec,lineWidthKey,lineWidthVal);
    if mod(solNo,2) == 1
      labelNo = (solNo-1)/2;
      h = labelSol(l,labelNo);
      setPosition(h,posArr(labelNo+1,:));
    end    
  end

  function meanVarVal = getMeanVarVal(sol,varIndex)
    [ptWithMinVarVal,~] = getLastRowWithExtremeElementValue(sol,...
      varIndex,'min');
    [ptWithMaxVarVal,~] = getLastRowWithExtremeElementValue(sol,...
      varIndex,'max');
    meanVarVal = (ptWithMaxVarVal(varIndex)+ptWithMinVarVal(varIndex))/2;
  end

  function sol = loadSol(famDirName,firstPlottedEquilibriumNo,solNo)
    vars = load(sprintf('%s%d.mat',famDirName,...
      firstPlottedEquilibriumNo+solNo),'w');
    sol = vars.w;
  end

  function [X,Y,Z] = getSolPartForPlot(sol,plotptstart,...
      preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
      secondPredatorCenterPointVarIndex)
    X = sol(end-plotptstart:end,preyCenterPointVarIndex);
    Y = sol(end-plotptstart:end,firstPredatorCenterPointVarIndex);
    Z = sol(end-plotptstart:end,secondPredatorCenterPointVarIndex);
  end

  function h = labelSol(l,solNo)
    h = label(l,char('A'+solNo),fontNameKey,fontNameVal,fontSizeKey,...
      fontSizeVal,interpreterKey,interpreterVal);
  end

  function h = lbl(fcn,str,pos)
    h = fcn(str,fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
      interpreterKey,interpreterVal);
    setPosition(h,pos);
  end

  function setPosition(h,pos)
    set(h,'Position',pos);
  end
end

