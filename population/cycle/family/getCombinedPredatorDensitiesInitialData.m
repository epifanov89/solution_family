function ic = getCombinedPredatorDensitiesInitialData(...
  zeroFirstPredatorSolutionResultsFilename,nsol,solno)
%GETCOMBINEDPREDATORDENSITIESINITIALDATA —оздает начальные данные с 
%плотност€ми попул€ций хищников, представл€ющими собой линейную комбинацию 
%максимальной плотности второй попул€ции хищников дл€ решени€ из начальных 
%данных с нулевой плотностью первой попул€ции хищников

ic = doGetCombinedPredatorDensitiesInitialData(...
  @doGetCombinedPredatorDensitiesInitialDataCore,...
  zeroFirstPredatorSolutionResultsFilename,nsol,solno);
end

