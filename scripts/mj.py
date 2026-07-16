import argparse
import fileinput
import json
import os
import pathlib
import platform
import sys

import minijinja


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('templates', nargs='+')
    parser.add_argument('--output-encoding')
    args = parser.parse_args()

    pixi_home = pathlib.Path(
        os.environ.get('PIXI_HOME', '~/.pixi'),
    ).expanduser()
    context = {'environ': dict(os.environ), 'pixi_home': str(pixi_home)}
    for p in (
        pixi_home.joinpath('bin', 'trampoline_configuration')
                 .resolve(strict=True)
                 .glob('*.json')
    ):
        k = p.stem.replace('-', '_')
        if not k.isidentifier():
            k = '_' + k
            if not k.isidentifier():
                raise ValueError(p.stem)
        context[k] = json.loads(p.read_text('utf-8'))
    context['vscodium_escaped'] = os.path.dirname(
        os.path.dirname(context['code']['exe']),
    ).replace('/', '\\').replace('\\', r'\\')
    if sys.platform == 'win32':
        build = int(platform.win32_ver()[1].split('.')[2])
        # https://learn.microsoft.com/en-us/windows/terminal/customize-settings/themes#mica
        context['use_mica'] = build >= 22621

    with fileinput.FileInput(args.templates, encoding='utf-8') as f:
        output_text = minijinja.render_str(''.join(f), **context)
    if args.output_encoding:
        sys.stdout.reconfigure(encoding=args.output_encoding)
    print(output_text)


if __name__ == '__main__':
    main()
