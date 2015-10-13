classdef DoPlotCombinedFamSolPhaseTrajectoriesCoreTest < ...
    FakeCurrentDirNameHelper & MultipleLoadTestHelper...
      & MultiplePlotsOnSameFigureSingleFigureTestHelper
  
  properties
    npt
    argsPassedInToPlot3
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.npt = 200;
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
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\0.mat';
      setupSol();
      
      solNo = 1;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\1.mat';
      setupSol();
      
      solNo = 2;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\2.mat';
      setupSol();
      
      solNo = 3;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\3.mat';
      setupSol();
      
      solNo = 4;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\4.mat';
      setupSol();
      
      solNo = 5;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\5.mat';
      setupSol();
      
      solNo = 6;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\6.mat';
      setupSol();
      
      solNo = 7;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\7.mat';
      setupSol();
      
      solNo = 8;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\8.mat';
      setupSol();
      
      solNo = 9;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\9.mat';
      setupSol();
      
      solNo = 10;
      filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\10.mat';
      setupSol();
      
      nfamvar = testCase.getNFamVar(nvar);
         
      solNo = 7;
      offset = nfamvar;
      setupSolPtsWithExtremeVarVals();
      
      for solNo = 8:10
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
    
    function fakePlot3(testCase,X,Y,Z,varargin)
      args = struct;
      args.X = X;
      args.Y = Y;
      args.Z = Z;
      testCase.argsPassedInToPlot3 = [testCase.argsPassedInToPlot3,args];
      
      callInfo = testCase.processPlotCall();
      testCase.callSequence = [testCase.callSequence,callInfo];
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
      nplotpt = 100;
      testCase.verifySolPlotted(solNo,nplotpt,N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex,msgStart);
    end
    
    function verifySolPlotted(testCase,solNo,nplotpt,N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex,msgStart)
      testCase.setupFam(nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      testCase.dirname = 'dir\';      
      testCase.act();
      expArgs = struct;
      offset = (testCase.npt*(solNo+1)-nplotpt)*nvar;     
      X = zeros(nplotpt,1);
      Y = zeros(nplotpt,1);
      Z = zeros(nplotpt,1);
      for row = 1:nplotpt
        rowOffset = offset+(row-1)*nvar;
        X(row) = rowOffset+preyCenterPointVarIndex;
        Y(row) = rowOffset+firstPredatorCenterPointVarIndex;
        Z(row) = rowOffset+secondPredatorCenterPointVarIndex;
      end
      expArgs.X = X;
      expArgs.Y = Y;
      expArgs.Z = Z;
      testCase.verifyContainsItem(testCase.argsPassedInToPlot3,expArgs,...
        testCase.getMsg(msgStart,N));
    end
    
    function verifyEquilibriaPlotted(testCase,N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex)
      testCase.setupFam(nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      
      testCase.act();
      
      args = struct;
      nequilibrium = 7;
      offset = (testCase.npt-1)*nvar;
      X = zeros(1,nequilibrium);
      Y = zeros(1,nequilibrium);
      Z = zeros(1,nequilibrium);
      for pt = 1:nequilibrium
        ptOffset = offset+(pt-1)*testCase.npt*nvar;
        X(pt) = ptOffset+preyCenterPointVarIndex;
        Y(pt) = ptOffset+firstPredatorCenterPointVarIndex;
        Z(pt) = ptOffset+secondPredatorCenterPointVarIndex;
      end
      args.X = X;
      args.Y = Y;
      args.Z = Z;
      testCase.verifyContainsItem(testCase.argsPassedInToPlot3,args,...
        testCase.getMsg('Ќе выведены равновеси€ семейства',N));      
    end
    
    function verifyFamAxisPlotted(testCase,N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex)   
      testCase.setupFam(nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      
      testCase.act();
            
      args = struct;
      nDashedLineConnectedPt = 5;
      nfamvar = testCase.getNFamVar(nvar);
      offset = nfamvar+nvar;
      X = zeros(1,nDashedLineConnectedPt);
      Y = zeros(1,nDashedLineConnectedPt);
      Z = zeros(1,nDashedLineConnectedPt);
      for pt = 1:nDashedLineConnectedPt-1
        X(pt) = offset+preyCenterPointVarIndex;
        offset = offset+3*nvar;
        Y(pt) = offset+firstPredatorCenterPointVarIndex;
        offset = offset+3*nvar;
        Z(pt) = offset+secondPredatorCenterPointVarIndex;
        offset = offset+3*nvar;
      end
      equilibriumNo = 6;
      offset = equilibriumNo*testCase.npt*nvar+(testCase.npt-1)*nvar;
      X(nDashedLineConnectedPt) = offset+preyCenterPointVarIndex;
      Y(nDashedLineConnectedPt) = offset+firstPredatorCenterPointVarIndex;
      Z(nDashedLineConnectedPt) = offset+secondPredatorCenterPointVarIndex;
      
      args.X = X;
      args.Y = Y;
      args.Z = Z;
      testCase.verifyContainsItem(testCase.argsPassedInToPlot3,args,...
        testCase.getMsg('Ќе выведена ось циклов семейства',N));
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
        @testCase.fakePlot3,@testCase.fakeHold,@testCase.fakeXLabel,...
        @testCase.fakeYLabel,@testCase.fakeZLabel,@testCase.fakeGCA,...
        @testCase.fakeSet);
    end
  end
  
  methods (Test)    
    function testPlotsFamSol7TrajectoryForNEqualTo3(testCase)
      solNo = 7;
      testCase.verifyCyclePlottedForNEqualTo3(solNo,...
        'Ќе выведено восьмое решение семейства');
    end
    
    function testPlotsFamSol7TrajectoryForNEqualTo4(testCase)
      solNo = 7;
      testCase.verifyCyclePlottedForNEqualTo4(solNo,...
        'Ќе выведено восьмое решение семейства');
    end
    
    function testPlotsFamSol8TrajectoryForNEqualTo3(testCase)
      solNo = 8;
      testCase.verifyCyclePlottedForNEqualTo3(solNo,...
        'Ќе выведено дев€тое решение семейства');
    end
    
    function testPlotsFamSol8TrajectoryForNEqualTo4(testCase)
      solNo = 8;
      testCase.verifyCyclePlottedForNEqualTo4(solNo,...
        'Ќе выведено дев€тое решение семейства');
    end
    
    function testPlotsFamSol9TrajectoryForNEqualTo3(testCase)
      solNo = 9;
      testCase.verifyCyclePlottedForNEqualTo3(solNo,...
        'Ќе выведено дес€тое решение семейства');
    end
    
    function testPlotsFamSol9TrajectoryForNEqualTo4(testCase)
      solNo = 9;
      testCase.verifyCyclePlottedForNEqualTo4(solNo,...
        'Ќе выведено дес€тое решение семейства');
    end
    
    function testPlotsFamSol10TrajectoryForNEqualTo3(testCase)
      solNo = 10;
      testCase.verifyCyclePlottedForNEqualTo3(solNo,...
        'Ќе выведено одиннадцатое решение семейства');
    end
    
    function testPlotsFamSol10TrajectoryForNEqualTo4(testCase)
      solNo = 10;
      testCase.verifyCyclePlottedForNEqualTo4(solNo,...
        'Ќе выведено одиннадцатое решение семейства');
    end
    
    function testPlotsEquilibriaForNEqualTo3(testCase)
      N = 3;
      [nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      testCase.verifyEquilibriaPlotted(N,nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function testPlotsEquilibriaForNEqualTo4(testCase)
      N = 4;
      [nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo4();
      testCase.verifyEquilibriaPlotted(N,nvar,preyCenterPointVarIndex,...
        firstPredatorCenterPointVarIndex,...
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

