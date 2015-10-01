classdef GetSolutionPartTest < matlab.unittest.TestCase
  
  properties
    t
    w
    ptstart
    tspan
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      nt = 15;
      testCase.t = 1:nt;      
      nvar = 2;
      testCase.w = zeros(nt,nvar);
      for row = 1:nt
        for col = 1:nvar
          testCase.w(row,col) = (row-1)*nvar+col;
        end
      end
      testCase.ptstart = 5;
      testCase.tspan = 5;
    end
  end
  
  methods
    function [tpart,wpart] = act(testCase)
      [tpart,wpart] = getSolutionPart(testCase.t,testCase.w,...
        testCase.ptstart,testCase.tspan);
    end
  end
  
  methods (Test)
    function testReturnsSolutionTPartOnPassedInTSpan(testCase)      
      [acttpart,~] = testCase.act();
      exptpart = 0:5;
      testCase.verifyEqual(acttpart,exptpart,...
        '¬озвращена неправильна€ часть временной компоненты решени€');
    end
    
    function testReturnsSolutionWPartOnPassedInTSpan(testCase)
      [~,actwpart] = testCase.act();
      nrow = 6;
      ncol = 2;
      expwpart = zeros(nrow,ncol);
      for row = 1:nrow
        for col = 1:ncol
          expwpart(row,col) = (testCase.ptstart+row-2)*ncol+col;
        end
      end
      testCase.verifyEqual(actwpart,expwpart,...
        '¬озвращена неправильна€ часть значений зависимых переменных решени€');
    end
  end
  
end

