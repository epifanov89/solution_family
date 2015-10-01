function solutions = doLoadFamilySolutions( doLoadFamilySolutionsCore,...
  familyName,varargin )

solutions = doLoadFamilySolutionsCore(@currentDirName,@dir,...
  @load,familyName,varargin{:});
end

