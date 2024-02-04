import argparse
import json
import os
import glob

def main():
    parser = argparse.ArgumentParser(description="Print examples to test as JSON.")
    parser.add_argument(
        'examples',
        type=str,
        nargs='?',
        default='all',
        help='Comma-separated list of examples. Specify "all" to build all (the default).'
    )
    args = parser.parse_args()
    if args.examples == 'all':
        os.chdir('examples')
        examples = glob.glob('*')
    else:
        examples = args.examples.split(',')
    examples = [ e.strip() for e in examples ]
    print(json.dumps(examples))

if __name__ == '__main__':
    main()
