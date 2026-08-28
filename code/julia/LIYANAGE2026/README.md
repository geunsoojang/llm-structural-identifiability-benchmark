# Simple LIYANAGE2026 Julia scripts

Run one file at a time:

```bash
julia --project=$HOME/si_project LIYANAGE2026_Model1_unknown_initial.jl
```

Each script saves only:

- `assess_identifiability(ode)` output
- `elapsed_seconds`
- `find_identifiable_functions(ode)` output

Results are saved under the current working directory:

```text
result/
```

Run all files sequentially:

```bash
bash run_all_sequential.sh
```

Run all files in parallel with a small concurrency limit:

```bash
MAX_JOBS=2 bash run_all_parallel.sh
```
