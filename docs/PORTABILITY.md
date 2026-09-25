# Portability choices

1. No `output` blocks — connector names and modes are machine-specific.
2. No cursor theme/size — left for the user; NVIDIA cursor debug flags stay commented.
3. No layout pins — `open-on-output` assumes one person's dual-monitor map.
4. No game exe rules — keep those in a private local overlay.
5. No second-monitor autostart layout script.
6. Waywallen is **optional** — AppImage not vendored; bridge has no hardcoded
   connector (set `WAYWALLEN_MAIN_CONNECTOR` only if you need that fallback).
7. Autostart files use `@HOME@` rewrite, never a username path.
