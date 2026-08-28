# Sequential runs

Run all Julia files in this folder:

```bash
bash run_sequential.sh
```

Run with a one-hour timeout per Julia file. Timed-out files are skipped and the runner continues:

```bash
bash run_sequential_timeout.sh
```

Change timeout:

```bash
TIME_LIMIT=7200 bash run_sequential_timeout.sh
```

On Sol with a project:

```bash
PROJECT_ARG="--project=$HOME/si_project" bash run_sequential_timeout.sh
```

Results are saved under `./result`; console logs are saved under `./run_logs`.