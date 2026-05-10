function result = run_linear_kf(zMeas, cfg)
%RUN_LINEAR_KF Run linear KF over full measurement sequence.

model = build_kf_models(cfg.dt, cfg.qAccel, cfg.R_meas);

N = size(zMeas, 2);
xHat = zeros(4, N);
PHist = zeros(4, 4, N);
KHist = zeros(4, 2, N);
innovHist = zeros(2, N);
SxxHist = zeros(2, 2, N);

xHat(:, 1) = cfg.x0Hat;
PHist(:, :, 1) = cfg.P0;

for k = 2:N
    [xPred, PPred] = kf_predict(xHat(:, k-1), PHist(:, :, k-1), model.F, model.Q);

    [xUpd, PUpd, K, innov, S] = kf_update(xPred, PPred, zMeas(:, k), model.H, model.R);

    xHat(:, k) = xUpd;
    PHist(:, :, k) = PUpd;
    KHist(:, :, k) = K;
    innovHist(:, k) = innov;
    SxxHist(:, :, k) = S;
end

result.model = model;
result.xHat = xHat;
result.PHist = PHist;
result.KHist = KHist;
result.innovHist = innovHist;
result.SHist = SxxHist;
end
