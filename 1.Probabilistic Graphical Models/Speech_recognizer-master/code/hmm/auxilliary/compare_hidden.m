function [ err ] = compare_hidden( hidden1, hidden2 )
%Convergence criterion
    try
        eta1 = hidden1.eta; eta2 = hidden2.eta;
        gamma1 = hidden1.gamma; gamma2 = hidden2.gamma;
        err_q = sum(abs(eta1(:)-eta2(:)));
        err_c = sum(abs(gamma1(:)-gamma2(:)));
        err = .5*err_q + .5*err_c;
    catch
        err = Inf;
    end
end

