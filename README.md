# Rust

## Overview

- This repository is 
  - for replication of Rust (1987), Bus engine exchange problem.
  - consists of 2 parts
    - `./matlab/` : codes written in matlab, using Policy Iteration as Inner-loop in NFXP algorithm.
    - Others wtitten in R, using Value Iteration  as Inner-loop in NFXP algorithm.

## Structure
- 01_Data_Construction
  - read raw data from `./dat`, which is open data for Rust (1987), and process raw data into tidy data.
  - you can get data from here.
- 02_Descriptive_Stats
  - replicate Table 2a, 2b and Figure 1
- 03_Estimation_First_Stage
  - Under Construction
- 10_MonteCarlo_Simulation_NFP
  - Under Construction
  - Simulation for NFXP algorithm

- `./matlab/`
  - Reference: 楠田(2018)