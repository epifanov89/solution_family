function plotTillSteady()

resultsFilename = 'tillsteadyC_p=1+0,5sin(2 pi x).mat';
tstart = 400;
tspan = 100;
XAxisGap = 50;
doPlotTillSteady(@doPlotTillSteadyCore,resultsFilename,...
  tstart,tspan,XAxisGap);
end

