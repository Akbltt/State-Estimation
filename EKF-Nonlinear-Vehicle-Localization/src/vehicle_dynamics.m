function xNext = vehicle_dynamics(x, u, dt)
%VEHICLE_DYNAMICS Nonlinear unicycle-style vehicle model.
% State: x = [px; py; psi; v], input: u = [a; omega].

px = x(1);
py = x(2);
psi = x(3);
v = x(4);

a = u(1);
omega = u(2);

pxNext = px + v * cos(psi) * dt;
pyNext = py + v * sin(psi) * dt;
psiNext = wrapToPi(psi + omega * dt);
vNext = max(0.1, v + a * dt);

xNext = [pxNext; pyNext; psiNext; vNext];
end
