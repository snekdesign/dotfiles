import fileinput
import json
import os
import pathlib
import string
import sys

import minijinja

_DIGITS = tuple(string.digits)


def main():
    data = {
        '_'+k if k.startswith(_DIGITS) else k: json.loads(p.read_text('utf-8'))
        for p in pathlib.Path(
            os.environ.get('PIXI_HOME', '~/.pixi'),
            'bin/trampoline_configuration',
        ).expanduser().resolve(strict=True).glob('*.json')
        for k in [p.stem.replace('-', '_')]
    }
    with fileinput.FileInput(sys.argv[1:], encoding='utf-8') as f:
        sys.stdout.write(minijinja.render_str(''.join(f), **data))


if __name__ == '__main__':
    main()
