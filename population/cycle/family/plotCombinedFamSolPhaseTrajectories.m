function plotCombinedFamSolPhaseTrajectories()

doPlotCombinedFamSolPhaseTrajectories(...
  @doPlotCombinedFamSolPhaseTrajectoriesCore);
xmin = 0.4;
xmax = 0.6;
ymin = 0.4;
ymax = 0.85;
zmin = 0;
zmax = 0.4;
axis([xmin xmax ymin ymax zmin zmax]); 
az = -56;
el = 12;
view(az,el);
box
end

