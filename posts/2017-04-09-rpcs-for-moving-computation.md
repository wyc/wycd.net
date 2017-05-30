---
title: RPCs for Moving Computation
tags: software, data
description: "Code moves to the cloud, cheaply!"
---

One of the tenants of
[HDFS](https://hadoop.apache.org/docs/r3.0.0-alpha2/hadoop-project-dist/hadoop-hdfs/HdfsDesign.html)
is that “Moving Computation is Cheaper than Moving Data”. Basically, 20 KBs of
code that perform useful computations are a lot easier to move to your 20 TB
datasets than the other way around. It's a methodology popular in many
distributed data analytics platforms including [Apache
Spark](https://spark.apache.org/), [Joyent's
Manta](https://github.com/joyent/manta),
and [Apache Hadoop](https://hadoop.apache.org), not to mention the countless custom systems that apply the
same approach. 

The implementations are still rather ad-hoc, but they tend to provide a set of
primitives such as `filter`, `map`, `reduce`, `partition`, etc. I predict that
this will be formalized in something like an [RPC
framework](https://en.wikipedia.org/wiki/Remote_procedure_call) that will
support functional programming as a first-class feature, so that the system as
a whole could be self-modifying in providing new endpoints constructed purely
via structured RPC calls. This would be not unlike stored database procedures,
and it would perhaps have stricter typing to deal with the amalgamation of
vastly different data sets.

Such powerful configuration could be ripe for abuse, so permissions in this
distributed system could reflect the protected OS and userspace memory
delineations that current operating systems enforce--core privileged
functionality can be separated from user-defined functions. This would
definitely be a move forward towards computation-as-a-service, and it could be
accelerated with a decent standard.
