function ic = getCombinedPredatorDensitiesInitialData(...
  zeroFirstPredatorSolutionResultsFilename,nsol,solno)
%GETCOMBINEDPREDATORDENSITIESINITIALDATA ������� ��������� ������ � 
%����������� ��������� ��������, ��������������� ����� �������� ���������� 
%������������ ��������� ������ ��������� �������� ��� ������� �� ��������� 
%������ � ������� ���������� ������ ��������� ��������

ic = doGetCombinedPredatorDensitiesInitialData(...
  @doGetCombinedPredatorDensitiesInitialDataCore,...
  zeroFirstPredatorSolutionResultsFilename,nsol,solno);
end

