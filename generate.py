#!/usr/bin/env python3
"""Generate locate-*-edge.g files from the Mako template."""

import re
from pathlib import Path
from mako.template import Template


FACES = ["left", "right", "front", "back", "top"]

TEMPLATE_DIR = Path(__file__).parent / "xyz-probe"
TEMPLATE_FILE = TEMPLATE_DIR / "locate-edge.g.mako"

# Inline comment: code (non-whitespace) followed by "; comment"
# Does NOT match lines that are comment-only (starting with optional whitespace then ;)
INLINE_COMMENT_RE = re.compile(r"^(\s*\S[^;]*?)\s*(;.*)$")


def align_comments(text: str, col: int = 40) -> str:
    """Align inline comments to a common column.

    Lines that are purely comments (no code before the ;) are left untouched.
    """
    lines = text.splitlines()
    out = []
    for line in lines:
        m = INLINE_COMMENT_RE.match(line)
        if m:
            code, comment = m.group(1).rstrip(), m.group(2)
            padding = max(col - len(code), 1)
            out.append(code + " " * padding + comment)
        else:
            out.append(line)
    return "\n".join(out) + "\n"


def main():
    template = Template(filename=str(TEMPLATE_FILE))

    for face in FACES:
        output = template.render(face=face)
        output = align_comments(str(output))
        out_path = TEMPLATE_DIR / f"locate-{face}-face.g"
        out_path.write_text(output)
        print(f"Generated {out_path}")


if __name__ == "__main__":
    main()
