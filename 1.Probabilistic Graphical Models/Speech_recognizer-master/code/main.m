%% Environnement
% Directory
opts.data_path = '../data/raw_data';
opts.save_dir = '../data/saved_descriptors';
opts.fig_dir = '../figures';

% Simulated or real data
opts.real = true;
opts.display_descriptors = false; % Look at the construction of audio descriptors
opts.data = 'audio';

% HMM options
opts.met = 'simple';         % 'product', 'independant', 'coupled', 'factorial', 'multistream'
opts.K = 5;                   % Number of hidden states
opts.M = 3;                   % Number of mixture components
opts.prec_hmm = 10^(-4);
opts.it_max_hmm = 100;
opts.init_met = 'gmm';
opts.prec_gmm = 10^(-2);
opts.it_max_gmm = 20;
opts.calcul_log = false;
opts.calcul_log_test = false;
opts.Xtest = [];

if ~opts.real
    opts.S = 4;            % Number of streams
    opts.T = 10;           % Length of the sequences
    opts.nb_samples = 4 ;  % Number of sequences
end

% Saving files
if opts.real
  opts.para_file = fullfile(opts.save_dir, 'real', sprintf('para_K%d_M%d_met%s', opts.K, opts.M, opts.met));
else
  opts.para_file = fullfile(opts.save_dir, 'simulated', sprintf('para_S%d_K%d_M%d_met%s', opts.S, opts.K, opts.M, opts.met));
end

% Verbose mode
opts.verbose = true;

% Dictionnaries
if opts.real
  opts.size_audio_descriptors = 5;
  opts.speakers = {'Anne','Betty','Chris','Gavin','Joe','Jon','Mike','Scott','Sue'};
  opts.nb_samples = 10;
  opts.dictionary = {'one', 'two', 'three', 'four', 'five', 'six', 'seven',};%...
%      'eight', 'nine', 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen',...
%      'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen', 'twenty',...
%      'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety',...
%      'hundred', 'thousand', 'million', 'billion', 'january', 'february',...
%      'march', 'april', 'may', 'june', 'july', 'august', 'september',...
%      'october', 'november', 'december', 'monday', 'tuesday', 'wednesday',...
%      'thursday', 'friday', 'saturday', 'sunday', 'morning', 'noon',...
%      'afternoon', 'night', 'midnight', 'evening', 'a.m.', 'p.m.', 'now',...
%      'next', 'last', 'yesterday', 'today', 'tomorrow', 'ago', 'after',...
%      'before', 'from', 'for', 'through', 'until', 'till', 'that', 'this',...
%      'day', 'month', 'week', 'year'};
  SIZE_DICT = numel(opts.dictionary);
  opts.speaker_train = [1,2];
  opts.speaker_test = [1,2];
  opts.sample_train = 1:7;
  opts.sample_test = 8:10;
end

%% Setup libraries
run setup

%% Preprocessing data
preprocess_data( opts ); 

%% Learning
if opts.real
  if opts.verbose
      fprintf('Learning.\n');
      g = waitbar(0,'iteration 0','Name','Learning...',...
                 'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
      setappdata(g,'canceling',0)
  end
  for nb_word = 1:SIZE_DICT
      opts.word = opts.dictionary{nb_word};
      if opts.verbose
          waitbar(nb_word / SIZE_DICT, g, sprintf('word: %s', opts.word));
          if getappdata(g,'canceling')
              break
          end
      end
      data_train = get_data_train( opts );

      %% Running HMM
      opts.save_file = fullfile(opts.save_dir, 'real', opts.word,...
          strcat('parameter','_', opts.data));
      parameter = run_hmm(data_train, opts);
      save(opts.save_file, 'parameter');
  end; clear nb_word;
  if opts.verbose
      delete(g)
  end
end

%% Testing
if opts.real
   % Waitbar
   [data_test, word_test] = get_data_test( opts );
   [ prediction, proba ] = test_hmm(data_test, opts);
end

%% Comparing precision
prec = 0;
for i=1:numel(word_test)
    if strcmp(word_test{i}, prediction{i})
        prec=prec+1;
    end
end
prec = prec/numel(word_test);
random_prec = 1/SIZE_DICT;


proba = proba./ max(proba,[],1);
[~, ind_word] = max(proba, [], 1);
prediction_bis = cell(size(ind_word));
% Translation into word
for i=1:numel(prediction)
    prediction_bis{i} = opts.dictionary{ind_word(i)};
end
prec_bis = 0;
for i=1:numel(word_test)
    if strcmp(word_test{i}, prediction_bis{i})
        prec_bis=prec_bis+1;
    end
end
prec_bis = prec_bis/numel(word_test);