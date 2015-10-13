function doPlotCombinedFamSolPhaseTrajectoriesCore( currentDirName,load,...
  getLastRowWithExtremeElementValue,plot3,hold,xlabel,ylabel,zlabel,gca,set )

curDirName = currentDirName();
famDirName = strcat(curDirName,...
  'solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\');

vars = load(strcat(famDirName,'0.mat'),'w');

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

plotptstart = 0;

lineSpec = '-o';

nequilibrium = 7;
equilibriumPreyArr = zeros(1,nequilibrium);
equilibriumFirstPredatorArr = zeros(1,nequilibrium);
equilibriumSecondPredatorArr = zeros(1,nequilibrium);
[solLastPtPrey,solLastPtFirstPredator,solLastPtSecondPredator] = ...
  getSolPartForPlot();
equilibriumPreyArr(1) = solLastPtPrey;
equilibriumFirstPredatorArr(1) = solLastPtFirstPredator;
equilibriumSecondPredatorArr(1) = solLastPtSecondPredator;

hold('on');

lastEquilibriumNo = nequilibrium-1;
preLastEquilibriumNo = lastEquilibriumNo-1;
for solNo = 1:preLastEquilibriumNo
  vars = load(sprintf('%s%d.mat',famDirName,solNo),'w');
  sol = vars.w;
  [solLastPtPrey,solLastPtFirstPredator,solLastPtSecondPredator] = ...
    getSolPartForPlot();
  equilibriumPreyArr(solNo+1) = solLastPtPrey;
  equilibriumFirstPredatorArr(solNo+1) = solLastPtFirstPredator;
  equilibriumSecondPredatorArr(solNo+1) = solLastPtSecondPredator;
end

solNo = lastEquilibriumNo;
vars = load(sprintf('%s%d.mat',famDirName,solNo),'w');
sol = vars.w;
[solLastPtPrey,solLastPtFirstPredator,solLastPtSecondPredator] = ...
  getSolPartForPlot();
equilibriumPreyArr(nequilibrium) = solLastPtPrey;
equilibriumFirstPredatorArr(nequilibrium) = solLastPtFirstPredator;
equilibriumSecondPredatorArr(nequilibrium) = solLastPtSecondPredator;

plotLineOfSpecifiedWidth(equilibriumPreyArr,equilibriumFirstPredatorArr,...
  equilibriumSecondPredatorArr);

plotptstart = 99;

lastSolNo = 10;

nDashedLinePt = lastSolNo-preLastEquilibriumNo;
preyMeanArr = zeros(1,nDashedLinePt);
firstPredatorMeanArr = zeros(1,nDashedLinePt);
secondPredatorMeanArr = zeros(1,nDashedLinePt);

lineSpec = '-';

for solNo = lastEquilibriumNo+1:lastSolNo
  vars = load(sprintf('%s%d.mat',famDirName,solNo),'w');
  sol = vars.w;
  [X,Y,Z] = getSolPartForPlot();
  plotLineOfSpecifiedWidth(X,Y,Z);
  
  arrIndex = solNo-lastEquilibriumNo;
  varIndex = preyCenterPointVarIndex;
  preyMeanArr(arrIndex) = getMeanVarVal();
  varIndex = firstPredatorCenterPointVarIndex;
  firstPredatorMeanArr(arrIndex) = getMeanVarVal();
  varIndex = secondPredatorCenterPointVarIndex;
  secondPredatorMeanArr(arrIndex) = getMeanVarVal();
end

preyMeanArr(nDashedLinePt) = solLastPtPrey;
firstPredatorMeanArr(nDashedLinePt) = solLastPtFirstPredator;
secondPredatorMeanArr(nDashedLinePt) = solLastPtSecondPredator;

lineSpec = 'o--';
plotLineOfSpecifiedWidth(preyMeanArr,firstPredatorMeanArr,...
  secondPredatorMeanArr);

fontNameKey = 'FontName';
fontNameVal = 'Times';
fontSizeKey = 'FontSize';
fontSizeVal = 18;
interpreterKey = 'Interpreter';
interpreterVal = 'latex';

set(gca(),fontNameKey,fontNameVal,fontSizeKey,fontSizeVal);

str = '$U$';
lbl(xlabel);
str = '$V$';
lbl(ylabel);
str = '$W$';
zlabel(str,'rot',1,fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
  interpreterKey,interpreterVal);

  function lbl(fcn)
    fcn(str,fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
      interpreterKey,interpreterVal);
  end

  function meanVarVal = getMeanVarVal()
    [ptWithMinVarVal,~] = ...
      getLastRowWithExtremeElementValue(sol,varIndex,'min');
    [ptWithMaxVarVal,~] = ...
      getLastRowWithExtremeElementValue(sol,varIndex,'max');
    meanVarVal = (ptWithMaxVarVal(varIndex)+ptWithMinVarVal(varIndex))/2;
  end

  function [X,Y,Z] = getSolPartForPlot()
    X = sol(end-plotptstart:end,preyCenterPointVarIndex);
    Y = sol(end-plotptstart:end,firstPredatorCenterPointVarIndex);
    Z = sol(end-plotptstart:end,secondPredatorCenterPointVarIndex);
  end

  function plotLineOfSpecifiedWidth(X,Y,Z)
    plot3(X,Y,Z,lineSpec,lineWidthKey,lineWidthVal);
  end
end

