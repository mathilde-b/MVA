function [ hidden ] = initialization_hmm( Xs, opts )
% Initialization of HMM parameter before inference

  % Implicit parameter
  K=opts.K; R=size(Xs,2); M=opts.M;  % ADD S IN THE FUTURE
  hidden.q = []; hidden.c = []; Xtot = [];
  for r=1:R
    X = Xs{r}; T = size(X,1);
    Xtot = [Xtot; X];
    % For backbone nodes
    q = zeros(T,1);
    for k=0:K-1
        ind = 1+floor(k*T/K);
        q(ind)=1;
    end
    hidden.q = [ hidden.q ; cumsum(q,1) ];
  end
  
  % For mixture nodes
  q = hidden.q;
  c = zeros(size(q));
  for i=1:K
      % Extract all observation to perform the GMM
      ind = q==i;
      Z = Xtot(ind, :);
      % Clustering with GMM
      tmp = run_gmm(Z, M, opts);
      % Assign results to latent variable
      c(ind) = tmp; 
  end
  hidden.c = [hidden.c; c];
end
