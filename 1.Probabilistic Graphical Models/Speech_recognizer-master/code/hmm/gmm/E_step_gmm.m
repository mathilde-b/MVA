function [ q ] = E_step_gmm( X, pi, mu, Sigma )
% Derivation of p(z|x, theta)
  K = numel(pi);
  q = zeros(size(X,1), K);
  for k=1:K
    q(:,k) = pi(k) * gaussian(X, mu{k}, Sigma{k});
  end
  % Normalization
  q = bsxfun(@rdivide, q, sum(q,2));
end
