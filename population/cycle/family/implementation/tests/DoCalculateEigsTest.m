classdef DoCalculateEigsTest < IsPassedInFunctionCalledTestHelper
  
  properties
    filename
    passedInParentDirName
    passedInLoad
    passedInGetSystem
    passedInEig
    passedInDisp
    passedInFilename
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      setup@IsPassedInFunctionCalledTestHelper(testCase);
    end
  end
  
  methods (Access = protected)
    function fakeFcnToPassIn(testCase,parentDirName,load,getSystem,eig,...
        disp,filename)
      fakeFcnToPassIn@IsPassedInFunctionCalledTestHelper(testCase);
      testCase.passedInParentDirName = parentDirName;
      testCase.passedInLoad = load;
      testCase.passedInGetSystem = getSystem;
      testCase.passedInEig = eig;
      testCase.passedInDisp = disp;
      testCase.passedInFilename = filename;
    end
    
    function act(testCase)
      doCalculateEigs(@testCase.fakeFcnToPassIn,testCase.filename);
    end
  end
  
  methods (Test)
    function testRightParamsPassedToPassedInFunction(testCase)
      testCase.filename = 'file.mat';
      testCase.act();
      testCase.assertPassedInFunctionCalled();
      testCase.verifyEqual(testCase.passedInParentDirName,...
        @currentDirName,...
        'Передана неправильная функция получения имени родительской папки');
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        'Передана неправильная функция загрузки переменных из файла');
      testCase.verifyEqual(testCase.passedInGetSystem,...
        @predatorPrey2x1Params,...
        'Передана неправильная функция получения правых частей системы');
      testCase.verifyEqual(testCase.passedInEig,@eig,...
        'Передана неправильная функция нахождения СЗ');
      testCase.verifyEqual(testCase.passedInDisp,@disp,...
        'Передана неправильная функция вывода значений');
      testCase.verifyEqual(testCase.passedInFilename,testCase.filename,...
        'Передано неправильное имя файла');
    end
  end
  
end

