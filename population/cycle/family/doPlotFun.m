function doPlotFun( doPlotFunCore,fun,xlabelStr,ylabelStr,fontSize,...
  varargin )

doPlotFunCore(@close,@axes,@fplot,@xlabel,@ylabel,@set,fun,...
  xlabelStr,ylabelStr,fontSize,varargin{:});
end

