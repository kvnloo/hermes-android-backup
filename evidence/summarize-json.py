#!/usr/bin/env python3
"""Count visible Flutter tests; report loader failures separately."""
import collections
import json
import pathlib
import sys

for argument in sys.argv[1:]:
    path = pathlib.Path(argument)
    tests = {}
    suites = {}
    results = collections.Counter()
    loaders = collections.Counter()
    failures = []
    errors = []
    done = None
    for line in path.open(encoding='utf-8'):
        try:
            row = json.loads(line)
        except ValueError:
            continue  # A concurrently written final line is not a result.
        kind = row.get('type')
        if kind == 'suite':
            suite = row['suite']
            suites[suite['id']] = suite
        elif kind == 'testStart':
            test = row['test']
            tests[test['id']] = test
        elif kind == 'testDone':
            counter = loaders if row.get('hidden') else results
            key = 'skipped' if row.get('skipped') else row['result']
            counter[key] += 1
            if row['result'] != 'success':
                test = tests.get(row['testID'], {})
                failures.append({'test': test, 'result': row})
        elif kind == 'error':
            errors.append(row)
        elif kind == 'done':
            done = row
    report = {
        'path': str(path),
        'visible_counts': dict(results),
        'loader_counts': dict(loaders),
        'suite_count': len(suites),
        'done': done,
        'failures': failures,
        'errors': errors,
    }
    print(json.dumps(report, indent=2))
