function res = getSolutionTillMinPredatorDensities( sol,startIndex )

  sz = size(sol);
  npt = sz(1);

  if nargin < 2
    startIndex = npt;
  end

  row = startIndex;
  res = sol(row,:);

  N = sz(2)/3;

  % ������ ������� ����� ���������
  centerPointIndex = fix((N+2)/2);

  % ������� ����������, ���������� ���������� ��������� � �������
  % ����� ������
  firstPredatorCenterPointVarIndex = N+centerPointIndex;
  secondPredatorCenterPointVarIndex = 2*N+centerPointIndex;

  row = startIndex-1;
  
  while row >= 1 ...
      && (sol(row,firstPredatorCenterPointVarIndex) <= sol(row+1,firstPredatorCenterPointVarIndex)...
        || sol(row,secondPredatorCenterPointVarIndex) <= sol(row+1,secondPredatorCenterPointVarIndex))
    if sol(row,firstPredatorCenterPointVarIndex) <= sol(row+1,firstPredatorCenterPointVarIndex)...
        && sol(row,secondPredatorCenterPointVarIndex) <= sol(row+1,secondPredatorCenterPointVarIndex)
      res = [res;sol(row,:)];
    else
      error(...
        'getSolutionTillMinPredatorDensities:PredatorsMustVarySimultaneously',...
        '������� ������ ����� ��� ������� ������������');
    end  
    row = row-1;
  end
end

