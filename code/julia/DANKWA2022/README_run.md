# DANKWA2022 sequential runs

Run all files in the planned order:

```bash
bash run_sequential.sh
```

The default list is `script_list_sequential.txt`, where `slir_*` and `slirq_*` files are placed after the other models.

Run all files with a one-hour limit per Julia file. If a file times out, the runner continues to the next file:

```bash
bash run_sequential_timeout.sh
```

Change the per-file limit, in seconds:

```bash
TIME_LIMIT=7200 bash run_sequential_timeout.sh
```

Run only the first group:

```bash
LIST_FILE=script_list_first.txt bash run_sequential.sh
```

Run the S-L-I group later:

```bash
LIST_FILE=script_list_sli_later.txt bash run_sequential.sh
```

On Sol, if needed:

```bash
PROJECT_ARG="--project=$HOME/si_project" LIST_FILE=script_list_first.txt bash run_sequential.sh
PROJECT_ARG="--project=$HOME/si_project" LIST_FILE=script_list_sli_later.txt bash run_sequential.sh
```

With timeout:

```bash
PROJECT_ARG="--project=$HOME/si_project" TIME_LIMIT=3600 bash run_sequential_timeout.sh
```

Each Julia file saves results under the current directory's `result/` folder.
Console logs are saved under `run_logs/`.
