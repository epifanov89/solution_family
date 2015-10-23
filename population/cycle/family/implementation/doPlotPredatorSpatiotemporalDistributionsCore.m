function doPlotPredatorSpatiotemporalDistributionsCore(currentDirName,...
  load,getLastRowWithExtremeElementValue,subplot,plot3D,set,axis,...
  xlabel,ylabel,zlabel )

curDirName = currentDirName();
famDirName = strcat(curDirName,...
  'solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\');
loadedVarsA = load(strcat(famDirName,'1.mat'),'t','w');

tA = loadedVarsA.t;
solA = loadedVarsA.w;

loadedVarsB = load(strcat(famDirName,'9.mat'),'t','w');

tB = loadedVarsB.t;
solB = loadedVarsB.w;

nprey = 1;
npredator = 2;
nspecies = nprey+npredator;
sz = size(solA);
nvar = sz(2);
N = nvar/nspecies;
centerPointIndex = fix((N+2)/2);
firstPredatorCenterPointVarIndex = N+centerPointIndex;

maxExtremumKind = 'max';

[~,solALastPtWithPredator1Max] = ...
  getLastRowWithExtremeElementValue(solA,...
    firstPredatorCenterPointVarIndex,maxExtremumKind);
  
[~,solAPreLastPtWithPredator1Max] = ...
  getLastRowWithExtremeElementValue(solA,...
    firstPredatorCenterPointVarIndex,maxExtremumKind,...
    solALastPtWithPredator1Max);
  
[~,solALastPtWithPredator1MinBeforePreLastPtWithPredator1Max] = ...
  getLastRowWithExtremeElementValue(solA,...
    firstPredatorCenterPointVarIndex,'min',...
    solAPreLastPtWithPredator1Max);
    
[~,solBLastPtWithPredator1Max] = ...
  getLastRowWithExtremeElementValue(solB,...
    firstPredatorCenterPointVarIndex,maxExtremumKind);

[~,solBPreLastPtWithPredator1Max] = ...
  getLastRowWithExtremeElementValue(solB,...
    firstPredatorCenterPointVarIndex,maxExtremumKind,...
    solBLastPtWithPredator1Max);

[~,solBLastPtWithPredator1MinBeforePreLastPtWithPredator1Max] = ...
  getLastRowWithExtremeElementValue(solB,...
    firstPredatorCenterPointVarIndex,'min',...
    solBPreLastPtWithPredator1Max);

pt = solALastPtWithPredator1MinBeforePreLastPtWithPredator1Max;
while pt <= length(tA) && tA(pt) <= ...
    tA(solALastPtWithPredator1MinBeforePreLastPtWithPredator1Max)+...
      tB(solBLastPtWithPredator1Max)-...
      tB(solBLastPtWithPredator1MinBeforePreLastPtWithPredator1Max)
  pt = pt+1;
end

solAPartForPlotIndexFinish = pt-1;

tplotA = tA(solALastPtWithPredator1MinBeforePreLastPtWithPredator1Max:...
    solAPartForPlotIndexFinish)-...
  tA(solALastPtWithPredator1MinBeforePreLastPtWithPredator1Max);
wplotA = solA(solALastPtWithPredator1MinBeforePreLastPtWithPredator1Max:...
  solAPartForPlotIndexFinish,:);

tplotB = tB(solBLastPtWithPredator1MinBeforePreLastPtWithPredator1Max:...
    solBLastPtWithPredator1Max)-...
  tB(solBLastPtWithPredator1MinBeforePreLastPtWithPredator1Max);
wplotB = solB(solBLastPtWithPredator1MinBeforePreLastPtWithPredator1Max:...
  solBLastPtWithPredator1Max,:);

[tplotSparseA,wplotSparseA] = sparseSolution(tplotA,wplotA);
[tplotSparseB,wplotSparseB] = sparseSolution(tplotB,wplotB);

X = linspace(0,1,N+1);

maxDensity = max(maxMatrixElement(wplotSparseA),...
  maxMatrixElement(wplotSparseB));

fontNameKey = 'FontName';
fontNameVal = 'Times';
fontSizeKey = 'FontSize';
fontSizeVal = 36;
interpreterKey = 'Interpreter';
interpreterVal = 'latex';

species = 2;
pos = 1;
plotSpeciesDensity(tplotSparseA,wplotSparseA,species,pos);
pos = pos+1;
plotSpeciesDensity(tplotSparseB,wplotSparseB,species,pos);

species = 3;
pos = pos+1;
plotSpeciesDensity(tplotSparseA,wplotSparseA,species,pos);
pos = pos+1;
plotSpeciesDensity(tplotSparseB,wplotSparseB,species,pos);

  function el = maxMatrixElement(matr)
    el = max(max(matr));
  end

  function [tsparse,wsparse] = sparseSolution(t,w)
    gap = 100;
    tsparse = t(1:gap:length(t));
    wsparse = w(1:gap:length(t),:);
  end

  function plotSpeciesDensity(tplot,wplot,species,pos)
    nrow = 2;
    ncol = 2;
    h = subplot(nrow,ncol,pos);    
    gr = plot3D(h,X(1:N),tplot,wplot(:,(species-1)*N+1:species*N));
    set(gr,'EdgeColor',[0 0 0]);
    set(h,fontSizeKey,fontSizeVal,fontNameKey,fontNameVal,'XTick',[0 1],...
      'YTick',[0 fix(tplot(end))],'ZTick',[0.4 0.8]);
    axis(h,[0 1 0 inf 0 maxDensity]);
    h = xlabel('$x$',fontSizeKey,fontSizeVal,fontNameKey,fontNameVal,...
      interpreterKey,interpreterVal);
    setPos(h,[-4.042 -67.928 5.125]);
    h = ylabel('$t$',fontSizeKey,fontSizeVal,fontNameKey,fontNameVal,...
      interpreterKey,interpreterVal);
    setPos(h,[-4.733 -63.392 5.336]);
    h = zlabel(sprintf('$%s$',char('u'+species-1)),'rot',0,...
      fontSizeKey,fontSizeVal,fontNameKey,fontNameVal,...
      interpreterKey,interpreterVal);
    setPos(h,[-0.525 5.523 1.7]);
    
    function setPos(h,position)
      set(h,'Position',position);
    end
  end
end

