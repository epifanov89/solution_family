function mask = getArrayIndexMask( func,arr )

if iscell(arr)
  fun = @cellfun;
else
  fun = @arrayfun;
end
  
mask = fun(func,arr);
end

