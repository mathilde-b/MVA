function preprocess_video_data( opts )
%Saving data after preprocessing
    for i = 1:numel(opts.speakers)
        speaker = opts.speakers{i};
        for sample = 1:opts.nb_samples
            [ sounds, words ] = read_video_data( opts.data_path, speaker, sample );
            for j = 1:numel(words)
                word = words{j};
                if ~isempty(word)
                    X = sounds{j};
                    file_name = strcat('video_', speaker, '_', int2str(sample));
                    save_dir = fullfile(opts.save_dir, 'real', word);
                    if ~exist(save_dir, 'dir')
                        mkdir(save_dir);
                    end
                    save(fullfile(save_dir, file_name), 'X');
                end
            end
        end
    end
end


