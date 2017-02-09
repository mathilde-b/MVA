function [ video_sample, word ] = read_video_data( data_path,name,sample )
%Read video txt file and extract words
%   name & sample specify the speaker and the sample
    % Preallocation
    CONVERTION_RATIO = 1450;
    SIZE_DICT = 78;
    video_sample = cell(1,SIZE_DICT);
    word = cell(1,SIZE_DICT);
    
    % Open the txt file and file descriptor
    file_path = fullfile(data_path, name, strcat(name, int2str(sample), '.txt'));
    fid = fopen(file_path);
    
    file_path = fullfile(data_path, name, strcat('p_', lower(name), int2str(sample), '.txt'));
    desc_id = fopen(file_path);
    
    % Read data file
    fgetl(fid); % Skip the first line
    i=0;
    while true
        i = i+1;    
        % Descriptor file
        tline = fgetl(desc_id);
        if ~ischar(tline), break, end
        A = strsplit(tline);
        word{i} = A{4};
        begin = ceil((str2double(A{2})+1)/CONVERTION_RATIO); 
        ending = ceil((str2double(A{3})+1)/CONVERTION_RATIO);
        
        % Data file
        j = 0; h=zeros(ending-begin,3); k=0;
        while j<ending
            tline = fgetl(fid);
            if ~ischar(tline), break, end
            A = strsplit(tline);
            j = str2double(A{1}); k=k+1;
            try
            h(k,1) = ((str2double(A{4})-str2double(A{2})).^(2) + ...
                (str2double(A{5})-str2double(A{3})).^(2)).^(.5);
            catch
                fprintf('error')
            end
            h(k,2) = str2double(A{6});
            h(k,3) = str2double(A{7});
        end
        video_sample{i} = h;
    end
    
    % Close file
    fclose(fid);
    fclose(desc_id);
end

