---
title: "My Google Cloud Platform Experience: Great Tech, Awful Support"
tags: business, software, cloud
---

Over 1.5 months, I went through 34 back-and-forth messages, eight different Google support representatives, one unsolicited phone call on a Sunday, and a subsequent 24-hour self-destructing arbitration offer. This was finally resolved only after a friend who happened to be an _employee of Google_ kindly offered to escalate my ticket. This was $100 in dispute, while they simultaneously offer $300 of _free trial credit_ [to anyone](https://cloud.google.com/free/).

My position is that Google Cloud Platform has amazing technology, and the product's so good that I'm willing to wade through the customer support pain to keep using it. Furthermore, I'm still likely to recommend it to clients. However, I'd be a far happier user if the support was anywhere near as good. I think Ben Thompson has it right in his article [How Google is Challenging AWS](https://stratechery.com/2016/how-google-cloud-platform-is-challenging-aws/):

> To be sure, Google’s success is not assured: the company still has to grapple with a new business model — sales versus ads — and build up the sort of organization that is necessary for not just sales but also enterprise support. Both are areas where Amazon has a head start, along with a vastly larger partner ecosystem and a larger feature set generally.


## Timeline

- Early November: Saw a demonstration of Google Cloud Platform. I really liked Datastore, and thought it could save me a lot of time. It even has a well-written Go SDK! Checked out the rest of the SDK, including the `gcloud` command-line utility, and I decided that this was generally well-designed and something I'd enjoy using. I even [packaged it for Gentoo](https://github.com/wyc/wyc-overlay/blob/master/app-admin/google-cloud-sdk/google-cloud-sdk-138.0.0.ebuild) recently; this was the Real Deal. The web UI seemed consistent and excellent, especially compared to AWS, which feels a bit more inconsistent and clobbered together. The pricing was competitive. Okay, let's go! Sweep me away, Google Cloud Platform.

- November 17th: Implemented Kubernetes on GCE. Happy with my cluster and huge chunks of spent time that I'll never get back. Selected all my instances in the web UI, right click -> shutdown.

- December 3rd: Billed for $95.22, $93.60 of which is 949.45 hours of "Compute Engine Standard Intel N1 2 VCPU running in Americas". Hmm, that's way off--should have been somewhere under 20 hours for my usage. I went to console and deleted offending project. I opened a ticket to investigate the costs and get to the bottom of this billing error.

- December 3rd: I was asked for more information about the billed instances, project, etc. I responded.

- December 4th: Rep1 gives me instructions to disable the project in question. When I pointed out that the project was already deleted, I was told their Specialized team would be consulted.

- December 7th: Rep2 tells me that Rep1 is out of office and I'll receive an update soon.

- December 8th: Rep1 asks for more some more deatils about my refund request, and I answer. Again, the Specialized team would be consulted.

- December 10th: Rep1 is still investigating. I appreciate the update.

- December 11th: Rep1 calls me on a Sunday and attempts to explain the GCE billing page to me, and isn't sure what to do when I bring up my issue. Rep1 sends a follow-up email with instructions on how to stop instances and "[thus], I'm on the process of requesting only 50% of your disputed charge as a one time courtesy refund. Please let me know within 24 hours if you are amenable with this proposal." I do not accept the exploding offer.

- December 14th: Rep1 sends me general information about Compute Engine pricing, and I reiterate my concerns in paragraph form.

- December 16th: Rep1 informs me that it's now understood to be a UI issue.

- December 17th: Rep1 informs me that the case is still under review.

- December 20th: Rep3 tells me Rep1 is out of office and I'll receive an update soon.

- December 22nd: Rep4 tells me Rep1 is out of office and I'll receive an update soon. Rep4 transfers me to the technical team.

- December 24th: Rep5 tells me to rest assured, Rep1 is out of office and I'll receive an update soon. Rep6 tells me Rep1 is out of office and I'll receive an update soon.

- December 27th: Rep7 tells me Rep1 is out of office and I'll receive and update soon. I am now in a Kafkaesque cloud support nightmare.

- December 28th: Rep8 contacts me with general product descriptions. Rep8 has one note about the disputed project: "we are unable to search this kind of project in our database", to which I respond with my original concerns.

- December 29th: Rep8 decides to transfer me to the billing team. I briefly rant in Internet chat rooms--typically a very productive pastime and good investment of my time. My friend who works at Google messages me about how awful that sounds and insists we escalate the case. I forward my email and case number expecting nothing, but Rep9 reaches out to me in just a few hours.

- December 30th: Rep9 decides to issue a _full refund_ of ...$86? Wrong amount, but I'll take it. I thank him.

- January 2nd: Rep9 tells me that my refund is in progress.

- January 4th: Rep10 takes over the case?

- January 13th: Rep10 closes the case. System auto-sends Customer Feedback Survey email on behalf of Rep10.

I think you're likely to have a good support experience with GCP if you have one of:

- Awesome friend who works at Google
- [Spend several hundred thousand dollars per month for account managers](https://news.spotify.com/us/2016/02/23/announcing-spotify-infrastructures-googley-future/)
- Few billing or technical disputes

There are some immensely effort-saving features that definitely make my life easier, and I hope I get them soon without this friction.
