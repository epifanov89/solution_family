function doPlotTillSteadyInOneFigure(...
  doPlotTillSteadyInOneFigureCore,resultsFilename,tstart,tspan)

doPlotTillSteadyInOneFigureCore(resultsFilename,tstart,tspan,...
  @currentDirName,@load,@plot,@hold,@label,@xlabel,@gca,@set);
end

