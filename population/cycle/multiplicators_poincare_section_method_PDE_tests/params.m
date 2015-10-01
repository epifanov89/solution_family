function [ right_parts,linearized,resource,nprey,npredator,N,tlast,fixed_var_index,fixed_var_value,first_phas_var_index,second_phas_var_index ] = params(X)
%PARAMS Summary of this function goes here
%   Detailed explanation goes here
% ����� ���������� ��������� �������������� �� ������������
tlast = 50;

% ����� ��������� �����
nprey = 1;
% ����� ��������� ��������
npredator = 1;
nspecies = nprey + npredator;

N = length(X);
h = X(2)-X(1);
L = N*h;

% ������������ ������������ ����� / ����������
% ���������
growth = [3; -1];
% ������������ ��������� ����������
search_activity = [0.1; 0];
% ������������ ��������
diffusion_coeffs = [0.2; 0.3];
% ������������ ������������ ��������
taxis_coeffs_matrix = [0 0
                       0.4 0];
% ������������ �����������
species_interaction_coeffs_matrix = [0 -1
                                     2.5  0];
                                   
% ������ ������� ����� ���������
center_point_index = fix((N+1)/2);

% ������� ����������, ���������� ���������� ��������� � �������
% ����� ������
prey_center_point_var_index = center_point_index;
predator_center_point_var_index = N+center_point_index;

% ������ ���������� ����������� ��������� ��� ������� ����������
first_phas_var_index = prey_center_point_var_index;
second_phas_var_index = predator_center_point_var_index;


% ����� ����������, ������� ���������� � ��������� ������� ���������
% ����������� ��������
fixed_var_index = prey_center_point_var_index;
% �������� ���� ���������� � ��������� 
% ������� ��������� ����������� ��������
fixed_var_value = 0.5;

% ��������� ��������� �� �������, �������� � ������� �������, �� ������
% ���� �����
inverse_carrying_capacity_integral_array = compute_integrals();

right_parts = @f;
linearized = @g;
resource = @carrying_capacity;
                                   

  % -----------------------------------------------------------------------
  % Nested functions. Problem parameters provided by the outer function.
  %
  
  function inverse_carrying_capacity_integral_array = compute_integrals()
    inverse_carrying_capacity_integral_array = zeros(1, N);
    
    for point_index = 1:N
      % ������������ ���������� ������� ����� �����
      xcur = X(point_index);
      % ���������� ������� ����� �������� �����
      % ���������� ��� �������� � ��� ����� ��������������� �����
      xstart = xcur - h/2;
      xend = xcur + h/2;
      % � ���������� �������, ����������� ����� ����� ����� �������
      % ������ �������� �� �������, �������� � ������� �������, �� �����
      % �������
      inverse_carrying_capacity_integral_array(point_index) = integral(@(x) carrying_capacity(x).^(-1), xstart, xend) / h;
    end
  end
  % -----------------------------------------------------------------------
  
  function P = carrying_capacity( x )
  % Carrying capacity function
    P = 1+0.2*exp(-0.0*x/L).*sin(2*pi*x/L);
  end
  % -----------------------------------------------------------------------
  
  function mu = growth_fcn( w )
    mu = zeros(1, nspecies);
    for cur_species_index = 1:nprey
      mu(cur_species_index) = growth(cur_species_index) * w;
    end
    for cur_species_index = nprey + 1:nspecies
      mu(cur_species_index) = growth(cur_species_index);
    end
  end
  % -----------------------------------------------------------------------
  
  function dwdt = f( ~, w )
    dwdt = right_parts_of_equations( w, nprey, npredator, X, @growth_fcn, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, @carrying_capacity, inverse_carrying_capacity_integral_array );
  end
  % -----------------------------------------------------------------------  
  
  function dwdt = g( ~, w, basis_vector_index )
    dwdt = linearized_system( w, basis_vector_index, nprey, npredator, X, growth, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, @carrying_capacity, inverse_carrying_capacity_integral_array );
  end
  % -----------------------------------------------------------------------                                   

end

