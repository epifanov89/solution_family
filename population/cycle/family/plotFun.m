function plotFun()

resourceDeviation = 0.2;
fontSize = 36;
doPlotFun(@doPlotFunCore,@(x) resource(x,resourceDeviation),...
  '$x$','$p\left(x\right)$',fontSize,...
  'XTick',[0 0.4 0.8],'YTick',[0.8 1 1.2]);
end

