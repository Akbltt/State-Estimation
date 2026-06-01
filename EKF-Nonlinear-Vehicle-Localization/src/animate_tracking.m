function animate_tracking(cfg, out)
%ANIMATE_TRACKING Creates smooth EKF tracking animation and exports GIF/MP4.

if ~cfg.animation.makeGif && ~cfg.animation.makeMp4
    return;
end

gifPath = fullfile(cfg.resultsDir, cfg.animation.gifFilename);
mp4Path = fullfile(cfg.resultsDir, cfg.animation.mp4Filename);

fig = figure('Color', 'w', 'Name', 'EKF Tracking Animation');
axis equal;
grid on;
box on;
hold on;

xAll = [out.xTrue(1, :), out.zMeas(1, :)];
yAll = [out.xTrue(2, :), out.zMeas(2, :)];
padding = 6;
xlim([min(xAll)-padding, max(xAll)+padding]);
ylim([min(yAll)-padding, max(yAll)+padding]);
xlabel('x [m]');
ylabel('y [m]');
title('Nonlinear Vehicle Localization - EKF');

hTrueTrail = plot(nan, nan, 'k-', 'LineWidth', 1.5);
hEstTrail = plot(nan, nan, '-', 'Color', [0.1 0.42 0.82], 'LineWidth', 1.5);
hTrue = plot(nan, nan, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);
hEst = plot(nan, nan, 'o', 'Color', [0.1 0.42 0.82], 'MarkerFaceColor', [0.1 0.42 0.82], 'MarkerSize', 6);
hGps = plot(nan, nan, '.', 'Color', [0.75 0.75 0.75], 'MarkerSize', 10);
hEllipse = plot(nan, nan, '-', 'Color', [0.2 0.55 0.2], 'LineWidth', 1.0);
legend('True trail', 'EKF trail', 'True state', 'EKF state', 'GPS measurement', '2\sigma ellipse', ...
    'Location', 'southwest');

if cfg.animation.makeMp4
    writerObj = VideoWriter(mp4Path, 'MPEG-4');
    writerObj.FrameRate = cfg.animation.playbackFps;
    open(writerObj);
else
    writerObj = [];
end

frameStep = max(1, cfg.animation.frameStep);
delayTime = 1 / cfg.animation.playbackFps;

for k = 1:frameStep:numel(out.time)
    set(hTrueTrail, 'XData', out.xTrue(1, 1:k), 'YData', out.xTrue(2, 1:k));
    set(hEstTrail, 'XData', out.xEst(1, 1:k), 'YData', out.xEst(2, 1:k));
    set(hTrue, 'XData', out.xTrue(1, k), 'YData', out.xTrue(2, k));
    set(hEst, 'XData', out.xEst(1, k), 'YData', out.xEst(2, k));
    set(hGps, 'XData', out.zMeas(1, max(1, k-15):k), 'YData', out.zMeas(2, max(1, k-15):k));

    % Update uncertainty ellipse line without creating new plot objects.
    Pxy = 0.5 * (out.P(1:2, 1:2, k) + out.P(1:2, 1:2, k)');
    [V, D] = eig(Pxy);
    lambda = max(diag(D), 1e-12);
    theta = linspace(0, 2 * pi, 60);
    unitCircle = [cos(theta); sin(theta)];
    ellipse = 2 * V * diag(sqrt(lambda)) * unitCircle + out.xEst(1:2, k);
    set(hEllipse, 'XData', ellipse(1, :), 'YData', ellipse(2, :));

    drawnow;

    frame = getframe(fig);
    if cfg.animation.makeGif
        [imind, cm] = rgb2ind(frame2im(frame), 256);
        if k == 1
            imwrite(imind, cm, gifPath, 'gif', 'Loopcount', inf, 'DelayTime', delayTime);
        else
            imwrite(imind, cm, gifPath, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
        end
    end

    if cfg.animation.makeMp4
        writeVideo(writerObj, frame);
    end
end

if cfg.animation.makeMp4
    close(writerObj);
end
end
