function doSolveAndFindPoincareMap( doSolveAndFindPoincareMapCore,...
  solutionResultsFilename,preyDiffusionCoeff,...
  secondPredatorDiffusionCoeff,resourceDeviation,N,tf,getInitialData )

doSolveAndFindPoincareMapCore(solutionResultsFilename,...
  preyDiffusionCoeff,secondPredatorDiffusionCoeff,resourceDeviation,N,...
  tf,getInitialData,@currentDirName,@exist,@load,@mkdir,@saveStruct,...
  @predatorPrey2x1Params,@myode4);
end

