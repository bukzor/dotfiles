#!/usr/bin/env python3
import json
from pathlib import Path


def read_roles(path: Path):
    with path.open() as raw_roles:
        roles = []
        role = []
        for line in raw_roles:
            role.append(line)
            if line == '}\n':
                roles.append(json.loads(''.join(role)))
                role = []
    return roles


def main():
    roles = read_roles(Path('./roles.raw.json'))
    for role in roles:
        path = Path(role['name'].replace('.', '/')).with_suffix('.json')
        path.parent.mkdir(exist_ok=True, parents=True)
        print(path)
        with path.open('w') as role_json:
            json.dump(role, role_json, indent=2)
            role_json.write('\n')


if __name__ == '__main__':
    raise SystemExit(main())
