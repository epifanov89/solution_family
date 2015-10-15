function plotPeriodVarianceWithSolutionNo()

familyNames = {'families\p=1+0.5sin(2 pi x)\l2=1.1\'};
doPlotPeriodVarianceWithSolutionNo(...
  @doPlotPeriodVarianceWithSolutionNoCore,familyNames);
end

