function doPlotTillSteadyInOneFigureCore( resultsFilename,tstart,tspan,...
  currentDirName,loadVars,plot,hold,label,xlbl,gca,set )

curFileDir = currentDirName();
loadedVars = loadVars(strcat(curFileDir,'solution_results\',...
  resultsFilename),'t','w');
w = loadedVars.w;
t = loadedVars.t;

sz = size(w);
nvar = sz(2);
N = nvar/3;

centerPointIndex = fix((N+2)/2);

firstPredatorCenterPointVarIndex = N+centerPointIndex;
secondPredatorCenterPointVarIndex = 2*N+centerPointIndex;

timept = 1;
while t(timept) < tstart
  timept = timept+1;
end

npt = length(t);
reltimept = 1;
while timept <= npt && t(timept) <= tstart+tspan
  tplot(reltimept) = t(timept);
  firstpredatorplot(reltimept) = ...
    w(timept,firstPredatorCenterPointVarIndex);
  secondpredatorplot(reltimept) = ...
    w(timept,secondPredatorCenterPointVarIndex);
  timept = timept+1;
  reltimept = reltimept+1;
end

lineSpec = 'k-';
lineWidthKey = 'LineWidth';
lineWidthVal = 2;
fontSizeKey = 'FontSize';
fontSizeVal = 36;
fontNameKey = 'FontName';
fontNameVal = 'Times';
interpreterKey = 'Interpreter';
interpreterVal = 'latex';

l = plot(tplot,firstpredatorplot,lineSpec,lineWidthKey,lineWidthVal);
h = label(l,'$V$',fontSizeKey,fontSizeVal,fontNameKey,fontNameVal,...
  interpreterKey,interpreterVal);
setPos(h,[279.175 0.08]);
hold('on');
l = plot(tplot,secondpredatorplot,lineSpec,lineWidthKey,lineWidthVal);
h = label(l,'$W$',fontSizeKey,fontSizeVal,fontNameKey,fontNameVal,...
  interpreterKey,interpreterVal);
setPos(h,[277.984 0.88]);
h = xlbl('$t$',fontSizeKey,fontSizeVal,fontNameKey,fontNameVal,...
  interpreterKey,interpreterVal);
setPos(h,[299.537 -0.041]);
set(gca(),fontSizeKey,fontSizeVal,fontNameKey,fontNameVal,...
  'XTick',[200 250],'YTick',[0 0.5 1]);

  function setPos(h,pos)
    set(h,'Position',pos);
  end
end

