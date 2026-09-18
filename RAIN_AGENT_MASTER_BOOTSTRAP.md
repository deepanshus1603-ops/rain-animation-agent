# Rain Animation Agent — Master Bootstrap Instructions

You are an autonomous coding/automation agent running on the GPU/Blender laptop.

Your job is to build and operate a safe local Blender animation agent for the Blender Studio character **Rain v3.3** using:

- Blender 5.2.1 LTS
- CloudRig
- Ollama
- Qwen3.5 9B as the main local model
- GitHub Issues as the task queue
- Python for Blender automation
- GitHub CLI (`gh`) for task/result exchange

Do as much as possible yourself: inspect the repository, create missing folders/files, run tests, fix errors, and report results. Do not ask the user to manually create files that you can create yourself.

---

## 1. Machine / Project Locations

Repository:

```text
C:\Users\Dipanshu\Desktop\blender\project4\rain-animation-agent
```

MASTER Blender file:

```text
C:\Users\Dipanshu\Desktop\blender\project4\project4_rain_wave_working.blend
```

The MASTER file is read-only from the agent's perspective.

Never modify it directly.

Create/use this agent copy:

```text
C:\Users\Dipanshu\Desktop\blender\project4\rain-animation-agent\workspace\agent_working.blend
```

If `agent_working.blend` does not exist, copy the MASTER file into `workspace`.

GitHub repository:

```text
deepanshus1603-ops/rain-animation-agent
```

GitHub CLI is already authenticated on this laptop.

Primary Ollama model:

```text
qwen3.5:9b
```

Ollama API:

```text
http://localhost:11434
```

The 9B model runs 100% on GPU on this machine.

---

## 2. Current Architecture Goal

Build this pipeline:

```text
ChatGPT on work laptop
        ↓
GitHub Issue with label rain-agent
        ↓
GPU laptop worker
        ↓
Blender scene inspection
        ↓
Qwen3.5 9B planning / review
        ↓
safe Blender Python execution
        ↓
preview render
        ↓
Qwen visual review
        ↓
correction loop
        ↓
result posted back to GitHub
```

Use GitHub Issues as the job queue.

---

## 3. Current GitHub Task Format

Valid jobs contain:

```text
RAIN_TASK

Goal:
...

Character:
Rain v3.3

Mode:
READ_ONLY
or
WRITE_SAFE

Action:
...

END_RAIN_TASK
```

Only process issues that:

- are OPEN
- contain label `rain-agent`
- contain both `RAIN_TASK` and `END_RAIN_TASK`
- do not already have label `processed`

Recommended labels:

```text
rain-agent
queued
running
processed
needs-review
completed
failed
```

Do not process malformed issues.

---

## 4. Existing Verified Bridge

Already verified:

```text
Work laptop
  → GitHub CLI
  → GitHub Issue
  → GPU laptop
  → gh issue view
```

Already verified:

```text
GPU laptop
  → Python worker
  → Ollama qwen3.5:9b
  → final analysis
  → GitHub issue comment
```

Issue #3 was successfully processed in READ_ONLY mode.

Do not rebuild this from scratch if working code already exists. Inspect the repository first and extend what is there.

---

# 5. Rain v3.3 Rig Knowledge

Character:

```text
Rain v3.3
```

Rig object:

```text
RIG-rain
```

Rig system:

```text
CloudRig
```

Blender:

```text
5.2.1 LTS
```

There are some CloudRig UI compatibility errors in Blender 5.2.1, including errors similar to:

```text
AttributeError: 'Bone' object has no attribute 'select'
```

Direct Blender Python manipulation of the rig works.

Do not treat CloudRig UI errors as evidence that the underlying rig cannot be automated.

---

# 6. ABSOLUTE SAFETY RULES

These rules are mandatory.

Never execute:

```python
rig.animation_data_clear()
```

Never:

- clear the entire Action
- delete all keyframes
- overwrite the master `.blend`
- rebuild the existing working right-arm animation unless explicitly requested
- re-enable known left-arm IK override constraints unless explicitly required
- make scene-wide destructive changes
- animate helper/internal bones directly when animator-facing controls exist
- commit `.blend` files to GitHub
- put GitHub tokens or credentials in source files

Avoid directly animating bones with prefixes such as:

```text
DEF-
MCH-
TAN-
N-
P-BB-
BB-
```

Before any WRITE_SAFE task:

1. make a timestamped checkpoint of `agent_working.blend`
2. record a pre-change scene snapshot
3. apply only the requested changes
4. validate unrelated animation remains unchanged
5. save to the agent working copy only
6. render preview frames
7. if validation fails, restore checkpoint

---

# 7. Existing Working Animation — DO NOT BREAK

The current right-hand wave is working correctly.

Approximate timing:

```text
Frame 1   = relaxed
Frame 12  = relaxed hold
Frame 20  = raising starts
Frame 28  = halfway
Frame 36  = wave position
42–75     = wrist waving
Frame 82  = lowering
Frame 90  = almost down
Frame 96  = relaxed again
```

Right-arm FK controls:

```text
FK-Upperarm_Parent.R
FK-Upperarm.R
FK-Forearm.R
FK-Hand.R
```

CloudRig FK/IK state:

```text
Left Arm = 0.000
Right Arm = 0.000
```

Both arms are intentionally using FK.

---

# 8. Left Arm — Already Fixed

The anatomical left arm previously stayed in a T-pose because CloudRig IK constraints were overriding the FK pose.

Relevant controls:

```text
FK-Upperarm_Parent.L
FK-Upperarm.L
FK-Forearm.L
FK-Hand.L
```

Constraints with names containing:

```text
ik_arm_left
```

were muted on the left FK chain.

This fixed the left arm.

Do not undo this.

Current intended state:

```text
Right arm = working wave
Left arm = naturally lowered
Start pose = good
End pose = good
```

---

# 9. Face Controls

Use animator-facing controls from `Face Main`.

Main smile controls:

```text
ACT-Lips_Corner.L
ACT-Lips_Corner.R
```

Approximate limits:

`ACT-Lips_Corner.L`

```text
X: -0.015 → 0.030
Y: -0.020 → 0.030
Z: -0.015 → 0.050
Rotation X: -1.0472 → +1.0472 rad
Rotation Y/Z: locked
```

`ACT-Lips_Corner.R`

```text
X: -0.030 → 0.015
Y: -0.020 → 0.030
Z: -0.015 → 0.050
```

X is mirrored between left and right.

Useful cheek controls:

```text
ACT-Cheek_Outer.L
ACT-Cheek_Outer.R
```

Other potentially useful facial controls:

```text
MSTR-Mouth
MSTR-LowerLip
MSTR-UpperLip
ACT-Sneer.L
ACT-Sneer.R
ACT-Lip_Roll_Upper
ACT-Lip_Roll_Lower
```

Smile style rule:

- avoid excessive sideways X stretch
- prefer subtle upward Z movement
- add small cheek contribution when useful
- expressions should remain natural and friendly

---

# 10. Blink Controls — Verified

Use:

```text
ACT-Eyelid_Upper.L
ACT-Eyelid_Upper.R
ACT-Eyelid_Lower.L
ACT-Eyelid_Lower.R
```

Correct closed-eye values:

```python
upper_l.location.y = -0.038
upper_r.location.y = -0.038

lower_l.location.y = 0.018
lower_r.location.y = 0.018
```

Confirmed:

```text
Upper eyelids → negative Y closes
Lower eyelids → positive Y closes
```

Suggested natural blink pattern:

```text
open
2–4 frame transition
1–2 frames closed
2–4 frame transition open
```

Avoid identical mechanical blink timing across multiple blinks.

---

# 11. Shape Keys

Rain's head mesh includes semantic shape keys such as:

```text
mouth_open
LipsAdjust
LipsWide.L
LipsWide.R
LipsUp.L
LipsUp.R
Smile.L
Smile.R
CheekPuff.L
CheekPuff.R
EyebrowsTogether.L
EyebrowsTogether.R
EyebrowsDown.L
EyebrowsDown.R
EyelidsClose.L
EyelidsClose.R
Lips_Corner_In.L
Lips_Corner_In.R
Head_Back
Head_Forward
```

Directly animating:

```text
Smile.L
Smile.R
EyelidsClose.L
EyelidsClose.R
```

did not produce the desired visible result.

Prefer `ACT-*` Face Main controls.

---

# 12. Current Creative Goal

Current animation should become:

1. Rain starts relaxed
2. raises right hand
3. smiles toward viewer
4. waves naturally
5. blinks naturally
6. receives subtle head/body acting
7. lowers hand
8. returns toward relaxed pose

Immediate priority:

```text
Finish a natural smile + blink on top of the already-working Rain wave without changing the arm animation.
```

Later:

- head tilt
- body weight shift
- subtle breathing
- shoulder settle
- eye gaze
- eyebrow acting
- finger relaxation
- camera
- lighting
- environment
- final rendering

---

# 13. Repository Structure to Create / Maintain

Use this structure unless an equivalent already exists:

```text
rain-animation-agent/
│
├── rain_worker.py
│
├── blender_tools/
│   ├── inspect_scene.py
│   ├── apply_face_animation.py
│   ├── render_preview.py
│   ├── validate_scene.py
│   └── restore_checkpoint.py
│
├── knowledge/
│   ├── rain_rig.json
│   ├── rain_rules.md
│   └── successful_examples.jsonl
│
├── prompts/
│   ├── planner.md
│   ├── animator.md
│   └── reviewer.md
│
├── workspace/
│   ├── agent_working.blend
│   ├── scene_state.json
│   ├── checkpoints/
│   ├── previews/
│   └── reports/
│
└── .gitignore
```

`.gitignore` must include at minimum:

```text
workspace/
__pycache__/
*.pyc
*.blend
*.blend1
```

---

# 14. READ_ONLY Blender Inspection

Implement or verify `blender_tools/inspect_scene.py`.

It must inspect at minimum:

```text
FK-Upperarm_Parent.R
FK-Upperarm.R
FK-Forearm.R
FK-Hand.R

FK-Upperarm_Parent.L
FK-Upperarm.L
FK-Forearm.L
FK-Hand.L

ACT-Lips_Corner.L
ACT-Lips_Corner.R
ACT-Cheek_Outer.L
ACT-Cheek_Outer.R

ACT-Eyelid_Upper.L
ACT-Eyelid_Upper.R
ACT-Eyelid_Lower.L
ACT-Eyelid_Lower.R
```

For each control capture where possible:

- exists
- current location
- rotation mode
- Euler rotation
- quaternion
- scale
- constraints
- constraint mute state
- constraint influence
- keyframe frames

Also capture:

- Blender version
- blend file path
- current frame
- frame start/end
- rig found
- rig type
- action name
- F-curve count
- pose bone count

Write state to:

```text
workspace\scene_state.json
```

Inspection must not save or modify the blend file.

Print:

```text
RAIN_BLENDER_INSPECT_OK
READ ONLY: YES
```

on success.

---

# 15. Blender Executable

Auto-detect Blender from:

```text
C:\Program Files\Blender Foundation\Blender *\blender.exe
```

Do not hardcode a version-specific path unless detection fails.

Typical command:

```text
blender.exe --background workspace\agent_working.blend --python blender_tools\inspect_scene.py -- workspace\scene_state.json
```

---

# 16. Ollama Usage

Primary model:

```text
qwen3.5:9b
```

Use the Ollama HTTP API.

Preferred endpoint:

```text
POST http://localhost:11434/api/generate
```

For planning/debugging, enable:

```json
"think": true
```

The terminal may print the model's thinking for debugging.

GitHub comments should contain only the final answer / structured result, not the full reasoning trace.

Start with:

```json
"stream": false
```

for reliability.

Later streaming can be added.

---

# 17. Model Responsibilities

For every task, provide Qwen with:

1. the GitHub task
2. the actual Blender `scene_state.json`
3. the Rain safety rules
4. the current creative goal
5. the list of controls that must be preserved

Qwen should return structured output, not free-form code execution.

Recommended high-level plan format:

```text
TASK UNDERSTANDING:
...

SCENE FACTS:
...

CONTROLS TO MODIFY:
...

CONTROLS TO PRESERVE:
...

PROPOSED CHANGES:
...

PREVIEW FRAMES:
...

VALIDATION RULES:
...

SAFETY CHECK:
...
```

For write-capable stages, prefer JSON plans that can be validated before execution.

Do not let the model directly execute arbitrary shell commands.

The controller should expose a small allow-listed toolset.

---

# 18. WRITE_SAFE Mode — Only After READ_ONLY Passes

Do not enable writing until:

- Blender inspection works
- scene state reaches Qwen
- GitHub result posting works
- checkpoint creation works
- rollback works
- validation works

When enabling WRITE_SAFE:

Allowed first target:

```text
facial controls only
```

Specifically:

```text
ACT-Lips_Corner.L
ACT-Lips_Corner.R
ACT-Cheek_Outer.L
ACT-Cheek_Outer.R
ACT-Eyelid_Upper.L
ACT-Eyelid_Upper.R
ACT-Eyelid_Lower.L
ACT-Eyelid_Lower.R
```

Do not touch arm controls in the first write-capable milestone.

---

# 19. Checkpoint / Rollback

Before every write:

Create:

```text
workspace\checkpoints\agent_working_YYYYMMDD_HHMMSS.blend
```

Also save a pre-change JSON state.

After change:

- save agent working copy
- run inspection again
- compare preserved controls
- if protected data changed unexpectedly, restore checkpoint

Protected controls initially include all right-arm and left-arm FK controls.

---

# 20. Preview Rendering

Eventually implement:

```text
blender_tools/render_preview.py
```

Initial preview frames:

```text
1
20
36
50
60
75
82
96
```

For smile-focused tasks also consider:

```text
24
36
48
60
```

Store:

```text
workspace\previews\<issue-number>\
```

Prefer low-resolution preview renders first.

Final high-quality render should only happen after approval / validation.

---

# 21. Visual Review Loop

The long-term goal is:

```text
task
 ↓
plan
 ↓
apply safe changes
 ↓
render representative frames
 ↓
vision-capable model reviews images
 ↓
diagnose specific problem
 ↓
minimal correction
 ↓
render again
 ↓
repeat until acceptable or max iterations reached
```

Do not endlessly loop.

Use a configurable max iteration count, e.g.:

```text
3 to 5 iterations
```

If not solved, label task:

```text
needs-review
```

and post a concise report to GitHub.

---

# 22. GitHub Result Format

Post structured comments such as:

```text
## Rain Agent Result

Model: qwen3.5:9b

Mode:
READ_ONLY / WRITE_SAFE

Issue:
#<number>

Blender inspection:
PASS

Changes applied:
...

Controls modified:
...

Protected controls verified:
PASS / FAIL

Preview frames:
...

Iterations:
...

Validation:
PASS / FAIL

Status:
needs-review / completed / failed
```

Never post secrets.

---

# 23. Continuous Worker

After individual runs are stable, support:

```text
python rain_worker.py --watch
```

Suggested behavior:

- poll GitHub every 30–60 seconds
- pick one unprocessed task
- label it `running`
- process it
- post result
- mark `processed` / `needs-review` / `failed`
- continue waiting

Do not process more than one Blender write task concurrently on a single machine.

---

# 24. GPU Strategy on Current Laptop

Current GPU VRAM is 8 GB.

Qwen3.5 9B fits and runs 100% on GPU, but Blender rendering also needs GPU memory.

Therefore run heavy GPU workloads alternately:

```text
Ollama inference
↓
unload/stop model if necessary
↓
Blender GPU render
↓
finish render
↓
load Ollama again
```

Do not try to keep a heavy Blender Cycles render and Qwen3.5 9B fully resident simultaneously on this machine.

When a second 12 GB GPU laptop becomes available, future architecture can split:

```text
12 GB laptop → Ollama / vision / planning
8 GB laptop  → Blender / rendering
```

---

# 25. Coding Quality Rules

All scripts should:

- use clear logging
- fail safely
- use absolute paths internally after resolution
- create required directories automatically
- validate file existence
- validate rig existence
- avoid silent destructive actions
- catch errors and post useful failure information
- keep configuration near the top or in a config file
- preserve compatibility with Python 3.12 where possible
- use Blender's bundled Python only for Blender-side scripts

Prefer standard-library Python where possible.

Do not add unnecessary dependencies.

---

# 26. First Job to Complete Now

Your immediate assignment:

1. inspect the existing repository
2. preserve any working code
3. create any missing folder structure
4. ensure `.gitignore` protects Blender/workspace files
5. ensure `workspace\agent_working.blend` exists as a copy of the MASTER
6. implement/verify `blender_tools\inspect_scene.py`
7. update/verify `rain_worker.py` so it:
   - finds the newest valid `rain-agent` GitHub issue
   - accepts READ_ONLY mode
   - runs Blender inspection
   - reads `scene_state.json`
   - sends both task + scene state to Qwen3.5 9B
   - optionally prints model thinking locally
   - posts only final analysis to GitHub
   - marks task processed
8. run an end-to-end READ_ONLY test
9. report exactly what was created/changed
10. do not enable Blender writes yet

Do not stop at merely generating code. Run the tests yourself if your environment/tools allow it.

---

# 27. Definition of Success for This Stage

Success means:

```text
GitHub Issue
  ↓
rain_worker.py
  ↓
Blender opens agent_working.blend in background
  ↓
inspect_scene.py reads real Rain rig
  ↓
scene_state.json produced
  ↓
Qwen3.5 9B analyzes task + actual state
  ↓
GitHub receives final analysis
```

And:

```text
MASTER .blend untouched
agent_working.blend not modified
no animation keyframes changed
no arm animation changed
no constraints changed
```

Only after this is proven should WRITE_SAFE facial animation be built.

---

# 28. Operating Principle

The user wants approximately:

```text
90–95% automation
5–10% manual creative review
```

The system should therefore automate:

- rig inspection
- scripting
- checkpoints
- keyframe insertion
- preview rendering
- validation
- iterative correction
- GitHub reporting

The user should mainly provide creative direction and approve results.

Build toward that goal incrementally and safely.
