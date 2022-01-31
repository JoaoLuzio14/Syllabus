function [speed, E] = EnergyOpt(res, P0, lambda)

    M = 810;
    [K,~] = size(res);
    E_ = 0;

    dist = zeros(K-1,1);
    for i=1:(K-1)
       dist(i) = sqrt((res(i+1,1)-res(i,1))^2 + (res(i+1,2)-res(i,2))^2); 
    end

    % Solve optimization problem
    cvx_begin quiet

            variables t(1, K-1)

            % Build cost function 
            for i = 1:(K-1)
                d = dist(i)*dist(i);
                time = pow_p(t(i),-2);
                E_ = E_ + M*d*time - P0*t(i) + lambda*t(i)*t(i);
            end

            f = E_;
            minimize f;

            % Subjet to
            sum(t) <= 300; % Takes less then 5 min
            t(:) >= 0;
            dist(:) >= 1.389*t(:); % Minimum Speed
            dist(:) <= 5.556*t(:); % Maximum Speed

    cvx_end;

    speed = zeros(K-1,1);
    for i=1:(K-1)
        speed(i) = dist(i)/t(i);   
    end
    E = E_;

end