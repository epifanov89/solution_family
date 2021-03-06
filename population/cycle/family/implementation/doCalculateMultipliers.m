function doCalculateMultipliers(doCalculateMultipliersCore,...
  resultsFilename,preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
  firstPredatorMortality,resourceDeviation,solver )

doCalculateMultipliersCore(resultsFilename,preyDiffusionCoeff,...
  secondPredatorDiffusionCoeff,firstPredatorMortality,resourceDeviation,...
  @mfilename,@getFileDirname,@exist,@load,@mkdir,@saveStruct,...
  @getPoincareMapLastPoint,@getPeriod,@predatorPrey2x1Params,...
  @multipliers_one_system_for_each_monodromy_matrix_column,solver,...
  @fprintf,@disp);
end

