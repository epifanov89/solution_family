classdef DoGetCombinedPredatorDensitiesInitialDataCoreTest < ...
    matlab.unittest.TestCase & FakeCurrentDirNameHelper...
    & MultipleLoadTestHelper
  
  properties
    paramPassedInToGetFilename
    filename
    paramPassedInToGetFileDir
    dir
    zeroFirstPredatorSolutionResultsFilename
    nsol
    solno
    existent
    argsPassedInToGetLastPointWithExtremeVarValuesArr
    lastPointWithMaxSecondPredatorDensity
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.dirname = 'dir\';
      testCase.zeroFirstPredatorSolutionResultsFilename = ...
        'zero_first_predator_filename';
      testCase.nsol = 10;
      testCase.solno = 4;      
      testCase.existent = struct;
      testCase.argsPassedInToGetLastPointWithExtremeVarValuesArr = [];
    end
  end
  
  methods
    function setupSolutionToLoad(testCase,N)
      loadedVars = struct;
      loadedVars.filename = ...
        'dir\solution_results\zero_first_predator_filename';
      
      w(1:N) = 1;
      w(N+1:2*N) = 0;
      w(2*N+1:3*N) = 1;
      
      vars = struct;
      vars.w = w;
      loadedVars.vars = vars;
      testCase.varsToLoad = loadedVars;
      
      testCase.lastPointWithMaxSecondPredatorDensity(1:N) = 1;
      testCase.lastPointWithMaxSecondPredatorDensity(N+1:2*N) = 0;
      testCase.lastPointWithMaxSecondPredatorDensity(2*N+1:3*N) = 1;
    end
    
    function wmax = fakeGetLastPointWithExtremeVarValues(testCase,sol,...
        varIndices,kind)
      argsInfo = struct;
      argsInfo.solution = sol;
      argsInfo.varIndices = varIndices;
      argsInfo.extremeValuesKind = kind;
      testCase.argsPassedInToGetLastPointWithExtremeVarValuesArr = ...
        [testCase.argsPassedInToGetLastPointWithExtremeVarValuesArr,...
        argsInfo];
      wmax = testCase.lastPointWithMaxSecondPredatorDensity;
    end
    
    function w0 = act(testCase)
      w0 = doGetCombinedPredatorDensitiesInitialDataCore(...
        testCase.zeroFirstPredatorSolutionResultsFilename,...
        testCase.nsol,testCase.solno,@testCase.fakeCurrentDirName,...
        @testCase.fakeLoad,@testCase.fakeGetLastPointWithExtremeVarValues);
    end
  end
  
  methods (Test)    
    function testGetsLastPointWithMaxSecondPredatorDensityForNEqualTo5(testCase)      
      N = 5;
      testCase.setupSolutionToLoad(N);
      testCase.act();
      
      loadedVars = testCase.getVarsToLoadFromFile(...
        'dir\solution_results\zero_first_predator_filename');
      
      argsInfo = struct;
      argsInfo.solution = loadedVars.w;
      argsInfo.varIndices = 13;
      argsInfo.extremeValuesKind = 'max';
      testCase.verifyFalse(isempty(find(...
        arrayfun(@(args) isequal(args,argsInfo),...
        testCase.argsPassedInToGetLastPointWithExtremeVarValuesArr),1)),...
        'Ќе получена последн€€ точка решени€ с максимальной плотностью второй попул€ции хищников в центральной точке ареала при N = 5');
    end
    
    function testGetsLastPointWithMaxSecondPredatorDensityForNEqualTo6(testCase)      
      N = 6;
      testCase.setupSolutionToLoad(N);
      testCase.act();
      
      loadedVars = testCase.getVarsToLoadFromFile(...
        'dir\solution_results\zero_first_predator_filename');
      
      argsInfo = struct;
      argsInfo.solution = loadedVars.w;
      argsInfo.varIndices = 16;
      argsInfo.extremeValuesKind = 'max';
      testCase.verifyFalse(isempty(find(...
        arrayfun(@(args) isequal(args,argsInfo),...
        testCase.argsPassedInToGetLastPointWithExtremeVarValuesArr),1)),...
        'Ќе получена последн€€ точка решени€ с максимальной плотностью второй попул€ции хищников в центральной точке ареала при N = 6');
    end
    
    function testProperlyCombinesPredatorDensities(testCase)
      N = 5;
      testCase.setupSolutionToLoad(N);
      actInitialData = testCase.act();
      expInitialData(1:N) = 1;
      expInitialData(N+1:2*N) = 0.4;
      expInitialData(2*N+1:3*N) = 0.6;
      testCase.verifyEqual(actInitialData,expInitialData,...
        'ѕлотности попул€ций хищников возвращенных начальных данных не €вл€ютс€ комбинацией максимальных плотностей второй попул€ции хищников при нулевой первой попул€ции хищников');
    end
  end
  
end

