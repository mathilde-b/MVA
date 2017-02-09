function [ dist ] = distl2 ( A, B )
% Distances between point of A and B
    % Points correspond to matrix rows
    nb_ptA = size(A, 1); nb_ptB = size(B, 1);
    normA2 = repmat( sum(A.*A,2) , [ 1, nb_ptB ] );
    normB2 = repmat( sum(B.*B,2) , [ 1, nb_ptA ] )';
    dist = abs( normA2 + normB2 - 2*A*B' );
end