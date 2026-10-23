# Step 1 · Setup (about 15 minutes, once)

## You need
- **Claude desktop app** (macOS or Windows), signed in.
- **MATLAB R2021a or later** (R2023a+ recommended). The tutorial was tested with R2024a.
  Toolboxes used: Signal Processing (`findpeaks`) and Image Processing (`imresize`).
- **Adobe Premiere Pro** (any recent version) for Step 5.

## Install the MATLAB connector (official, by MathWorks)
1. Download `matlab-mcp-server.mcpb` from the latest release at
   https://github.com/matlab/matlab-mcp-server/releases
   (tested with v0.15.0).
2. Double-click the file. The Claude app opens it: click **Install**.
3. In Claude: **Settings → Extensions → MATLAB → Configure**
   - **MATLAB Installation Path**: on a Mac, for example `/Applications/MATLAB_R2024a.app`
     (no `/bin` at the end, and the version must match your folder name).
     On Windows, for example `C:\Program Files\MATLAB\R2024a`.
   - Optional: **Disable Telemetry** (the connector sends anonymous usage data
     to MathWorks by default).
   - Optional: **Initial Working Folder** = the folder of this kit.
4. **Quit Claude completely** (⌘Q on Mac, not just close the window) and reopen it.
   Without a full restart the new settings are not picked up.

## Test it
Ask Claude: *"Which MATLAB version and toolboxes can you see?"*
You should get your MATLAB version and toolbox list. If you get
"no valid MATLAB environments found", the installation path is wrong or Claude
was not fully restarted.

## Good practice before you start
- Keep **"Ask before running"** on: approve each MATLAB call and read the code first.
- Work on **copies** of real data; never point the AI at your only raw files.
- Check your institution's rules before using AI with participant video or
  unpublished data.
