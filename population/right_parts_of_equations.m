function dwdt = right_parts_of_equations( w, nprey, npredator, X, growth_fcn, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, carrying_capacity, inverse_carrying_capacity_integral_array )                     
% Derivative function
  nspecies = nprey + npredator;
  
  N = length(X);
  if N > 1
    h = X(2)-X(1);
  else
    h = 1;
  end
  
  % �������� ������ ��� �������-������� �������� ������ ������ �� 1 �������
  % � ����� �� ����� ����������. ��, ��� ������ ���� ������ 
  % ������-������� - ���������� ���������.
  dwdt = zeros(nspecies * N, 1);

  for cur_species_index = 1:nspecies
    % ��������� ����� �� ������ ������� ���������� ��� ������� ���������
    cur_species_offset = (cur_species_index - 1) * N;
    
    for cur_point_index = 1:N
      % ������������ ������ ���������� � ��������� ����� �����, ��������,
      % ��� ���������� ��� ������ ����� �������� ���������, � ���������
      % ������ ��� ��������� - ������, � ����� ��� ��������� �����
      % ���������� � �������
      prev_point_index = mod(cur_point_index + N - 2, N) + 1;
      next_point_index = mod(cur_point_index, N) + 1;     

      % ��������� ������ (������������ ��������), ��������� ���������������� ������������� ���������, � ����������, ������� �
      % ��������� ������ �����
      species_interaction_taxis_prev = 0;
      species_interaction_taxis_cur = 0;
      species_interaction_taxis_next = 0;
      for another_species_index = 1:nspecies
        another_species_offset = (another_species_index - 1) * N;
        
        prev_var_index = another_species_offset + prev_point_index;
        cur_var_index = another_species_offset + cur_point_index;
        next_var_index = another_species_offset + next_point_index;
        
        species_interaction_taxis_prev = species_interaction_taxis_prev + taxis_coeffs_matrix(cur_species_index, another_species_index) * w(prev_var_index);
        species_interaction_taxis_cur = species_interaction_taxis_cur + taxis_coeffs_matrix(cur_species_index, another_species_index) * w(cur_var_index);
        species_interaction_taxis_next = species_interaction_taxis_next + taxis_coeffs_matrix(cur_species_index, another_species_index) * w(next_var_index);
      end

      % ������������ ���������� ����������, ������� � ��������� ����� �����
      xprev = X(prev_point_index);
      xcur = X(cur_point_index);
      xnext = X(next_point_index);
      
      % ��������� ������ (������������ ��������), ���������
      % ���������������� �������, � ����������, ������� � ��������� ������
      carrying_capacity_taxis_prev = search_activity(cur_species_index) * carrying_capacity(xprev);
      carrying_capacity_taxis_cur = search_activity(cur_species_index) * carrying_capacity(xcur);
      carrying_capacity_taxis_next = search_activity(cur_species_index) * carrying_capacity(xnext);
      
      % ����� ������ ����� ����� �������, ���������� ����������������
      % ������������� ��������� � �������, ���������� ����������������
      % �������
      fi_prev = species_interaction_taxis_prev + carrying_capacity_taxis_prev;
      fi_cur = species_interaction_taxis_cur + carrying_capacity_taxis_cur;
      fi_next = species_interaction_taxis_next + carrying_capacity_taxis_next;

      % ������������ ��������� �����������
      predation_factor = 0;
      for another_species_index = 1:nspecies
        another_species_offset = (another_species_index - 1) * N;
        predation_factor = predation_factor + species_interaction_coeffs_matrix(cur_species_index, another_species_index) * w(another_species_offset + cur_point_index);
      end
      
      prev_var_index = cur_species_offset + prev_point_index;
      cur_var_index = cur_species_offset + cur_point_index;
      next_var_index = cur_species_offset + next_point_index;
      
      % ��������� ����� � �������� ����� � ������� ������ �������� �����
      % ����� ��������������� �����
      qprev = diffusion_coeffs(cur_species_index) * (w(cur_var_index) - w(prev_var_index)) / h - (w(cur_var_index) + w(prev_var_index)) / 2 * (fi_cur - fi_prev) / h;
      % ��������� ����� � �������� ������ � ������� ������ �������� �����
      % ����� ��������������� �����
      qnext = diffusion_coeffs(cur_species_index) * (w(next_var_index) - w(cur_var_index)) / h - (w(next_var_index) + w(cur_var_index)) / 2 * (fi_next - fi_cur) / h;

      if (cur_species_index <= nprey)
        % ���� ��������� ������ ��� �����
                
        % ��������� �������� ������������� �������
        sum = 0;
        for another_species_index=1:nprey
          another_species_offset = (another_species_index - 1) * N;
          sum = sum + w(another_species_offset + cur_point_index);
        end
        f0 = 1 - sum * inverse_carrying_capacity_integral_array(cur_point_index);
      else
        f0 = 1;
      end

      mu = growth_fcn(w(cur_var_index));
      
      % ��������� �������� �������� ������ ����� �������� �����������������
      % ���������
      dwdt(cur_var_index) = (qnext - qprev) / h + mu(cur_species_index) * w(cur_var_index) * f0 + predation_factor * w(cur_var_index);
    end
  end    
end