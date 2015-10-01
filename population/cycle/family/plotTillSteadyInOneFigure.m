function plotTillSteadyInOneFigure()

resultsFilename = 'tillsteadyC_p=1+0,5sin(2 pi x).mat';
tstart = 200;
tspan = 100;
doPlotTillSteadyInOneFigure(@doPlotTillSteadyInOneFigureCore,...
  resultsFilename,tstart,tspan);
end

