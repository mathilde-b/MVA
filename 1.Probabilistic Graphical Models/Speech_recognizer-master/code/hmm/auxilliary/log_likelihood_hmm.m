function [ loss ] = log_likelihood_hmm( X, parameter, met, hidden )
% Computation of the hmm log-likelihood
  K = size(parameter.a,2); M = size(parameter.s,2);

  if nargin<4
    [ hidden ] = E_step_hmm( X, parameter, met );
  end

  tmp = reshape(sum(hidden.eta,1),[K,K]).*log(parameter.a);
  loss = sum(tmp(parameter.a>0));

  for k=1:K
    for m=1:M
      tmp = hidden.gamma(:,k,m).*(log(parameter.s(k,m))+...
          log_gaussian(X, parameter.mu{k,m}', parameter.U{k,m}));
      tmp(isnan(tmp))=0;
      loss = loss + sum(tmp);
    end
  end
end
