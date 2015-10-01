function doPlotFunCore( close,axes,fplot,xlabel,ylabel,set,fun,...
  xlabelStr,ylabelStr,fontSize,varargin )

close('all');
h = axes();
fplot(h,fun,[0 1],'k');
set(h,'FontSize',fontSize,'FontName','Times',varargin{:});
xlabel(h,xlabelStr,'FontSize',fontSize,'FontName','Times','Interpreter','latex');
ylabel(h,ylabelStr,'rot',0,'FontSize',fontSize,...
  'FontName','Times','Interpreter','latex');
end

