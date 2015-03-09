#!/usr/bin/env python

import nltk
import sys
import csv

data = []

for i, path in enumerate(sys.argv[1:]):
  with open(path) as csvfile:
    spamreader = csv.reader(csvfile)
    for j,row in enumerate(spamreader):
      decision = row[0]
      wiki_name = row[1]
      data.append([i, wiki_name, decision])
      if j==500: break
      
task = nltk.metrics.agreement.AnnotationTask(data=data)
print 'Kappa', task.kappa()
print 'Alpha', task.alpha()