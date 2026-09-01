# Benchmark reference files

`ground_truth_88.csv` is the parameter-level reference table used for the revised analyses. It incorporates the documented Dankwa `slirq_s1_prevalence` correction and excludes five Dankwa scenarios whose available results did not resolve global from local identifiability.

Key files:

- `benchmark_scenarios_88.csv`: one row per retained benchmark scenario.
- `ground_truth_88.csv`: one row per retained scenario-parameter reference classification.
- `evidence_map.csv`: provenance and uncertainty notes for the source evidence.

The strict scoring classes are `global`, `local`, and `non-identifiable`. The retained population-size parameter in `slirq_s1_prevalence` remains qualified as at least locally identifiable so that strict and uncertainty-aware results can be distinguished.
