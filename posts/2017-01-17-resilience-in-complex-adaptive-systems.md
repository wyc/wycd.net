---
title: Resilience in Complex Adaptive Systems by Richard Cook
tags: software, engineering, security
description: "Richard Cook's talk on system risk and how to think about it."
---

I highly recommend [Richard Cook](https://www.linkedin.com/in/richardcookmd)'s presentation on [how to model system risk](https://www.youtube.com/watch?v=PGLYEDpNu60). It was wonderfully presented and put forward a very intuitive model of safety, reliability, and cost involved in running a big complex system. He drew heavily upon the work of [Jens Rasmussen](https://en.wikipedia.org/wiki/Jens_Rasmussen_(human_factors_expert)), who thought extensively about risk management for systems with lots of moving parts and people:

![Rasmussen Safety Model Diagram](/images/blog/20170117/rasmussen_safety_model.png)

In the presented model, there are three main forces at play:

- Management (top-right) actively tries to keep costs down as much as possible to keep the organization healthy, which will burden both system safety and its employees.
- Operators (bottom-right) maintaining the system actively try do as little work as possible due to competing priorities for finite workload capacity, and this will compromise both the safety of the system and organizational efficency, the latter causing shifts toward higher costs.
- Safety (left) by default will not have any long-lived constant forces pushing back on the two others. Things that further safety tend to be one-time applications that are subject to nasty time decay. New rules serve as short-term counter-gradient forces that are soon worked around. Recent accidents cause only temporarily revigorated awareness. Safety campaigns become less effective over time.

The [operating point](https://en.wikipedia.org/wiki/Operating_point) gets pushed around by all three forces in a Brownian-like motion. By default, it tends to get swept to the left because of the short-lived effects of most safety precautions against the constant thumping forces of management and operators.

While the presentation did a brilliant job of illustrating the problem at hand, there were no posited solutions, so I dug further into Cook's research. I will compile my findings in a future post.
