function doPlotPeriodVarianceWithSolutionNoCore( familyNames,...
  loadFamilySolutions,getPeriod,axes,hold,plot,label,set,xlbl,ylbl )

nfamily = length(familyNames);
periods = cell(1,nfamily);

for familyIndex = 1:length(familyNames)
  solutions = loadFamilySolutions(familyNames{familyIndex},'t','w');

  sol1 = solutions(1);

  sz = size(sol1.w);
  nspecies = 3;
  N = sz(2)/nspecies;

  centerPointIndex = fix((N+2)/2);

  preyCenterPointVarIndex = centerPointIndex;

  fixedVarIndex = preyCenterPointVarIndex;
  fixedVarValue = 0.5;

  nsol = length(solutions);
  familyPeriods = zeros(1,nsol);
  
  for solno = 1:nsol
    sol = solutions(solno);
    familyPeriods(solno) = getPeriod(sol.t,sol.w,fixedVarIndex,fixedVarValue);
  end
  
  periods{familyIndex} = familyPeriods;
end

numbers = linspace(0,1,nsol);

h = axes();

hold(h,'on');

for familyIndex = 1:length(familyNames)  
  l = plot(h,numbers,periods{familyIndex},'k-','Linewidth',2);
  label(l,num2str(familyIndex),'FontSize',18,'FontName','Times');
end

set(h,'FontSize',18,'FontName','Times','XTick',[0 0.4 0.8],...
  'YTick',[11 12 13]);

xlbl('$\theta$','FontSize',18,'FontName','Times','Interpreter','latex');
ylbl('$T$','rot',0,'FontSize',18,'FontName','Times','Interpreter','latex');

end

