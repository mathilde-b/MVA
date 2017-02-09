function [ audio_sample, word, fs ] = read_audio_data( data_path,name,sample )
%Read wav file and extract words
%   name & sample specify the speaker and the sample
    % Preallocation
    SIZE_DICT = 78;
    audio_sample = cell(1,SIZE_DICT);
    word = cell(1,SIZE_DICT);
    
    % Open the wav file
    file_path = fullfile(data_path, name, strcat(name, int2str(sample), '.wav'));
    [sound, fs] = audioread(file_path);
    
    % Open file descriptor
    file_path = fullfile(data_path, name, strcat('p_', lower(name), int2str(sample), '.txt'));
    fid = fopen(file_path);
    
    % Sampling
    i = 0;
    while true
        i = i+1;
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        A = strsplit(tline);
        begin = str2double(A{2})+1; ending = str2double(A{3})+1;
        word{i} = A{4};
        audio_sample{i} = sound(begin:ending);
    end
    fclose(fid);
end