---
title: pptpclient's Use of Fault Tree Analysis
tags: software, documentation, engineering
---

I was setting up a [pptp tunnel](https://en.wikipedia.org/wiki/Point-to-Point_Tunneling_Protocol) today, so as a result I was also glued to [pptpclient's documentation](http://pptpclient.sourceforge.net/). I was really impressed by the quality of writing and comprehensiveness--there is even a Gentoo howto.

One of the most interesting parts of the documentation was the [fault tree section of the diagnosis page](http://pptpclient.sourceforge.net/howto-diagnosis.phtml#fault_tree). It provided step-by-step troubleshooting that was informative and completely _accepting of failure_ as a possibility. Most docs I've been through typically present the happy case first and foremost, while furrowing some possible exceptions into an FAQ, seemingly as an afterthought. Using [fault tree analysis](https://en.wikipedia.org/wiki/Fault_tree_analysis) here, the pptpclient devs made their software much more user-friendly and usable. I hope to see this pattern in more future projects!
