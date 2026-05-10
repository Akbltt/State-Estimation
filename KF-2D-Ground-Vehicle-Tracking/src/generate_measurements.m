function zMeas = generate_measurements(xTrue, R)
%GENERATE_MEASUREMENTS Generate noisy position measurements.

N = size(xTrue, 2);
H = [1 0 0 0;
     0 1 0 0];

noise = chol(R, "lower") * randn(2, N);
zMeas = H * xTrue + noise;
end
