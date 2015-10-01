classdef DoPlotPeriodVarianceWithSolutionNoCoreTest < ...
    matlab.unittest.TestCase & FakeCurrentDirNameHelper & FakePlotHelper
  
  properties
    familyNames
    solutionsToReturnFromLoadFamilySolutions
    argsPassedInToGetPeriod
    periodsToReturnFromGetPeriod
    nextAxesHandle
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      setup@FakePlotHelper(testCase);
      testCase.familyNames = {'family1','family2'};
      testCase.argsPassedInToGetPeriod = [];
      testCase.plottedLines = {};
      testCase.nextAxesHandle = 1;
    end
  end
  
  methods
    function setupSolutionsToLoad(testCase,N,fixedVarIndex)
      nspecies = 3;
      nvar = N*nspecies;
      npt = 30;
      
      sol1 = struct;      
      sol1.t = zeros(1,npt);
      sol1.w = zeros(npt,nvar);
      
      sol2 = struct;
      sol2.t = ones(1,npt);
      sol2.w = ones(npt,nvar);
      
      vars = struct;
      vars.familyName = testCase.familyNames{1};
      vars.varsToLoad = {'t','w'};
      vars.solutions = [sol1,sol2];
      testCase.solutionsToReturnFromLoadFamilySolutions = vars;
      
      sol3 = struct;      
      sol3.t(1:npt) = 2;
      sol3.w(1:npt,1:nvar) = 2;
      
      sol4 = struct;
      sol4.t(1:npt) = 3;
      sol4.w(1:npt,1:nvar) = 3;
      
      vars = struct;
      vars.familyName = testCase.familyNames{2};
      vars.varsToLoad = {'t','w'};
      vars.solutions = [sol3,sol4];
      testCase.solutionsToReturnFromLoadFamilySolutions = ...
        [testCase.solutionsToReturnFromLoadFamilySolutions,vars];
            
      vars = struct;
      vars.t = sol1.t;
      vars.w = sol1.w;
      vars.fixedVarIndex = fixedVarIndex;
      vars.period = 10;
      testCase.periodsToReturnFromGetPeriod = vars;
      
      vars = struct;
      vars.t = sol2.t;
      vars.w = sol2.w;
      vars.fixedVarIndex = fixedVarIndex;
      vars.period = 20;
      testCase.periodsToReturnFromGetPeriod = ...
        [testCase.periodsToReturnFromGetPeriod,vars];
      
      vars = struct;
      vars.t = sol3.t;
      vars.w = sol3.w;
      vars.fixedVarIndex = fixedVarIndex;
      vars.period = 30;
      testCase.periodsToReturnFromGetPeriod = ...
        [testCase.periodsToReturnFromGetPeriod,vars];
      
      vars = struct;
      vars.t = sol4.t;
      vars.w = sol4.w;
      vars.fixedVarIndex = fixedVarIndex;
      vars.period = 40;
      testCase.periodsToReturnFromGetPeriod = ...
        [testCase.periodsToReturnFromGetPeriod,vars];
    end
    
    function solutions = fakeLoadFamilySolutions(testCase,...
        familyName,varargin)
      vars = testCase.solutionsToReturnFromLoadFamilySolutions(arrayfun(...
        @(v) strcmp(v.familyName,familyName)...
          && isequal(v.varsToLoad,varargin),...
        testCase.solutionsToReturnFromLoadFamilySolutions));
      solutions = vars.solutions;
    end
    
    function T = fakeGetPeriod(testCase,t,w,fixedVarIndex,fixedVarValue)
      args = struct;
      args.t = t;
      args.w = w;
      args.fixedVarIndex = fixedVarIndex;
      args.fixedVarValue = fixedVarValue;
      testCase.argsPassedInToGetPeriod = ...
        [testCase.argsPassedInToGetPeriod,args];
      
      vars = testCase.periodsToReturnFromGetPeriod(arrayfun(...
        @(p) isequal(p.t,t) && isequal(p.w,w)...
          && p.fixedVarIndex == fixedVarIndex,...
        testCase.periodsToReturnFromGetPeriod));
      T = vars.period;
    end
    
    function h = fakeAxes(testCase)
      h = testCase.nextAxesHandle;
      testCase.nextAxesHandle = testCase.nextAxesHandle+1;
    end
    
    function fakeHold(testCase,h,arg)
      callInfo = struct;
      callInfo.fcn = 'hold';
      args = struct;
      args.axesHandle = h;
      args.arg = arg;
      callInfo.args = args;
      testCase.callSequence = [testCase.callSequence,callInfo];
    end
    
    function fakeLabel(~,varargin)      
    end
    
    function fakeSet(~,varargin)
    end
    
    function fakeXLabel(~,varargin)
    end
    
    function fakeYLabel(~,varargin)
    end
    
    function verifyGotPeriod(testCase,sol,fixedVarIndex,msg)
      expArgs = struct;
      expArgs.t = sol.t;
      expArgs.w = sol.w;
      expArgs.fixedVarIndex = fixedVarIndex;
      expArgs.fixedVarValue = 0.5;
      testCase.verifyFalse(isempty(find(arrayfun(...
        @(args) isequal(args,expArgs),...
        testCase.argsPassedInToGetPeriod),1)),msg);
    end
    
    function verifyGotFirstSolutionPeriod(testCase,N,fixedVarIndex,msg)
      testCase.setupSolutionsToLoad(N,fixedVarIndex);
      testCase.act();      
      testCase.verifyGotPeriod(...
        testCase.solutionsToReturnFromLoadFamilySolutions.solutions(1),...
        fixedVarIndex,msg);
    end
    
    function verifyGotSecondSolutionPeriod(testCase,N,fixedVarIndex,msg)
      testCase.setupSolutionsToLoad(N,fixedVarIndex);
      testCase.act();           
      testCase.verifyGotPeriod(...
        testCase.solutionsToReturnFromLoadFamilySolutions.solutions(2),...
        fixedVarIndex,msg);
    end
    
    function verifyPeriodsPlotted(testCase,N,fixedVarIndex,msg)
      testCase.setupSolutionsToLoad(N,fixedVarIndex);
      testCase.act();
      expLine = [0 10
                 1 20];
      testCase.verifyFalse(isempty(find(cellfun(...
        @(l) isequal(l,expLine),testCase.plottedLines),1)),msg);
    end
  end
  
  methods (Access = protected)    
    function act(testCase)
      doPlotPeriodVarianceWithSolutionNoCore(testCase.familyNames,...
        @testCase.fakeLoadFamilySolutions,@testCase.fakeGetPeriod,...
        @testCase.fakeAxes,@testCase.fakeHold,@testCase.fakePlot,...
        @testCase.fakeLabel,@testCase.fakeSet,...
        @testCase.fakeXLabel,@testCase.fakeYLabel);
    end
  end
  
  methods (Test)
    function testGetsFirstFamilyFirstSolutionPeriodForNEqualTo5(testCase)
      N = 5;
      fixedVarIndex = 3;    
      testCase.setupSolutionsToLoad(N,fixedVarIndex);
      testCase.act();      
      vars = testCase.solutionsToReturnFromLoadFamilySolutions(arrayfun(...
        @(s) strcmp(s.familyName,'family1'),...
        testCase.solutionsToReturnFromLoadFamilySolutions));
      testCase.verifyGotPeriod(vars.solutions(1),fixedVarIndex,...
        'Не найден период первого решения первого семейства при N = 5');
    end
    
    function testGetsFirstFamilyFirstSolutionPeriodForNEqualTo6(testCase)
      N = 6;
      fixedVarIndex = 4;    
      testCase.setupSolutionsToLoad(N,fixedVarIndex);
      testCase.act();      
      vars = testCase.solutionsToReturnFromLoadFamilySolutions(arrayfun(...
        @(s) strcmp(s.familyName,'family1'),...
        testCase.solutionsToReturnFromLoadFamilySolutions));
      testCase.verifyGotPeriod(vars.solutions(1),fixedVarIndex,...
        'Не найден период первого решения первого семейства при N = 6');
    end
    
    function testGetsFirstFamilySecondSolutionPeriodForNEqualTo5(testCase)
      N = 5;
      fixedVarIndex = 3;   
      testCase.setupSolutionsToLoad(N,fixedVarIndex);
      testCase.act();      
      vars = testCase.solutionsToReturnFromLoadFamilySolutions(arrayfun(...
        @(s) strcmp(s.familyName,'family1'),...
        testCase.solutionsToReturnFromLoadFamilySolutions));
      testCase.verifyGotPeriod(vars.solutions(1),fixedVarIndex,...
        'Не найден период второго решения первого семейства при N = 5');
    end
    
    function testGetsFirstFamilySecondSolutionPeriodForNEqualTo6(testCase)
      N = 6;
      fixedVarIndex = 4;     
      testCase.setupSolutionsToLoad(N,fixedVarIndex);
      testCase.act();      
      vars = testCase.solutionsToReturnFromLoadFamilySolutions(arrayfun(...
        @(s) strcmp(s.familyName,'family1'),...
        testCase.solutionsToReturnFromLoadFamilySolutions));
      testCase.verifyGotPeriod(vars.solutions(1),fixedVarIndex,...
        'Не найден период второго решения первого семейства при N = 6');
    end
    
    function testGetsSecondFamilyFirstSolutionPeriodForNEqualTo5(testCase)
      N = 5;
      fixedVarIndex = 3;    
      testCase.setupSolutionsToLoad(N,fixedVarIndex);
      testCase.act();      
      vars = testCase.solutionsToReturnFromLoadFamilySolutions(arrayfun(...
        @(s) strcmp(s.familyName,'family2'),...
        testCase.solutionsToReturnFromLoadFamilySolutions));
      testCase.verifyGotPeriod(vars.solutions(1),fixedVarIndex,...
        'Не найден период первого решения второго семейства при N = 5');
    end
    
    function testGetsSecondFamilyFirstSolutionPeriodForNEqualTo6(testCase)
      N = 6;
      fixedVarIndex = 4;    
      testCase.setupSolutionsToLoad(N,fixedVarIndex);
      testCase.act();      
      vars = testCase.solutionsToReturnFromLoadFamilySolutions(arrayfun(...
        @(s) strcmp(s.familyName,'family2'),...
        testCase.solutionsToReturnFromLoadFamilySolutions));
      testCase.verifyGotPeriod(vars.solutions(1),fixedVarIndex,...
        'Не найден период первого решения второго семейства при N = 6');
    end
    
    function testGetsSecondFamilySecondSolutionPeriodForNEqualTo5(testCase)
      N = 5;
      fixedVarIndex = 3;   
      testCase.setupSolutionsToLoad(N,fixedVarIndex);
      testCase.act();      
      vars = testCase.solutionsToReturnFromLoadFamilySolutions(arrayfun(...
        @(s) strcmp(s.familyName,'family2'),...
        testCase.solutionsToReturnFromLoadFamilySolutions));
      testCase.verifyGotPeriod(vars.solutions(1),fixedVarIndex,...
        'Не найден период второго решения второго семейства при N = 5');
    end
    
    function testGetsSecondFamilySecondSolutionPeriodForNEqualTo6(testCase)
      N = 6;
      fixedVarIndex = 4;     
      testCase.setupSolutionsToLoad(N,fixedVarIndex);
      testCase.act();      
      vars = testCase.solutionsToReturnFromLoadFamilySolutions(arrayfun(...
        @(s) strcmp(s.familyName,'family2'),...
        testCase.solutionsToReturnFromLoadFamilySolutions));
      testCase.verifyGotPeriod(vars.solutions(1),fixedVarIndex,...
        'Не найден период второго решения второго семейства при N = 6');
    end
    
    function testPlotsFirstFamilyPeriods(testCase)
      N = 5;
      fixedVarIndex = 3;
      testCase.setupSolutionsToLoad(N,fixedVarIndex);
      testCase.act();
      expX = [0 1];
      expY = [10 20];
      testCase.verifyFalse(isempty(find(arrayfun(...
          @(c) strcmp(c.fcn,'plot') && isequal(c.args.X,expX)...
            && isequal(c.args.Y,expY)...
            && ~isempty(strfind(c.args.LineSpec,'-')),...
          testCase.callSequence),1)),...
        'Не выведены периоды решений первого семейства');
    end
    
    function testAddsSecondFamilyPeriodsPlotToFirstFamilyPeriodsPlot(testCase)
      N = 5;
      fixedVarIndex = 3;
      testCase.setupSolutionsToLoad(N,fixedVarIndex);
      testCase.act();
      
      expX = [0 1];
      expY = [10 20];
      
      firstFamilyPlotCall = testCase.callSequence(...
        arrayfun(@(c) strcmp(c.fcn,'plot') && isequal(c.args.X,expX)...
          && isequal(c.args.Y,expY)...
          && ~isempty(strfind(c.args.LineSpec,'-')),...
          testCase.callSequence));
      
      expX = [0 1];
      expY = [30 40];
      secondFamilyPlotCallIndex = find(arrayfun(...
        @(c) strcmp(c.fcn,'plot') && isequal(c.args.X,expX)...
          && isequal(c.args.Y,expY)...
          && ~isempty(strfind(c.args.LineSpec,'-'))...
          && c.args.axesHandle == ...
              firstFamilyPlotCall.args.axesHandle,...
        testCase.callSequence));
      
      holdCallIndex = find(arrayfun(...
        @(c) strcmp(c.fcn,'hold') && strcmp(c.args.arg,'on')...
          && c.args.axesHandle == firstFamilyPlotCall.args.axesHandle,...
        testCase.callSequence));
               
      testCase.verifyTrue(secondFamilyPlotCallIndex > holdCallIndex,...
        'Вывод периодов решений второго семейства не добавлен к выводу периодов решений первого семейства');      
    end
  end
    
end

