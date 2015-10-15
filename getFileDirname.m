function dirname = getFileDirname( filename )

dirSeparatorIndexes = strfind(filename,'\');
lastDirSeparatorIndex = dirSeparatorIndexes(end-1);
dirname = substr(filename,0,lastDirSeparatorIndex);
end

