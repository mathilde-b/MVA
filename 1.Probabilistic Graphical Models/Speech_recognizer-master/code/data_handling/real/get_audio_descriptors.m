function [ desc, f ] = get_audio_descriptors( sound_sample, fs, k, disp, verbose )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    if nargin<5, verbose = false; end;
    if nargin<4, disp = false; end;
    if nargin<3, k = 5; end;

    % Implicit parameter
    T = size(sound_sample, 1);

    % Wavelet transform
    [wt,f] = cwt(sound_sample,fs);
    a = abs(wt);
    if disp
        figure(100); clf; imagesc(a);
        xlabel('Time');ylabel('Frequency index'); title('Scalogram')
        b = zeros(size(a));
    end

    % Filtering to remove noise
    [m, i] = max(a(:)); pos_pitch = mod(i,size(a,1));
    a = a.*(a>(0.05*m));

    % Find Maximum at a given time: silly iterative implementation
    desc = zeros(T,2*k);
    if verbose
      fprintf(' - Getting audio descriptors.\n')
    end
    for n=1:T
        [pks,locs] = findpeaks(a(:,n), 'SortStr','descend', 'NPeaks', k);
        tmp = size(pks,1);
        desc(n, 1:tmp) = pks;
        % Invariance to pitch by shifting method (not necessarly stable)
        desc(n, k+1:k+tmp) = locs - pos_pitch;
        if disp
            b(locs,n) = pks;
        end
    end

    if disp
        figure(101); clf; imagesc(a);
        xlabel('Time');ylabel('Frequency index'); title('Scalogram')

        figure(102); clf; imagesc(b);
        xlabel('Time');ylabel('Frequency index'); title('Descriptors')
        pause(.01)
    end
end
