function [ y ] = run_gmm( X, K, opts )
  % Initialization with the K means
  if opts.verbose
      fprintf(' - Initialization with k-means.\n');
  end
  q = initialization_gmm( X, K );

  % EM algorithm
  if opts.verbose
    fprintf(' - Running Gaussian mixture model.\n');
  end

  q_old = zeros(size(q)); i = 0;
  while sum(abs(q_old(:)-q(:))) > opts.prec_gmm && i < opts.it_max_gmm
      q_old = q; i=i+1;
      [pi, mu, Sigma] = M_step_gmm(X, q_old);
      q = E_step_gmm(X, pi, mu, Sigma);
  end
  [~, y] = max(q,[],2);
end

% The stop criterion could be on the likelihood rather than the parameter but
% this would take more time of computation.
