function dirname = getFileDirname( filename )

dirSeparatorIndexes = strfind(filename,'\');
lastDirSeparatorIndex = dirSeparatorIndexes(end);
dirname = substr(filename,0,lastDirSeparatorIndex);
end

