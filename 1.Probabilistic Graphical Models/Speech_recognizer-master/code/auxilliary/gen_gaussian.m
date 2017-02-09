function [ X ] = gen_gaussian( mu, cov )
    X_01 = randn(length(mu),1);
    X = sqrt(cov)*X_01 + mu;
end

