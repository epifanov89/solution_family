function doPlotTillSteadyCore( resultsFilename,tstart,tspan,XAxisGap,...
  currentDirName,loadVars,plot,xlbl,ylbl,figure,gca,set )

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

tf = t(end);

firsttspan = 100;

timept = 1;
while t(timept) <= firsttspan
  tplot(timept) = t(timept);
  firstpredatorplot(timept) = w(timept,firstPredatorCenterPointVarIndex);
  secondpredatorplot(timept) = w(timept,secondPredatorCenterPointVarIndex);
  timept = timept+1;
end

while t(timept) < tstart
  tplot(timept) = NaN;
  firstpredatorplot(timept) = NaN;
  secondpredatorplot(timept) = NaN;
  timept = timept+1;
end

npt = length(t);
while timept <= npt && t(timept) <= tstart+tspan 
  tplot(timept) = t(timept)-tstart+firsttspan+XAxisGap;
  firstpredatorplot(timept) = w(timept,firstPredatorCenterPointVarIndex);
  secondpredatorplot(timept) = w(timept,secondPredatorCenterPointVarIndex);
  timept = timept+1;
end

XTickStart = firsttspan+XAxisGap;
XTickOffset = 50;
lastXTick = XTickStart+XTickOffset;
lastXTickLabel = tstart+XTickOffset;

plot(tplot,firstpredatorplot,'k-','LineWidth',2);
xlbl('$t$','FontSize',36,'FontName','Times','Interpreter','latex');
ylbl('$V$','rot',0,'FontSize',36,'FontName','Times',...
  'Interpreter','latex');
set(gca(),'FontSize',36,'FontName','Times',...
  'XTick',[0 firsttspan XTickStart lastXTick],...
  'XTickLabel',[0 firsttspan tstart lastXTickLabel],...
  'YTick',[0 0.2 0.4 0.6]);

figure();
plot(tplot,secondpredatorplot,'k-','LineWidth',2);
xlbl('$t$','FontSize',36,'FontName','Times','Interpreter','latex');
ylbl('$W$','rot',0,'FontSize',36,'FontName','Times',...
  'Interpreter','latex');
set(gca(),'FontSize',36,'FontName','Times',...
  'XTick',[0 firsttspan XTickStart lastXTick],...
  'XTickLabel',[0 firsttspan tstart lastXTickLabel],...
  'YTick',[0 0.5 1]);
end

