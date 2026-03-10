import fileinput
import json
import os
import pathlib
import sys

import minijinja


def main():
    context = {'environ': dict(os.environ)}
    for p in pathlib.Path(
        os.environ.get('PIXI_HOME', '~/.pixi'),
        'bin/trampoline_configuration',
    ).expanduser().resolve(strict=True).glob('*.json'):
        k = p.stem.replace('-', '_')
        if not k.isidentifier():
            k = '_' + k
            if not k.isidentifier():
                raise ValueError(p.stem)
        context[k] = json.loads(p.read_text('utf-8'))
    with fileinput.FileInput(sys.argv[1:], encoding='utf-8') as f:
        print(minijinja.render_str(''.join(f), **context))


if __name__ == '__main__':
    main()
