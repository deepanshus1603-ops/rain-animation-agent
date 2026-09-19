# AGENTS.md - AI Agent Guidelines for rain-animation-agent

## 1. Project Root
```
C:\Users\Dipanshu\Desktop\blender\project4\rain-animation-agent
```

## 2. Master Blender File (NEVER MODIFY)
```
C:\Users\Dipanshu\Desktop\blender\project4\project4_rain_wave_working.blend
```

## 3. Agent Working Copy
```
workspace\agent_working.blend
```
All Blender automation must use the working copy only.

## 4. Blender Version
`5.2.1 LTS`

## 5. Character
`Rain v3.3` (RIG-rain, CloudRig)

## 6. Absolute Safety Rules
- NEVER call `rig.animation_data_clear()`
- NEVER clear the entire Action
- NEVER globally delete keyframes
- NEVER overwrite the master `.blend` file
- NEVER commit `.blend` files
- NEVER modify working arm animation unless explicitly requested
- NEVER re-enable left-arm IK override unless explicitly required
- Prefer animator-facing controls
- Do not animate DEF-, MCH-, TAN-, N-, P-BB-, or BB- helper bones

## 7. Right Arm (Approved Animation)
FK-Upperarm_Parent.R, FK-Upperarm.R, FK-Forearm.R, FK-Hand.R

## 8. Left Arm (Already Fixed, Lowered)
FK-Upperarm_Parent.L, FK-Upperarm.L, FK-Forearm.L, FK-Hand.L

Constraints containing `ik_arm_left` were muted.

## 9. Face Controls

### Smille
ACT-Lips_Corner.L/R, ACT-Cheek_Outer.L/R

### Blink
ACT-Eyelid_Upper.L/R, ACT-Eyelid_Lower.L/R
- Closed blink: upper Y = -0.038, lower Y = +0.018

## 10. Current Stage
`READ_ONLY` - Do not enable `WRITE_SAFE` unless explicitly instructed.

## 11. Immediate Goal
Build READ_ONLY GitHub -> worker -> Blender inspection -> Qwen -> GitHub pipeline.

## 12. Local Model
`rain-agent-9b-16k`

## 13. GitHub Repo
`deepanshus1603-ops/rain-animation-agent`

## 14. Reference
Use `RAIN_AGENT_MASTER_BOOTSTRAP.md` only as reference when necessary (read relevant sections).
