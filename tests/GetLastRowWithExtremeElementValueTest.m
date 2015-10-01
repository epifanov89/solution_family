classdef GetLastRowWithExtremeElementValueTest < matlab.unittest.TestCase
  
  properties
    matr
    colIndex
    extremeValueKind
    rowIndexStart
  end
  
  methods
    function setupForMax(testCase)
      testCase.matr = [1 1 1 1
                       0 2 0 0
                       1 1 1 1
                       3 3 3 3
                       1 1 1 1];
      testCase.colIndex = 2;
      testCase.extremeValueKind = 'max';
      testCase.rowIndexStart = 4;
    end
    
    function setupForMin(testCase)
      testCase.matr = [1 1 1 1
                       2 2 2 2
                       3 1 3 3
                       2 2 2 2
                       5 1 5 5
                       2 2 2 2];
      testCase.colIndex = 2;
      testCase.extremeValueKind = 'min';
      testCase.rowIndexStart = 5;
    end
    
    function [row,rowIndex] = act(testCase)
      [row,rowIndex] = getLastRowWithExtremeElementValue(testCase.matr,...
        testCase.colIndex,testCase.extremeValueKind,testCase.rowIndexStart);
    end
  end
  
  methods (Test)
    function testReturnsLastRowWithMaxElementValue(testCase)
      testCase.setupForMax();
      [actRow,~] = testCase.act();
      expRow = [0 2 0 0];
      testCase.verifyEqual(actRow,expRow,...
        'Не возвращена последняя строка с максимальным значением элемента в столбце с переданным индексом');
    end
    
    function testReturnsIndexOfLastRowWithMaxElementValue(testCase)
      testCase.setupForMax();
      [~,actRowIndex] = testCase.act();
      expRowIndex = 2;
      testCase.verifyEqual(actRowIndex,expRowIndex,...
        'Не возвращен индекс последней строки с максимальным значением элемента в столбце с переданным индексом');
    end
    
    function testReturnsLastRowWithMinElementValue(testCase)
      testCase.setupForMin();
      [actRow,~] = testCase.act();
      expRow = [3 1 3 3];
      testCase.verifyEqual(actRow,expRow,...
        'Не возвращена последняя строка с минимальным значением элемента в столбце с переданным индексом');
    end
    
    function testReturnsIndexOfLastRowWithMinElementValue(testCase)
      testCase.setupForMin();
      [~,actRowIndex] = testCase.act();
      expRowIndex = 3;
      testCase.verifyEqual(actRowIndex,expRowIndex,...
        'Не возвращен индекс последней строки с минимальным значением элемента в столбце с переданным индексом');
    end
    
    function testReturnsLastRowWithExtremeElementValueWhenRowIndexStartIsNotPassed(testCase)
      testCase.setupForMin();
      [actRow,~] = getLastRowWithExtremeElementValue(...
        testCase.matr,testCase.colIndex,testCase.extremeValueKind);
      expRow = [5 1 5 5];
      testCase.verifyEqual(actRow,expRow,...
        'Не возвращена последняя строка с минимальным значением элемента в столбце с переданным индексом');
    end
  end
  
end

