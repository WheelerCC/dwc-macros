#!/usr/bin/env python3
"""Generate locate-*-edge.g files from the Mako template."""

from pathlib import Path
from mako.template import Template


EDGES = ["left", "right", "front", "back"]

TEMPLATE_DIR = Path(__file__).parent / "xyz-probe"
TEMPLATE_FILE = TEMPLATE_DIR / "locate-edge.g.mako"


def main():
    template = Template(filename=str(TEMPLATE_FILE))

    for edge in EDGES:
        output = template.render(edge=edge)
        out_path = TEMPLATE_DIR / f"locate-{edge}-edge.g"
        out_path.write_text(str(output))
        print(f"Generated {out_path}")


if __name__ == "__main__":
    main()
