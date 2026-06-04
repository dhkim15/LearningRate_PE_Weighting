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
│   ├── Fig1c.m          # Figure 1c: Value and PE time-series plots
│   └── demodata/        # Example regressor files for one participant
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

> Additional analysis scripts will be added upon acceptance.

---

## Data

Full dataset (regressors, behavioral data, and source data for all figures) is available on OSF:  
**https://osf.io/7j3sy**

| Dataset | Location |
|---|---|
| FSL regressors (all participants) | OSF / regressor/ |
| Behavioral ratings | OSF / behavioral/ |
| Figure source data | OSF / sourcedata/ |
| MNI-space EPI | Available upon acceptance |

---

## Usage

### Figure 1c

1. Set MATLAB current directory to `scripts/`
2. Run `Fig1c.m`

The script loads regressor files from `scripts/demodata/` by default:
```matlab
baseDir = fullfile(pwd, 'demodata');  % relative to scripts/
```

To use a different participant's data, change `baseDir` to the desired regressor folder.

---

## Regressor file naming

| File index | α value |
|---|---|
| 01 | 0.1 |
| 02 | 0.2 |
| 03 | 0.3 |
| 05 | 0.5 |
| 07 | 0.7 |

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
