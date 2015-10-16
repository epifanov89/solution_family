classdef DoCalculateEigsCoreTest < FakeCurrentDirNameHelper...
    & LoadTestHelper
  
  properties
    filename
    matrPassedInToEig
    eigArr
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      vars = struct;
      vars.w = [1 2];
      testCase.varsToLoad = vars;
      
      testCase.rightParts = @(~,w) [w(1)^2 w(2)^2];
    end
  end
  
  methods
    function eigs = fakeEig(testCase,matr)
      testCase.matrPassedInToEig = matr;
      eigs = testCase.eigArr;
    end
  end
  
  methods (Access = protected)
    function act(testCase)
      doCalculateEigsCore(@testCase.fakeCurrentDirName,...
        @testCase.fakeLoad,@testCase.fakeGetSystem,@testCase.fakeEig,...
        @testCase.fakeDisp,testCase.filename);
    end
  end  
  
  methods (Test)
    function testLoadsSol(testCase)
      testCase.dirname = 'dir\';
      testCase.filename = 'filename.mat';
      testCase.verifySolutionLoaded(...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\filename.mat',...
        {'w'});
    end    
    
    function testGetsSystem(testCase)
      expPreyDiffusionCoeff = 0.2;
      expSecondPredatorDiffusionCoeff = 0.24;
      expFirstPredatorMortality = 1.2;
      expResourceVariation = 0.5;
      expN = 24;
      testCase.verifyGetsSystem(expPreyDiffusionCoeff,...
        expSecondPredatorDiffusionCoeff,expFirstPredatorMortality,...
        expResourceVariation,expN);
    end
    
    function testCalculatesEigs(testCase)
      testCase.act();
      eps = 1e-7;
      expMatr = [2+eps 0
                 0      4+eps];
      err = 0.1*eps;
      testCase.assertGreaterThan(testCase.matrPassedInToEig(1,1),...
        expMatr(1,1)-err,'Не рассчитаны СЗ матрицы Якоби');
      testCase.assertLessThan(testCase.matrPassedInToEig(1,1),...
        expMatr(1,1)+err,'Не рассчитаны СЗ матрицы Якоби');
      testCase.assertEqual(testCase.matrPassedInToEig(1,2),expMatr(1,2),...
        'Не рассчитаны СЗ матрицы Якоби');
      testCase.assertEqual(testCase.matrPassedInToEig(2,1),expMatr(2,1),...
        'Не рассчитаны СЗ матрицы Якоби');
      testCase.assertGreaterThan(testCase.matrPassedInToEig(2,2),...
        expMatr(2,2)-err,'Не рассчитаны СЗ матрицы Якоби');
      testCase.verifyLessThan(testCase.matrPassedInToEig(2,2),...
        expMatr(2,2)+err,'Не рассчитаны СЗ матрицы Якоби');
    end
    
    function testDisplaysEigsSortedByRealPart(testCase)
      testCase.eigArr = [0+2i 1+1i];
      expEigArr = [1+1i 0+2i];
      testCase.verifyDisplayed(expEigArr,...
        'Не выведены СЗ, упорядоченные по убыванию действительной части');
    end
  end
  
end

