function tillsteady()
%TILLSTEADY Решение модели 
%одной популяции жертв и двух популяций хищника 
%с ростом жертв, пропорциональным квадрату плотности популяции,
%при условии пропорциональности уравнений для хищников
%   Detailed explanation goes here
clear all; close all; clc

path = mfilename('fullpath');
dir_separator_indexes = strfind(path,'\');
last_dir_separator_index = dir_separator_indexes(end);
curfiledir = substr(path,0,last_dir_separator_index);

final_solutions_file_path = strcat(curfiledir,'final_solutions\\tillsteadyA.mat');

% Длина кольца
L = 1;
% Число точек сетки
N = 24;


[right_parts_of_equations,~,nprey,npredator,X,tspan] = predatorPrey2x1Params();

N = length(X);
h = X(2)-X(1);
nspecies = nprey+npredator;
nvar = nspecies*N;

% Индекс средней точки разбиения
centerPointIndex = fix((N+2)/2);

% Индексы переменных, отвечающих плотностям популяций в средней
% точке ареала
preyCenterPointVarIndex = centerPointIndex;
firstPredatorCenterPointVarIndex = N+centerPointIndex;

% Номера переменных проективной плоскости для фазовых траекторий
firstPhasVarIndex = preyCenterPointVarIndex;
secondPhasVarIndex = firstPredatorCenterPointVarIndex;
  
w0 = zeros(1,nvar);
for pt = 1:N
  w0(pt) = u10((pt-1)*h);
  w0(N+pt) = u50((pt-1)*h);
  w0(2*N+pt) = u60((pt-1)*h);
end

plot_spatial_distributions(w0);

figure
[t,w] = ...
    myode4(right_parts_of_equations,tspan,w0,...
           odeset('NonNegative',1:nvar,...
                  'OutputFcn',@odephas2,...
                  'OutputSel',[firstPhasVarIndex,secondPhasVarIndex]));

save(final_solutions_file_path,'w');


  % -----------------------------------------------------------------------
  % Nested functions. Problem parameters provided by the outer function.
  %
  
  % Возвращает значения всех переменных, 
  % соответствующие максимуму переменной с переданным номером
  function wmax = get_max_point_densities(w,varindex)
    % Сначала двигаемся, пока значения плотностей в точке не начнут расти.    
    grows = false;    
    timept = 2;
    
    while ~grows
      wprev = w(timept-1,:);
      if w(timept,varindex) >= wprev(varindex)
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
  
  function plot_max_space_point_densities()
    % Вывод максимумов значений плотностей популяций в точке ареала
    figure
    hold on
    xlabel('V_1');
    ylabel('V_2','rot',0);
    plot(wpredatormax(1,:),wpredatormax(2,:),'o-');


    % Вывод графиков установления на плоскости значений
    % плотностей популяций в точке ареала
    for sol = 1:length(idxSolutions)
      w = wtrajectory_all{sol};

      v1phasetrajectory = w(:,first_predator_center_point_var_index);
      v2phasetrajectory = w(:,second_predator_center_point_var_index);

      v1phasetrajectorytomin = v1phasetrajectory(1);
      v2phasetrajectorytomin = v2phasetrajectory(1);
      declines = true;
      timept = 2;
      while timept <= sz(1) && declines
        if v1phasetrajectory(timept) <= v1phasetrajectory(timept-1) && v2phasetrajectory(timept) <= v2phasetrajectory(timept-1)
          v1phasetrajectorytomin = [v1phasetrajectorytomin; v1phasetrajectory(timept)];
          v2phasetrajectorytomin = [v2phasetrajectorytomin; v2phasetrajectory(timept)];
        else
          declines = false;
        end
        timept = timept+1;
      end

      l = plot(v1phasetrajectorytomin,v2phasetrajectorytomin,'--');
      label(l,char('A'+sol-1),'location','center');
    end
  end
  % -----------------------------------------------------------------------
  
  function plot_spatial_distributions(w0)
    % Plot of the initial conditions        
    w01 = zeros(N+1,npredator);
    for i = 1:npredator
      w01(1:N,i) = w0((nprey+i-1)*N+1:(nprey+i)*N);
      w01(N+1,i) = w01(1,i);
    end

    Xout = zeros(1,N+1);
    for pt = 1:N
      Xout(pt) = X(pt);
    end
    Xout(N+1) = L;

    figure
    plot(Xout,w01)    
    xlabel('x')
    ylabel('v_1, v_2','rot',0)
    title('Initial distributions')
  end
  % -----------------------------------------------------------------------
  
  function calculate_multiplicators(w,tspan,solver,options,outputopts)
    fprintf('\n');
    tic
    M = monodromy_matrix_one_system_for_each_column(@f, @g, solver, tspan, w, nvar,...
                   options,outputopts);
    rho = sort(eig(M),'descend');
    elapsedTime = toc;
    fprintf('Мультипликаторы:\n\n');
    for rho_index = 1:length(rho)
      disp(rho(rho_index));
    end
    fprintf('\nВычисление мультипликаторов завершено за %d секунд\n',round(elapsedTime));
  end

  % -----------------------------------------------------------------------

  function plot_phase_portrait_projections(w,imagepath,imagenamebeginning)      
    hFig = figure;
    hAxes = axes;
    hold('on');
    plot(w(:,prey_center_point_var_index),w(:,first_predator_center_point_var_index),'Linewidth',2);
    xlabel('$u$','FontSize',18,'FontName','Times','Interpreter','latex')
    ylabel('$v_1$','rot',0,'FontSize',18,'FontName','Times','Interpreter','latex')
    moveLabel('y',70,hFig,hAxes);
    set(gca,'FontSize',18,'FontName','Times');  
    imagenameending = 'phase1';
    saveas(hFig,strcat(imagepath,imagenamebeginning,imagenameending,'.eps'),'psc2');
    saveas(hFig,strcat(imagepath,imagenamebeginning,imagenameending,'.png'),'png');
    
    hFig = figure;
    hAxes = axes;
    hold('on');
    plot(w(:,prey_center_point_var_index),w(:,second_predator_center_point_var_index),'Linewidth',2);
    xlabel('$u$','FontSize',18,'FontName','Times','Interpreter','latex')
    ylabel('$v_2$','rot',0,'FontSize',18,'FontName','Times','Interpreter','latex')
    moveLabel('y',70,hFig,hAxes);
    set(gca,'FontSize',18,'FontName','Times');  
    imagenameending = 'phase2';
    saveas(hFig,strcat(imagepath,imagenamebeginning,imagenameending,'.eps'),'psc2');
    saveas(hFig,strcat(imagepath,imagenamebeginning,imagenameending,'.png'),'png');
    
    hFig = figure;
    hAxes = axes;
    hold('on');
    plot(w(:,first_predator_center_point_var_index),w(:,second_predator_center_point_var_index),'Linewidth',2);
    xlabel('$v_1$','FontSize',18,'FontName','Times','Interpreter','latex')
    ylabel('$v_2$','rot',0,'FontSize',18,'FontName','Times','Interpreter','latex')
    moveLabel('y',30,hFig,hAxes);
    set(gca,'FontSize',18,'FontName','Times');  
    imagenameending = 'phase3';
    saveas(hFig,strcat(imagepath,imagenamebeginning,imagenameending,'.eps'),'psc2');
    saveas(hFig,strcat(imagepath,imagenamebeginning,imagenameending,'.png'),'png');
  end

  % -----------------------------------------------------------------------
  
  function plot_phase_trajectories(solutions)
    % Выводит проекции фазовых траекторий из разных начальных данных на 
    % одном графике
    sz = size(solutions);
    nsol = sz(2);
    figure
    hold on    
    for sol_index = 1:nsol
      solution = solutions{sol_index};
      plot(solution(:,1),solution(:,2));
    end
    hold off
  end

  % -----------------------------------------------------------------------
  
  function u = u10( x )
    u = 1+0.2*sin(2*pi*x);
  end
  % -----------------------------------------------------------------------

  function u = u20( x )
    u = 0.2+0.02*cos(2*pi*x);
  end
  % -----------------------------------------------------------------------

  function u = u30( x )
    u = 0.1-0.02*sin(2*pi*x);
  end
  % -----------------------------------------------------------------------

  function u = u40( x )
    u = 0.2-0.2*cos(2*pi*x);
  end
  % -----------------------------------------------------------------------
  
  function u = u50( x )
    u = 0.1+0.02*sin(2*pi*x);
  end
  % -----------------------------------------------------------------------

  function u = u60( x )
    u = 0.2-0.02*cos(2*pi*x);
  end
  % -----------------------------------------------------------------------
  
  function [value,isterminal,direction] = events(t,y)
    value = y(fixed_var_index)-fixed_var_value;
    isterminal = 0;
    direction = 0;
  end
  % -----------------------------------------------------------------------

  function status = poincare_map_iteration( t, w, flag )  
    global w_prev t_prev
    
    if ~strcmp(flag, 'init') && ~strcmp(flag, 'done')
      tf = t(end);
      wf = w(:, end);
        
      if ~isempty(w_prev) && sign(wf(fixed_var_index) - fixed_var_value) ~= sign(w_prev(fixed_var_index) - fixed_var_value)        
        w_poincare = zeros(1, nvar);
        w_poincare(fixed_var_index) = fixed_var_value;
        for var_index = 1:nvar
          if var_index ~= fixed_var_index
            w_poincare(var_index) = wf(var_index) - (wf(var_index) - w_prev(var_index)) * (wf(fixed_var_index) - fixed_var_value) / (wf(fixed_var_index) - w_prev(fixed_var_index));
          end
        end
        
        t_poincare = tf - (tf - t_prev) * (wf(fixed_var_index) - fixed_var_value) / (wf(fixed_var_index) - w_prev(fixed_var_index));
      
        sz_poincare = size(poincare_points);
        npoincare = sz_poincare(1);
        
        if npoincare > 1
          distance = euclidian_norm(w_poincare, poincare_points(end - 1, :));
          if distance < eps
            status = 1;
            isperiodic = true;
          end
        end
        
        are_zeros = true;
        if npoincare == 1
          for var_index = 1:nvar
            if poincare_points(1, var_index) > 0
              are_zeros = false;
            end
          end
        end
        
        if npoincare > 0 && (npoincare > 1 || ~are_zeros)
          poincare_times = [poincare_times, t_poincare];
          poincare_points(npoincare + 1, :) = w_poincare;
        else
          poincare_times(1) = t_poincare;
          poincare_points(1, :) = w_poincare;
        end
      end
      
      w_prev = wf;
      t_prev = tf;
    end 
    
    if ~strcmp(flag, 'done')
      sz = size(w);
      w_phas = zeros(2, sz(2));
      w_phas(1, :) = w(first_oscillating_var_index, :);
      w_phas(2, :) = w(second_oscillating_var_index, :);
    else
      w_phas = w;
    end
    
    if ~isperiodic
      status = odephas2(t, w_phas, flag);
    else
      odephas2(t, w_phas, flag);
    end
  end
  % -----------------------------------------------------------------------

  function status = odespatial2(t,y,flag,varargin)
    status = odespatial(t,y,flag,N,nspecies,['g','r','m'],varargin);
  end

end