To do
=====

Implement regular-expression priorities like Cucumber:
------------------------------------------------------

  1. The longest Regexp with 0 capture groups always wins.
  2. The Regexp with the most capture groups wins (when there are none with 0 groups)
  3. If there are 2+ Regexen with the same number of capture groups, the one with the shortest overall captured string length wins
  4. If there are still 2+ options then an Ambiguous error is raised