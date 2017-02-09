function [ data, words ] = get_data_test( opts )
  if opts.real
    data = cell(1); r=0; words = cell(1);
    for nb_word = 1:numel(opts.dictionary)
        word = opts.dictionary{nb_word};
        desc_dir = fullfile( opts.save_dir, 'real', word );
        for speaker = opts.speaker_test
            name = opts.speakers{speaker};
            for sample = opts.sample_test
                save_file =  strcat(opts.data, '_', name, '_', ...
                    int2str(sample), '.mat');
                try
                    load(fullfile(desc_dir, save_file)); r=r+1;
                    data{r} = X; 
                    words{r} = word;
                catch
                    if opts.verbose
                        fprintf('Did not succeed to open %s, %s, %s, %d.\n',...
                            opts.data, word, name, sample);
                    end
                end
            end
        end
    end
  else
    data = get_simulated_data ( opts );
  end

