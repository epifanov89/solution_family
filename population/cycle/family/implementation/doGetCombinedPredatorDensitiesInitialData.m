function ic = doGetCombinedPredatorDensitiesInitialData(...
  doGetCombinedPredatorDensitiesInitialDataCore,...
  zeroFirstPredatorSolutionResultsFilename,nsol,solno)
%DOGETCOMBINEDPREDATORDENSITIESINITIALDATA ������� ��������� ������ 
%� ����������� ��������� ��������, ��������������� ����� �������� 
%���������� ������������ ��������� ������ ��������� �������� ��� ������� ��
%��������� ������ � ������� ���������� ������ ��������� ��������
%   Detailed explanation goes here

ic = doGetCombinedPredatorDensitiesInitialDataCore(...
  zeroFirstPredatorSolutionResultsFilename,nsol,solno,@currentDirName,...
  @load,@getLastRowWithExtremeElementValue);
end

