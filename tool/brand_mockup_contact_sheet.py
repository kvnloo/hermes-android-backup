"""Contact sheets for the NextGen brand mockups (40% scale, labelled)."""
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

OUT = Path(sys.argv[1])
SCALE = 0.4
GAP = 28
LABEL_H = 64
MAGENTA = (255, 0, 255)
BG = (238, 238, 242)

try:
    FONT = ImageFont.truetype("/System/Library/Fonts/SFNS.ttf", 26)
    TITLE = ImageFont.truetype("/System/Library/Fonts/SFNS.ttf", 34)
except OSError:
    FONT = TITLE = ImageFont.load_default()


def sheet(name, title, rows):
    """rows: list of rows; each row a list of (file, label)."""
    loaded = []
    for row in rows:
        items = []
        for file, label in row:
            im = Image.open(OUT / file).convert("RGB")
            w, h = round(im.width * SCALE), round(im.height * SCALE)
            items.append((im.resize((w, h), Image.LANCZOS), label))
        loaded.append(items)
    width = max(sum(i.width for i, _ in row) + GAP * (len(row) + 1) for row in loaded)
    height = 80 + sum(max(i.height for i, _ in row) + LABEL_H + GAP for row in loaded) + GAP
    canvas = Image.new("RGB", (width, height), BG)
    draw = ImageDraw.Draw(canvas)
    draw.text((GAP, 22), title, fill=(20, 20, 24), font=TITLE)
    y = 80
    for row in loaded:
        x = GAP
        row_h = max(i.height for i, _ in row)
        for im, label in row:
            draw.text((x, y + 14), label, fill=(20, 20, 24), font=FONT)
            top = y + LABEL_H
            # magenta frame marks the image edge
            draw.rectangle((x - 3, top - 3, x + im.width + 2, top + im.height + 2), outline=MAGENTA, width=3)
            canvas.paste(im, (x, top))
            x += im.width + GAP
        y += LABEL_H + row_h + GAP
    canvas.save(OUT / name)
    print(name, canvas.size)


sheet(
    "contact-launch.png",
    "Ares NextGen - launch screen (A) - real renders, 40% scale",
    [
        [
            ("A1-launch-phone-dark.png", "A1 iPhone - dark"),
            ("A2-launch-phone-light-proposal.png", "A2 iPhone - light theme proposal"),
            ("A5-launch-android-dark.png", "A5 Android - dark"),
        ],
        [
            ("A3-launch-desktop-dark.png", "A3 Mac window - dark (docked sidebar)"),
            ("A4-launch-desktop-light-proposal.png", "A4 Mac window - light theme proposal"),
        ],
    ],
)
sheet(
    "contact-newchat.png",
    "Ares NextGen - new chat screen (B) - real renders, 40% scale",
    [
        [
            ("B1-newchat-phone-dark.png", "B1 dark - brand above, sparkle kept"),
            ("B2-newchat-phone-dark-approved-sparkle.png", "B2 final - approved sparkle retained"),
            ("B3-newchat-phone-light-proposal.png", "B3 light theme proposal"),
            ("B4-newchat-phone-dark-keyboard.png", "B4 dark - keyboard up (brand hidden)"),
        ],
        [
            ("B5-newchat-desktop-dark.png", "B5 Mac window - dark, brand above, sparkle kept"),
        ],
        [
            ("B6-newchat-phone-dark-project.png", "B6 phone - project picker visible"),
            ("B7-newchat-desktop-dark-project.png", "B7 desktop - project picker visible"),
        ],
    ],
)
