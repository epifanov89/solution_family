function dwdt = linearized_system( w, basis_vector_index, nprey, npredator, X, mu, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, carrying_capacity, inverse_carrying_capacity_integral_array )
%LINEARIZED_SYSTEM Summary of this function goes here
%   Detailed explanation goes here
  nspecies = nprey + npredator;
  
  N = length(X);
  if N > 1
    h = X(2)-X(1);
  else
    h = 1;
  end
  
  nvar = nspecies * N;
    
  dwdt = zeros(nvar, 1);

  for cur_species_index = 1:nspecies
    cur_species_offset = (cur_species_index - 1) * N;
    
    for cur_point_index = 1:N
      prev_point_index = mod(cur_point_index + N - 2, N) + 1;
      next_point_index = mod(cur_point_index, N) + 1;
      
      species_interaction_taxis_prev = 0;
      species_interaction_taxis_cur = 0;
      species_interaction_taxis_next = 0;
      sum_prev = 0;
      sum_cur = 0;
      sum_next = 0;
      for another_species_index = 1:nspecies
        another_species_offset = (another_species_index - 1) * N;
          
        prev_var_index = another_species_offset + prev_point_index;
        cur_var_index = another_species_offset + cur_point_index;
        next_var_index = another_species_offset + next_point_index;
          
        species_interaction_taxis_prev = species_interaction_taxis_prev + taxis_coeffs_matrix(cur_species_index, another_species_index) * w(prev_var_index);
        species_interaction_taxis_cur = species_interaction_taxis_cur + taxis_coeffs_matrix(cur_species_index, another_species_index) * w(cur_var_index);
        species_interaction_taxis_next = species_interaction_taxis_next + taxis_coeffs_matrix(cur_species_index, another_species_index) * w(next_var_index);

        sum_prev = sum_prev + taxis_coeffs_matrix(cur_species_index, another_species_index) * w(nvar * basis_vector_index + prev_var_index);
        sum_cur = sum_cur + taxis_coeffs_matrix(cur_species_index, another_species_index) * w(nvar * basis_vector_index + cur_var_index);
        sum_next = sum_next + taxis_coeffs_matrix(cur_species_index, another_species_index) * w(nvar * basis_vector_index + next_var_index);
      end
      
      % Получаем координаты предыдущей, текущей и следующей точек сетки
      xprev = X(prev_point_index);
      xcur = X(cur_point_index);
      xnext = X(next_point_index);
      
      carrying_capacity_taxis_prev = search_activity(cur_species_index) * carrying_capacity(xprev);
      carrying_capacity_taxis_cur = search_activity(cur_species_index) * carrying_capacity(xcur);
      carrying_capacity_taxis_next = search_activity(cur_species_index) * carrying_capacity(xnext);

      fi_prev = species_interaction_taxis_prev + carrying_capacity_taxis_prev;
      fi_cur = species_interaction_taxis_cur + carrying_capacity_taxis_cur;
      fi_next = species_interaction_taxis_next + carrying_capacity_taxis_next;
      
      predation_factor = 0;
      linearized_predation_factor = 0;
      for another_species_index = 1:nspecies
        another_species_offset = (another_species_index - 1) * N;          
        cur_var_index = another_species_offset + cur_point_index;
        
        predation_factor = predation_factor + species_interaction_coeffs_matrix(cur_species_index, another_species_index) * w(cur_var_index);
        linearized_predation_factor = linearized_predation_factor + species_interaction_coeffs_matrix(cur_species_index, another_species_index) * w(nvar * basis_vector_index + cur_var_index);
      end

      prey_vars_sum = 0;
      if cur_species_index <= nprey
        for another_species_index = 1:nprey
          another_species_offset = (another_species_index - 1) * N;
          cur_var_index = another_species_offset + cur_point_index;
          
          term = w(nvar * basis_vector_index + cur_var_index);
          if another_species_index == cur_species_index
            term = 3 * term;
          end
          prey_vars_sum = prey_vars_sum + term;
        end
      end

      prev_var_index = cur_species_offset + prev_point_index;
      cur_var_index = cur_species_offset + cur_point_index;
      next_var_index = cur_species_offset + next_point_index;
      
      if cur_species_index <= nprey
        sum = 0;
        for another_species_index=1:nprey
          if another_species_index ~= cur_species_index
            another_species_offset = (another_species_index - 1) * N;
            sum = sum + w(another_species_offset + cur_point_index);
          end
        end
        f0 = 2 * w(cur_var_index) * (1 - sum * inverse_carrying_capacity_integral_array(cur_point_index));
      else
        f0 = 1;
      end
        
      dwdt(cur_var_index) = diffusion_coeffs(cur_species_index) * (w(nvar * basis_vector_index + next_var_index) - 2 * w(nvar * basis_vector_index + cur_var_index) + w(nvar * basis_vector_index + prev_var_index)) / h^2 - (fi_next * (w(nvar * basis_vector_index + next_var_index) + w(nvar * basis_vector_index + cur_var_index)) - fi_cur * (w(nvar * basis_vector_index + next_var_index) + 2 * w(nvar * basis_vector_index + cur_var_index) + w(nvar * basis_vector_index + prev_var_index)) + fi_prev * (w(nvar * basis_vector_index + cur_var_index) + w(nvar * basis_vector_index + prev_var_index)) + sum_next * (w(next_var_index) + w(cur_var_index)) - sum_cur * (w(next_var_index) + 2 * w(cur_var_index) + w(prev_var_index)) + sum_prev * (w(cur_var_index) + w(prev_var_index))) / 2 / h^2 + (mu(cur_species_index) * f0 + predation_factor) * w(nvar * basis_vector_index + cur_var_index) - mu(cur_species_index) * prey_vars_sum * inverse_carrying_capacity_integral_array(cur_point_index) * w(cur_var_index) ^ 2 + linearized_predation_factor * w(cur_var_index);
    end
  end
end