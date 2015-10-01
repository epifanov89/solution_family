function saveStruct( filename,S,isAppend )
%SAVESTRUCT Сохраняет переменные из структуры в файл
%   Принимает структуру и поэтому подходит для тестирования того, что
%   сохранены нужные значения

if nargin < 3
  isAppend = false;
end
doSaveStruct(@save,filename,S,isAppend);
end

