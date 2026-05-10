function model = build_kf_models(dt, qAccel, R_meas)
%BUILD_KF_MODELS Build linear CV model and position-only measurement model.

F = [1 0 dt 0;
     0 1 0 dt;
     0 0 1 0;
     0 0 0 1];

G = [0.5 * dt^2, 0;
     0, 0.5 * dt^2;
     dt, 0;
     0, dt];

Q = G * diag(qAccel) * G';

H = [1 0 0 0;
     0 1 0 0];

model.F = F;
model.G = G;
model.Q = Q;
model.H = H;
model.R = R_meas;
end
