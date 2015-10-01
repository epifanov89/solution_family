function family_of_cycles()
%FAMILY_OF_CYCLES Решение модели 
%одной популяции жертв и двух популяций хищника 
%с ростом жертв, пропорциональным квадрату плотности популяции,
%при условии пропорциональности уравнений для хищников
%   Detailed explanation goes here
clear all; close all; clc

% Признак совершившегося установления. 
% Присвойте ему true, чтобы рассчитать мультипликаторы
steady = true;

% Номер решения на семействе
solno = 0;

path = mfilename('fullpath');
dir_separator_indexes = strfind(path,'\');
last_dir_separator_index = dir_separator_indexes(end);
curfiledir = substr(path,0,last_dir_separator_index);

intermediate_solutions_file_path = strcat(curfiledir,sprintf('intermediate_solutions\\family_%d.mat',solno));

final_solutions_file_path = strcat(curfiledir,sprintf('final_solutions\\family_%d.mat',solno));

% Длина кольца
L = 1;
% Число точек сетки
N = 24;
h = L/N;

X = zeros(N,1);
for pt = 1:N
  X(pt) = (pt-1)*h;
end

[right_parts_of_equations,carrying_capacity,nprey,npredator,X,tspan] = predatorPrey2x1Params();
  
tstep = tspan(2)-tspan(1);

N = length(X);
nspecies = nprey+npredator;
nvar = nspecies*N;

% Индекс средней точки разбиения
center_point_index = fix((N+2)/2);

% Индексы переменных, отвечающих плотностям популяций в средней
% точке ареала
prey_center_point_var_index = center_point_index;
first_predator_center_point_var_index = N+center_point_index;
second_predator_center_point_var_index = 2*N+center_point_index;

% Номера переменных проективной плоскости для фазовых траекторий
firstPhasVarIndex = prey_center_point_var_index;
secondPhasVarIndex = first_predator_center_point_var_index;

% Номер переменной, которая фигурирует в уравнении секущей плоскости
% отображения Пуанкаре
fixed_var_index = prey_center_point_var_index;
% Значение этой переменной в уравнении 
% секущей плоскости отображения Пуанкаре
fixed_var_value = 0.5;

eps = 1e-3;

hFig = figure;
hAxes = axes;
hold('on');
fplot(carrying_capacity,[0 L]);
xlabel('$x$','FontSize',18,'FontName','Times','Interpreter','latex');
ylabel('$p(x)$','rot',0,'FontSize',18,'FontName','Times','Interpreter','latex');
moveLabel('y',30,hFig,hAxes);
%title('Carrying capacity');
set(gca,'FontSize',18,'FontName','Times','XTick',[0 0.25 0.5 0.75],'YTick',[0.8 0.9 1 1.1 1.2]);  
imagepath = 'C:\Users\Андрей\Desktop\Учеба\1 семестр\Научная работа\';
imagename = 'resource';
saveas(hFig,strcat(imagepath,imagename,'.eps'),'psc2');
saveas(hFig,strcat(imagepath,imagename,'.png'),'png');

if ~exist(intermediate_solutions_file_path,'file')  
  % Раскомментировать, чтобы рассчитать предельный цикл с плотностью первой
  % популяции хищников, положенной равной нулю
  w0 = get_zero_first_predator_initial_distribution();
  
  % Раскомментировать, чтобы рассчитать предельные циклы семейства с
  % плотностью первой популяции хищников, отличной от нуля
%   w0 = get_nonzero_first_predator_initial_distribution();

  plot_spatial_distributions(w0);
else
 load(intermediate_solutions_file_path,'w0','wpoincareend');
 load(final_solutions_file_path,'T');
end

solve(@myode4,w0);


  % -----------------------------------------------------------------------
  % Nested functions. Problem parameters provided by the outer function.
  %
  
  function solve(solver,w0)
    if ~steady
      % Сначала просто решаем систему до некоторого момента времени
      figure
      [t,w,tpoincare,wpoincare,~] = ...
          solver(right_parts_of_equations,tspan,w0,...
                 odeset('NonNegative',1:nvar,...
                        'OutputFcn',@odephas2,...
                        'OutputSel',[firstPhasVarIndex,secondPhasVarIndex]),...
                 fixed_var_index,fixed_var_value);
               
      w0 = w(end,:);
      save(intermediate_solutions_file_path,'w0');
      
      if t(end) == tspan(end)
        wpoincareend = wpoincare(end,:);
        % Находим разницу между последними двумя временами пересечения 
        % секущей плоскости отображения Пуанкаре 
        % (для периодического решения это будет период)
        T = tpoincare(end)-tpoincare(end-2);

        save(intermediate_solutions_file_path,'wpoincareend','-append');

        save(final_solutions_file_path,'T');
      end

      plot_spatiotemporal_distributions(nprey,npredator,X,t,w);

      v1 = w(:,first_predator_center_point_var_index);
      v2 = w(:,second_predator_center_point_var_index);

      hFig = figure;
      hAxes = axes;
      hold('on');
      plot(t,v1,'b','LineWidth',2);
      plot(t,v2,'g','LineWidth',2);
      xlabel('$t$','FontSize',18,'FontName','Times','Interpreter','latex');
      ylabel('$v_1, v_2$','rot',0,'FontSize',18,'FontName','Times','Interpreter','latex');
      moveLabel('y',30,hFig,hAxes);
      set(gca,'FontSize',18,'FontName','Times');
      imagename = sprintf('%dtillsteady',solno);
      saveas(hFig,strcat(imagepath,imagename,'.eps'),'psc2');
      saveas(hFig,strcat(imagepath,imagename,'.png'),'png');
    else
%       final_multipliers_file_path = strcat(curfiledir,sprintf('final_multipliers\\family_%d_variations_constant_time_step.mat',solno));
%       
%       intermediate_monodromy_matrix_file_path = get_results_file_path_for_m_file_at_path(path,'intermediate_monodromy_matrix');
%       
%       [multipliers,computation_time] = multipliers_one_system_for_each_monodromy_matrix_column(...
%           @f,@g,@myode4,tspan,wpoincareend,nvar,intermediate_monodromy_matrix_file_path,...
%           fixed_var_index,fixed_var_value,...
%           odeset('NonNegative',1:nvar),...
%           odeset('OutputFcn',@odephas2,...
%                  'OutputSel',[firstPhasVarIndex,...
%                               secondPhasVarIndex]));
% 
%       if ~isempty(multipliers)
%         fprintf('Вычисление мультипликаторов завершено за %d секунд\n\n',round(computation_time));
%         
%         fprintf('Мультипликаторы:\n\n');
%         for multiplier_index = 1:length(multipliers)
%           disp(multipliers(multiplier_index));
%         end
% 
%         save(final_multipliers_file_path,'multipliers','computation_time');
%         
%         fprintf('\n');
        
        % Решаем систему на времени, кратном предполагаемому периоду, 
        % для построения графика пространственно-временного распределения
        figure
        [t,w] = myode4(right_parts_of_equations,0:tstep:T,w0,...
                 odeset('NonNegative',1:nvar,'RelTol',1e-6,'AbsTol',1e-9,'OutputFcn',@odephas2,...
                        'OutputSel',[firstPhasVarIndex,secondPhasVarIndex]));

        imagenamebeginning = num2str(solno);
        plot_spatiotemporal_distributions(nprey,npredator,X,t,w,imagepath,imagenamebeginning);

        plot_phase_portrait_projections(w,imagepath,imagenamebeginning);
        
        % Решаем систему на времени, кратном предполагаемому периоду, 
        % для построения графика семейства с проекциями фазовых траекторий
        % для некоторых режимов
        figure
        [~,w] = myode4(right_parts_of_equations,0:tstep:2*T,w0,...
                 odeset('NonNegative',1:nvar,'RelTol',1e-6,'AbsTol',1e-9,'OutputFcn',@odephas2,...
                        'OutputSel',[firstPhasVarIndex,secondPhasVarIndex]));
        
        save(final_solutions_file_path,'w','-append');
%       end
    end
  end
  % -----------------------------------------------------------------------
  
  function w0 = get_zero_first_predator_initial_distribution()
    w0 = zeros(1,nvar);
    for pt = 1:N
      w0(pt) = u10((pt-1)*h);
      w0(N+pt) = 0;
      w0(2*N+pt) = u20((pt-1)*h);
    end
  end
  % -----------------------------------------------------------------------
  
  function w0 = get_nonzero_first_predator_initial_distribution()
    first_predator_zero_file_path = strcat(curfiledir,'final_solutions\family_0.mat');
    load(first_predator_zero_file_path,'w');

    wmax = get_max_point_densities(w,second_predator_center_point_var_index);

    gamma = 0.1*solno;

    w0 = zeros(1,nvar);
    w0(1:N) = wmax(1,1:N);
    w0(N+1:2*N) = gamma*wmax(1,2*N+1:3*N);
    w0(2*N+1:3*N) = (1-gamma)*wmax(1,2*N+1:3*N);
  end
  % -----------------------------------------------------------------------
  
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
    if x >= 0 && x <= 0.4*L
      u = 0.2*sin(x*pi/0.4/L);
    else
      u = 0;
    end
  end
  % -----------------------------------------------------------------------
  
  function u = u20( x )
    if x >= L/2 && x <= 0.9*L
      u = max(0, 0.2*sin((x-L/2)*pi/0.4/L));
    else
      u = 0;
    end
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
  
  function dwdt = g( ~, w, basis_vector_index )
    dwdt = linearized_system( w, basis_vector_index, nprey, npredator, X, growth, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, carrying_capacity, inverse_carrying_capacity_integral_array );
  end
  % -----------------------------------------------------------------------

  function dwdt = gg( ~, w, basis_vector_index )
    dwdt = zeros(nvar, 1);
      
    for cur_species_index = 1:nspecies
      cur_species_offset = (cur_species_index - 1) * N;
      
      for cur_point_index = 1:N
        prev_point_index = mod(cur_point_index + N - 2, N) + 1;
        next_point_index = mod(cur_point_index, N) + 1;
          
        cur_species_prev_point_var_index = cur_species_offset + prev_point_index;
        cur_species_cur_point_var_index = cur_species_offset + cur_point_index;
        cur_species_next_point_var_index = cur_species_offset + next_point_index;
        
        sum_1 = 0;
        sum_2 = 0;
        sum_3 = 0;
        sum_4 = 0;
        sum_5 = 0;
        sum_6 = 0;
        sum_7 = 0;
        sum_8 = 0;
        for another_species_index = 1:nspecies
          another_species_offset = (another_species_index - 1) * N;
            
          another_species_prev_point_var_index = another_species_offset + prev_point_index;
          another_species_cur_point_var_index = another_species_offset + cur_point_index;
          another_species_next_point_var_index = another_species_offset + next_point_index;
            
          sum_1 = sum_1 + taxis_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_next_point_var_index) * w(N * nspecies * basis_vector_index + another_species_next_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_next_point_var_index) * w(another_species_next_point_var_index));
          sum_2 = sum_2 + taxis_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_next_point_var_index) * w(N * nspecies * basis_vector_index + another_species_cur_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_next_point_var_index) * w(another_species_cur_point_var_index));
          sum_3 = sum_3 + taxis_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_cur_point_var_index) * w(N * nspecies * basis_vector_index + another_species_next_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_cur_point_var_index) * w(another_species_next_point_var_index));        
          sum_4 = sum_4 + taxis_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_cur_point_var_index) * w(N * nspecies * basis_vector_index + another_species_cur_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_cur_point_var_index) * w(another_species_cur_point_var_index));
          sum_5 = sum_5 + taxis_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_cur_point_var_index) * w(N * nspecies * basis_vector_index + another_species_prev_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_cur_point_var_index) * w(another_species_prev_point_var_index));
          sum_6 = sum_6 + taxis_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_prev_point_var_index) * w(N * nspecies * basis_vector_index + another_species_cur_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_prev_point_var_index) * w(another_species_cur_point_var_index));
          sum_7 = sum_7 + taxis_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_prev_point_var_index) * w(N * nspecies * basis_vector_index + another_species_prev_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_prev_point_var_index) * w(another_species_prev_point_var_index));
          sum_8 = sum_8 + species_interaction_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_cur_point_var_index) * w(N * nspecies * basis_vector_index + another_species_cur_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_cur_point_var_index) * w(another_species_cur_point_var_index));
        end
        
        % Рассчитываем координату текущей точки сетки
        xcur = (cur_point_index - 1) * h;
        
        factor = 1;
        if cur_species_index <= nprey
          % Вычисляем интеграл от обратной к функции ресурса функции по
          % промежутку, заключенному между соседними с текущей точкой
          % основной сетки точками вспомогательной сетки
          inverse_carrying_capacity_integral = integral(@(x) carrying_capacity(x).^(-1), xcur - h/2, xcur + h/2) / h;
            
          factor = 2 * w(cur_species_cur_point_var_index) - 3 * inverse_carrying_capacity_integral * w(cur_species_cur_point_var_index)^2;
        end
        
        % Рассчитываем координаты предыдущей, текущей и следующей точек сетки
        xprev = (prev_point_index - 1) * h;
        xcur = (cur_point_index - 1) * h;
        xnext = (next_point_index - 1) * h;
        
        carrying_capacity_taxis_prev = 0;
        carrying_capacity_taxis_cur = 0;
        carrying_capacity_taxis_next = 0;
      
        if search_activity(cur_species_index) ~= 0          
          % Вычисляем интеграл от функции ресурса по промежутку,
          % заключенному между соседними с предыдущей точкой основной сетки
          % точками вспомогательной сетки
          carrying_capacity_integral = integral(carrying_capacity, xprev - h/2, xprev + h/2) / h;
          
          % Вычисляем таксис (направленную миграцию), вызванный
          % неравномерностью ресурса, в предыдущей точке
          carrying_capacity_taxis_prev = search_activity(cur_species_index) * carrying_capacity_integral;
                    
          % Вычисляем интеграл от функции ресурса по промежутку,
          % точками вспомогательной сетки
          carrying_capacity_integral = integral(carrying_capacity, xcur - h/2, xcur + h/2) / h;
          
          % Вычисляем таксис (направленную миграцию), вызванный
          % неравномерностью ресурса, в текущей точке
          carrying_capacity_taxis_cur = search_activity(cur_species_index) * carrying_capacity_integral;
            
          % Вычисляем интеграл от функции ресурса по промежутку,
          % заключенному между соседними со следующей точкой основной сетки
          % точками вспомогательной сетки
          carrying_capacity_integral = integral(carrying_capacity, xnext * h - h/2, xnext * h + h/2) / h;
          
          % Вычисляем таксис (направленную миграцию), вызванный
          % неравномерностью ресурса, в следующей точке
          carrying_capacity_taxis_next = search_activity(cur_species_index) * carrying_capacity_integral;
        end
        
        dwdt(cur_species_cur_point_var_index) = diffusion_coeffs(cur_species_index) * (w(nvar * basis_vector_index + cur_species_next_point_var_index) - 2 * w(nvar * basis_vector_index + cur_species_cur_point_var_index) + w(nvar * basis_vector_index + cur_species_prev_point_var_index)) / h^2 + ((- sum_1 + sum_2 - sum_3 - sum_5 + sum_6 - sum_7) / 2 + sum_4) / h^2 - (w(nvar * basis_vector_index + cur_species_next_point_var_index) + w(nvar * basis_vector_index + cur_species_cur_point_var_index)) * carrying_capacity_taxis_next / 2 / h^2 + (w(nvar * basis_vector_index + cur_species_next_point_var_index) + 2 * w(nvar * basis_vector_index + cur_species_cur_point_var_index) + w(nvar * basis_vector_index + cur_species_prev_point_var_index)) * carrying_capacity_taxis_cur / 2 / h^2 - (w(nvar * basis_vector_index + cur_species_cur_point_var_index) + w(nvar * basis_vector_index + cur_species_prev_point_var_index)) * carrying_capacity_taxis_prev / 2 / h^2 + mu(cur_species_index) * factor * w(nvar * basis_vector_index + cur_species_cur_point_var_index) + sum_8;
      end
    end
  end

  function status = odespatial2(t,y,flag,varargin)
    status = odespatial(t,y,flag,N,nspecies,['g','r','m'],varargin);
  end

end