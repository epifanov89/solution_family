function saveStruct( filename,S,isAppend )
%SAVESTRUCT ��������� ���������� �� ��������� � ����
%   ��������� ��������� � ������� �������� ��� ������������ ����, ���
%   ��������� ������ ��������

if nargin < 3
  isAppend = false;
end
doSaveStruct(@save,filename,S,isAppend);
end

