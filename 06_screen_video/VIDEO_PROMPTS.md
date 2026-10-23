# Step 6 · A video of Claude controlling Premiere Pro (optional)

Show colleagues what "computer use" looks like: Claude clicking through Premiere
to do Step 5. Two ways. Both need the Claude **desktop app** with
**computer use turned on** (Claude: Settings → This computer → Computer use).

## Before you start (both ways)
- Quit apps that float over others (e.g. ChatGPT, chat widgets): Claude may not click
  through a window you have not approved.
- Have `trial01_sync.mp4`, `events.srt` and `markers_list.txt` ready (Steps 4–5).
- Don't touch the mouse or keyboard while Claude works on that screen.
- Claude will ask you to approve control of Premiere Pro. Approve only Premiere.

---

## Way 1 · Real screen recording (you record, Claude acts)
Smooth, real motion. About 5 minutes of your time.

1. **Open Premiere Pro first** and close its start / "What's New" screen, so the
   recording starts on the editor, not on loading screens.
   Then start recording: **⌘⇧5 → Record Selected Portion** (around the Premiere window)
   → Record. On Windows: **Win+Alt+R** (Xbox Game Bar).
2. Paste this prompt:

> I am recording my screen. Take control of Adobe Premiere Pro and repeat Step 5 of
> the tutorial in a NEW project called drop_test_demo, saved in Documents:
> import <KIT>/04_sync_video/trial01_sync.mp4, make a sequence with File → New →
> Sequence From Clip, import <KIT>/05_premiere/events.srt and drag it onto the
> Timeline choosing Start Point "Source timecode", then add a marker at each
> timecode in <KIT>/05_premiere/markers_list.txt using Markers → Add Marker, and
> finally park the playhead on impact 1. Work slowly: pause about 2 seconds after
> each action so it is visible in the recording. Only use Premiere Pro; ask me
> before anything else. Tell me when you are done.

3. When Claude says it is done, stop the recording (⌘⇧5 → stop, or the ⏹ in the menu bar).
4. Paste this prompt (attach or point to the recording):

> Here is my screen recording <path to .mov>. Make a presentation version: trim
> the dead time at the start and end, speed up waiting parts ×4, add a short caption
> at the bottom naming each action, add the label "Claude controlling Premiere Pro ·
> real recording · sped up" in a corner, and export an MP4 (1080p, under 50 MB) as
> <KIT>/06_screen_video/claude_controls_premiere_recording.mp4.

**Check:** watch the result once end to end. Every caption must match what you see,
and the speed-up must be stated on screen.

---

## Way 2 · Time-lapse from screenshots (Claude does everything)
No recording needed. Looks like a fast slideshow, but every frame is real.

1. Premiere can be open or closed (Claude opens it if needed). Paste this prompt:

> Take control of Adobe Premiere Pro and repeat Step 5 of the tutorial in a NEW
> project called drop_test_demo, saved in Documents (same steps as in
> PREMIERE_STEPS.md, Start Point "Source timecode", markers via Markers → Add Marker).
> After EVERY action, take a screenshot of the Premiere window and save it as
> <KIT>/06_screen_video/frames/001.png, 002.png, … Also write
> <KIT>/06_screen_video/steps.csv with columns file,caption, one short caption per
> screenshot describing the action. Include any mistake you make and how you fixed it.

2. Then paste:

> Run <KIT>/06_screen_video/make_timelapse.m in MATLAB and show me one frame of
> claude_controls_premiere.mp4.

**Check:** the step count in the video matches steps.csv, and each caption matches its
screenshot. The sample `frames/` and `steps.csv` in this folder (3 real screenshots from
the 22 Oct 2026 run) let you test `make_timelapse.m` straight away.

---

## Responsible use of these videos
- Label them as AI-controlled and say if they are sped up (both ways do this).
- Blur or crop anything private on screen (email, file names, notifications)
  before sharing. Turn on Do Not Disturb before recording.
- Keep the mistakes in: they show why a human reviews every step.
