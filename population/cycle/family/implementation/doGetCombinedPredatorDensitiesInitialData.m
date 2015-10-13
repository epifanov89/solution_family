function ic = doGetCombinedPredatorDensitiesInitialData(...
  doGetCombinedPredatorDensitiesInitialDataCore,...
  zeroFirstPredatorSolutionResultsFilename,nsol,solno)
%DOGETCOMBINEDPREDATORDENSITIESINITIALDATA —оздает начальные данные 
%с плотност€ми попул€ций хищников, представл€ющими собой линейную 
%комбинацию максимальной плотности второй попул€ции хищников дл€ решени€ из
%начальных данных с нулевой плотностью первой попул€ции хищников
%   Detailed explanation goes here

ic = doGetCombinedPredatorDensitiesInitialDataCore(...
  zeroFirstPredatorSolutionResultsFilename,nsol,solno,@currentDirName,...
  @load,@getLastRowWithExtremeElementValue);
end

