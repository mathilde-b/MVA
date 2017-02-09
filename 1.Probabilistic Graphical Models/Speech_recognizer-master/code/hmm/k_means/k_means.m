function [ y, C, distortion ] = k_means(K, X )
% Perform the k means algorithm on X

    % Implicit parameter
    nb_pt = size(X,1);


    % Pick randomly K means
    center_ind = randperm(nb_pt, K);
    C = X(center_ind,:);
    C_old = Inf;

    % Until convergence criterion is reached
    while C ~= C_old
        C_old = C;

        % Compute distance to cluster centers
        dist2C = distl2(X, C_old);
        [M,y] = min(dist2C,[],2);

        % Find the new cluster centers
        for i=1:K
            ind = y == i;
            C(i,:) = mean(X(ind,:),1);
        end
    end
    distortion = sum(M);
end