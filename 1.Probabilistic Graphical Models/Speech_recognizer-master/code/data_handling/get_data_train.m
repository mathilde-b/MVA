function data = get_data_train( opts )
  if opts.real
    data = cell(1); r=0;
    desc_dir = fullfile( opts.save_dir, 'real', opts.word );
    for speaker = opts.speaker_train
        name = opts.speakers{speaker};
        for sample = opts.sample_train
            save_file =  strcat(opts.data, '_', name, '_', ...
                int2str(sample), '.mat');
            try
                load(fullfile(desc_dir, save_file)); r=r+1;
                data{r} = X; 
            catch
                if opts.verbose
                    fprintf('Did not succeed to open %s, %s, %s, %d.\n', ...
                        opts.data, opts.word, name, sample);
                end
            end
        end
    end
  else
    data = get_simulated_data ( opts );
  end
