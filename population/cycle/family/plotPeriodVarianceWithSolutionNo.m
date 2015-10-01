function plotPeriodVarianceWithSolutionNo()

familyNames = {'family_k1=0,2','family_k1=0,2_p=1+0,5sin(2 pi x)'};
doPlotPeriodVarianceWithSolutionNo(...
  @doPlotPeriodVarianceWithSolutionNoCore,familyNames);
end

