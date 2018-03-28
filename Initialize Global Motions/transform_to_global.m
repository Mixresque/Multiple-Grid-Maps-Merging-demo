function p = transform_to_global(q, R, t)


p(1:2,:) = R*q(1:2,:);

% translate
p(1,:) = p(1,:) + t(1);
p(2,:) = p(2,:) + t(2);