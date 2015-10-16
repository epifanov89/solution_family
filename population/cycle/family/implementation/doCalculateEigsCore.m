function doCalculateEigsCore( parentDirName,load,getSystem,eig,disp,...
  filename )

parDirName = parentDirName();
vars = load(strcat(parDirName,...
  'solution_results\families\p=1+0.5sin(2 pi x)\l2=1.2\',filename),'w');
sol = vars.w(end,:);
nvar = length(sol);
preyDiffusionCoeff = 0.2;
secondPredatorDiffusionCoeff = 0.24;
firstPredatorMortality = 1.2;
resourceVariation = 0.5;
N = 24;
[rightParts,~,~,~,~] = getSystem(preyDiffusionCoeff,...
  secondPredatorDiffusionCoeff,firstPredatorMortality,resourceVariation,N);
eps = 1e-7;
J = zeros(nvar,nvar);
for col = 1:nvar
  sol2 = sol;
  sol2(col) = sol2(col)+eps;
  J(:,col) = (rightParts(0,sol2)-rightParts(0,sol))/eps;
end
eigArr = eig(J);
eigRealPartArr = real(eigArr);
[~,descEigRealPartIndexArr] = sort(eigRealPartArr,'descend');
disp(eigArr(descEigRealPartIndexArr));
end

