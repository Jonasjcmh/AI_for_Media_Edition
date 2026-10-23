# Step 5 · Annotated video in Premiere Pro

Tested in **Premiere Pro 2026** on macOS. Input: `../04_sync_video/trial01_sync.mp4`
plus `events.srt` and `markers_list.txt` from `make_premiere_files.m`.
`premiere_result.jpg` shows what you should end up with.

## Route A (recommended): Claude makes the files, you place them
No extra software, nothing runs unattended.

1. **New project:** File → New → Project. Name it `drop_test_trial01`, choose a
   **local** location (not a shared folder), click **Create**.
2. **Import the video:** File → Import… (⌘I) → `04_sync_video/trial01_sync.mp4`.
3. **Make a sequence:** select the clip in the Project panel, then
   File → New → **Sequence From Clip** (1200×540, 30 fps, 3 s 12 frames).
4. **Import the captions:** File → Import… → `05_premiere/events.srt`.
5. **Put the captions on the Timeline:** **drag** `events.srt` from the Project panel
   onto the Timeline (the `.`/`,` insert keys do not work for caption files).
   In the *New caption track* dialog choose **Start Point: Source timecode** and OK.
   ⚠ Do **not** pick "Timeline start": it moves the first caption to 00:00 and shifts
   every caption 0.333 s early.
6. **Markers:** for each line of `markers_list.txt`
   - click the blue playhead timecode above the Timeline, type the digits
     (e.g. `108` for 00:00:01:08) and press Return;
   - choose **Markers → Add Marker** (or press **M** with the Timeline focused);
   - optional: double-click the marker to name it after the event.
7. **Check:** each marker should sit on the start of its caption. Step to an impact
   marker: the force spike is under the cursor and the ball is at, or within a few cm
   of, the floor. At 30 fps no frame catches the exact 4 ms contact, which is expected.
8. **Save** (⌘S) and **export:** File → Export → Media (H.264).

## Route B (optional): Claude edits the timeline directly
Community MCP servers can drive a local Premiere timeline (import, markers,
captions) from Claude. They are **unofficial**: some need unsigned extensions enabled
and can run arbitrary scripts on your computer. Use them only on your own machine,
on a copy of the project, after reading the code. Example prompt once installed:

> Create a sequence from trial01_sync.mp4 and add one marker per row of events.csv,
> named after the event column.

## Route C: Adobe for creativity connector (official)
Adobe's official Claude connector works in Adobe's cloud. It suits reformatting
and resizing (e.g. a vertical version for social media), not frame-accurate
timeline work. Footage is uploaded to Adobe.
