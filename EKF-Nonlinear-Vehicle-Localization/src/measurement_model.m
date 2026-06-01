function [zPred, H] = measurement_model(x)
%MEASUREMENT_MODEL GPS-like position measurement model.
% z = [x; y] + noise.

zPred = x(1:2);
H = [1 0 0 0;
     0 1 0 0];
end
