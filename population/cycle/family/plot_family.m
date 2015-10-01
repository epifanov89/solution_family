function plot_family()
%PLOT_FAMILY Выводит несколько решений семейства на плоскости максимумов
%плотностей популяций хищников
%   Detailed explanation goes here
clear all; close all; clc

nsol = 11;

tstep = 0.002;
tlast = 50;
tspan = 0:tstep:tlast;

path = mfilename('fullpath');
dir_separator_indexes = strfind(path,'\');
last_dir_separator_index = dir_separator_indexes(end);
curfiledir = substr(path,0,last_dir_separator_index);

% Длина кольца
L = 1;
% Число точек сетки
N = 24;
h = L/N;

X = zeros(N,1);
for pt = 1:N
  X(pt) = (pt-1)*h;
end

nprey = 1;
npredator = 2;
nspecies = nprey+npredator;

nvar = N*nspecies;

ntillsteady = 2;

periods = zeros(1,nsol);

load(strcat(curfiledir,sprintf('solution_results\\family_%d.mat',0)),'w','T');

periods(1) = T;

wpredatormax = zeros(2,nsol);
v1trajectorytomax = cell(ntillsteady);
v2trajectorytomax = cell(ntillsteady);

first_predator_center_point_var_index = N+fix((N+2)/2);
second_predator_center_point_var_index = 2*N+fix((N+2)/2);

% wmax = get_max_point_densities(w,second_predator_center_point_var_index);
% wpredatormax(1,1) = wmax(first_predator_center_point_var_index);
% wpredatormax(2,1) = wmax(second_predator_center_point_var_index);

for solno = 1:nsol-1
  load(strcat(curfiledir,sprintf('solution_results\\family_%d.mat',solno)),'w','T');
  
  periods(solno+1) = T;
  
%   wmax = get_max_point_densities(w,first_predator_center_point_var_index);
%   wpredatormax(1,solno+1) = wmax(first_predator_center_point_var_index);
%   wpredatormax(2,solno+1) = wmax(second_predator_center_point_var_index);
end

plot_solution_periods(periods);


for sol = 1:ntillsteady
  load(strcat(curfiledir,'final_solutions\\tillsteady',char('A'+sol-1),'.mat'),'w');

  v1phasetrajectory = w(:,first_predator_center_point_var_index);
  v2phasetrajectory = w(:,second_predator_center_point_var_index);

  v1phasetrajectorytomax = v1phasetrajectory(1);
  v2phasetrajectorytomax = v2phasetrajectory(1);
  grows = false;

  sz = size(w);

  timept = 2;
  
  while ~grows
    if v1phasetrajectory(timept) <= v1phasetrajectory(timept-1) && v2phasetrajectory(timept) <= v2phasetrajectory(timept-1)
      v1phasetrajectorytomax = [v1phasetrajectorytomax; v1phasetrajectory(timept)];
      v2phasetrajectorytomax = [v2phasetrajectorytomax; v2phasetrajectory(timept)];
    else
      grows = true;
    end
    timept = timept+1;
  end

  while timept <= sz(1) && grows
    if v1phasetrajectory(timept) >= v1phasetrajectory(timept-1) && v2phasetrajectory(timept) >= v2phasetrajectory(timept-1)
      v1phasetrajectorytomax = [v1phasetrajectorytomax; v1phasetrajectory(timept)];
      v2phasetrajectorytomax = [v2phasetrajectorytomax; v2phasetrajectory(timept)];
    else
      grows = false;
    end
    timept = timept+1;
  end
  
  v1trajectorytomax{sol} = v1phasetrajectorytomax;
  v2trajectorytomax{sol} = v2phasetrajectorytomax;
end
  

imagepath = 'C:\Users\Андрей\Desktop\Учеба\1 семестр\Научная работа\';
imagename = 'family_of_cycles_trajectories';

% Вывод максимумов значений плотностей популяций в точке ареала
h = figure;
hold('on');
plot(wpredatormax(1,:),wpredatormax(2,:),'ko-','Linewidth',2);

loadedVars = load(strcat(curfiledir,'final_results\\tillsteadyC.mat'),...
  'maxPredatorDensitiesPoint');
maxPredatorDensitiesPoint = loadedVars.maxPredatorDensitiesPoint;
plot(maxPredatorDensitiesPoint(first_predator_center_point_var_index),...
  maxPredatorDensitiesPoint(second_predator_center_point_var_index),'ko');

loadedVars = load(strcat(curfiledir,'final_results\\tillsteadyD.mat'),...
  'maxPredatorDensitiesPoint');
maxPredatorDensitiesPoint = loadedVars.maxPredatorDensitiesPoint;
plot(maxPredatorDensitiesPoint(first_predator_center_point_var_index),...
  maxPredatorDensitiesPoint(second_predator_center_point_var_index),'ko');

set(gca,'FontSize',18,'FontName','Times','XTick',[0 0.5 1],'YTick',[0 0.5 1]);
% Вывод графиков установления на плоскости значений
% плотностей популяций в точке ареала
for sol = 1:ntillsteady
  l = plot(v1trajectorytomax{sol},v2trajectorytomax{sol},'k--','Linewidth',2);
  label(l,char('A'+sol-1),'location','center','FontSize',18,'FontName','Times','Interpreter','latex');
end

axis('tight');
xlabel('$V_1$','FontSize',18,'FontName','Times','Interpreter','latex');
ylabel('$V_2$','rot',0,'FontSize',18,'FontName','Times','Interpreter','latex');
saveas(h,strcat(imagepath,imagename,'.eps'),'psc2');
saveas(h,strcat(imagepath,imagename,'.png'),'png');


k3 = 0.28;

filename = strcat(curfiledir,sprintf('final_solutions\\predator_prey_2x1_perturbation_k3=%.2f.mat',k3));
load(filename,'w','t');

tlast = 10000;
plotgap = 100;

timept = 1;

while t(timept) <= tlast/20
  firstpredatorplot(timept) = w(timept,first_predator_center_point_var_index);
  secondpredatorplot(timept) = w(timept,second_predator_center_point_var_index);
  tplot(timept) = t(timept);
  timept = timept+1;
end

while t(timept) < 7*tlast/20  
  firstpredatorplot(timept) = NaN;
  secondpredatorplot(timept) = NaN;
  tplot(timept) = NaN;
  timept = timept+1;
end

while t(timept) <= 2*tlast/5  
  firstpredatorplot(timept) = w(timept,first_predator_center_point_var_index);
  secondpredatorplot(timept) = w(timept,second_predator_center_point_var_index);
  tplot(timept) = t(timept)-3*tlast/10+plotgap;
  timept = timept+1;
end

while t(timept) < 19*tlast/20  
  firstpredatorplot(timept) = NaN;
  secondpredatorplot(timept) = NaN;
  tplot(timept) = NaN;
  timept = timept+1;
end

while timept <= length(t)
  firstpredatorplot(timept) = w(timept,first_predator_center_point_var_index);
  secondpredatorplot(timept) = w(timept,second_predator_center_point_var_index);
  tplot(timept) = t(timept)-17*tlast/20+2*plotgap;
  timept = timept+1;
end


imagename = sprintf('first_predator_k3=%.2f',k3);

hFig = figure;
hAxes = axes;
hold('on');
plot(tplot,firstpredatorplot,'k-','Linewidth',2);

set(gca,'FontSize',36,'FontName','Times','XTick',[0 250 600 850 1200 1450],'XTickLabel',[0 250 3500 3750 9500 9750],'YTick',[0 0.4 0.8 1.2]);

axis('tight');
xlabel('$t$','FontSize',36,'FontName','Times','Interpreter','latex');
ylabel('$V_1$','rot',0,'FontSize',36,'FontName','Times','Interpreter','latex');
moveLabel('y',30,hFig,hAxes);
saveas(hFig,strcat(imagepath,imagename,'.eps'),'psc2');
saveas(hFig,strcat(imagepath,imagename,'.png'),'png');


imagename = sprintf('second_predator_k3=%.2f',k3);

hFig = figure;
hAxes = axes;
hold('on');
plot(tplot,secondpredatorplot,'k-','Linewidth',2);

set(gca,'FontSize',36,'FontName','Times','XTick',[0 250 600 850 1200 1450],'XTickLabel',[0 250 3500 3750 9500 9750],'YTick',[0 0.2 0.4 0.6]);

axis('tight');
xlabel('$t$','FontSize',36,'FontName','Times','Interpreter','latex');
ylabel('$V_2$','rot',0,'FontSize',36,'FontName','Times','Interpreter','latex');
moveLabel('y',30,hFig,hAxes);
saveas(hFig,strcat(imagepath,imagename,'.eps'),'psc2');
saveas(hFig,strcat(imagepath,imagename,'.png'),'png');


k3 = 0.2;

filename = strcat(curfiledir,sprintf('final_solutions\\predator_prey_2x1_perturbation_k3=%.2f.mat',k3));
load(filename,'w','t');

tlast = 10000;
plotgap = 100;

timept = 1;

while t(timept) <= tlast/20
  firstpredatorplot2(timept) = w(timept,first_predator_center_point_var_index);
  secondpredatorplot2(timept) = w(timept,second_predator_center_point_var_index);
  tplot2(timept) = t(timept);
  timept = timept+1;
end

while t(timept) < 7*tlast/20  
  firstpredatorplot2(timept) = NaN;
  secondpredatorplot2(timept) = NaN;
  tplot2(timept) = NaN;
  timept = timept+1;
end

while t(timept) <= 2*tlast/5  
  firstpredatorplot2(timept) = w(timept,first_predator_center_point_var_index);
  secondpredatorplot2(timept) = w(timept,second_predator_center_point_var_index);
  tplot2(timept) = t(timept)-3*tlast/10+plotgap;
  timept = timept+1;
end

while t(timept) < 19*tlast/20  
  firstpredatorplot2(timept) = NaN;
  secondpredatorplot2(timept) = NaN;
  tplot2(timept) = NaN;
  timept = timept+1;
end

while timept <= length(t)
  firstpredatorplot2(timept) = w(timept,first_predator_center_point_var_index);
  secondpredatorplot2(timept) = w(timept,second_predator_center_point_var_index);
  tplot2(timept) = t(timept)-17*tlast/20+2*plotgap;
  timept = timept+1;
end


imagename = sprintf('first_predator_k3=%.2f',k3);

hFig = figure;
hAxes = axes;
hold('on');
plot(tplot2,firstpredatorplot2,'k-','Linewidth',2);

set(gca,'FontSize',36,'FontName','Times','XTick',[0 250 600 850 1200 1450],'XTickLabel',[0 250 3500 3750 9500 9750]);

axis('tight');
xlabel('$t$','FontSize',36,'FontName','Times','Interpreter','latex');
ylabel('$V_1$','rot',0,'FontSize',36,'FontName','Times','Interpreter','latex');
moveLabel('y',30,hFig,hAxes);
saveas(hFig,strcat(imagepath,imagename,'.eps'),'psc2');
saveas(hFig,strcat(imagepath,imagename,'.png'),'png');


imagename = sprintf('second_predator_k3=%.2f',k3);

hFig = figure;
hAxes = axes;
hold('on');
plot(tplot2,secondpredatorplot2,'k-','Linewidth',2);

set(gca,'FontSize',36,'FontName','Times','XTick',[0 250 600 850 1200 1450],'XTickLabel',[0 250 3500 3750 9500 9750]);

axis('tight');
xlabel('$t$','FontSize',36,'FontName','Times','Interpreter','latex');
ylabel('$V_2$','rot',0,'FontSize',36,'FontName','Times','Interpreter','latex');
moveLabel('y',30,hFig,hAxes);
saveas(hFig,strcat(imagepath,imagename,'.eps'),'psc2');
saveas(hFig,strcat(imagepath,imagename,'.png'),'png');

tperiods = zeros(1,ntillsteady);
wtillsteady = cell(ntillsteady);
times = zeros(2,ntillsteady);

for sol = 1:ntillsteady
  letter = char('A'+sol-1);
  load(strcat(curfiledir,'final_solutions\\tillsteady',letter,'.mat'),'w');  
  wtillsteady{sol} = w;
  
  sz = size(w);
  timept = sz(1)-1;
  [~,timept] = get_min_point_densities(w,first_predator_center_point_var_index,timept);
  timeptlastmin = timept;
  [~,timept] = get_min_point_densities(w,first_predator_center_point_var_index,timept);
  
  times(1,sol) = timept;
  times(1,sol) = timeptlastmin;
end

%maxtperiod = max(tperiod);

for sol = 1:ntillsteady  
  w = wtillsteady{sol};
  wperiod = w(timept+1:timeptlastmin+1,:);
  tperiod = t(timept+1:timeptlastmin+1,:);
  
  plot_spatiotemporal_distributions(nprey,npredator,X,tperiod,wperiod,imagepath,letter);
end


plot_solution_periods(periods);


  % Возвращает значения всех переменных, 
  % соответствующие минимуму переменной с переданным номером
  function [wmin,timept] = get_min_point_densities(w, varindex, timept)
    % Сначала двигаемся, пока значения плотностей в точке не начнут убывать.    
    decreases = false;   
    
    while ~decreases
      if w(timept,varindex) <= w(timept+1,varindex)
        decreases = true;
      end
      timept = timept-1;
    end
    
    % Теперь двигаемся, пока значения плотностей не начнут расти. 
    % Это будет означать, что мы достигли минимума.    
    while timept >= 1 && decreases
      wmin = w(timept+1,:);
      
      if w(timept,varindex) > wmin(varindex)
        decreases = false;
        break;
      else
        timept = timept-1;
      end
    end
  end
  % -----------------------------------------------------------------------
  
  % Возвращает максимум переменной с переданным номером
  function wmax = get_max_point_densities(w, varindex)
    timept = 2;
    
    % Сначала двигаемся, пока значения плотностей в точке не начнут расти.    
    grows = false;   
    
    while ~grows
      if w(timept,varindex) >= w(timept-1,varindex)
        grows = true;
      end
      timept = timept+1;
    end
    
    % Теперь двигаемся, пока значения плотностей не начнут убывать. 
    % Это будет означать, что мы достигли максимума.
    sz = size(w);
    
    while timept <= sz(1) && grows
      wmax = w(timept-1,:);
      
      if w(timept,varindex) < wmax(varindex)
        grows = false;
        break;
      end
      timept = timept+1;
    end
  end
  % -----------------------------------------------------------------------

  % Вывод графика зависимости периода от номера на семействе
  function plot_solution_periods(T)
    h = figure;
    hold('on');
    plot(linspace(0,1,length(T)),T,'-','Linewidth',2);
    axis('tight');
    xlabel('$\theta$','FontSize',18,'FontName','Times','Interpreter','latex');
    ylabel('$T$','rot',0,'FontSize',18,'FontName','Times','Interpreter','latex');
    set(gca,'FontSize',18,'FontName','Times');
    saveas(h,'C:\Users\Андрей\Desktop\Учеба\1 семестр\Научная работа\periods.eps','psc2');
    saveas(h,'C:\Users\Андрей\Desktop\Учеба\1 семестр\Научная работа\periods.png','png');
  end
  % -----------------------------------------------------------------------
  
  function dwdt = f( ~, w )
    dwdt = right_parts_of_equations( w, nprey, npredator, X, @growth_fcn, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, @carrying_capacity, inverse_carrying_capacity_integral_array );
  end
  % -----------------------------------------------------------------------  
  
end

