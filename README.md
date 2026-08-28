# LLM Structural Identifiability Benchmark

This repository contains the benchmark materials and formal verification code for:

> Evaluating large language models for structural identifiability analysis of epidemic models: a retrospective benchmark

The benchmark contains 93 model scenarios from 14 source studies, 737 parameter-level reference classifications, Original and Anonymized prompts, and Julia code used for formal structural-identifiability checks.

## Repository contents

- `benchmark/`: scenario manifest, evidence map, and revised parameter-level reference table.
- `prompts/original/`: frozen prompts using the terminology and symbols from the source studies.
- `prompts/anonymized/`: frozen prompts with neutral state, parameter, and output symbols.
- `code/julia/`: formal structural-identifiability scripts.

Processed analysis outputs, manuscript figures, and manuscript source files are intentionally not included in this repository.

## Reference-table revision

The current reference table incorporates the user-supplied StructuralIdentifiability.jl result for Dankwa et al.'s `slirq_s1_prevalence` scenario. The revision changes only the applicable Dankwa reference classifications and then rescored the frozen model responses; it does not overwrite or regenerate any model response.

## Reproducing formal checks

The `code/julia/` directory contains the model encodings used with `StructuralIdentifiability.jl`. Study-specific README files and run scripts document the available checks. Generated Julia outputs and run logs are intentionally not included.

## Primary data files

- Parameter-level reference: `benchmark/ground_truth_93.csv`
- Scenario manifest: `benchmark/benchmark_scenarios_93.csv`
- Original prompts: `prompts/original/`
- Anonymized prompts: `prompts/anonymized/`

## Authors

- Geunsoo Jang
- K. Selcuk Candan
- Gerardo Chowell
