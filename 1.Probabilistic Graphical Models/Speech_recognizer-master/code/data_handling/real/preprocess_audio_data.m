function preprocess_audio_data( opts )
%Saving data after preprocessing
    for i = 1:numel(opts.speakers)
        speaker = opts.speakers{i};
        for sample = A:opts.nb_samples
            [ sounds, words, fs ] = read_audio_data( opts.data_path, speaker, sample );
            for j = 1:numel(words)
                word = words{j};
                if ~isempty(word)
                    sound = sounds{j};
                    X = get_audio_descriptors(sound, fs, opts.size_audio_descriptors, opts.display_descriptors, opts.verbose );
                    file_name = strcat('audio_', speaker, '_', int2str(sample));
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

