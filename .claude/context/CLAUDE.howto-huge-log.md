When you have a log that's much to large to look at, here's how you can divide
and conquer it. The basic idea is to get a summary and iteratively remove noise
or otherwise uninteresting bits.

# huge log strategies

- have a look at overall size:

```
$ cat redo.log | wc
 696020 2274781 57499030
```

- take a histogram:

```
$ cat redo.log | sort | uniq -c | sort -rn | head
 111810 redo                    -- CLEAN (checked)
  64264 redo                  -- CLEAN (checked)
  37281 redo                    ?test_name.d 1,0
  37280 redo                    ?parse_message_patches.py 0,0
  30485
  30143 redo                  -- CLEAN
  21024 redo                  ?test_name.d 1,0
  20970 redo                  ?parse_message_patches.py 0,0
  19312 redo                    -- CLEAN
  19280 redo                    ?default.message.patch.d.do 0,0
```

- remove uninteresting content:

```
$ cat redo.log | grep -Pv 'CLEAN'| sort | uniq -c | sort -rn | head
  37281 redo                    ?test_name.d 1,0
  37280 redo                    ?parse_message_patches.py 0,0
  30485
  21024 redo                  ?test_name.d 1,0
  20970 redo                  ?parse_message_patches.py 0,0
  19280 redo                    ?default.message.patch.d.do 0,0
  18022 redo                  -- DIRTY (missing)
  10845 redo                  ?default.message.patch.d.do 0,0
  10187 redo                -- DIRTY (missing)
   2410 redo                ?test_name.d 1,0
```

- remove unhelpful uniqueness

```
$ cat redo.log | grep -Pv 'CLEAN' | sed -r 's/      +/  /g' | sort | uniq -c | sort -rn | head
  37281 redo  ?test_name.d 1,0
  37280 redo  ?parse_message_patches.py 0,0
  30485
  21024 redo  ?test_name.d 1,0
  20970 redo  ?parse_message_patches.py 0,0
  19280 redo  ?default.message.patch.d.do 0,0
  18022 redo  -- DIRTY (missing)
  10845 redo  ?default.message.patch.d.do 0,0
  10187 redo  -- DIRTY (missing)
   2410 redo  ?test_name.d 1,0
```

- take a sample (of the histogram, in this example):

```
$ cat redo.log | grep -Pv 'CLEAN' | sed -r 's/      +/  /g' | sort | uniq -c | shuf | head | sort
      1 redo  issue-group.d/Unknown.d/../spans processing.d/../../patches.d/tests/sentry/taskworker/test_worker.py::TestTaskWorker::test_run_once_with_update_failure/bukzor/di-1008--all-threading-fixes.2/2.message.patch.d (resumed)
     27 redo  patches.d/tests/sentry/remote_subscriptions/consumers/test_queue_consumer.py::TestSimpleQueueProcessingStrategy::test_preserves_order_within_group/bukzor/di-1008--all-threading-fixes.3/5.message.patch.d (done)
     27 redo  patches.d/tests/sentry/taskworker/test_worker.py::TestTaskWorker::test_run_once_with_update_failure/bukzor/di-1008--all-threading-fixes/1.message.patch.d (done)
     27 test_name.d/tests/sentry/remote_subscriptions/consumers/test_queue_consumer.py::TestSimpleQueueProcessingStrategy::test_concurrent_processing_different_groups/bukzor/di-1008--all-threading-fixes.2/5.message.txt: 3
     27 test_name.d/tests/sentry/remote_subscriptions/consumers/test_queue_consumer.py::TestSimpleQueueProcessingStrategy::test_preserves_order_within_group/bukzor/di-1008--all-threading-fixes.2/1.message.txt: 3
     27 test_name.d/tests/sentry/uptime/consumers/test_results_consumer.py::ProcessResultSerialTest::test_missed_check_false_positive/bukzor/di-1008--all-threading-fixes.2/0.message.txt: 1
     53 redo  ?patches.d/tests/relay_integration/lang/javascript/test_plugin.py::TestJavascriptIntegration::test_expansion_via_release_archive_no_sourcemap_link/bukzor/di-1008--all-threading-fixes.4/0.message.patch.d 1,0
     53 redo  ?patches.d/tests/sentry/taskworker/scheduler/test_runner.py::test_schedulerunner_tick_one_task_multiple_ticks/bukzor/di-1008--all-threading-fixes.4/2.message.patch.d 1,0
     53 redo  ?test_name.d/tests/sentry/remote_subscriptions/consumers/test_queue_consumer.py::TestSimpleQueueProcessingStrategy::test_offset_gaps_block_commits/bukzor/di-1008--all-threading-fixes.2/4.message.txt 0,0
     53 redo  ?test_name.d/tests/sentry/utils/test_concurrent.py::test_threaded_same_priority_Tasks/bukzor/di-1008--all-threading-fixes.2/0.message.txt 0,0
```

- rinse and repeat: (reduce uniqueness again)

```
$ cat redo.log | grep -Pv 'CLEAN' | sed -r 's/      +/  /g; s#/bukzor/[^/]*/#/$BRANCH/#g; s#(test_name.d)/.*/(\$BRANCH)#\1/$TEST/\2#g' | sort | uniq -c | shuf | head | sort
      1 📁 Validating spans processing...
      1 redo  issue-group.d/spans processing.d/tests.list (done)
      1 redo  issue-group.d/Unknown.d/../remote subscriptions.d/../../patches.d/tests/sentry/post_process_forwarder/test_post_process_forwarder.py::PostProcessForwarderTest::test_multiprocess_post_process_forwarder/$BRANCH/4.message.patch.d (resumed)
      5 redo  patches.d/tests/sentry/taskworker/test_worker.py::TestTaskWorker::test_run_once_with_update_failure/$BRANCH/0.message.patch.d
     27 redo  converted target -> source 3219
     27 redo  converted target -> source 760
     27 redo  converted target -> source 879
     27 redo  converted target -> source 886
    318 redo  ?patches.d/tests/sentry/remote_subscriptions/consumers/test_queue_consumer.py::TestSimpleQueueProcessingStrategy::test_preserves_order_within_group/$BRANCH/4.message.patch.d 1,0
   7583 redo  ?test_name.d/$TEST/$BRANCH/2.message.txt 0,0

$ cat redo.log | grep -Pv 'CLEAN' | sed -r 's/      +/  /g; s#/bukzor/[^/]*/#/$BRANCH/#g; s#((test_name|patches).d)/.*/(\$BRANCH)#\1/$TEST/\3#g; s#source [0-9]+#source $N#g; s#[0-9]+.message#$N.message#g' | sort | uniq -c | shuf | head | sort
      1   django dev server.d/mark-at-analysis.json.history.d
      1   ingest consumers.d/mark-at-analysis.json.history.d
      1 redo    ?lint.log 0,0
      1 redo    lint.log (exit 123)
      1 redo  ?issue-group.d/ingest consumers.d/tests.list.history.d 1,0
      1 redo  issue-group.d/ingest consumers.d/tests.list
      1 redo  issue-group.d/post process forwarder.d/tests.list.history.d
      1 redo  issue-group.d/Unknown.d/mark-at-analysis.json.history.d (done)
      1 Stored new historical copy: sentry threaded executor.d/tests.list.history.d/4e1c32fd6a3e8ae05330a63efdf0ea2c83dfd9ee11e590c1d24c1f7a8ed9994a.list
      8 redo  ?issue-group.d/sentry threaded executor.d/patch.list 1,0
```

- have a look at overall size: (again)

```
$ cat redo.log | grep -Pv 'CLEAN' | sed -r 's/      +/  /g; s#/bukzor/[^/]*/#/$BRANCH/#g; s#((test_name|patches).d)/.*/(\$BRANCH)#\1/$TEST/\3#g; s#source [0-9]+#source $N#g; s#[0-9]+.message#$N.message#g' | sort | uniq -c | wc
    530    2737   39841
```

- that's reasonable! maybe you can get something out of that reduced log. if not
  we need to "rinse and repeat" more
