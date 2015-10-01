function multiplicators_poincare_section_method_PDE_test()
%MULTIPLICATORS_POINCARE_SECTION_METHOD_PDE_TEST Summary of this function goes here
%   Detailed explanation goes here
clear all; close all; clc

% ����� ������
L = 1;
% ����� ����� �����
N = 6;
% ��� �����
h = L/N;

% ������ ��������� ����� �����
X = zeros(N,1);
for pt = 1:N
  X(pt) = (pt-1)*h;
end

% ��� �������������� �� ������� ��� ������ � ���������� �����
tstep = 0.0001;

% ������ ��� �������� ��������� ��� ���������� ������� �����������
% ����������� ��������
eps = 1e-3;

path = mfilename('fullpath');

solution_results_file_path = get_results_file_path_for_m_file_at_path(path,'solution_results');
intermediate_multiplicators_file_path = get_results_file_path_for_m_file_at_path(path,'intermediate_monodromy_matrix');

dir_separator_indexes = strfind(path,'\');
last_dir_separator_index = dir_separator_indexes(end);
curfiledir = substr(path,0,last_dir_separator_index);
final_multiplicators_file_path_beginning = strcat(curfiledir,sprintf('final_multiplicators\\multiplicators_test_N=%d_tau=%4.3f_',N,tstep));

% �����������������, ����� ������ ������ ������� �� ������������
%solve_and_plot_solution(X,tstep,solution_results_file_path);
% �����������������, ����� ���������� ���������������
print_multiplicators_and_plot_solution(X,tstep,eps,solution_results_file_path,final_multiplicators_file_path_beginning,intermediate_multiplicators_file_path,@calculate_multiplicators_poincare_section_method);

end

