function [y,C,distortion] = run_k_means(K, X, nb)
% Perform nb k means algorithms and return the best solution
    % Optional arguments
    if nargin < 3
        nb = 10;
    end

    distortion = Inf; y=[]; C=[];
    for i=1:nb
        [y_new,C_new,distortion_new] = k_means(K, X );
        if distortion_new < distortion
            y = y_new; C = C_new; distortion = distortion_new;
        end
    end
end