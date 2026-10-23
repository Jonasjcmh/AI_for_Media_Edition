# Prompts: copy, paste, check

Use these in the **Claude desktop app** with the **MATLAB connector** switched on
(see `01_setup/SETUP.md`). Replace the folder path with where you saved this kit.
After every step, run the **Check** yourself before you go on. That check is the
"responsible" part of responsible AI.

Claude will usually write a slightly different script than the one in this folder.
That's fine. The scripts here are the reference: if your result differs, compare.

---

## Step 2 · Generate the dataset

> In MATLAB, work in the folder `<KIT>/02_data`. Simulate a drop test: a 0.2 kg ball
> released from 1 m at t = 1 s, coefficient of restitution 0.7, each impact a 4 ms
> half-sine force pulse. Sample force at 1 kHz from 0 to 3.6 s with 0.05 N noise
> (`rng(7)`). Save `trial01.csv` with columns t, force, h. Also save `logger.csv`
> as a data logger would record it: its clock starts 2.137 s late (column t_logger),
> plus a trigger channel that steps from 0 to 5 V at true t = 0.513 s. Save the
> script as `generate_drop_test.m` and print the number of impacts and the peak force.

**Check:** 8 impacts, peak force ≈ 546 N.

---

## Step 3 · Publication figure

> Using `<KIT>/02_data/trial01.csv`, plot force and height in two stacked panels with
> a shared time axis (time since release, s), SI units, no smoothing. Export a vector
> PDF 85 mm wide and a 200 dpi PNG to `<KIT>/03_figure`. Save the script as
> `plot_trial.m`. Then tell me the first rebound height and list every transformation
> you applied to the data.

**Check:** first rebound ≈ 490 mm (= e² × 1 m). The list of transformations should be
"none" apart from the time offset and the m → mm conversion.

---

## Step 4a · Camera video (synthetic, skip with real footage)

> In `<KIT>/04_sync_video`, render a 30 fps, 480×540 synthetic camera video
> `camera.mp4` of the ball from `trial01.csv`. The camera starts at true t = 0.2 s.
> Draw an LED in the top-left corner that is lit for 100 ms from t = 0.513 s.
> Save the script as `make_camera_video.m`.

**Check:** play `camera.mp4`; the LED flashes once near the start, before the drop.

---

## Step 4b · Synchronise and render

> In `<KIT>/04_sync_video`, synchronise `camera.mp4` with `../02_data/logger.csv`.
> Detect the LED flash in the video (mean brightness of the LED patch) and the
> trigger step in the logger, shift the logger time onto the video clock, and for
> each frame take the **peak** force within that frame's interval. Render
> `trial01_sync.mp4`: camera frame on the left, force trace drawn up to the current
> frame on the right, with the time and the peak force in the title. Also save a
> `sync_check.png` showing both detections, and an `events.csv` (LED sync + first 4
> impacts, video time). Report the clock offset, and compare interp1 vs frame-peak
> force on the impact frame.

**Check:** open `sync_check.png` and confirm both dashed lines sit on the edges.
Offset ≈ 2.317 s. On the impact frame interp1 gives ≈ 0 N, frame-peak gives ≈ 546 N:
that is why we use the peak.

---

## Step 5 · Files for Premiere Pro

> Convert `<KIT>/04_sync_video/events.csv` into an SRT caption file `events.srt`
> (one 0.25 s caption per event, no overlaps) and a `markers_list.txt` with
> HH:MM:SS:FF timecodes at 30 fps, both in `<KIT>/05_premiere`.

**Check:** 5 captions; the first at 00:00:00,333 ("LED sync").
Then follow `05_premiere/PREMIERE_STEPS.md` (tested in Premiere Pro 2026). In the caption dialog pick **Source timecode**.

---

## Step 6 · Video of Claude controlling Premiere (optional)

Two ways, both with computer use turned on in the Claude desktop app.
Full prompts and checks: `06_screen_video/VIDEO_PROMPTS.md`.

- **Way 1 · You record, Claude acts:** start ⌘⇧5 screen recording, then
  *"I am recording my screen. Take control of Adobe Premiere Pro and repeat Step 5 …
  pause about 2 seconds after each action."* Afterwards: *"Trim, speed up waits ×4,
  caption each action, label it, export an MP4."*
- **Way 2 · Time-lapse:** *"Take control of Premiere Pro, repeat Step 5, and after EVERY
  action save a numbered screenshot and a caption in steps.csv."* Then:
  *"Run make_timelapse.m."*

---

## Bonus prompts

- *"Explain line by line what sync_video.m does, and where it could silently go wrong."*
- *"My phone video has a variable frame rate. Change sync_video.m to use each frame's real timestamp."*
- *"Add a second sync event at the end and correct for clock drift."*
- *"Write the methods-section paragraph describing this processing, including that AI assistance was used."*
