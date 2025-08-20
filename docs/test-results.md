# Yelp Test Results

### landing page

by default, filter by logged-in user one row per "branch" sorted reverse
chronologically (newest first) colorized by high-level "ready to ship" status

- flaky test failures count as "tests not run" for this, resulting in
  problematic/yellow status
- currently-in-flight test runs are grey/blue
  - before tests start, ingest a "tests to run" list
  - enables discriminating tests taht should have run but never were reported

click on a row goes to "drill-down" view of a single branch

the branch's row-summary from this page is posted as a PR comment

- just shows the branch name, high-level status, and test count for each
  "section", below

### branch drill-down view

at top, a prominent "rerun failures" button

one row per test, three sections.

1. test failures -- these tests were (most likely) caused by the current PR this
   section is fully visible, the other sections are "rolled up" just showing
   their test-count

   - rows are ordered by: test count(1), minimum test duration, alphabetical

   - one row per "unique" test failure -- i.e. error-message
     reduction/normalization
     - clicking a gear button will show the "normalized" error, for comparison
   - in roll-up of row is labelled with name of shortest-duration test
   - show the failure (sampled randomly from the group)
   - name of test with shortest runtime is shown at top of row
   - other, error-matched test names are at bottom of row
     - expand a rollup to to see other test failures

2. flakes -- these failed in a way that's been seen on main branch
3. "infra failures" -- this is a time-correlated failure pattern -- i.e. several
   unrelated PRs and/or master have this failure
4. passing tests -- can be unrolled to see individual tests

### branch drill-down view -- v1

(no error normalization, no "infra failures")

one row per test, three sections.

each section:

- shows the count of tests
- colorized: red (must do), yellow (needs thought), green (no action)
- widget to see a copy-pasteable list of test names

1. test failures -- these tests were (most likely) caused by the current PR this
   section is fully visible, the other sections are "rolled up" just showing
   their test-count

   - rows are ordered by: test duration, alphabetical

   - one row per test failure
   - in roll-up of row is labelled with name of test
   - show the failure
   - show runtime in smaller font beside test name

2. flakes -- these failed in a way that's been seen on main branch
3. passing tests -- can be unrolled to see list of passing tests
