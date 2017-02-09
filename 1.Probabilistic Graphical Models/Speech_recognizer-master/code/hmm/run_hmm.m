function [ parameter, Ltrain, Ltest ] =  run_hmm( Xtrain, opts )
% Running HMM with K hidden states and M mixture components
% Streams are correlated according to met

    % Introduce the possibility to use a saving file
  R = numel(Xtrain);
  
  %% Initialization of parameters
  if opts.verbose
      fprintf('Parameter Initialization.\n');
  end
  try
      load(opts.save_file)      
      hidden.gamma = []; hidden.eta = [];
      for r=1:R
          hidden_tmp = E_step_hmm( Xtrain{r}, parameter, opts.met );
          hidden.gamma = [ hidden.gamma ; hidden_tmp.gamma ];
          hidden.eta = [ hidden.eta ; hidden_tmp.eta ];
      end
  catch
      hidden = initialization_hmm( Xtrain, opts );
      hidden = dirac2proba( hidden, opts );
  end
  %% EM algoritm with Viterbi
  if opts.verbose
    fprintf('Running EM with Viterbi.\n');
    h = waitbar(0,'iteration 0','Name','Running HMM...',...
              'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(h,'canceling',0)
  end

  Ltrain = zeros(2*opts.it_max_hmm,1); Ltest = Ltrain;
  i=0; hidden_old = 0;
  while compare_hidden(hidden,hidden_old) > opts.prec_hmm && i<opts.it_max_hmm
      i=i+1; hidden_old = hidden;
     
      parameter = M_step_hmm( Xtrain, hidden, opts.met );
      hidden.q = []; hidden.c = [];
      % Concatenation of all results per sample
      for r=1:R
          hidden_tmp = Viterbi_decoding( Xtrain{r}, parameter, opts.met );
          hidden.q = [ hidden.q ; hidden_tmp.q ];
          hidden.c = [ hidden.c ; hidden_tmp.c ];
      end
      hidden = dirac2proba(hidden, opts);
      
      % Log-likelihood
      if opts.calcul_log
        Ltrain(i) = log_likelihood_hmm( Xtrain, parameter, opts.met, hidden );
        if opts.calcul_log_test
          Ltest(i) = log_likelihood_hmm( opts.Xtest, parameter, opts.met );
        end
      end
      if opts.verbose
          waitbar(.5*(i / opts.it_max_hmm), h, sprintf('iteration %d', i));
          if getappdata(h,'canceling')
              break
          end
      end
  end
  
  %% Regular EM algoritm
  hidden_old = 0;
  if opts.verbose 
    fprintf('Running general EM.\n');
  end
  while compare_hidden(hidden,hidden_old) > opts.prec_hmm && i<2*opts.it_max_hmm
      i=i+1; hidden_old = hidden;

      parameter = M_step_hmm( Xtrain, hidden, opts.met );
      % Concatenation of all results per sample
      hidden.gamma = []; hidden.eta = [];
      for r=1:R
          hidden_tmp = E_step_hmm( Xtrain{r}, parameter, opts.met );
          hidden.gamma = [ hidden.gamma ; hidden_tmp.gamma ];
          hidden.eta = [ hidden.eta ; hidden_tmp.eta ];
      end

      % Log-likelihood
      if opts.calcul_log
        Ltrain(i) = log_likelihood_hmm( Xtrain, parameter, opts.met, hidden );
        if opts.calcul_log_test
          Ltest(i) = log_likelihood_hmm( opts.Xtest, parameter, opts.met );
        end
      end
      if opts.verbose
          waitbar(.5 * (i / opts.it_max_hmm), h, sprintf('iteration %d', i));
          if getappdata(h,'canceling')
              break
          end
      end
  end
  if opts.verbose
      delete(h)
  end
end
