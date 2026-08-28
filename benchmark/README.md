# Benchmark reference files

`ground_truth_93.csv` is the parameter-level reference table used for the revised analyses. It supersedes the earlier frozen table only for the documented Dankwa `slirq_s1_prevalence` correction.

Key files:

- `benchmark_scenarios_93.csv`: one row per benchmark scenario.
- `ground_truth_93.csv`: one row per scenario-parameter reference classification.
- `evidence_map.csv`: provenance and uncertainty notes for the source evidence.

The strict scoring classes are `globally`, `locally`, and `nonidentifiable`. Rows whose source evidence establishes only "at least locally identifiable" retain an uncertainty flag so that strict and uncertainty-aware results can be distinguished.
