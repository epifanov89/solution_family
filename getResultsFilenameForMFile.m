function filepath = getResultsFilenameForMFile( filepath,dir )

backslashIndexArr = strfind(filepath,'\');
lastBackslashIndex = backslashIndexArr(end);
basepath = substr(filepath,0,lastBackslashIndex);
filename = substr(filepath,lastBackslashIndex,...
  length(filepath)-lastBackslashIndex);
filepath = strcat(basepath,dir,filename,'.mat');
end

