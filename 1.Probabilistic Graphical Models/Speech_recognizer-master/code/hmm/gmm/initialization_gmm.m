function [ q ] = initialization_gmm( X, K, nb_it )
  if nargin<3, nb_it=10; end;
  y = run_k_means(K, X, nb_it);
  q = cumsum(ones(size(X,1),K),2)==y;
end

