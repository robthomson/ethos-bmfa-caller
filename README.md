# BMFA Achievement Caller for Ethos

An Ethos widget for FrSky X-series radios that announces each maneuver in sequence during a BMFA achievement test flight. Supports fixed-wing and helicopter, A and B certificates.

## What it does

Steps through BMFA achievement maneuvers in order, playing an audio call-out for each one when you press your trigger switch. Select your aircraft type and certificate level from the widget settings. Use it to prompt yourself (or a trainee) through the test sequence without looking at a list.

### Airplane — A Certificate

| # | Maneuver |
|---|----------|
| 1 | Takeoff & Circuit |
| 2 | Figure of Eight |
| 3 | Circuit & Landing |
| 4 | Takeoff & Circuit |
| 5 | Opposite Circuit |
| 6 | Dead Stick Landing |

### Airplane — B Certificate

| # | Maneuver |
|---|----------|
| 1 | Figure of Eight |
| 2 | Inside Loop |
| 3 | Outside Loop |
| 4 | Two consecutive rolls (into wind) |
| 5 | Two consecutive rolls (downwind) |
| 6 | Stall Turn |
| 7 | Three-turn Spin |
| 8 | Approach & Overshoot |
| 9 | Rectangular Circuit |

### Helicopter — A Certificate

| # | Maneuver |
|---|----------|
| 1 | Maneuver 1 |
| 2 | Maneuver 2 |
| 3 | Maneuver 3 |

### Helicopter — B Certificate

| # | Maneuver |
|---|----------|
| 1 | Hovering M |
| 2 | Top Hat |
| 3 | Takeoff & Climb |
| 4 | Left Hand Circuit |
| 5 | Right Hand Circuit |
| 6 | Stall Turn |
| 7 | Nose-In Hover |
| 8 | Double Stall Turn |
| 9 | 45° Approach & Land |

## Installation

Copy the `bmfa-caller` folder to the `scripts/` directory on your radio:

```
scripts/
  bmfa-caller/
    main.lua
    sounds/
      mnvr1.wav … mnvr9.wav
      mnvrst.wav
```

Then add the **BMFA Achievement Caller** widget to any screen.

### Using the deploy script

With the radio connected in mass-storage mode, use the VSCode launch configuration **Deploy Radio** or run:

```
python .vscode/scripts/deploy.py --radio
```

See [requirements.txt](requirements.txt) for Python dependencies (`pip install -r requirements.txt`).

## Configuration

Open the widget settings and assign three switches:

| Setting | Function |
|---------|----------|
| **Trigger Switch** | Advance to the next maneuver and play its audio |
| **Repeat Switch** | Replay the current maneuver audio |
| **Reset Switch** | Return to the start and play the reset announcement |

After the final maneuver the sequence resets automatically.

## Development

Requires Python 3.11+ and the packages in [requirements.txt](requirements.txt).

### VSCode launch configurations

| Configuration | Action |
|---------------|--------|
| Deploy & Launch [SIM] | Deploy to simulator and start Ethos |
| Deploy Radio | Copy to connected radio (mass-storage mode) |
| Deploy Radio [Fast] | Incremental copy — changed files only |
| Deploy Radio + Serial Debug | Deploy then open serial log |
| Radio: Serial Debug | Open serial log without deploying |
| Clear locks | Clear any stale deploy lock files |

### Releases

Tag a commit `release/x.y.z` to trigger the GitHub release workflow, which builds a zip and publishes a GitHub Release.  
Tag `snapshot/x.y.z` for a pre-release snapshot.

Add release notes to [Releases.md](Releases.md) under a heading that matches the version tag (e.g. `# 1.0.0`).

## Licence

Free to use and modify.
