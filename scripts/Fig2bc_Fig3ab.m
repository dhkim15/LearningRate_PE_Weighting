%% ============================================================
%  Fig2b, Fig2c, Fig3a, Fig3b
%  Source data: PPE_Fig2bc_Fig3ab_sourcedata.xlsx
%
%  Usage: place this script in the same folder as the Excel file,
%         set MATLAB current directory to that folder, then run.
%% ============================================================

clear; clc; close all;

%% --- path (EDIT THIS if needed)
dataFile = fullfile(pwd, 'PPE_Fig2bc_Fig3ab_sourcedata.xlsx');

%% --- ROI order and colors
roiOrder  = {'S1','ACC','Insula','Putamen','Caudate','Thalamus'};
roiColors = containers.Map( ...
    roiOrder, ...
    {[0.00 0.45 0.74], ...   % S1       - blue
     [0.85 0.33 0.10], ...   % ACC      - red-orange
     [0.93 0.69 0.13], ...   % Insula   - yellow
     [0.49 0.18 0.56], ...   % Putamen  - purple
     [0.47 0.67 0.19], ...   % Caudate  - green
     [0.30 0.75 0.93]});     % Thalamus - cyan

fs      = 12;
lw_main = 2.0;
lw_ci   = 2.6;
lw_err  = 1.0;
capB    = 3;

%% --- Load sheets
opts = detectImportOptions(dataFile, "Sheet", "Fig2b_LME_slopes");
opts.VariableNamingRule = "preserve";
RT_base = readtable(dataFile, opts);
opts = detectImportOptions(dataFile, "Sheet", "Fig2c_MeanDeltaPE");
opts.VariableNamingRule = "preserve";
MT_base = readtable(dataFile, opts);
opts = detectImportOptions(dataFile, "Sheet", "Fig3a_LME_slopes");
opts.VariableNamingRule = "preserve";
RT_ctrl = readtable(dataFile, opts);
opts = detectImportOptions(dataFile, "Sheet", "Fig3b_MeanDeltaPE");
opts.VariableNamingRule = "preserve";
MT_ctrl = readtable(dataFile, opts);

%% --- Enforce ROI order
for tbl = {RT_base, MT_base, RT_ctrl, MT_ctrl}; end  % preload
RT_base.ROI = categorical(string(RT_base.ROI), roiOrder, 'Ordinal', true);
MT_base.ROI = categorical(string(MT_base.ROI), roiOrder, 'Ordinal', true);
RT_ctrl.ROI = categorical(string(RT_ctrl.ROI), roiOrder, 'Ordinal', true);
MT_ctrl.ROI = categorical(string(MT_ctrl.ROI), roiOrder, 'Ordinal', true);

RT_base = sortrows(RT_base, 'ROI');
MT_base = sortrows(MT_base, {'ROI','Alpha'});
RT_ctrl = sortrows(RT_ctrl, 'ROI');
MT_ctrl = sortrows(MT_ctrl, {'ROI','Alpha'});

%% ============================================================
%  Fig2b + Fig2c (base model)
%% ============================================================
f1 = figure('Color','w','Position',[100 100 900 420]);
tiledlayout(1,2,'Padding','compact','TileSpacing','compact');

%% Panel A: Fig2b
axA = nexttile; hold(axA,'on');
nROI = height(RT_base);
ypos = 1:nROI;
xpad = 0.025 * range([RT_base.CI_low; RT_base.CI_high]);
if xpad == 0; xpad = 1; end

for i = 1:nROI
    roi = char(RT_base.ROI(i));
    col = roiColors(roi);
    plot(axA, [RT_base.CI_low(i) RT_base.CI_high(i)], [ypos(i) ypos(i)], '-', ...
        'LineWidth', lw_ci, 'Color', col);
    plot(axA, RT_base.beta_Alpha(i), ypos(i), 'o', ...
        'MarkerSize', 7, 'MarkerFaceColor', col, ...
        'MarkerEdgeColor', 'w', 'LineWidth', 0.8);
    isSig = RT_base.("FDR_significant (q<0.05)")(i);
    if isSig
        text(axA, RT_base.CI_high(i) + xpad, ypos(i), '*', ...
            'FontSize', 14, 'FontWeight','bold', ...
            'Color', col, 'VerticalAlignment','middle');
    end
end
yticks(axA, ypos);
yticklabels(axA, string(RT_base.ROI));
yline(axA, 0, '--', 'LineWidth', 1, 'Color', [0.4 0.4 0.4]);
xlabel(axA, '\beta_\alpha (base model)');
grid(axA,'on'); box(axA,'off');
set(axA,'TickDir','out','FontSize',fs,'Layer','top');
axA.GridAlpha = 0.15;

%% Panel B: Fig2c
axB = nexttile; hold(axB,'on');
aAll   = sort(unique(MT_base.Alpha));
nROI2  = numel(roiOrder);
roiOff = ((1:nROI2) - (nROI2+1)/2) * 0.40 * 0.02;

for i = 1:nROI2
    roi = roiOrder{i};
    idx = string(MT_base.ROI) == roi;
    Mr  = MT_base(idx,:);
    [aSorted, ord] = sort(Mr.Alpha);
    y    = Mr.Mean_DeltaPE(ord);
    eSEM = Mr.SEM_DeltaPE(ord);
    col  = roiColors(roi);
    xDodge = aSorted + roiOff(i);
    plot(axB, xDodge, y, '-', 'Color', col, 'LineWidth', lw_main, 'HandleVisibility','off');
    errorbar(axB, xDodge, y, eSEM, 'o', ...
        'Color', col, 'MarkerSize', 6, 'MarkerFaceColor', col, ...
        'MarkerEdgeColor', 'w', 'LineStyle','none', ...
        'CapSize', capB, 'LineWidth', lw_err, 'DisplayName', roi);
end
yline(axB, 0, '--', 'LineWidth', 1, 'Color', [0.4 0.4 0.4]);
xlabel(axB, '\alpha (learning-rate regime)');
ylabel(axB, '\DeltaPE (PPE \minus RPE)');
xticks(axB, aAll);
xticklabels(axB, compose('%.1f', aAll));
xlim(axB, [min(aAll)-0.05 max(aAll)+0.05]);
grid(axB,'on'); box(axB,'off');
set(axB,'TickDir','out','FontSize',fs,'Layer','top');
axB.GridAlpha = 0.15;
legend(axB,'Location','northeastoutside','Box','off');

exportgraphics(f1, 'Fig2bc.pdf', 'ContentType','vector');
exportgraphics(f1, 'Fig2bc.png', 'Resolution', 300);
fprintf('Saved: Fig2bc.pdf / Fig2bc.png\n');

%% ============================================================
%  Fig3a + Fig3b (outcome-controlled model)
%% ============================================================
f2 = figure('Color','w','Position',[100 100 900 420]);
tiledlayout(1,2,'Padding','compact','TileSpacing','compact');

%% Panel A: Fig3a
axC = nexttile; hold(axC,'on');
xpad2 = 0.025 * range([RT_ctrl.CI_low; RT_ctrl.CI_high]);
if xpad2 == 0; xpad2 = 1; end

for i = 1:nROI
    roi = char(RT_ctrl.ROI(i));
    col = roiColors(roi);
    plot(axC, [RT_ctrl.CI_low(i) RT_ctrl.CI_high(i)], [ypos(i) ypos(i)], '-', ...
        'LineWidth', lw_ci, 'Color', col);
    plot(axC, RT_ctrl.beta_Alpha(i), ypos(i), 'o', ...
        'MarkerSize', 7, 'MarkerFaceColor', col, ...
        'MarkerEdgeColor', 'w', 'LineWidth', 0.8);
    isSig = RT_ctrl.("FDR_significant (q<0.05)")(i);
    if isSig
        text(axC, RT_ctrl.CI_high(i) + xpad2, ypos(i), '*', ...
            'FontSize', 14, 'FontWeight','bold', ...
            'Color', col, 'VerticalAlignment','middle');
    end
end
yticks(axC, ypos);
yticklabels(axC, string(RT_ctrl.ROI));
yline(axC, 0, '--', 'LineWidth', 1, 'Color', [0.4 0.4 0.4]);
xlabel(axC, '\beta_\alpha (outcome-controlled model)');
grid(axC,'on'); box(axC,'off');
set(axC,'TickDir','out','FontSize',fs,'Layer','top');
axC.GridAlpha = 0.15;

%% Panel B: Fig3b
axD = nexttile; hold(axD,'on');
aAll2  = sort(unique(MT_ctrl.Alpha));
roiOff2 = ((1:nROI2) - (nROI2+1)/2) * 0.40 * 0.02;

for i = 1:nROI2
    roi = roiOrder{i};
    idx = string(MT_ctrl.ROI) == roi;
    Mr  = MT_ctrl(idx,:);
    [aSorted, ord] = sort(Mr.Alpha);
    y    = Mr.Mean_DeltaPE(ord);
    eSEM = Mr.SEM_DeltaPE(ord);
    col  = roiColors(roi);
    xDodge = aSorted + roiOff2(i);
    plot(axD, xDodge, y, '-', 'Color', col, 'LineWidth', lw_main, 'HandleVisibility','off');
    errorbar(axD, xDodge, y, eSEM, 'o', ...
        'Color', col, 'MarkerSize', 6, 'MarkerFaceColor', col, ...
        'MarkerEdgeColor', 'w', 'LineStyle','none', ...
        'CapSize', capB, 'LineWidth', lw_err, 'DisplayName', roi);
end
yline(axD, 0, '--', 'LineWidth', 1, 'Color', [0.4 0.4 0.4]);
xlabel(axD, '\alpha (learning-rate regime)');
ylabel(axD, '\DeltaPE (PPE \minus RPE)');
xticks(axD, aAll2);
xticklabels(axD, compose('%.1f', aAll2));
xlim(axD, [min(aAll2)-0.05 max(aAll2)+0.05]);
grid(axD,'on'); box(axD,'off');
set(axD,'TickDir','out','FontSize',fs,'Layer','top');
axD.GridAlpha = 0.15;
legend(axD,'Location','northeastoutside','Box','off');

exportgraphics(f2, 'Fig3ab.pdf', 'ContentType','vector');
exportgraphics(f2, 'Fig3ab.png', 'Resolution', 300);
fprintf('Saved: Fig3ab.pdf / Fig3ab.png\n');
