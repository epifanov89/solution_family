function res = getSolutionTillMinFirstPredatorDensity( sol,startIndex )

  sz = size(sol);
  
  if nargin < 2
    startIndex = sz(1);
  end

  row = startIndex;
  res = sol(row,:);

  N = sz(2)/3;

  % »ндекс средней точки разбиени€
  centerPointIndex = fix((N+2)/2);

  % »ндексы переменных, отвечающих плотност€м попул€ций в средней
  % точке ареала
  firstPredatorCenterPointVarIndex = N+centerPointIndex;

  row = startIndex-1;
  
  while row >= 1 ...
      && sol(row,firstPredatorCenterPointVarIndex) <= ...
         sol(row+1,firstPredatorCenterPointVarIndex)
    res = [res;sol(row,:)];
    row = row-1;
  end
end

