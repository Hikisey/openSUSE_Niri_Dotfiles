#!/usr/bin/env python3
"""Helpers for waywallen-gtk-qt-palette: breeze colors.css + MaterialYouDark.colors + kdeglobals + qt5ct."""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path


def hx(data: dict, key: str, fallback: str = "#000000") -> str:
    v = data.get(key, fallback)
    if isinstance(v, str) and v.startswith("#") and len(v) >= 7:
        return v[:7].lower()
    return fallback


def write_breeze_css(data: dict, home: Path) -> dict:
    surface = hx(data, "surface")
    surface_var = hx(data, "surface_variant")
    surface_high = hx(data, "surface_container_high", surface_var)
    surface_highest = hx(data, "surface_container_highest", surface_high)
    surface_dim = hx(data, "surface_dim", surface)
    surface_lowest = hx(data, "surface_container_lowest", surface_dim)
    on_surface = hx(data, "on_surface", "#ffffff")
    on_surface_var = hx(data, "on_surface_variant", "#aaaaaa")
    primary = hx(data, "primary")
    on_primary = hx(data, "on_primary", "#000000")
    primary_c = hx(data, "primary_container", primary)
    secondary = hx(data, "secondary", primary)
    error = hx(data, "error", "#ff6b81")
    tertiary = hx(data, "tertiary", secondary)
    outline = hx(data, "outline", "#666666")
    outline_var = hx(data, "outline_variant", outline)
    link = hx(data, "secondary", "#8ab4f8")
    visited = hx(data, "tertiary", "#c58af9")
    success = hx(data, "tertiary", "#78fdcb")
    warning = hx(data, "error", "#ffded6")

    pairs = {
        "borders_breeze": outline,
        "content_view_bg_breeze": surface_lowest,
        "error_color_backdrop_breeze": error,
        "error_color_breeze": error,
        "error_color_insensitive_backdrop_breeze": on_surface_var,
        "error_color_insensitive_breeze": on_surface_var,
        "insensitive_base_color_breeze": surface,
        "insensitive_base_fg_color_breeze": on_surface_var,
        "insensitive_bg_color_breeze": surface,
        "insensitive_borders_breeze": outline_var,
        "insensitive_fg_color_breeze": on_surface_var,
        "insensitive_selected_bg_color_breeze": surface,
        "insensitive_selected_fg_color_breeze": on_surface_var,
        "insensitive_unfocused_bg_color_breeze": surface,
        "insensitive_unfocused_fg_color_breeze": on_surface_var,
        "insensitive_unfocused_selected_bg_color_breeze": surface,
        "insensitive_unfocused_selected_fg_color_breeze": on_surface_var,
        "link_color_breeze": link,
        "link_visited_color_breeze": visited,
        "success_color_backdrop_breeze": success,
        "success_color_breeze": success,
        "success_color_insensitive_backdrop_breeze": on_surface_var,
        "success_color_insensitive_breeze": on_surface_var,
        "theme_base_color_breeze": surface_lowest,
        "theme_bg_color_breeze": surface,
        "theme_button_background_backdrop_breeze": surface_high,
        "theme_button_background_backdrop_insensitive_breeze": surface,
        "theme_button_background_insensitive_breeze": surface,
        "theme_button_background_normal_breeze": surface_high,
        "theme_button_decoration_focus_backdrop_breeze": primary,
        "theme_button_decoration_focus_backdrop_insensitive_breeze": on_surface_var,
        "theme_button_decoration_focus_breeze": primary,
        "theme_button_decoration_focus_insensitive_breeze": on_surface_var,
        "theme_button_decoration_hover_backdrop_breeze": primary,
        "theme_button_decoration_hover_backdrop_insensitive_breeze": on_surface_var,
        "theme_button_decoration_hover_breeze": primary,
        "theme_button_decoration_hover_insensitive_breeze": on_surface_var,
        "theme_button_foreground_active_backdrop_breeze": on_surface,
        "theme_button_foreground_active_backdrop_insensitive_breeze": on_surface_var,
        "theme_button_foreground_active_breeze": on_primary,
        "theme_button_foreground_active_insensitive_breeze": on_surface_var,
        "theme_button_foreground_backdrop_breeze": on_surface,
        "theme_button_foreground_backdrop_insensitive_breeze": on_surface_var,
        "theme_button_foreground_insensitive_breeze": on_surface_var,
        "theme_button_foreground_normal_breeze": on_surface,
        "theme_fg_color_breeze": on_surface,
        "theme_header_background_backdrop_breeze": surface,
        "theme_header_background_breeze": surface,
        "theme_header_background_light_breeze": surface,
        "theme_header_foreground_backdrop_breeze": on_surface,
        "theme_header_foreground_breeze": on_surface,
        "theme_header_foreground_insensitive_backdrop_breeze": on_surface,
        "theme_header_foreground_insensitive_breeze": on_surface,
        "theme_hovering_selected_bg_color_breeze": primary,
        "theme_selected_bg_color_breeze": primary,
        "theme_selected_fg_color_breeze": on_primary,
        "theme_text_color_breeze": on_surface,
        "theme_titlebar_background_backdrop_breeze": surface,
        "theme_titlebar_background_breeze": surface,
        "theme_titlebar_background_light_breeze": surface,
        "theme_titlebar_foreground_backdrop_breeze": on_surface,
        "theme_titlebar_foreground_breeze": on_surface,
        "theme_titlebar_foreground_insensitive_backdrop_breeze": on_surface,
        "theme_titlebar_foreground_insensitive_breeze": on_surface,
        "theme_unfocused_base_color_breeze": surface_lowest,
        "theme_unfocused_bg_color_breeze": surface,
        "theme_unfocused_fg_color_breeze": on_surface,
        "theme_unfocused_selected_bg_color_alt_breeze": surface_highest,
        "theme_unfocused_selected_bg_color_breeze": surface_highest,
        "theme_unfocused_selected_fg_color_breeze": on_surface,
        "theme_unfocused_text_color_breeze": on_surface,
        "theme_unfocused_view_bg_color_breeze": surface,
        "theme_unfocused_view_text_color_breeze": on_surface_var,
        "theme_view_active_decoration_color_breeze": primary_c,
        "theme_view_hover_decoration_color_breeze": primary_c,
        "tooltip_background_breeze": surface,
        "tooltip_border_breeze": outline,
        "tooltip_text_breeze": on_surface,
        "unfocused_borders_breeze": outline,
        "unfocused_insensitive_borders_breeze": outline_var,
        "warning_color_backdrop_breeze": warning,
        "warning_color_breeze": warning,
        "warning_color_insensitive_backdrop_breeze": on_surface_var,
        "warning_color_insensitive_breeze": on_surface_var,
    }
    lines = [
        "/* Generated by waywallen-gtk-qt-palette from wallpaper (Breeze GTK named colors) */",
        "/* Do not edit by hand — re-run waywallen-noctalia-palette / waywallen-gtk-qt-palette */",
        "",
    ]
    for k, v in pairs.items():
        lines.append(f"@define-color {k} {v};")
    lines.append("")
    css = "\n".join(lines)
    for sub in ("gtk-3.0", "gtk-4.0"):
        d = home / ".config" / sub
        d.mkdir(parents=True, exist_ok=True)
        (d / "colors.css").write_text(css)
        gtk_css = d / "gtk.css"
        text = gtk_css.read_text() if gtk_css.exists() else ""
        if "colors.css" not in text:
            text = "@import 'colors.css';\n" + (text if text.strip() else "")
            gtk_css.write_text(text if text.endswith("\n") else text + "\n")

    sample = {
        "source_color": data.get("source_color"),
        "primary": primary,
        "surface": surface,
        "on_surface": on_surface,
        "surface_container_lowest": surface_lowest,
        "error": error,
    }
    return {
        "sample": sample,
        "tokens": {
            "surface": surface,
            "surface_var": surface_var,
            "surface_high": surface_high,
            "surface_lowest": surface_lowest,
            "on_surface": on_surface,
            "on_surface_var": on_surface_var,
            "primary": primary,
            "on_primary": on_primary,
            "primary_c": primary_c,
            "link": link,
            "visited": visited,
            "error": error,
            "success": success,
            "warning": warning,
        },
    }


def colors_file(t: dict, name_scheme: str, name_human: str) -> str:
    def c(h: str) -> str:
        return h

    surface = t["surface"]
    surface_var = t["surface_var"]
    surface_high = t["surface_high"]
    surface_lowest = t["surface_lowest"]
    on_surface = t["on_surface"]
    on_surface_var = t["on_surface_var"]
    primary = t["primary"]
    on_primary = t["on_primary"]
    primary_c = t["primary_c"]
    link = t["link"]
    visited = t["visited"]
    error = t["error"]
    success = t["success"]
    warning = t["warning"]
    return f"""[ColorEffects:Disabled]
Color={c(surface)}
ColorAmount=0.5
ColorEffect=3
ContrastAmount=0
ContrastEffect=0
IntensityAmount=0
IntensityEffect=0

[ColorEffects:Inactive]
ChangeSelectionColor=true
Color=#000000
ColorAmount=0.025
ColorEffect=0
ContrastAmount=0.1
ContrastEffect=0
Enable=true
IntensityAmount=0
IntensityEffect=0

[Colors:Button]
BackgroundAlternate={c(surface_var)}
BackgroundNormal={c(surface_high)}
DecorationFocus={c(primary)}
DecorationHover={c(primary)}
ForegroundActive={c(on_surface)}
ForegroundInactive={c(on_surface_var)}
ForegroundLink={c(link)}
ForegroundNegative={c(error)}
ForegroundNeutral={c(warning)}
ForegroundNormal={c(on_surface)}
ForegroundPositive={c(success)}
ForegroundVisited={c(visited)}

[Colors:Complementary]
BackgroundAlternate={c(surface_lowest)}
BackgroundNormal={c(surface)}
DecorationFocus={c(primary)}
DecorationHover={c(primary)}
ForegroundActive={c(on_surface)}
ForegroundInactive={c(on_surface_var)}
ForegroundLink={c(link)}
ForegroundNegative={c(error)}
ForegroundNeutral={c(warning)}
ForegroundNormal={c(on_surface)}
ForegroundPositive={c(success)}
ForegroundVisited={c(visited)}

[Colors:Header]
BackgroundAlternate={c(surface)}
BackgroundNormal={c(surface)}
DecorationFocus={c(primary)}
DecorationHover={c(primary)}
ForegroundActive={c(on_surface)}
ForegroundInactive={c(on_surface_var)}
ForegroundLink={c(link)}
ForegroundNegative={c(error)}
ForegroundNeutral={c(warning)}
ForegroundNormal={c(on_surface)}
ForegroundPositive={c(success)}
ForegroundVisited={c(visited)}

[Colors:Header][Inactive]
BackgroundAlternate={c(surface)}
BackgroundNormal={c(surface)}
DecorationFocus={c(primary)}
DecorationHover={c(primary)}
ForegroundActive={c(on_surface)}
ForegroundInactive={c(on_surface_var)}
ForegroundLink={c(link)}
ForegroundNegative={c(error)}
ForegroundNeutral={c(warning)}
ForegroundNormal={c(on_surface)}
ForegroundPositive={c(success)}
ForegroundVisited={c(visited)}

[Colors:Selection]
BackgroundAlternate={c(primary)}
BackgroundNormal={c(primary)}
DecorationFocus={c(primary)}
DecorationHover={c(primary)}
ForegroundActive={c(on_primary)}
ForegroundInactive={c(on_primary)}
ForegroundLink={c(link)}
ForegroundNegative={c(error)}
ForegroundNeutral={c(warning)}
ForegroundNormal={c(on_primary)}
ForegroundPositive={c(success)}
ForegroundVisited={c(visited)}

[Colors:Tooltip]
BackgroundAlternate={c(surface_var)}
BackgroundNormal={c(surface)}
DecorationFocus={c(primary)}
DecorationHover={c(primary)}
ForegroundActive={c(on_surface)}
ForegroundInactive={c(on_surface_var)}
ForegroundLink={c(link)}
ForegroundNegative={c(error)}
ForegroundNeutral={c(warning)}
ForegroundNormal={c(on_surface)}
ForegroundPositive={c(success)}
ForegroundVisited={c(visited)}

[Colors:View]
BackgroundAlternate={c(surface)}
BackgroundNormal={c(surface_lowest)}
DecorationFocus={c(primary)}
DecorationHover={c(primary_c)}
ForegroundActive={c(on_surface)}
ForegroundInactive={c(on_surface_var)}
ForegroundLink={c(link)}
ForegroundNegative={c(error)}
ForegroundNeutral={c(warning)}
ForegroundNormal={c(on_surface)}
ForegroundPositive={c(success)}
ForegroundVisited={c(visited)}

[Colors:Window]
BackgroundAlternate={c(surface_var)}
BackgroundNormal={c(surface)}
DecorationFocus={c(primary)}
DecorationHover={c(primary)}
ForegroundActive={c(link)}
ForegroundInactive={c(on_surface_var)}
ForegroundLink={c(link)}
ForegroundNegative={c(error)}
ForegroundNeutral={c(warning)}
ForegroundNormal={c(on_surface)}
ForegroundPositive={c(success)}
ForegroundVisited={c(visited)}

[General]
ColorScheme={name_scheme}
Name={name_human}
shadeSortColumn=true

[KDE]
contrast=4
frameContrast=0.25

[WM]
activeBackground={c(surface_var)}
activeBlend=252,252,252
activeForeground={c(on_surface)}
inactiveBackground={c(primary)}
inactiveBlend=161,169,177
inactiveForeground={c(on_primary)}
"""


def merge_kdeglobals(home: Path, scheme_path: Path) -> None:
    kde = home / ".config/kdeglobals"
    if not scheme_path.exists():
        return
    scheme_text = scheme_path.read_text()
    kde_text = kde.read_text() if kde.exists() else "[General]\n"
    parts = re.split(r"\n(?=\[)", scheme_text)
    keep = []
    for p in parts:
        p = p.strip("\n")
        if not p:
            continue
        header = p.split("\n", 1)[0]
        if header.startswith("[ColorEffects:") or header.startswith("[Colors:") or header == "[WM]":
            keep.append(p if p.startswith("[") else "[" + p)
    kde_parts = re.split(r"\n(?=\[)", kde_text)
    out = []
    for p in kde_parts:
        p = p.strip("\n")
        if not p:
            continue
        header = p.split("\n", 1)[0]
        if header.startswith("[ColorEffects:") or header.startswith("[Colors:") or header == "[WM]":
            continue
        out.append(p)
    new_out = []
    for p in out:
        if p.startswith("[General]"):
            lines = p.splitlines()
            rewritten = [lines[0]]
            seen = set()
            for line in lines[1:]:
                if line.startswith("ColorScheme="):
                    rewritten.append("ColorScheme=MaterialYouDark")
                    seen.add("ColorScheme")
                else:
                    rewritten.append(line)
            if "ColorScheme" not in seen:
                rewritten.insert(1, "ColorScheme=MaterialYouDark")
            new_out.append("\n".join(rewritten))
        else:
            new_out.append(p)
    if not any(p.startswith("[General]") for p in new_out):
        new_out.insert(0, "[General]\nColorScheme=MaterialYouDark")
    kde.parent.mkdir(parents=True, exist_ok=True)
    kde.write_text("\n\n".join(new_out + keep) + "\n")


def patch_qtct(conf_path: Path, colors_path: str) -> None:
    text = conf_path.read_text() if conf_path.exists() else "[Appearance]\n"
    lines = text.splitlines()
    out: list[str] = []
    in_app = False
    seen_path = seen_custom = False
    for line in lines:
        if line.strip().startswith("[") and line.strip().endswith("]"):
            if in_app:
                if not seen_path:
                    out.append(f"color_scheme_path={colors_path}")
                if not seen_custom:
                    out.append("custom_palette=true")
            in_app = line.strip() == "[Appearance]"
            out.append(line)
            continue
        if in_app and line.startswith("color_scheme_path="):
            out.append(f"color_scheme_path={colors_path}")
            seen_path = True
            continue
        if in_app and line.startswith("custom_palette="):
            out.append("custom_palette=true")
            seen_custom = True
            continue
        out.append(line)
    if in_app:
        if not seen_path:
            out.append(f"color_scheme_path={colors_path}")
        if not seen_custom:
            out.append("custom_palette=true")
    elif "[Appearance]" not in text:
        out = [
            "[Appearance]",
            f"color_scheme_path={colors_path}",
            "custom_palette=true",
            "style=Breeze",
            "",
        ] + out
    conf_path.parent.mkdir(parents=True, exist_ok=True)
    conf_path.write_text("\n".join(out) + "\n")


def main() -> int:
    if len(sys.argv) < 3:
        print("usage: waywallen-gtk-qt-palette-lib.py <json> <home>", file=sys.stderr)
        return 2
    data = json.loads(Path(sys.argv[1]).read_text())
    home = Path(sys.argv[2])
    result = write_breeze_css(data, home)
    scheme_dir = home / ".local/share/color-schemes"
    scheme_dir.mkdir(parents=True, exist_ok=True)
    myd = scheme_dir / "MaterialYouDark.colors"
    myd.write_text(colors_file(result["tokens"], "MaterialYouDark", "Material You dark"))
    merge_kdeglobals(home, myd)
    qt5 = home / ".config/qt5ct/qt5ct.conf"
    qt5_colors = home / ".config/qt5ct/colors/noctalia.conf"
    if qt5_colors.exists():
        patch_qtct(qt5, str(qt5_colors))
    qt6 = home / ".config/qt6ct/qt6ct.conf"
    qt6_colors = home / ".config/qt6ct/colors/noctalia.conf"
    if qt6_colors.exists() and qt6.exists() and qt6.stat().st_size > 0:
        patch_qtct(qt6, str(qt6_colors))
    print(json.dumps(result["sample"]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
