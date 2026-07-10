#!/usr/bin/env python3
"""Generate the Modrinth icon for shulker-preview.

Composites real item renders (from the gitignored `block images/` directory,
produced by the block-image-renderer mod) into a vanilla-style tooltip hovering
over a shulker box — the pack's whole pitch in one image. Re-runnable; writes
icon.png here.
"""
import os
from PIL import Image, ImageDraw

HERE = os.path.dirname(os.path.abspath(__file__))
BI = os.path.join(HERE, '..', 'block images')

CANVAS = 512

# Vanilla tooltip palette
TT_BG = (16, 0, 16, 244)
TT_BORDER_TOP = (80, 0, 255, 255)
TT_BORDER_BOT = (40, 0, 127, 255)


def load(name, size):
    img = Image.open(os.path.join(BI, f'{name}.png')).convert('RGBA')
    return img.resize((size, size), Image.NEAREST)


def tooltip_panel(w, h, px=4):
    """Vanilla-ish tooltip: dark background, purple gradient border, drawn at
    pixel scale `px` so edges stay chunky/pixel-art."""
    panel = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(panel)
    # background with 1px-notched corners (vanilla look), scaled by px
    d.rectangle([px, 0, w - 1 - px, h - 1], fill=TT_BG)
    d.rectangle([0, px, w - 1, h - 1 - px], fill=TT_BG)
    # border: vertical gradient between the two purples, inset by one px-unit
    steps = max(1, (h - 4 * px) // px)
    for i in range(steps + 1):
        t = i / steps
        col = tuple(round(TT_BORDER_TOP[c] + (TT_BORDER_BOT[c] - TT_BORDER_TOP[c]) * t) for c in range(3)) + (255,)
        y0 = px + i * px
        y1 = min(y0 + px - 1, h - 1 - px)
        if y0 > h - 1 - px:
            break
        d.rectangle([px, y0, 2 * px - 1, y1], fill=col)            # left
        d.rectangle([w - 2 * px, y0, w - 1 - px, y1], fill=col)    # right
    d.rectangle([px, px, w - 1 - px, 2 * px - 1], fill=TT_BORDER_TOP)          # top
    d.rectangle([px, h - 2 * px, w - 1 - px, h - 1 - px], fill=TT_BORDER_BOT)  # bottom
    return panel


def main():
    canvas = Image.new('RGBA', (CANVAS, CANVAS), (0, 0, 0, 0))

    # Shulker box anchored bottom-center, 4x the 64px render.
    shulker = load('shulker_box', 256)
    sx = (CANVAS - 256) // 2
    sy = CANVAS - 256 - 24
    canvas.alpha_composite(shulker, (sx, sy))

    # Tooltip hovering above with three recognizable items (2x = crisp pixels).
    items = ['diamond', 'golden_apple', 'ender_pearl']
    isz, gap, pad = 128, 12, 20
    tw = pad * 2 + len(items) * isz + (len(items) - 1) * gap
    th = pad * 2 + isz
    panel = tooltip_panel(tw, th)
    tx = (CANVAS - tw) // 2
    ty = 36
    canvas.alpha_composite(panel, (tx, ty))
    for i, name in enumerate(items):
        canvas.alpha_composite(load(name, isz), (tx + pad + i * (isz + gap), ty + pad))

    out = os.path.join(HERE, 'icon.png')
    canvas.save(out)
    print('wrote', out)


if __name__ == '__main__':
    main()
