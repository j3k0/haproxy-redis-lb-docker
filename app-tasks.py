#!/usr/bin/python
import json
import sys
out = []
try:
    doc = json.load(sys.stdin)
except Exception as e:
    sys.stderr.write('No valid JSON data\n')
    sys.exit(1)

if 'app' in doc and 'tasks' in doc['app']:
    for task in doc['app']['tasks']:
        if 'ports' in task and 'ipAddresses' in task:
            for ipAddress in task['ipAddresses']:
                for port in task['ports']:
                    out.append(ipAddress['ipAddress'] + ':' + str(port))
if len(out) > 0:
    print '\n'.join(out)
