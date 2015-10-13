classdef DoPlotTillSteadyCoreTest < TestCaseBase
  
  properties
    resultsFilename
    plottedPoints
    plottedLines
    callSequence
        
    tstart
    tspan
    XAxisGap
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.dirname = 'dir\';
      testCase.resultsFilename = 'results.mat';
      
      testCase.plottedPoints = [];
      testCase.plottedLines = {};
      testCase.callSequence = [];
            
      testCase.tstart = 200;
      testCase.tspan = 100;
      testCase.XAxisGap = 50;
    end
  end
  
  methods    
    function fakePlot(testCase,X,Y,LineSpec,varargin)
      islineplot = ~isempty(strfind(LineSpec,'-'));
      npoint = length(X);
      line = zeros(npoint,2);
      for pointIndex = 1:npoint
        point = [X(pointIndex),Y(pointIndex)];
        if islineplot
          line(pointIndex,:) = point;
        else
          testCase.plottedPoints = [testCase.plottedPoints;point];
        end
      end
      
      if islineplot
        testCase.plottedLines = [testCase.plottedLines,line];
      end
      
      callInfo = struct;
      callInfo.fcn = 'plot';
      args = struct;
      args.X = X;
      args.Y = Y;
      callInfo.args = args;
      testCase.callSequence = [testCase.callSequence,callInfo];
    end
    
    function fakeXLabel(testCase,str,varargin)      
      callInfo = struct;
      callInfo.fcn = 'xlabel';
      argsInfo = struct;
      argsInfo.str = str;
      callInfo.args = argsInfo;
      testCase.callSequence = [testCase.callSequence,callInfo];
    end
    
    function fakeYLabel(testCase,str,varargin)      
      callInfo = struct;
      callInfo.fcn = 'ylabel';
      argsInfo = struct;
      argsInfo.str = str;
      callInfo.args = argsInfo;
      testCase.callSequence = [testCase.callSequence,callInfo];
    end
    
    function fakeFigure(testCase)
      callInfo = struct;
      callInfo.fcn = 'figure';
      callInfo.args = struct;
      testCase.callSequence = [testCase.callSequence,callInfo];
    end

    function h = fakeGCA(~)
      h = 1;
    end
    
    function fakeSet(testCase,~,varargin)
      argIndex = 1;
      while argIndex < length(varargin)
        propName = varargin{argIndex};
        propVal = varargin{argIndex+1};        
        graphicsProps.(propName) = propVal;
        argIndex = argIndex+2;
      end
      
      callInfo = struct;
      callInfo.fcn = 'set';
      callInfo.args = graphicsProps;
      
      testCase.callSequence = [testCase.callSequence,callInfo];
    end
    
    function setupSolutionForNEqualTo5(testCase)
      vars = struct;
      tf = testCase.tstart+testCase.tspan;
      vars.t = 0:tf;
      nrow = tf+1;
      N = 5;
      nspecies = 3;
      ncol = N*nspecies;
      w = zeros(nrow,ncol);
      for row = 1:nrow
        w(row,:) = (row-1)*ncol+1:row*ncol;
      end
      vars.w = w;
      
      testCase.varsToLoad = struct;
      testCase.varsToLoad.filename = 'dir\solution_results\results.mat';
      testCase.varsToLoad.vars = vars;
    end
    
    function setupSolutionForNEqualTo6(testCase)      
      vars = struct;
      tf = testCase.tstart+testCase.tspan;
      vars.t = 0:tf;
      nrow = tf+1;
      N = 6;
      nspecies = 3;
      ncol = N*nspecies;
      w = zeros(nrow,ncol);
      for row = 1:nrow
        w(row,:) = (row-1)*ncol+1:row*ncol;
      end
      vars.w = w;
      
      testCase.varsToLoad = struct;
      testCase.varsToLoad.filename = 'dir\solution_results\results.mat';
      testCase.varsToLoad.vars = vars;
    end
  end
  
  methods (Access = protected)
    function act(testCase)
      doPlotTillSteadyCore(testCase.resultsFilename,testCase.tstart,...
        testCase.tspan,testCase.XAxisGap,@testCase.fakeCurrentDirName,...
        @testCase.fakeLoad,@testCase.fakePlot,@testCase.fakeXLabel,...
        @testCase.fakeYLabel,@testCase.fakeFigure,@testCase.fakeGCA,...
        @testCase.fakeSet);
    end
  end
  
  methods (Test)    
    function testPlotsFirstPredatorDensityTimeDependency(testCase)      
      testCase.setupSolutionForNEqualTo5();
      
      testCase.act();
            
      firsttspan = 100;
      
      tfinal = testCase.tstart+testCase.tspan+1;
      
      ncol = 2;
      expLine = zeros(tfinal,ncol);
      expLine(1:firsttspan+1,1) = 0:firsttspan;
      expLine(firsttspan+2:testCase.tstart,1) = NaN;
      XAxisFinal = firsttspan+testCase.XAxisGap+testCase.tspan;
      expLine(testCase.tstart+1:tfinal,1) = ...
        firsttspan+testCase.XAxisGap:XAxisFinal;
      
      nvar = 15;
      firstPredatorCenterPointVarIndex = 8;
      
      for row = 1:firsttspan+1
        expLine(row,ncol) = (row-1)*nvar+firstPredatorCenterPointVarIndex;
      end
      expLine(firsttspan+2:testCase.tstart,ncol) = NaN;
      for row = testCase.tstart+1:tfinal
        expLine(row,ncol) = (row-1)*nvar+firstPredatorCenterPointVarIndex;
      end
      testCase.assertFalse(isempty(find(cellfun(...
        @(line) isequaln(line,expLine),testCase.plottedLines),1)),...
        'Не выведен график зависимости плотности первой популяции хищников в центральной точке ареала от времени');
      
      testCase.setupSolutionForNEqualTo6();
      
      testCase.act();
      
      expLine = zeros(tfinal,2);
      expLine(1:firsttspan+1,1) = 0:1:firsttspan;
      expLine(firsttspan+2:testCase.tstart,1) = NaN;
      expLine(testCase.tstart+1:tfinal,1) = ...
        firsttspan+testCase.XAxisGap:XAxisFinal;
      for row = 1:firsttspan+1
        expLine(row,2) = (row-1)*18+10;
      end
      expLine(firsttspan+2:testCase.tstart,2) = NaN;
      for row = testCase.tstart+1:tfinal
        expLine(row,2) = (row-1)*18+10;
      end
      testCase.verifyFalse(isempty(find(cellfun(...
        @(line) isequaln(line,expLine),testCase.plottedLines),1)),...
        'Не выведен график зависимости плотности первой популяции хищников в центральной точке ареала от времени');
    end
    
    function testPlotsSecondPredatorDensityTimeDependency(testCase)      
      testCase.setupSolutionForNEqualTo5();
      
      testCase.act();
            
      firsttspan = 100;
      
      tfinal = testCase.tstart+testCase.tspan+1;
      
      expLine = zeros(tfinal,2);
      expLine(1:firsttspan+1,1) = 0:1:firsttspan;
      expLine(firsttspan+2:testCase.tstart,1) = NaN;
      XAxisFinal = firsttspan+testCase.XAxisGap+testCase.tspan;
      expLine(testCase.tstart+1:tfinal,1) = ...
        firsttspan+testCase.XAxisGap:1:XAxisFinal;
      for row = 1:firsttspan+1
        expLine(row,2) = (row-1)*15+13;
      end
      expLine(firsttspan+2:testCase.tstart,2) = NaN;
      for row = testCase.tstart+1:tfinal
        expLine(row,2) = (row-1)*15+13;
      end
      testCase.assertFalse(isempty(find(cellfun(...
        @(pt) isequaln(pt,expLine),testCase.plottedLines),1)),...
        'Не выведен график зависимости плотности второй популяции хищников в центральной точке ареала от времени');
      
      testCase.setupSolutionForNEqualTo6();
      
      testCase.act();
      
      expLine = zeros(tfinal,2);
      expLine(1:firsttspan+1,1) = 0:1:firsttspan;
      expLine(firsttspan+2:testCase.tstart,1) = NaN;
      XAxisFinal = firsttspan+testCase.XAxisGap+testCase.tspan;
      expLine(testCase.tstart+1:tfinal,1) = ...
        firsttspan+testCase.XAxisGap:1:XAxisFinal;
      for row = 1:firsttspan+1
        expLine(row,2) = (row-1)*18+16;
      end
      expLine(firsttspan+2:testCase.tstart,2) = NaN;
      for row = testCase.tstart+1:tfinal
        expLine(row,2) = (row-1)*18+16;
      end
      testCase.verifyFalse(isempty(find(cellfun(...
        @(pt) isequaln(pt,expLine),testCase.plottedLines),1)),...
        'Не выведен график зависимости плотности второй популяции хищников в центральной точке ареала от времени');
    end
    
    function testPlotsPredatorsOnDifferentFigures(testCase)
      testCase.setupSolutionForNEqualTo5();
      testCase.act();
      figureCallNo = find(arrayfun(@(call) strcmp(call.fcn,'figure'),...
        testCase.callSequence));
      
      firsttspan = 100;
      tfinal = testCase.tstart+testCase.tspan+1;
      
      expX = zeros(1,tfinal);
      expX(1:firsttspan+1) = 0:1:firsttspan;
      expX(firsttspan+2:testCase.tstart) = NaN;
      XAxisFinal = firsttspan+testCase.XAxisGap+testCase.tspan;
      expX(testCase.tstart+1:tfinal) = ...
        firsttspan+testCase.XAxisGap:1:XAxisFinal;
      
      expY = zeros(1,tfinal);
      for row = 1:firsttspan+1
        expY(row) = (row-1)*15+8;
      end
      expY(firsttspan+2:testCase.tstart) = NaN;
      for row = testCase.tstart+1:tfinal
        expY(row) = (row-1)*15+8;
      end
      
      callInfo = struct;
      callInfo.fcn = 'plot';
      argsInfo = struct;
      argsInfo.X = expX;
      argsInfo.Y = expY;
      callInfo.args = argsInfo;
      
      firstPredatorPlotCallNo = find(arrayfun(...
        @(call) isequaln(call,callInfo),testCase.callSequence));
      
      expX = zeros(1,tfinal);
      expX(1:firsttspan+1) = 0:1:firsttspan;
      expX(firsttspan+2:testCase.tstart) = NaN;
      expX(testCase.tstart+1:tfinal) = ...
        firsttspan+testCase.XAxisGap:1:XAxisFinal;
      
      expY = zeros(1,tfinal);
      for row = 1:firsttspan+1
        expY(row) = (row-1)*15+13;
      end
      expY(firsttspan+2:testCase.tstart) = NaN;
      for row = testCase.tstart+1:tfinal
        expY(row) = (row-1)*15+13;
      end
      
      callInfo = struct;
      callInfo.fcn = 'plot';
      argsInfo = struct;
      argsInfo.X = expX;
      argsInfo.Y = expY;
      callInfo.args = argsInfo;
      
      secondPredatorPlotCallNo = find(arrayfun(...
        @(call) isequaln(call,callInfo),testCase.callSequence));
      
      testCase.assertFalse(isempty(figureCallNo),...
        'Зависимости плотностей популяций хищников от времени не выведены на разных рисунках');
      testCase.assertFalse(isempty(firstPredatorPlotCallNo),...
        'Зависимости плотностей популяций хищников от времени не выведены на разных рисунках');
      testCase.assertFalse(isempty(secondPredatorPlotCallNo),...
        'Зависимости плотностей популяций хищников от времени не выведены на разных рисунках');
      testCase.verifyTrue(figureCallNo(1) > firstPredatorPlotCallNo(1)...
        && figureCallNo(1) < secondPredatorPlotCallNo(1)...
        || figureCallNo(1) < firstPredatorPlotCallNo(1)...
        && figureCallNo(1) > secondPredatorPlotCallNo(1),...
        'Зависимости плотностей популяций хищников от времени не выведены на разных рисунках');
    end
    
    function testPlotsRightFirstFigureTicks(testCase)
      testCase.setupSolutionForNEqualTo5();
      testCase.act();
      
      figureCallNo = find(arrayfun(@(call) strcmp(call.fcn,'figure'),...
        testCase.callSequence));
      
      firsttspan = 100;
      XTickOffset = 50;
      
      setCallNo = find(arrayfun(@(call) strcmp(call.fcn,'set')...
        && isfield(call.args,'XTick')...
        && isequal(call.args.XTick,[0 firsttspan firsttspan+testCase.XAxisGap firsttspan+testCase.XAxisGap+XTickOffset])...
        && isfield(call.args,'XTickLabel')...
        && isequal(call.args.XTickLabel,[0 firsttspan testCase.tstart testCase.tstart+XTickOffset]),...
        testCase.callSequence));
      
      testCase.verifyFalse(isempty(find(setCallNo < figureCallNo(1),1)),...
        'Выведены неправильные засечки оси абсцисс первого рисунка');
    end
    
    function testPlotsRightSecondFigureTicks(testCase)
      testCase.setupSolutionForNEqualTo5();
      testCase.act();
      
      figureCallNo = find(arrayfun(@(call) strcmp(call.fcn,'figure'),...
        testCase.callSequence));
      
      firsttspan = 100;
      XTickOffset = 50;
      
      setCallNo = find(arrayfun(@(call) strcmp(call.fcn,'set')...
        && isfield(call.args,'XTick')...
        && isequal(call.args.XTick,[0 firsttspan firsttspan+testCase.XAxisGap firsttspan+testCase.XAxisGap+XTickOffset])...
        && isfield(call.args,'XTickLabel')...
        && isequal(call.args.XTickLabel,[0 firsttspan testCase.tstart testCase.tstart+XTickOffset]),...
        testCase.callSequence));
      
      testCase.verifyFalse(isempty(find(setCallNo > figureCallNo(1),1)),...
        'Выведены неправильные засечки оси абсцисс второго рисунка');
    end
  end
  
end

