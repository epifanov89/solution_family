function item = getArrayItem( arr,func )

if iscell(arr)
  fun = @cellfun;
else
  fun = @arrayfun;
end
  
item = arr(fun(func,arr));

end

