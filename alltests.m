import matlab.unittest.TestSuite
fullSuite = TestSuite.fromClass(?DoSaveStructTest);
fullSuite = [fullSuite,TestSuite.fromClass(?DoSolveOneCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoSolveOneTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoSolveAllCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoSolveAllTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoSolveAndFindPoincareMapCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoSolveAndFindPoincareMapTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoCalculateMultipliersCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoCalculateMultipliersTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?GetZeroFirstPredatorInitialDataTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?GetZeroSecondPredatorInitialDataTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoGetCombinedPredatorDensitiesInitialDataCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoGetCombinedPredatorDensitiesInitialDataTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?GetSolutionTillMaxPredatorDensitiesTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?GetResultsFilenameForMFileTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?GetLastRowWithExtremeElementValueTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?GetFileDirnameTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?GetInitialDataToSolveTillSteadyTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoLoadFamilySolutionsCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoLoadFamilySolutionsTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoPlotFamilyCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoPlotFamilyTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoPlotTillSteadyCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoPlotTillSteadyTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoPlotTillSteadyInOneFigureCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoPlotTillSteadyInOneFigureTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoPlotPredatorSpatiotemporalDistributionsCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoPlotPredatorSpatiotemporalDistributionsTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoPlotPeriodVarianceWithSolutionNoCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoPlotPeriodVarianceWithSolutionNoTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoPlotFunCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoPlotFunTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoGetCurrentDirNameTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?GetCurrentDirNameTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?GetPoincareMapLastPointIndexTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?GetInterpValueTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoGetPeriodCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoGetPeriodTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoGetPoincareMapLastPointCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoGetPoincareMapLastPointTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?GetSolutionPartTest)];
fullSuite = [fullSuite,TestSuite.fromClass(...
  ?DoPlotCombinedFamSolPhaseTrajectoriesCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(...
  ?DoPlotCombinedFamSolPhaseTrajectoriesTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoCalculateEigsCoreTest)];
fullSuite = [fullSuite,TestSuite.fromClass(?DoCalculateEigsTest)];
result = run(fullSuite)