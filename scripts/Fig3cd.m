%% ============================================================
%  Fig3c (S1) and Fig3d (Caudate)
%  Source data: PPE_Fig3cd_sourcedata.xlsx
%
%  Usage: place this script in the same folder as the Excel file,
%         set MATLAB current directory to that folder, then run.
%% ============================================================

clear; clc; close all;

%% --- path (EDIT THIS if needed)
dataFile = fullfile(pwd, 'PPE_Fig3cd_sourcedata.xlsx');

%% --- Load sheets
raw  = readtable(dataFile, 'Sheet', 'Fig3cd_subjectlevel');
summ = readtable(dataFile, 'Sheet', 'Fig3cd_summary');

%% --- settings
col_pain   = [0.0000 0.4470 0.7410];  % blue
col_reward = [0.8500 0.3250 0.0980];  % red-orange

ROIs_plot  = {'S1', 'Caudate'};
ylims      = {[-20 100], [-20 40]};   % y-axis limits per panel

offset     = 0.015;   % horizontal dodge between pain/reward
dotSize    = 14;
dotAlpha   = 0.5;
lineWidth  = 2.5;
markerSize = 8;
errWidth   = 2.0;
fs         = 14;

%% --- Figure
figure('Color','w','Position',[100 100 900 420]);

for r = 1:numel(ROIs_plot)

    roi = ROIs_plot{r};
    subplot(1,2,r); hold on;

    %% ---- individual subject dots ----
    % pain_PE
    idx_p = strcmp(string(raw.ROI), roi) & strcmp(string(raw.outcome), 'pain_PE');
    x_p   = raw.Alpha(idx_p) - offset;
    y_p   = raw.MeanCOPE(idx_p);
    jitter = (rand(size(x_p)) - 0.5) * 0.02;
    scatter(x_p + jitter, y_p, dotSize, ...
        'MarkerFaceColor', col_pain, ...
        'MarkerEdgeColor', 'none', ...
        'MarkerFaceAlpha', dotAlpha, ...
        'HandleVisibility','off');

    % reward_PE
    idx_r = strcmp(string(raw.ROI), roi) & strcmp(string(raw.outcome), 'reward_PE');
    x_r   = raw.Alpha(idx_r) + offset;
    y_r   = raw.MeanCOPE(idx_r);
    jitter = (rand(size(x_r)) - 0.5) * 0.02;
    scatter(x_r + jitter, y_r, dotSize, ...
        'MarkerFaceColor', col_reward, ...
        'MarkerEdgeColor', 'none', ...
        'MarkerFaceAlpha', dotAlpha, ...
        'HandleVisibility','off');

    %% ---- summary line + error bars ----
    % pain_PE
    idx_sp = strcmp(string(summ.ROI), roi) & strcmp(string(summ.outcome), 'pain_PE');
    Sp = summ(idx_sp,:);
    [xp, ord] = sort(Sp.Alpha);
    yp = Sp.Mean(ord);
    ep = Sp.SEM(ord);

    h1 = errorbar(xp - offset, yp, ep, '-o', ...
        'Color', col_pain, ...
        'LineWidth', lineWidth, ...
        'MarkerSize', markerSize, ...
        'MarkerFaceColor', 'w', ...
        'CapSize', 0, ...
        'DisplayName', 'pain PE');

    % reward_PE
    idx_sr = strcmp(string(summ.ROI), roi) & strcmp(string(summ.outcome), 'reward_PE');
    Sr = summ(idx_sr,:);
    [xr, ord] = sort(Sr.Alpha);
    yr = Sr.Mean(ord);
    er = Sr.SEM(ord);

    h2 = errorbar(xr + offset, yr, er, '-o', ...
        'Color', col_reward, ...
        'LineWidth', lineWidth, ...
        'MarkerSize', markerSize, ...
        'MarkerFaceColor', 'w', ...
        'CapSize', 0, ...
        'DisplayName', 'reward PE');

    %% ---- axes ----
    yline(0, 'k-', 'LineWidth', 0.8);
    xlabel('\alpha', 'FontSize', 18);
    ylabel('Prediction error (a.u.)', 'FontSize', 18);
    title(roi, 'FontSize', 18, 'FontWeight', 'normal');
    ylim(ylims{r});
    xlim([0.05 0.75]);
    xticks([0.1 0.2 0.3 0.5 0.7]);
    legend('Location','northeast','Box','off','FontSize',12);
    set(gca,'FontSize', fs, 'LineWidth', 1.2, 'TickDir','out', 'Box','off');
end

%% --- Save
exportgraphics(gcf, 'Fig3cd.pdf', 'ContentType','vector');
exportgraphics(gcf, 'Fig3cd.png', 'Resolution', 300);
fprintf('Saved: Fig3cd.pdf / Fig3cd.png\n');
