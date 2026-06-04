%% ============================================================
%  Fig.1c: Value / PE time-series
%  Interleaved CS structure version
%
%  - Load C1-C4 files and regressor files from baseDir
%  - Value: same-CS trajectory line + marker
%  - PE: vertical stem/bar + marker
%
%  Usage: set baseDir to the folder containing regressor files
%         (C1, C2, C3, C4, Value_*.txt, PE_*.txt)
%% ============================================================

clear; clc; close all

%% --- paths (EDIT THIS)
baseDir = fullfile(pwd, 'demodata');  % ← set to your regressor folder

peShift = 8;  % seconds; adjust between 6-10 for visual clarity

% alpha = 0.1 → run 01, alpha = 0.7 → run 07
F.Value.Rew.a01 = fullfile(baseDir, 'Value_Reward01.txt');
F.Value.Rew.a07 = fullfile(baseDir, 'Value_Reward07.txt');
F.Value.Pun.a01 = fullfile(baseDir, 'Value_Punishment01.txt');
F.Value.Pun.a07 = fullfile(baseDir, 'Value_Punishment07.txt');

F.PE.Rew.a01 = fullfile(baseDir, 'PE_Reward01.txt');
F.PE.Rew.a07 = fullfile(baseDir, 'PE_Reward07.txt');
F.PE.Pun.a01 = fullfile(baseDir, 'PE_Punishment01.txt');
F.PE.Pun.a07 = fullfile(baseDir, 'PE_Punishment07.txt');

% CS onset files
F.C1 = fullfile(baseDir, 'C1');
F.C2 = fullfile(baseDir, 'C2');
F.C3 = fullfile(baseDir, 'C3');
F.C4 = fullfile(baseDir, 'C4');

%% --- helper
readEV = @(fp) sortrows(readmatrix(fp), 1);

EV.Value.Rew.a01 = readEV(F.Value.Rew.a01);
EV.Value.Rew.a07 = readEV(F.Value.Rew.a07);
EV.Value.Pun.a01 = readEV(F.Value.Pun.a01);
EV.Value.Pun.a07 = readEV(F.Value.Pun.a07);

EV.PE.Rew.a01 = readEV(F.PE.Rew.a01);
EV.PE.Rew.a07 = readEV(F.PE.Rew.a07);
EV.PE.Pun.a01 = readEV(F.PE.Pun.a01);
EV.PE.Pun.a07 = readEV(F.PE.Pun.a07);

C1 = readEV(F.C1);
C2 = readEV(F.C2);
C3 = readEV(F.C3);
C4 = readEV(F.C4);

%% --- CS onset only
C1_on = C1(:,1);
C2_on = C2(:,1);
C3_on = C3(:,1);
C4_on = C4(:,1);

%% --- outcome onset for PE matching
% PE is locked to outcome onset.
% In this task, outcome onset = CS onset + 14 s
outcomeDelay = 14;

C1_pe_on = C1_on + outcomeDelay;
C2_pe_on = C2_on + outcomeDelay;
C3_pe_on = C3_on + outcomeDelay;
C4_pe_on = C4_on + outcomeDelay;

%% --- plotting settings
lab01 = '\alpha = 0.1';
lab07 = '\alpha = 0.7';

% CS colors
col.C1 = [0.80 0.10 0.10];   % CS1 reward 80% - dark red
col.C2 = [1.00 0.55 0.25];   % CS2 reward 20% - orange
col.C3 = [0.10 0.25 0.85];   % CS3 pain 80%   - dark blue
col.C4 = [0.30 0.75 1.00];   % CS4 pain 20%   - light blue

msValue = 36;
msPE    = 32;

figure('Color','w','Position',[100 100 1250 850]);

%% ============================================================
% (1) Reward Value
%% ============================================================
subplot(2,2,1); hold on;

plotValueByCS(EV.Value.Rew.a01, C1_on, col.C1, msValue, 'o');
plotValueByCS(EV.Value.Rew.a01, C2_on, col.C2, msValue, 'o');

plotValueByCS(EV.Value.Rew.a07, C1_on, col.C1, msValue, '^');
plotValueByCS(EV.Value.Rew.a07, C2_on, col.C2, msValue, '^');

title('Reward Value');
xlabel('Onset (s)');
ylabel('Value');
set(gca, 'FontSize', 16);
xlim([0 3200]);
ylim([0 1]);
box off;

%% ============================================================
% (2) Pain Value
%% ============================================================
subplot(2,2,2); hold on;

plotValueByCS(EV.Value.Pun.a01, C3_on, col.C3, msValue, 'o');
plotValueByCS(EV.Value.Pun.a01, C4_on, col.C4, msValue, 'o');

plotValueByCS(EV.Value.Pun.a07, C3_on, col.C3, msValue, '^');
plotValueByCS(EV.Value.Pun.a07, C4_on, col.C4, msValue, '^');

yline(0, 'k-', 'LineWidth', 0.8);

title('Pain Value');
xlabel('Onset (s)');
ylabel('Value');
set(gca, 'FontSize', 16);
xlim([0 3200]);
ylim([-1.5 1]);
box off;

%% ============================================================
% (3) Reward PE
%% ============================================================
subplot(2,2,3); hold on;

plotPEbyCS(EV.PE.Rew.a01, C1_pe_on, col.C1, msPE, 'o', -peShift);
plotPEbyCS(EV.PE.Rew.a01, C2_pe_on, col.C2, msPE, 'o', -peShift);

plotPEbyCS(EV.PE.Rew.a07, C1_pe_on, col.C1, msPE, '^',  peShift);
plotPEbyCS(EV.PE.Rew.a07, C2_pe_on, col.C2, msPE, '^',  peShift);

yline(0, 'k-', 'LineWidth', 0.8);

title('Reward Prediction Error');
xlabel('Outcome onset (s)');
ylabel('PE');
set(gca, 'FontSize', 16);
xlim([0 3200]);
ylim([-2 1]);
box off;

%% ============================================================
% (4) Pain PE
%% ============================================================
subplot(2,2,4); hold on;

plotPEbyCS(EV.PE.Pun.a01, C3_pe_on, col.C3, msPE, 'o', -peShift);
plotPEbyCS(EV.PE.Pun.a01, C4_pe_on, col.C4, msPE, 'o', -peShift);

plotPEbyCS(EV.PE.Pun.a07, C3_pe_on, col.C3, msPE, '^',  peShift);
plotPEbyCS(EV.PE.Pun.a07, C4_pe_on, col.C4, msPE, '^',  peShift);

yline(0, 'k-', 'LineWidth', 0.8);

title('Pain Prediction Error');
xlabel('Outcome onset (s)');
ylabel('PE');
set(gca, 'FontSize', 16);
xlim([0 3200]);
ylim([-2 1]);
box off;

%% ============================================================
% Legend
%% ============================================================
h1 = scatter(nan,nan,120,col.C1,'filled');
h2 = scatter(nan,nan,120,col.C2,'filled');
h3 = scatter(nan,nan,120,col.C3,'filled');
h4 = scatter(nan,nan,120,col.C4,'filled');
h5 = scatter(nan,nan,120,'k','o','filled');
h6 = scatter(nan,nan,120,'k','^','filled');

lgd = legend([h1 h2 h3 h4 h5 h6], ...
    {'CS1 reward 80%', ...
     'CS2 reward 20%', ...
     'CS3 pain 80%',   ...
     'CS4 pain 20%',   ...
     lab01, lab07},    ...
     'Orientation','horizontal', ...
     'Box','off', ...
     'FontSize',16);

lgd.Position = [0.12 -0.02 0.76 0.07];

%% ============================================================
% Local functions
%% ============================================================

function plotValueByCS(EVmat, CS_onsets, colorVal, markerSize, markerType)
    tol = 1e-6;
    evOnsets = EVmat(:,1);
    idx = false(size(evOnsets));
    for i = 1:numel(CS_onsets)
        idx = idx | abs(evOnsets - CS_onsets(i)) < tol;
    end
    x = EVmat(idx,1);
    y = EVmat(idx,3);
    [x, ord] = sort(x);
    y = y(ord);
    if markerType == 'o'
        lineStyle = '-';  lineWidth = 1.5;
    else
        lineStyle = '--'; lineWidth = 1.0;
    end
    plot(x, y, lineStyle, 'Color', colorVal, 'LineWidth', lineWidth, 'HandleVisibility','off');
    scatter(x, y, markerSize, colorVal, markerType, 'filled', ...
        'MarkerFaceAlpha',0.90, 'MarkerEdgeColor','none');
end

function plotPEbyCS(EVmat, CS_onsets, colorVal, markerSize, markerType, xShift)
    tol = 1e-6;
    evOnsets = EVmat(:,1);
    idx = false(size(evOnsets));
    for i = 1:numel(CS_onsets)
        idx = idx | abs(evOnsets - CS_onsets(i)) < tol;
    end
    x = EVmat(idx,1);
    y = EVmat(idx,3);
    [x, ord] = sort(x);
    y = y(ord);
    xPlot = x + xShift;
    if markerType == 'o'; stemWidth = 1.1; else; stemWidth = 0.9; end
    for k = 1:numel(xPlot)
        line([xPlot(k) xPlot(k)], [0 y(k)], ...
            'Color', colorVal, 'LineWidth', stemWidth, 'HandleVisibility','off');
    end
    scatter(xPlot, y, markerSize, colorVal, markerType, 'filled', ...
        'MarkerFaceAlpha',0.90, 'MarkerEdgeColor','none');
end
