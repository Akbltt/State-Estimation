function animate_tracking(t, xTrue, zMeas, xHat, PHist, resultsDir, cfg)
%ANIMATE_TRACKING Animate 2D tracking and optionally export as GIF.

opts = cfg.animation;
N = numel(t);
frameSkip = max(1, opts.frameSkip);

gifPath = fullfile(resultsDir, opts.gifFileName);
if opts.exportGif && exist(gifPath, "file")
    delete(gifPath);
end

fig = figure("Color", "w", "Name", "KF Tracking Demo");
ax = axes(fig);
hold(ax, "on");
grid(ax, "on");
box(ax, "on");
axis(ax, "equal");

xMin = min([xTrue(1, :), zMeas(1, :), xHat(1, :)]) - 10;
xMax = max([xTrue(1, :), zMeas(1, :), xHat(1, :)]) + 10;
yMin = min([xTrue(2, :), zMeas(2, :), xHat(2, :)]) - 10;
yMax = max([xTrue(2, :), zMeas(2, :), xHat(2, :)]) + 10;
axis(ax, [xMin xMax yMin yMax]);

trueTrail = animatedline(ax, "Color", [0.05 0.05 0.05], "LineWidth", 1.8);
measTrail = animatedline(ax, "Color", [0.7 0.7 0.7], "LineStyle", "none", "Marker", ".", "MarkerSize", 10);
estTrail = animatedline(ax, "Color", [0.0 0.35 0.85], "LineWidth", 1.6);

trueNow = plot(ax, nan, nan, "ko", "MarkerFaceColor", "k", "MarkerSize", 6);
measNow = plot(ax, nan, nan, "o", "Color", [0.55 0.55 0.55], "MarkerFaceColor", [0.75 0.75 0.75], "MarkerSize", 5);
estNow = plot(ax, nan, nan, "bo", "MarkerFaceColor", [0.0 0.35 0.85], "MarkerSize", 6);

if opts.showCovarianceEllipse
    ell = plot(ax, nan, nan, "-", "Color", [0.0 0.35 0.85], "LineWidth", 1.0);
else
    ell = gobjects(1, 1);
end

legend(ax, [trueNow, measNow, estNow], {"True position", "GPS measurement", "KF estimate"}, "Location", "northwest");
xlabel(ax, "x [m]");
ylabel(ax, "y [m]");

frameIdx = 0;
gifMap = [];

for k = 1:frameSkip:N
    frameIdx = frameIdx + 1;

    addpoints(trueTrail, xTrue(1, k), xTrue(2, k));
    addpoints(measTrail, zMeas(1, k), zMeas(2, k));
    addpoints(estTrail, xHat(1, k), xHat(2, k));

    set(trueNow, "XData", xTrue(1, k), "YData", xTrue(2, k));
    set(measNow, "XData", zMeas(1, k), "YData", zMeas(2, k));
    set(estNow, "XData", xHat(1, k), "YData", xHat(2, k));

    if opts.showCovarianceEllipse
        [xe, ye] = covariance_ellipse_xy(xHat(1:2, k), PHist(1:2, 1:2, k), opts.ellipseNSigma, 80);
        set(ell, "XData", xe, "YData", ye);
    end

    title(ax, sprintf("KF Tracking Animation | t = %.1f s", t(k)));

    % Force draw before frame capture so each animation step is written.
    drawnow;

    if opts.exportGif
        frame = getframe(ax);
        rgb = frame2im(frame);

        if frameIdx == 1
            [imInd, gifMap] = rgb2ind(rgb, 256);
            imwrite(imInd, gifMap, gifPath, "gif", "LoopCount", inf, "DelayTime", opts.gifDelay);
        else
            imInd = rgb2ind(rgb, gifMap);
            imwrite(imInd, gifMap, gifPath, "gif", "WriteMode", "append", "DelayTime", opts.gifDelay);
        end
    end

    if opts.realTimePlayback
        pause((cfg.dt * frameSkip) / max(opts.playbackSpeed, 0.1));
    end
end

if opts.closeFigureOnFinish
    close(fig);
end
end

function [xEllipse, yEllipse] = covariance_ellipse_xy(mu, Pxy, nSigma, nPts)
%COVARIANCE_ELLIPSE_XY Build 2D covariance ellipse coordinates.

Pxy = 0.5 * (Pxy + Pxy');
[V, D] = eig(Pxy);
D = max(real(diag(D)), 0);

theta = linspace(0, 2 * pi, nPts);
unitCircle = [cos(theta); sin(theta)];
shape = V * diag(sqrt(D)) * unitCircle;
ellipsePts = mu + nSigma * shape;

xEllipse = ellipsePts(1, :);
yEllipse = ellipsePts(2, :);
end
