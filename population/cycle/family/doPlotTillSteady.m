function doPlotTillSteady( doPlotTillSteadyCore,resultsFilename,...
  tstart,tspan,XAxisGap )

doPlotTillSteadyCore(resultsFilename,tstart,tspan,XAxisGap,...
  @currentDirName,@load,@plot,@xlabel,@ylabel,@figure,@gca,@set);
end

