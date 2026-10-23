# Responsible AI for experimental media: hands-on tutorial

A guided example for colleagues: use **Claude + MATLAB** to turn an experiment into a
publication figure and a synchronised video, then annotate it in **Premiere Pro**,
checking every result along the way.

The example is a **synthetic drop test** (a ball bouncing on a force plate filmed by a
camera), so everyone can run it without lab data. All numbers below come from
running this kit in MATLAB R2024a.

| Step | What you do | Folder | Script (reference) | You should see |
|---|---|---|---|---|
| 1 | Install the MATLAB connector | `01_setup` | `SETUP.md` | Claude reports your MATLAB version |
| 2 | Generate the dataset | `02_data` | `generate_drop_test.m` | 8 impacts, peak 546 N |
| 3 | Publication figure | `03_figure` | `plot_trial.m` | first rebound 490 mm |
| 4a | Synthetic camera video | `04_sync_video` | `make_camera_video.m` | LED flash near the start |
| 4b | Sync video + force | `04_sync_video` | `sync_video.m` | offset 2.317 s, `trial01_sync.mp4` |
| 5 | Annotate in Premiere | `05_premiere` | `make_premiere_files.m`, `PREMIERE_STEPS.md` | captions + markers, see `premiere_result.jpg` |
| 6 | Video of Claude using Premiere (optional) | `06_screen_video` | `VIDEO_PROMPTS.md`, `make_timelapse.m` | labelled MP4 |

## Get the kit
```bash
git clone https://github.com/Jonasjcmh/AI_for_Media_Edition.git
```
or download the ZIP from GitHub (Code → Download ZIP).
The talk itself is in `slides/Responsible_AI_for_Research_Media.pdf` (read-only PDF),
and the 63 s demo of Claude controlling Premiere is `06_screen_video/claude_controls_premiere_recording.mp4`.

## Two ways to follow it
- **With Claude (the point of the tutorial):** paste the prompts from `PROMPTS.md`
  step by step and let Claude write and run the code in MATLAB. Compare with the
  reference scripts.
- **Without AI:** run the scripts in order in MATLAB (2 → 3 → 4a → 4b → 5).
  Each script finds its inputs relative to its own folder.

`reference/` holds the expected outputs so you can compare yours.

## The rules we follow
1. **You own the result.** Claude drafts; you read, run and sign.
2. **Verify every number** against raw data or physics (each step has a check).
3. **Protect data.** Use copies; check consent and policy before uploading real video.
4. **Disclose AI use** in methods and captions.

## Lesson built into Step 4b
Interpolating the force at each video frame time shows **0 N** on the impact frame,
because a 4 ms impact falls between 33 ms frames. The script takes the **peak within
each frame interval** instead (546 N). The code ran without errors either way; only
checking against the raw data revealed the problem.

## Requirements
Claude desktop app · MATLAB R2021a+ with Signal Processing and Image Processing
toolboxes · Premiere Pro (Step 5) · MathWorks MATLAB MCP Server
(https://github.com/matlab/matlab-mcp-server).

Prepared by Jonathan Tirado (joti@sdu.dk), SDU Soft Robotics, October 2026, with AI assistance
(Claude). Data are synthetic.
