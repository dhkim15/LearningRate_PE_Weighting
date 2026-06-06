# Learning rate shapes the relative weighting of outcome-specific prediction errors in human cortex

Dongho Kim, SoHyun Han, HyungGoo R. Kim

---

## Overview

This repository contains analysis scripts for the paper:

> **"Learning rate shapes the relative weighting of outcome-specific prediction errors in human cortex"**  
> *Nature Communications* (under review)

Participants underwent ultra-high-field (7 T) spin-echo fMRI during a probabilistic conditioning paradigm involving reward and pain outcomes. Prediction-error (PE) signals were derived from a Rescorla–Wagner model with systematically varied learning rates (α), and their neural expression was examined across cortical and subcortical regions.

---

## Repository structure

```
LearningRate_PE_Weighting/
├── scripts/
│   ├── Fig1c.m                        # Figure 1c: Value and PE time-series
│   ├── Fig2bc_Fig3ab.m                # Figure 2b,c and Figure 3a,b
│   ├── Fig3cd.m                       # Figure 3c,d: directional PE decomposition
│   ├── PPE_Fig2bc_Fig3ab_sourcedata.xlsx  # Source data for Fig2b,c and Fig3a,b
│   ├── PPE_Fig3cd_sourcedata.xlsx         # Source data for Fig3c,d
│   └── demodata/                      # Example regressor files (one participant)
│       ├── C1, C2, C3, C4            # CS onset files
│       ├── U1, U2, U3                # US onset files
│       ├── PE_Reward01.txt           # Reward PE regressor (α = 0.1)
│       ├── PE_Reward07.txt           # Reward PE regressor (α = 0.7)
│       ├── PE_Punishment01.txt       # Pain PE regressor (α = 0.1)
│       ├── PE_Punishment07.txt       # Pain PE regressor (α = 0.7)
│       ├── Value_Reward01.txt        # Reward value regressor (α = 0.1)
│       ├── Value_Reward07.txt        # Reward value regressor (α = 0.7)
│       ├── Value_Punishment01.txt    # Pain value regressor (α = 0.1)
│       └── Value_Punishment07.txt    # Pain value regressor (α = 0.7)
└── README.md
```

---

## Data

Full dataset (regressors, behavioral data, and figure source data) is available on OSF:  
**https://osf.io/7j3sy**

| Dataset | Location |
|---|---|
| FSL regressors — all participants (001–020) | OSF / regressor/ |
| Behavioral ratings | OSF / behavioral/ |
| Figure source data | OSF / sourcedata/ |
| MNI-space fMRI data | Available upon acceptance |

---

## Usage

### Figure 1c
1. Set MATLAB current directory to `scripts/`
2. Run `Fig1c.m`

Loads regressor files from `scripts/demodata/` by default:
```matlab
baseDir = fullfile(pwd, 'demodata');
```

### Figure 2b, 2c, 3a, 3b
1. Place `Fig2bc_Fig3ab.m` and `PPE_Fig2bc_Fig3ab_sourcedata.xlsx` in the same folder
2. Set MATLAB current directory to that folder
3. Run `Fig2bc_Fig3ab.m`
4. Output: `Fig2bc.pdf`, `Fig2bc.png`, `Fig3ab.pdf`, `Fig3ab.png`

### Figure 3c, 3d
1. Place `Fig3cd.m` and `PPE_Fig3cd_sourcedata.xlsx` in the same folder
2. Set MATLAB current directory to that folder
3. Run `Fig3cd.m`
4. Output: `Fig3cd.pdf`, `Fig3cd.png`

---

## Regressor file naming

| File index | α value |
|---|---|
| 01 | 0.1 |
| 02 | 0.2 |
| 03 | 0.3 |
| 05 | 0.5 |
| 07 | 0.7 |

> Indices 04 and 06 are not used; numbering reflects α × 10.

---

## Software

| Software | Version |
|---|---|
| MATLAB | R2022b |
| FSL | 6.0.x |
| FreeSurfer | 7.x |

> MNI template: MNI152 2mm standard brain (FSL default)

---

## Contact

Dongho Kim — corresponding author  
HyungGoo R. Kim — corresponding author  
Center for Neuroscience Imaging Research, Institute for Basic Science, Suwon, South Korea
