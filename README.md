# AI Agent Lab

## AI Research Daily

`research-daily` keeps its runtime state under `.openclaw-stage/` (ignored by
Git). The JSON file `research-state.json` and its per-topic `checkpoints/`
files are the source of truth; Markdown is rendered deterministically only
after all six fixed topics are `accepted` or `gap`.

Useful entry points:

```bash
Scripts/research-daily-preflight.sh 2026-07-19
python3 Scripts/research-daily-workflow.py record --date 2026-07-19 --topic ai-general --candidate candidate.json
python3 Scripts/research-daily-workflow.py render --date 2026-07-19
Scripts/research-daily-validate-and-promote.sh .openclaw-stage/research-daily-2026-07-19 2026-07-19
```

The final promotion path remains staging validation → Quartz build → Git
commit/push → remote `v5` verification. `STATUS.md` is written only by the
workflow program, and a verified rerun returns `ALREADY_COMPLETED`.
