function dirname = doGetCurrentDirName( mfilename,getFileDirname )

filename = mfilename('fullpath');
dirname = getFileDirname(filename);
end

