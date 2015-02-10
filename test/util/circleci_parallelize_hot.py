#!/usr/bin/env python

import os
import subprocess
import sys
import yaml


increment = 0
test_cases = yaml.load(open('tests.yaml')).get('test-cases')
node_total = int(os.environ.get('CIRCLE_NODE_TOTAL'))
node_index = int(os.environ.get('CIRCLE_NODE_INDEX'))

print 'node total is {}, node index is {}'.format(node_total, node_index)

tests_to_run = []

for case in test_cases:
    print "case is {}".format(case.get('name'))
    print "increment is {}, total is {}, mod is {}\n-----".format(
        increment, node_total, increment % node_total)
    if (increment % node_total) == node_index:
        tests_to_run.append(case.get('name'))
    increment += 1

print "calling {}".format(['hot', 'test', '--test-cases']+tests_to_run)

sys.exit(subprocess.call(['hot', 'test', '--test-cases']+tests_to_run))
