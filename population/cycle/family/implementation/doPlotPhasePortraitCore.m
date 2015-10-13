function doPlotPhasePortraitCore( close,currentDirName,load,subplot,...
  hold,plot,label,xlabel,ylabel,gca,set )

close('all');

curDirName = currentDirName();
loadedVars = load(strcat(curDirName,...
  'solution_results\tillsteadyA.mat'),'w');
wA = loadedVars.w;

loadedVars = load(strcat(curDirName,...
  'solution_results\tillsteadyB.mat'),'w');
wB = loadedVars.w;

sz = size(wA);
N = sz(2)/3;
centerPointIndex = fix((N+2)/2);
preyCenterPointVarIndex = centerPointIndex;
firstPredatorCenterPointVarIndex = N+centerPointIndex;
secondPredatorCenterPointVarIndex = 2*N+centerPointIndex;

lineSpec = 'k-';

lineWidthKey = 'LineWidth';
fontNameKey = 'FontName';
fontSizeKey = 'FontSize';
interpreterKey = 'Interpreter';

lineWidthVal = 2;
fontNameVal = 'Times';
fontSizeVal = 18;
interpreterVal = 'latex';

nrow = 1;
ncol = 2;

pos = 1;
ylabelstr = '$V$';
ytick = [0 0.5 1];
plotPhasePortraits(pos,firstPredatorCenterPointVarIndex,ylabelstr,ytick);
pos = 2;
ylabelstr = '$W$';
ytick = [0 0.4 0.8];
plotPhasePortraits(pos,secondPredatorCenterPointVarIndex,ylabelstr,ytick);

  function plotPhasePortraits(pos,secondVarIndex,ylabelstr,ytick)
    h = subplot(nrow,ncol,pos);
    hold(h,'on');
    l1 = plot(h,wA(sz(1)/2+1:sz(1),preyCenterPointVarIndex),...
      wA(sz(1)/2+1:sz(1),secondVarIndex),...
      lineSpec,lineWidthKey,lineWidthVal);
    label(l1,'A',fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
      interpreterKey,interpreterVal);
    l2 = plot(h,wB(sz(1)/2+1:sz(1),preyCenterPointVarIndex),...
      wB(sz(1)/2+1:sz(1),secondVarIndex),...
      lineSpec,lineWidthKey,lineWidthVal);
    label(l2,'B',fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
      interpreterKey,interpreterVal);

    xlabel('$U$',fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
      interpreterKey,interpreterVal);
    ylabel(ylabelstr,'rot',0,fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
      interpreterKey,interpreterVal);
    set(gca(),fontNameKey,fontNameVal,fontSizeKey,fontSizeVal,...
      'XTick',[0 0.4 0.8,],'YTick',ytick);
  end
end

