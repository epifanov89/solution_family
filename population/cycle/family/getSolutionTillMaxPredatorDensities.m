function res = getSolutionTillMaxPredatorDensities( sol,ptstart )

  if nargin < 2
    sz = size(sol);
    ptstart = sz(1);
  end
    
  res = sol(ptstart,:);

  sz = size(sol);
  row = ptstart-1;

  N = sz(2)/3;

  % »ндекс средней точки разбиени€
  centerPointIndex = fix((N+2)/2);

  % »ндексы переменных, отвечающих плотност€м попул€ций в средней
  % точке ареала
  firstPredatorCenterPointVarIndex = N+centerPointIndex;
  secondPredatorCenterPointVarIndex = 2*N+centerPointIndex;

  while row >= 0 ...
      && (sol(row,firstPredatorCenterPointVarIndex) >= sol(row+1,firstPredatorCenterPointVarIndex)...
        || sol(row,secondPredatorCenterPointVarIndex) >= sol(row+1,secondPredatorCenterPointVarIndex))
    if sol(row,firstPredatorCenterPointVarIndex) >= sol(row+1,firstPredatorCenterPointVarIndex)...
        && sol(row,secondPredatorCenterPointVarIndex) >= sol(row+1,secondPredatorCenterPointVarIndex)
      res = [res;sol(row,:)];
    else
      error('getSolutionTillMaxPredatorDensities:PredatorsMustVarySimultaneously',...
        '’ищники должны расти или убывать одновременно');
    end  
    row = row-1;
  end
end

