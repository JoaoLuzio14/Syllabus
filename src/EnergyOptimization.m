M = 810;
P0 = 200;
[K,~] = size(res);
E_ = 0;

dist = zeros(1,K-1);
for i=1:(K-1)
   dist(1,i) = sqrt((res(i+1,1)-res(i,1))^2 + (res(i+1,2)-res(i,2))^2); 
end

% Solve optimization problem
cvx_begin quiet

        variables t(1, K-1)
        
        % Build cost function 
        for i = 1:(K-1)
            d2 = dist(1, i)*dist(1, i);
            t2 = pow_p(t(1,i),-2);
            E_ = E_ + M*d2*t2 - P0*t(1, i);
        end

        f = E_;
        minimize f;

        % Subjet to
        sum(t.') <= 120;
        t(1,:) >= 1;
        
cvx_end;
    
speed = zeros(K-1,1);
for i=1:(K-1)
    speed(i) = dist(1,i)/t(1,i);   
end
E = E_;



