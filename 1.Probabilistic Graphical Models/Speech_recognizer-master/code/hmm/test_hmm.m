function [ prediction, proba ] = test_hmm( data, opts )
% Test the HMM according the procedure described in our paper
    if opts.verbose
        fprintf('Testing.\n');
        f = waitbar(0,'iteration 0','Name','Testing...',...
                  'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
        setappdata(f,'canceling',0)
    end
    SIZE_DICT = numel(opts.dictionary);
    proba = zeros(SIZE_DICT, numel(data));
    for nb_word = 1:SIZE_DICT
        opts.word = opts.dictionary{nb_word};
      if opts.verbose
          waitbar(nb_word / SIZE_DICT, f, sprintf('word: %s', opts.word));
          if getappdata(f,'canceling')
              break
          end
      end
        % Load learnt parameter
        load(fullfile(opts.save_dir, 'real', opts.word, 'parameter_video'));
        for r = 1:numel(data)
            X = data{r};
            proba(nb_word, r) = log_likelihood_hmm( X, parameter, opts.met );
        end
    end
    [~, ind_word] = max(proba, [], 1);
  if opts.verbose
      delete(f)
  end
  
    prediction = cell(size(ind_word));
    % Translation into word
    for i=1:numel(prediction)
        prediction{i} = opts.dictionary{ind_word(i)};
    end
end