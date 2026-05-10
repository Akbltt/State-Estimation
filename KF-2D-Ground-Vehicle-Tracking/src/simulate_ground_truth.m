function [t, xTrue, uTrue] = simulate_ground_truth(cfg)
%SIMULATE_GROUND_TRUTH Generate trajectory with piecewise accelerations.

N = cfg.N;
dt = cfg.dt;
t = (0:N-1) * dt;

xTrue = zeros(4, N);
uTrue = zeros(2, N);
xTrue(:, 1) = cfg.x0True;

for k = 2:N
    tk = t(k);

    [ax, ay, yawRate] = truth_maneuver_profile(tk, cfg.truthModel.enableManeuvers);

    prevPos = xTrue(1:2, k-1);
    prevVel = xTrue(3:4, k-1);

    vel = prevVel + [ax; ay] * dt;

    if yawRate ~= 0
        theta = yawRate * dt;
        Rz = [cos(theta), -sin(theta);
              sin(theta),  cos(theta)];
        vel = Rz * vel;
    end

    pos = prevPos + prevVel * dt + 0.5 * [ax; ay] * dt^2;

    xTrue(:, k) = [pos; vel];
    uTrue(:, k) = [ax; ay];
end
end

function [ax, ay, yawRate] = truth_maneuver_profile(t, enableManeuvers)
%TRUTH_MANEUVER_PROFILE Piecewise truth accelerations and turn-rate.

ax = 0.0;
ay = 0.0;
yawRate = 0.0;

if ~enableManeuvers
    return;
end

if t > 10 && t <= 18
    ay = 0.7;
elseif t > 24 && t <= 34
    ax = -0.5;
end

if t > 30 && t <= 38
    yawRate = deg2rad(5.0);
end
end
