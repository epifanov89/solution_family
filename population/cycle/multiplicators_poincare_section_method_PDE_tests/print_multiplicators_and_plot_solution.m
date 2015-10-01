function print_multiplicators_and_plot_solution(X,tstep,eps,soluton_results_file_path,final_multiplicators_file_path_beginning,intermediate_multiplicators_file_path,calculate_multiplicators,interp_method)
%PRINT_MULTIPLICATORS_AND_PLOT_SOLUTION Summary of this function goes here
%   Detailed explanation goes here
[right_parts_of_equations,linearized_system,carrying_capacity,nprey,npredator,N,tlast,...
    fixed_var_index,fixed_var_value,...
    first_phas_var_index,second_phas_var_index] = params(X);
  
plot_fcn_approx(X,carrying_capacity);
  
load(soluton_results_file_path,'wpoincareend','T');

nspecies = nprey+npredator;

if nargin < 8
  interp_method = 'linear';
end

[multiplicators,computation_time] =...
    calculate_multiplicators(right_parts_of_equations,linearized_system,...
                             nspecies,N,wpoincareend,tlast,T,tstep,...
                             fixed_var_index,fixed_var_value,eps,...
                             first_phas_var_index,...
                             second_phas_var_index,...
                             final_multiplicators_file_path_beginning,...
                             intermediate_multiplicators_file_path,...
                             interp_method);

if ~isempty(multiplicators)
  fprintf('Вычисление мультипликаторов завершено за %d секунд\n\n',round(computation_time));
  
  fprintf('Мультипликаторы:\n\n');
  for multiplicator_index = 1:length(multiplicators)
    disp(multiplicators(multiplicator_index));
  end
  fprintf('\n');
  
  nvar = nspecies*N;

  % Решаем систему на времени, кратном предполагаемому периоду, 
  % для построения графика пространственно-временного распределения, 
  % а также для нахождения максимальных плотностей популяций хищников
  figure
  [t,w] = myode4(right_parts_of_equations,0:tstep:2*T,wpoincareend,...
                 odeset('NonNegative',1:nvar,...
                        'OutputFcn',@odephas2,...
                        'OutputSel',[first_phas_var_index,...
                                     second_phas_var_index]));

  plot_spatiotemporal_distributions(nprey,npredator,X,t,w);
end

end

