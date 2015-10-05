function doPlotPredatorSpatiotemporalDistributionsCore(currentDirName,...
  load,getLastRowWithExtremeElementValue,getPeriod,getSolutionPart,...
  subplot,plot3D,set,axis,xlabel,ylabel,zlabel )

curDirName = currentDirName();
loadedVarsA = load(strcat(curDirName,...
  'solution_results\tillsteadyA.mat'),'t','w');

tA = loadedVarsA.t;
solA = loadedVarsA.w;

loadedVarsB = load(strcat(curDirName,...
  'solution_results\tillsteadyB.mat'),'t','w');

tB = loadedVarsB.t;
solB = loadedVarsB.w;

nprey = 1;
npredator = 2;
nspecies = nprey+npredator;
sz = size(solA);
nvar = sz(2);
N = nvar/nspecies;
centerPointIndex = fix((N+2)/2);
preyCenterPointVarIndex = centerPointIndex;
firstPredatorCenterPointVarIndex = N+centerPointIndex;

[~,lastPointWithMinPreyDensityIndexA] = ...
  getLastRowWithExtremeElementValue(solA,...
  firstPredatorCenterPointVarIndex,'min');

[~,preLastPointWithMinPreyDensityIndexA] = ...
  getLastRowWithExtremeElementValue(solA,...
  firstPredatorCenterPointVarIndex,'min',...
lastPointWithMinPreyDensityIndexA);

[~,lastPointWithMinPreyDensityIndexB] = ...
  getLastRowWithExtremeElementValue(solB,...
  firstPredatorCenterPointVarIndex,'min');

[~,preLastPointWithMinPreyDensityIndexB] = ...
  getLastRowWithExtremeElementValue(solB,...
  firstPredatorCenterPointVarIndex,'min',...
  lastPointWithMinPreyDensityIndexB);

fixedVarIndex = preyCenterPointVarIndex;
fixedVarValue = 0.5;

periodA = getPeriod(tA,solA,fixedVarIndex,fixedVarValue);
periodB = getPeriod(tB,solB,fixedVarIndex,fixedVarValue);

tspan = max(periodA,periodB);

[tperiodA,wperiodA] = getSolutionPart(tA,solA,...
  preLastPointWithMinPreyDensityIndexA,tspan);

[tperiodB,wperiodB] = getSolutionPart(tB,solB,...
  preLastPointWithMinPreyDensityIndexB,tspan);

[tperiodSparseA,wperiodSparseA] = sparseSolution(tperiodA,wperiodA);

[tperiodSparseB,wperiodSparseB] = sparseSolution(tperiodB,wperiodB);

X = linspace(0,1,N+1);

maxDensity = max(maxMatrixElement(wperiodSparseA),...
  maxMatrixElement(wperiodSparseB));

pos = 1;

species = 2;
plotSpeciesDensity(tperiodSparseA,wperiodSparseA);
species = 2;
plotSpeciesDensity(tperiodSparseB,wperiodSparseB);

species = 3;
plotSpeciesDensity(tperiodSparseA,wperiodSparseA);
species = 3;
plotSpeciesDensity(tperiodSparseB,wperiodSparseB);

  function el = maxMatrixElement(matr)
    el = max(max(matr));
  end

  function [tsparse,wsparse] = sparseSolution(t,w)
    gap = 100;
    npt = length(t)/gap*gap;
    tsparse = t(1:gap:npt);
    wsparse = w(1:gap:npt,:);
  end

  function plotSpeciesDensity(tplot,wplot)
    nrow = 2;
    ncol = 2;
    h = subplot(nrow,ncol,pos);
    pos = pos+1;
    gr = plot3D(h,X(1:N),tplot,wplot(:,(species-1)*N+1:species*N));
    set(gr,'EdgeColor',[0 0 0]);
    set(h,'FontSize',36,'FontName','Times','XTick',[0 1],'YTick',[0 12],'ZTick',[0.4 0.8]);
    axis(h,[0 1 0 inf 0 maxDensity]);
    xlabel('$x$','FontSize',36,'FontName','Times','Interpreter','latex');
    ylabel('$t$','FontSize',36,'FontName','Times','Interpreter','latex');
    zlabel(sprintf('$%s$',char('u'+species-1)),...
      'rot',0,'FontSize',36,'FontName','Times','Interpreter','latex');
  end
end

