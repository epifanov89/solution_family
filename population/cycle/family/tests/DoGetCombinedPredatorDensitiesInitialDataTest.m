classdef DoGetCombinedPredatorDensitiesInitialDataTest < matlab.unittest.TestCase
  
  properties
    zeroFirstPredatorSolutionResultsInitialData
    nsol
    solno
    passedInZeroFirstPredatorSolutionResultsFilename
    passedInNSol
    passedInSolNo
    passedInCurrentDirName
    passedInLoad
    passedInGetLastRowWithExtremeElementValue
    
    initialData
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.zeroFirstPredatorSolutionResultsInitialData = ...
        'zero_first_predator_filename';
      testCase.nsol = 10;
      testCase.solno = 4;
    end
  end
  
  methods
    function ic = fakeFcnToPassIn(testCase,...
        zeroFirstPredatorSolutionResultsFilename,nsol,solno,...
        currentDirName,load,getLastRowWithExtremeElementValue)
      testCase.passedInZeroFirstPredatorSolutionResultsFilename = ...
        zeroFirstPredatorSolutionResultsFilename;
      testCase.passedInNSol = nsol;
      testCase.passedInSolNo = solno;
      testCase.passedInCurrentDirName = currentDirName;
      testCase.passedInLoad = load;
      testCase.passedInGetLastRowWithExtremeElementValue = ...
        getLastRowWithExtremeElementValue;
      ic = testCase.initialData;
    end
    
    function ic = act(testCase)
      ic = doGetCombinedPredatorDensitiesInitialData(...
        @testCase.fakeFcnToPassIn,...
        testCase.zeroFirstPredatorSolutionResultsInitialData,...
        testCase.nsol,testCase.solno);
    end
  end
  
  methods (Test)
    function testPassesZeroFirstPredatorSolutionResultsFilenameToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInZeroFirstPredatorSolutionResultsFilename,...
        testCase.zeroFirstPredatorSolutionResultsInitialData,...
        'Передано неправильное имя файла с результатами решения при нулевой плотности первой популяции хищников');
    end
    
    function testPassesNSolToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInNSol,testCase.nsol,...
        'Передано неправильное число решений');
    end
    
    function testPassesSolNoToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInSolNo,testCase.solno,...
        'Передан неправильный номер решения');
    end
    
    function testPassesCurrentDirNameToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInCurrentDirName,...
        @currentDirName,...
        'Передана неправильная функция получения имени папки файла с кодом');
    end
    
    function testPassesLoadToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        'Передана неправильная функция загрузки переменных из файла');
    end
    
    function testPassesGetLastRowWithExtremeElementValueToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInGetLastRowWithExtremeElementValue,...
        @getLastRowWithExtremeElementValue,...
        'Передана неправильная функция получения последней строки с максимальным значением столбца с переданным индексом');
    end
    
    function testReturnsInitialData(testCase)
      testCase.initialData = [1 1];
      actInitialData = testCase.act();
      expInitialData = testCase.initialData;
      testCase.verifyEqual(actInitialData,expInitialData,...
        'Возвращены неправильные начальные данные');
    end
  end
  
end

