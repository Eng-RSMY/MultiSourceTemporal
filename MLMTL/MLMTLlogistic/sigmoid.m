function val = sigmoid ( w, X )
    [P,N] = size(X);
    val = zeros(N,1);
    for n= 1:N
        val(n) = 1/(1+exp((-w'*X(:,n))));
    end
end


