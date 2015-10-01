function [row,rowIndex] = getLastRowWithExtremeElementValue( matr,...
  colIndex,extremeValueKind,rowIndexStart )

if nargin >= 4
  rowIndex = rowIndexStart;
else
  sz = size(matr);
  rowIndex = sz(1);
end

while rowIndex > 1 && (strcmp(extremeValueKind,'max')...
    && matr(rowIndex-1,colIndex) <= matr(rowIndex,colIndex)...
    || strcmp(extremeValueKind,'min')...
    && matr(rowIndex-1,colIndex) >= matr(rowIndex,colIndex))  
  rowIndex = rowIndex-1;
end

while rowIndex > 1 && (strcmp(extremeValueKind,'max')...
    && matr(rowIndex-1,colIndex) >= matr(rowIndex,colIndex)...
    || strcmp(extremeValueKind,'min')...
    && matr(rowIndex-1,colIndex) <= matr(rowIndex,colIndex))
  rowIndex = rowIndex-1;  
end

row = matr(rowIndex,:);

end

