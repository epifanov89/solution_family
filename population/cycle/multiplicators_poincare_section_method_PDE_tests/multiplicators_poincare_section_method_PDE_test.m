function multiplicators_poincare_section_method_PDE_test()
%MULTIPLICATORS_POINCARE_SECTION_METHOD_PDE_TEST Summary of this function goes here
%   Detailed explanation goes here
clear all; close all; clc

% Длина кольца
L = 1;
% Число точек сетки
N = 6;
% Шаг сетки
h = L/N;

% Вектор координат точек сетки
X = zeros(N,1);
for pt = 1:N
  X(pt) = (pt-1)*h;
end

% Шаг интегрирования по времени для метода с постоянным шагом
tstep = 0.0001;

% Отступ для конечных разностей для вычисления частных производных
% отображения Пуанкаре
eps = 1e-3;

path = mfilename('fullpath');

solution_results_file_path = get_results_file_path_for_m_file_at_path(path,'solution_results');
intermediate_multiplicators_file_path = get_results_file_path_for_m_file_at_path(path,'intermediate_monodromy_matrix');

dir_separator_indexes = strfind(path,'\');
last_dir_separator_index = dir_separator_indexes(end);
curfiledir = substr(path,0,last_dir_separator_index);
final_multiplicators_file_path_beginning = strcat(curfiledir,sprintf('final_multiplicators\\multiplicators_test_N=%d_tau=%4.3f_',N,tstep));

% Раскомментировать, чтобы просто решить систему до установления
%solve_and_plot_solution(X,tstep,solution_results_file_path);
% Раскомментировать, чтобы рассчитать мультипликаторы
print_multiplicators_and_plot_solution(X,tstep,eps,solution_results_file_path,final_multiplicators_file_path_beginning,intermediate_multiplicators_file_path,@calculate_multiplicators_poincare_section_method);

end

