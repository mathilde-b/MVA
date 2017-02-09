function preprocess_data( opts )
  if opts.real
    if ~exist(fullfile(opts.save_dir, 'real', 'a.m.'), 'dir')
      if opts.verbose
        fprintf('Preprocessing data. Do not quit, but do not hesistate to go take a coffee.\n');
      end
      preprocess_video_data( opts );
      preprocess_audio_data( opts );
    end
  end
