function plot_spatiotemporal_distributions( nprey,npredator,X,t,w,imagepath,imagenamebeginning )
%PLOT_SPATIOTEMPORAL_DISTRIBUTIONS Summary of this function goes here
%   Detailed explanation goes here
nspecies = nprey+npredator;

sz = size(w);
nrow = sz(1);

N = length(X);
h = X(2)-X(1);
L = N*h;

if X(1) == 0
  Xout = zeros(N+1,1);
  wres = zeros(nrow,N+1,nspecies);
  start_point_index = 1;
else
  Xout = zeros(N+2,1);
  wres = zeros(nrow,N+2,nspecies);
  start_point_index = 2;
end

for species_index = 1:nspecies
  for point_index = 1:N
    Xout(point_index+start_point_index-1) = X(point_index);
    for time_moment_index = 1:nrow
      wres(time_moment_index,point_index+start_point_index-1,species_index) = w(time_moment_index,(species_index-1)*N+point_index);
    end
  end
  if X(1) == 0
    Xout(N+1) = L;
    wres(:,N+1,species_index) = wres(:,1,species_index);
  else
    Xout(1) = 0;
    Xout(N+2) = L;
    interpval = (wres(:,2,species_index)+wres(:,N+1,species_index))/2;
    wres(:,1,species_index) = interpval;
    wres(:,N+2,species_index) = interpval;
  end
end

for species_index = 1:nspecies
  figure
  gr = surf(Xout, t, wres(:,:,species_index));
  if species_index <= nprey
    if nprey == 1
      imagenameending = 'prey';
      zlabel('$u$','rot',0,'FontSize',18,'FontName','Times','Interpreter','latex')
    else
      imagenameending = sprintf('prey%d',species_index);
      zlabel(sprintf('$u_%d$',species_index),'rot',0,'FontSize',18,'FontName','Times','Interpreter','latex')
    end
  else
    if npredator == 1
      imagenameending = 'predator';
      zlabel('$v$','rot',0,'FontSize',18,'FontName','Times','Interpreter','latex')
    else
      imagenameending = sprintf('predator%d',species_index-nprey);
      zlabel(sprintf('$v_%d$',species_index-nprey),'rot',0,'FontSize',18,'FontName','Times','Interpreter','latex')
    end
  end
  xlabel('$x$','FontSize',18,'FontName','Times','Interpreter','latex')
  ylabel('$t$','FontSize',18,'FontName','Times','Interpreter','latex')
  
  % Раскомментировать, чтобы убрать черные линии
  set(gr, 'LineStyle', 'none')
  
  set(gca,'FontSize',18,'FontName','Times');  
  if nargin >= 7
    saveas(gr,strcat(imagepath,imagenamebeginning,imagenameending,'.eps'),'psc2');
    saveas(gr,strcat(imagepath,imagenamebeginning,imagenameending,'.png'),'png');
  end
end

end

