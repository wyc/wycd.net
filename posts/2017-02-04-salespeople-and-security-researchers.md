---
title: Enterprise Salespeople are a lot like Computer Security Researchers
tags: business, security
description: Similarities between two fields rarely mentioned together.
---

Who do hackers stereotypically hate most? Probably [business people](http://www.theonion.com/article/businessman-goes-home-for-the-holidays-to-network--30719). They schmooze around with their fake friends, talk about value and synergy, have a poor understanding of technology, and disrespect our craftsmanship. They hobble highly-skilled work as no more than a means to their nefarious profit-driven ends. Yet, I think there's a strong resemblence between the most businessy and Successful enterprise salesperson and the much-glorified hardcore penetration tester who regularly collects on bug bounties.

How do many pen testers operate? They first [collect as much information](http://internetcensus2012.bitbucket.org/paper.html) as possible. When they're satisfied with the amount and quality of data, they'll attempt to conquer one of many [entry points](https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-security/DCNTNp_qjFM) exposed from a system's exterior and eventually perform [privilege escalations](http://seclists.org/oss-sec/2014/q2/469) once they're inside.

Here's a visual representation of what a system intrusion could look like:

```
    +-------------+
    | SHIT WEBAPP | (1) break into this
    +-------------+
          |     |
          |     +-------------------+
          |                         |  (3) leverage position to
          | (2) pwn db         /^^^^^^^^^\    pwn whole network
     +-----------------+     /^ CORPORATE ^\
     | DATABASE        |    <   CLOUD VPN   >
     +-----------------+     \vvvvvvvvvvvvv/
```

Outbound salespeople do a pretty similar dance. They first [gather intel](https://blog.hubspot.com/marketing/beginner-inbound-lead-generation-guide-ht). When they're happy with the amount and quality of data, then they'll try to [access an entry point](http://predictablerevenue.com/blog/how-to-write-a-cold-sales-email). Once they're in, they try to find the decision maker(s) and perform [privilege escalation](http://amzn.to/2iKNoyR).

Here's a visual representation of what an enterprise sale could look like:

```
    +-------------+
    | GATEKEEPER  | (1) get past this
    +-------------+
          |     |
          |     +-------------------+
          |                         |  (3) cross-sell and get warm leads
          | (2) make the sale  /^^^^^^^^^^^^^^^\
     +-----------------+     /^     CORPORATE   ^\
     | ECONOMIC BUYER  |    <   REFERRAL NETWORK  >
     +-----------------+     \vvvvvvvvvvvvvvvvvvv/
```

While their tools and tactics are different, the general outlines look very similar: failure is the norm. Persistence, savviness, and ingenuity are keys to winning. The big firms have very well-defined processes that can efficiently perforate a staggering amount of organizations at breakneck speeds. Both fields are founded on trust, and the best practicioners seem to be most concerned with other people. There may be things for these fields to learn from each other after all.
