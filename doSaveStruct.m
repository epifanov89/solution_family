function doSaveStruct( save,filename,S,isAppend )

if isAppend
  save(filename,'-struct','S','-append');
else
  save(filename,'-struct','S');
end
end

