function [ A ] = init_transition_matrix( S, K, T, met )
% According to met, we represent
%  - ?product?: one matrix of dimension 2 une seul matrice de dimension 2
%  - ?independent', 'factorial': S matrices of dimension 2
%  - ?coupled?, 'general': one matrix of dimension 2*S
   switch met
      case {'general', 'coupled'}
          % A(i_1..i_S,j_1..j_S) = p(q_t+1=(j_1..j_S)|q_t=(i_1..i_S))
          size_A = K*ones(1,2*S);
          A = zeros(size_A);
          
          tmp = ones(size(A));
          % Logical matrices for j_s=i_s and j_s+1 = i_s+1 
          ind_eq = cell(1,S);
          ind_inc = cell(1,S);
          for s=1:S
              tmp1 = cumsum(tmp,s); tmp2 = cumsum(tmp,S+s);
              ind_eq{s} = (tmp1 == tmp2);
              ind_inc{s} = ((tmp1+1) == tmp2);
          end

          % Silly constraints
          % Logical matrices for i_s = cste and j_s = cste
          % But we want a laxer one
          % k_s \in {min(k),min(k)+1}
          % or in other term
          % rather k_s \in {k_1,k_1+1}, rather \in {k_1-1,k_1}
          ind_i = tmp; ind_j = ones(size(A));
          tmp1 = cumsum(tmp,1); tmp2 = cumsum(tmp,S+1);
          for t=1:S
              ind_i = ind_i.*(tmp1 == cumsum(tmp,t));
              ind_j = ind_j.*(tmp2 == cumsum(tmp,S+t));
          end
          
          ind_eq = ind_j .* ind_i .* ind_eq{1};
          ind_inc = ind_j .* ind_i .* ind_inc{1}; 
          eq_val = max(exp(-K*log(4)/T) - (K/T)*rand, .1*rand);
          A = eq_val * ind_eq + (1-eq_val) * ind_inc;
          A(end)=1;

      case {'independent','factorial'}
          A = cell(1,S);
          ind_eq = eye(K);
          ind_inc = (1+cumsum(ones(K),1)) == cumsum(ones(K),2);
          for s=1:S
              eq_val = max(exp(-K*log(4)/T) - (K/T)*rand, .1*rand);
              B = eq_val * ind_eq + (1-eq_val) * ind_inc;
              B(end)=1;
              A{s} = B;
          end   
       case 'product'
          ind_eq = eye(K);
          ind_inc = (1+cumsum(ones(K),1)) == cumsum(ones(K),2);
          eq_val = exp(-K*log(4)/T);
          A = eq_val * ind_eq + (1-eq_val) * ind_inc;
          A(end)=1;
  end
end
