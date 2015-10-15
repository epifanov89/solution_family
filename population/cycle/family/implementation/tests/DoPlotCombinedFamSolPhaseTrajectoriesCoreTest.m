classdef DoPlotCombinedFamSolPhaseTrajectoriesCoreTest < ...
    FakeCurrentDirNameHelper & MultipleLoadTestHelper...
      & MultiplePlotsOnSameFigureSingleFigureTestHelper
  
  properties
    npt
    plottedPoints
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.npt = 200;      
      testCase.plottedLines = {};
    end
  end
  
  methods
    function setupFamForNEqualTo3(testCase)
      [nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      testCase.setupFam(nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function setupFamForNEqualTo4(testCase)
      [nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo4();
      testCase.setupFam(nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function setupFam(testCase,nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,secondPredatorCenterPointVarIndex)
      testCase.dirname = 'dir\';
      
      solNo = 0;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\4.mat';
      setupSol();
      
      solNo = 1;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\5.mat';
      setupSol();
      
      solNo = 2;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\6.mat';
      setupSol();
      
      solNo = 3;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\7.mat';
      setupSol();
      
      solNo = 4;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\8.mat';
      setupSol();
      
      solNo = 5;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\9.mat';
      setupSol();
      
      solNo = 6;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\10.mat';
      setupSol();
      
      nfamvar = testCase.getNFamVar(nvar);
         
      solNo = 3;
      offset = nfamvar;
      setupSolPtsWithExtremeVarVals();
      
      for solNo = 4:6
        setupSolPtsWithExtremeVarVals();
      end
      
      function setupSol()
        loadedVars = struct;
        loadedVars.filename = filename;
        vars = struct;
        vars.w = testCase.getSol(solNo,nvar);
        loadedVars.vars = vars;
        testCase.varsToLoad = [testCase.varsToLoad,loadedVars];
      end
      
      function setupSolPtsWithExtremeVarVals()
        varIndex = preyCenterPointVarIndex;
        setupPtsWithExtremeVarVals();        

        varIndex = firstPredatorCenterPointVarIndex;
        setupPtsWithExtremeVarVals();

        varIndex = secondPredatorCenterPointVarIndex;
        setupPtsWithExtremeVarVals();
        
        function setupPtsWithExtremeVarVals()
          extremeValueKind = 'min';          
          setupPtWithExtremeVarVal();
                    
          offset = offset+2*nvar;
          
          extremeValueKind = 'max';
          setupPtWithExtremeVarVal();
          
          offset = offset+nvar;
          
          function setupPtWithExtremeVarVal()
            args = struct;
            sol = testCase.getSol(solNo,nvar);
            args.sol = sol;
            args.colIndex = varIndex;
            args.extremeValueKind = extremeValueKind;
            args.row = offset+1:offset+nvar;
            testCase.varsToReturnFromGetLastRowWithExtremeElementValue = ...
              [testCase.varsToReturnFromGetLastRowWithExtremeElementValue,...
                args];
          end
        end
      end
    end
    
    function [row,rowIndex] = fakeGetLastRowWithExtremeElementValue(...
        testCase,sol,colIndex,extremeValueKind)    
      vars = getArrayItems(@(args) isequal(args.sol,sol)...
          && args.colIndex == colIndex...
          && strcmp(args.extremeValueKind,extremeValueKind),...
        testCase.varsToReturnFromGetLastRowWithExtremeElementValue);

      if isfield(vars,'row')
        row = vars.row;
      else
        row = [];
      end
      
      rowIndex = [];
    end    
    
    function h = fakePlot3(testCase,X,Y,Z,LineSpec,varargin)     
      npt = length(X);
      isptplot = ~isempty(strfind(LineSpec,'o'));
      islineplot = ~isptplot || ~isempty(strfind(LineSpec,'-'));      
      ndim = 3;
      line = zeros(npt,ndim);
      for pointIndex = 1:npt
        pt = [X(pointIndex),Y(pointIndex),Z(pointIndex)];
        if islineplot
          line(pointIndex,:) = pt;
        end
        if isptplot
          testCase.plottedPoints = [testCase.plottedPoints,pt];
        end
      end
      
      testCase.plottedLines = [testCase.plottedLines,line];
      
      callInfo = testCase.processPlotCall();
      testCase.callSequence = [testCase.callSequence,callInfo];
      
      h = [];
    end
    
    function sol = getSol(testCase,solNo,nvar)
      offset = testCase.getNSolsVar(solNo,nvar);
      sol = zeros(testCase.npt,nvar);
      for row = 1:testCase.npt
        rowOffset = offset+(row-1)*nvar;
        sol(row,:) = rowOffset+1:rowOffset+nvar;
      end
    end
    
    function verifyCyclePlottedForNEqualTo3(testCase,solNo,msgStart)
      N = 3;
      [nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      testCase.verifyCyclePlotted(solNo,N,nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex,msgStart);
    end
    
    function verifyCyclePlottedForNEqualTo4(testCase,solNo,msgStart)
      N = 4;
      [nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo4();
      testCase.verifyCyclePlotted(solNo,N,nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex,msgStart);
    end
    
    function verifyCyclePlotted(testCase,solNo,N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex,msgStart)
      testCase.setupFam(nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      testCase.dirname = 'dir\';      
      testCase.act();
      nplotpt = 100;      
      offset = (testCase.npt*(solNo+1)-nplotpt)*nvar;     
      ndim = 3;
      line = zeros(nplotpt,ndim);
      for row = 1:nplotpt
        rowOffset = offset+(row-1)*nvar;
        line(row,1) = rowOffset+preyCenterPointVarIndex;
        line(row,2) = rowOffset+firstPredatorCenterPointVarIndex;
        line(row,3) = rowOffset+secondPredatorCenterPointVarIndex;
      end
      testCase.verifyContainsItem(testCase.plottedLines,line,...
        testCase.getMsg(msgStart,N));
    end
    
    function verifyEquilibriumPlottedForNEqualTo3(testCase,solNo,msgStart)
      N = 3;
      [nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      testCase.verifyEquilibriumPlotted(solNo,N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex,msgStart);
    end
    
    function verifyEquilibriumPlottedForNEqualTo4(testCase,solNo,msgStart)
      N = 4;
      [nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo4();
      testCase.verifyEquilibriumPlotted(solNo,N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex,msgStart);
    end
    
    function verifyEquilibriumPlotted(testCase,solNo,N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex,msgStart)
      testCase.setupFam(nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      testCase.dirname = 'dir\';      
      testCase.plottedPoints = {};
      testCase.act();    
      offset = (testCase.npt*(solNo+1)-1)*nvar;     
      pt = [offset+preyCenterPointVarIndex,...
        offset+firstPredatorCenterPointVarIndex,...
        offset+secondPredatorCenterPointVarIndex];
      testCase.verifyContainsItem(testCase.plottedPoints,pt,...
        testCase.getMsg(msgStart,N));
    end
    
    function verifyLineConnectingEquilibriaPlotted(testCase,N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex)
      testCase.setupFam(nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      
      testCase.act();
      
      nequilibrium = 3;
      offset = (testCase.npt-1)*nvar;
      ndim = 3;
      line = zeros(nequilibrium,ndim);
      for pt = 1:nequilibrium
        ptOffset = offset+(pt-1)*testCase.npt*nvar;
        line(pt,1) = ptOffset+preyCenterPointVarIndex;
        line(pt,2) = ptOffset+firstPredatorCenterPointVarIndex;
        line(pt,3) = ptOffset+secondPredatorCenterPointVarIndex;
      end
      testCase.verifyContainsItem(testCase.plottedLines,line,...
        testCase.getMsg(...
          'Ќе выведена лини€, соедин€юща€ равновеси€ семейства',N));      
    end
    
    function verifyFamAxisPlotted(testCase,N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex)   
      testCase.setupFam(nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      
      testCase.act();
            
      nDashedLineConnectedPt = 5;
      
      ndim = 3;
      line = zeros(nDashedLineConnectedPt,ndim);
      
      equilibriumNo = 2;
      offset = equilibriumNo*testCase.npt*nvar+(testCase.npt-1)*nvar;
      line(1,1) = offset+preyCenterPointVarIndex;
      line(1,2) = offset+firstPredatorCenterPointVarIndex;
      line(1,3) = offset+secondPredatorCenterPointVarIndex;
      
      nfamvar = testCase.getNFamVar(nvar);
      offset = nfamvar+nvar;
      cycleDimMeanOffset = 3*nvar;
      for pt = 2:nDashedLineConnectedPt
        line(pt,1) = offset+preyCenterPointVarIndex;
        offset = offset+cycleDimMeanOffset;
        line(pt,2) = offset+firstPredatorCenterPointVarIndex;
        offset = offset+cycleDimMeanOffset;
        line(pt,3) = offset+secondPredatorCenterPointVarIndex;
        offset = offset+cycleDimMeanOffset;
      end
      
      testCase.verifyContainsItem(testCase.plottedLines,line,...
        testCase.getMsg('Ќе выведена ось циклов семейства',N));
    end
    
    function verifyCycleMeanValPlottedForNEqualTo3(testCase,cycleNo,...
        msgStart)
      N = 3;
      [nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      testCase.verifyCycleMeanValPlotted(cycleNo,N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex,msgStart);   
    end
    
    function verifyCycleMeanValPlottedForNEqualTo4(testCase,cycleNo,...
        msgStart)
      N = 4;
      [nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo4();
      testCase.verifyCycleMeanValPlotted(cycleNo,N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex,msgStart);   
    end
    
    function verifyCycleMeanValPlotted(testCase,cycleNo,N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex,msgStart)         
      testCase.setupFam(nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      testCase.plottedPoints = {};
      testCase.act();
      nfamvar = testCase.getNFamVar(nvar);
      ndim = 3;
      offset = nfamvar+nvar+cycleNo*3*ndim*nvar;
      pt = [offset+preyCenterPointVarIndex,...
        offset+3*nvar+firstPredatorCenterPointVarIndex,...
        offset+6*nvar+secondPredatorCenterPointVarIndex];
      testCase.verifyContainsItem(testCase.plottedPoints,pt,...
        testCase.getMsg(msgStart,N));
    end
      
    function [nvar,preyCenterPointVarIndex,...
          firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        getVarNumberAndIndicesForNEqualTo3(~)
      nvar = 9;
      preyCenterPointVarIndex = 2;
      firstPredatorCenterPointVarIndex = 5;
      secondPredatorCenterPointVarIndex = 8;
    end
    
    function [nvar,preyCenterPointVarIndex,...
          firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        getVarNumberAndIndicesForNEqualTo4(~)
      nvar = 12;
      preyCenterPointVarIndex = 3;
      firstPredatorCenterPointVarIndex = 7;
      secondPredatorCenterPointVarIndex = 11;
    end
    
    function nfamvar = getNFamVar(testCase,nvar)
      nsol = 11;
      nfamvar = testCase.getNSolsVar(nsol,nvar);
    end
    
    function nvar = getNSolsVar(testCase,nsol,nvar)
      nvar = nsol*testCase.npt*nvar;
    end
  end
  
  methods (Access = protected)
    function act(testCase)
      doPlotCombinedFamSolPhaseTrajectoriesCore(...
        @testCase.fakeCurrentDirName,@testCase.fakeLoad,...
        @testCase.fakeGetLastRowWithExtremeElementValue,...
        @testCase.fakePlot3,@testCase.fakeHold,@testCase.fakeLabel,...
        @testCase.fakeXLabel,@testCase.fakeYLabel,@testCase.fakeZLabel,...
        @testCase.fakeGCA,@testCase.fakeSet);
    end
  end
  
  methods (Test)    
    function testPlotsSol5LastPtForNEqualTo3(testCase)
      solNo = 0;
      testCase.verifyEquilibriumPlottedForNEqualTo3(solNo,...
        'Ќе выведено п€тое решение семейства');
    end
    
    function testPlotsSol5LastPtForNEqualTo4(testCase)
      solNo = 0;
      testCase.verifyEquilibriumPlottedForNEqualTo4(solNo,...
        'Ќе выведено п€тое решение семейства');
    end
    
    function testPlotsSol6LastPtForNEqualTo3(testCase)
      solNo = 1;
      testCase.verifyEquilibriumPlottedForNEqualTo3(solNo,...
        'Ќе выведено шестое решение семейства');
    end
    
    function testPlotsSol6LastPtForNEqualTo4(testCase)
      solNo = 1;
      testCase.verifyEquilibriumPlottedForNEqualTo4(solNo,...
        'Ќе выведено шестое решение семейства');
    end
    
    function testPlotsSol7LastPtForNEqualTo3(testCase)
      solNo = 2;
      testCase.verifyEquilibriumPlottedForNEqualTo3(solNo,...
        'Ќе выведено седьмое решение семейства');
    end
    
    function testPlotsSol7LastPtForNEqualTo4(testCase)
      solNo = 2;
      testCase.verifyEquilibriumPlottedForNEqualTo4(solNo,...
        'Ќе выведено седьмое решение семейства');
    end
    
    function testPlotsFamSol8TrajectoryForNEqualTo3(testCase)
      solNo = 3;
      testCase.verifyCyclePlottedForNEqualTo3(solNo,...
        'Ќе выведено восьмое решение семейства');
    end
    
    function testPlotsFamSol8TrajectoryForNEqualTo4(testCase)
      solNo = 3;
      testCase.verifyCyclePlottedForNEqualTo4(solNo,...
        'Ќе выведено восьмое решение семейства');
    end
    
    function testPlotsCycle1MeanValForNEqualTo3(testCase)
      cycleNo = 0;
      testCase.verifyCycleMeanValPlottedForNEqualTo3(cycleNo,...
        'Ќе выведена средн€€ точка 1-го цикла семейства');
    end
    
    function testPlotsCycle1MeanValForNEqualTo4(testCase)
      cycleNo = 0;
      testCase.verifyCycleMeanValPlottedForNEqualTo4(cycleNo,...
        'Ќе выведена средн€€ точка 1-го цикла семейства');
    end
    
    function testPlotsCycle2MeanValForNEqualTo3(testCase)
      cycleNo = 1;
      testCase.verifyCycleMeanValPlottedForNEqualTo3(cycleNo,...
        'Ќе выведена средн€€ точка 2-го цикла семейства');
    end
    
    function testPlotsCycle2MeanValForNEqualTo4(testCase)
      cycleNo = 1;
      testCase.verifyCycleMeanValPlottedForNEqualTo4(cycleNo,...
        'Ќе выведена средн€€ точка 2-го цикла семейства');
    end
    
    function testPlotsCycle3MeanValForNEqualTo3(testCase)
      cycleNo = 2;
      testCase.verifyCycleMeanValPlottedForNEqualTo3(cycleNo,...
        'Ќе выведена средн€€ точка 3-го цикла семейства');
    end
    
    function testPlotsCycle3MeanValForNEqualTo4(testCase)
      cycleNo = 2;
      testCase.verifyCycleMeanValPlottedForNEqualTo4(cycleNo,...
        'Ќе выведена средн€€ точка 3-го цикла семейства');
    end
    
    function testPlotsCycle4MeanValForNEqualTo3(testCase)
      cycleNo = 3;
      testCase.verifyCycleMeanValPlottedForNEqualTo3(cycleNo,...
        'Ќе выведена средн€€ точка 4-го цикла семейства');
    end
    
    function testPlotsCycle4MeanValForNEqualTo4(testCase)
      cycleNo = 3;
      testCase.verifyCycleMeanValPlottedForNEqualTo4(cycleNo,...
        'Ќе выведена средн€€ точка 4-го цикла семейства');
    end
    
    function testPlotsFamSol9TrajectoryForNEqualTo3(testCase)
      solNo = 4;
      testCase.verifyCyclePlottedForNEqualTo3(solNo,...
        'Ќе выведено дев€тое решение семейства');
    end
    
    function testPlotsFamSol9TrajectoryForNEqualTo4(testCase)
      solNo = 4;
      testCase.verifyCyclePlottedForNEqualTo4(solNo,...
        'Ќе выведено дев€тое решение семейства');
    end
    
    function testPlotsFamSol10TrajectoryForNEqualTo3(testCase)
      solNo = 5;
      testCase.verifyCyclePlottedForNEqualTo3(solNo,...
        'Ќе выведено дес€тое решение семейства');
    end
    
    function testPlotsFamSol10TrajectoryForNEqualTo4(testCase)
      solNo = 5;
      testCase.verifyCyclePlottedForNEqualTo4(solNo,...
        'Ќе выведено дес€тое решение семейства');
    end
    
    function testPlotsFamSol11TrajectoryForNEqualTo3(testCase)
      solNo = 6;
      testCase.verifyCyclePlottedForNEqualTo3(solNo,...
        'Ќе выведено одиннадцатое решение семейства');
    end
    
    function testPlotsFamSol11TrajectoryForNEqualTo4(testCase)
      solNo = 6;
      testCase.verifyCyclePlottedForNEqualTo4(solNo,...
        'Ќе выведено одиннадцатое решение семейства');
    end
    
    function testPlotsLineConnectingEquilibriaForNEqualTo3(testCase)
      N = 3;
      [nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      testCase.verifyLineConnectingEquilibriaPlotted(N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function testPlotsLineConnectingEquilibriaForNEqualTo4(testCase)
      N = 4;
      [nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo4();
      testCase.verifyLineConnectingEquilibriaPlotted(N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function testPlotsFamAxisForNEqualTo3(testCase)   
      N = 3;
      [nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();      
      testCase.verifyFamAxisPlotted(N,nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function testPlotsFamAxisForNEqualTo4(testCase)
      N = 4;
      [nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo4();           
      testCase.verifyFamAxisPlotted(N,nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function testDoesNotOverwritePlots(testCase)
      testCase.setupFamForNEqualTo3();
      testCase.verifyPlotsAreNotOverwrited();
    end
  end
  
end

