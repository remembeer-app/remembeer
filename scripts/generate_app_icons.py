#!/usr/bin/env python3
"""Render the bumblebeer app icon phases into iOS and Android launcher assets.

Source images: assets/app_icon/bumblebeer_<phase>.svg (phases a..h).

Output:
  ios/Runner/Assets.xcassets/AppIcon.appiconset                (phase a, primary)
  ios/Runner/Assets.xcassets/AppIcon-bumblebeer_<x>.appiconset (alternate icons)
  android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_bumblebeer_<x>.xml
  android/app/src/main/res/mipmap-<density>/ic_launcher_bumblebeer_<x>.png
  android/app/src/main/res/mipmap-<density>/ic_launcher_bumblebeer_<x>_foreground.png
  android/app/src/main/res/drawable/ic_launcher_background.xml

Requires Google Chrome for headless SVG rendering (override the binary with
CHROME_BIN) and macOS `sips` for downscaling. Run from anywhere:

    python3 scripts/generate_app_icons.py
"""

from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

PHASES = 'abcdefgh'
PRIMARY_PHASE = 'a'

ROOT = Path(__file__).resolve().parent.parent
SOURCE_DIR = ROOT / 'assets' / 'app_icon'
IOS_ASSETS = ROOT / 'ios' / 'Runner' / 'Assets.xcassets'
ANDROID_RES = ROOT / 'android' / 'app' / 'src' / 'main' / 'res'

CHROME = os.environ.get(
    'CHROME_BIN', '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
)

CANVAS = 1024
BACKGROUND_START = '#A8731B'  # top-left
BACKGROUND_END = '#6A4308'  # bottom-right
# The bee sits slightly above the centre of its 300x300 canvas.
BEE_SHIFT_Y = '3%'
# Android adaptive foregrounds must keep the artwork inside the 66/108 dp
# safe zone, so the bee is drawn smaller on that layer.
FOREGROUND_SCALE = 0.78

# Android densities and the base dp sizes of legacy launcher icons and
# adaptive icon layers.
DENSITIES = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}
LEGACY_ICON_DP = 48
ADAPTIVE_LAYER_DP = 108


def source_svg(phase: str) -> str:
    return (SOURCE_DIR / f'bumblebeer_{phase}.svg').read_text()


def build_html(svg: str, *, with_background: bool, scale: float) -> str:
    background = (
        f'linear-gradient(135deg, {BACKGROUND_START}, {BACKGROUND_END})'
        if with_background
        else 'transparent'
    )
    return f'''<!doctype html>
<html><head><meta charset="utf-8"><style>
  html, body {{ margin: 0; padding: 0; overflow: hidden; background: transparent; }}
  #canvas {{ width: {CANVAS}px; height: {CANVAS}px; background: {background};
             display: flex; align-items: center; justify-content: center; }}
  svg {{ width: {CANVAS}px; height: {CANVAS}px;
         transform: translateY({BEE_SHIFT_Y}) scale({scale}); }}
</style></head>
<body><div id="canvas">{svg}</div></body></html>
'''


def render(html: str, png: Path, work_dir: Path) -> None:
    """Screenshot the HTML with headless Chrome. Chrome does not always exit
    after writing the screenshot, so wait for the file and terminate it."""
    html_path = work_dir / f'{png.stem}.html'
    html_path.write_text(html)
    if png.exists():
        png.unlink()

    process = subprocess.Popen(
        [
            CHROME,
            '--headless=new',
            '--disable-gpu',
            '--hide-scrollbars',
            '--no-first-run',
            '--force-device-scale-factor=1',
            f'--window-size={CANVAS},{CANVAS}',
            '--default-background-color=00000000',
            f'--user-data-dir={work_dir / "chrome-profile"}',
            f'--screenshot={png}',
            html_path.as_uri(),
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    try:
        deadline = time.time() + 60
        last_size = -1
        while time.time() < deadline:
            time.sleep(0.25)
            if not png.exists():
                continue
            size = png.stat().st_size
            if size > 0 and size == last_size:
                return
            last_size = size
        raise RuntimeError(f'Chrome did not produce {png}')
    finally:
        process.terminate()
        try:
            process.wait(timeout=10)
        except subprocess.TimeoutExpired:
            process.kill()


def downscale(source: Path, target: Path, size: int) -> None:
    target.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        ['sips', '-z', str(size), str(size), str(source), '--out', str(target)],
        check=True,
        stdout=subprocess.DEVNULL,
    )


def ios_iconset_dir(phase: str) -> Path:
    if phase == PRIMARY_PHASE:
        return IOS_ASSETS / 'AppIcon.appiconset'
    return IOS_ASSETS / f'AppIcon-bumblebeer_{phase}.appiconset'


def write_ios(phase: str, full_icon: Path) -> None:
    iconset = ios_iconset_dir(phase)
    if iconset.exists():
        shutil.rmtree(iconset)
    iconset.mkdir(parents=True)
    filename = f'bumblebeer_{phase}.png'
    shutil.copyfile(full_icon, iconset / filename)
    contents = {
        'images': [
            {
                'filename': filename,
                'idiom': 'universal',
                'platform': 'ios',
                'size': '1024x1024',
            }
        ],
        'info': {'author': 'xcode', 'version': 1},
    }
    (iconset / 'Contents.json').write_text(json.dumps(contents, indent=2) + '\n')


def write_android(phase: str, full_icon: Path, foreground: Path) -> None:
    name = f'ic_launcher_bumblebeer_{phase}'
    for density, factor in DENSITIES.items():
        mipmap = ANDROID_RES / f'mipmap-{density}'
        downscale(full_icon, mipmap / f'{name}.png', round(LEGACY_ICON_DP * factor))
        downscale(
            foreground,
            mipmap / f'{name}_foreground.png',
            round(ADAPTIVE_LAYER_DP * factor),
        )

    adaptive_dir = ANDROID_RES / 'mipmap-anydpi-v26'
    adaptive_dir.mkdir(parents=True, exist_ok=True)
    (adaptive_dir / f'{name}.xml').write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
        '    <background android:drawable="@drawable/ic_launcher_background"/>\n'
        f'    <foreground android:drawable="@mipmap/{name}_foreground"/>\n'
        '</adaptive-icon>\n'
    )


def write_android_background() -> None:
    drawable = ANDROID_RES / 'drawable'
    drawable.mkdir(parents=True, exist_ok=True)
    # Android measures gradient angles counter-clockwise from left-to-right,
    # so 315 runs from the top-left to the bottom-right corner.
    (drawable / 'ic_launcher_background.xml').write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<shape xmlns:android="http://schemas.android.com/apk/res/android"\n'
        '    android:shape="rectangle">\n'
        '    <gradient\n'
        '        android:angle="315"\n'
        f'        android:startColor="{BACKGROUND_START}"\n'
        f'        android:endColor="{BACKGROUND_END}"\n'
        '        android:type="linear"/>\n'
        '</shape>\n'
    )


def main() -> int:
    if not Path(CHROME).exists():
        print(f'Chrome not found at {CHROME}; set CHROME_BIN.', file=sys.stderr)
        return 1

    with tempfile.TemporaryDirectory(prefix='app_icon_') as tmp:
        work_dir = Path(tmp)
        for phase in PHASES:
            svg = source_svg(phase)
            full_icon = work_dir / f'bumblebeer_{phase}_full.png'
            foreground = work_dir / f'bumblebeer_{phase}_foreground.png'

            render(build_html(svg, with_background=True, scale=1), full_icon, work_dir)
            render(
                build_html(svg, with_background=False, scale=FOREGROUND_SCALE),
                foreground,
                work_dir,
            )

            write_ios(phase, full_icon)
            write_android(phase, full_icon, foreground)
            print(f'phase {phase}: done')

    write_android_background()
    print('all icons generated')
    return 0


if __name__ == '__main__':
    sys.exit(main())
