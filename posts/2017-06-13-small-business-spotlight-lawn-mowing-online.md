---
title: "Small Business Spotlight: LawnMowingOnline.com"
tags: business, spotlight
---

My lawn was getting scraggly, and I wanted to do something before it started to
raise eyebrows. I don't care for keeping up with the Jonses, but if this is a
cultural norm keeping my neighbors happy, then it's absolutely worth it. I
value:

- Low cost
- Low effort to book
- No management overhead on my part

## The Value Story

I heard about [LawnMowingOnline.com](https://lawnmowingonline.com) from some
neighbors' posts on NextDoor.  Upon visiting the website, I immediately valued:

- No app to download
- Low cost marketed first and foremost on their website ("$19 Lawn Mowing")
- Straightforward instructions

It looks like a standard Rails project, has no single-page app, and is as
bare-bones as the service price. But I don't care--my needs are being met,
and it even has a nice mobile-friendly intuitive design.

In short, my workflow went from:

1. Find multiple vendors. 20-30 mins.
2. Call each one to get quotes. 20-30 mins.
3. Have each vendor insist to schedule a time to come over give said quote.
4. Wait for vendors to show up late and give quotes. 15 minute property walk per vendor, 1-4 hours lost due to late vendors.
4. Gather quotes and call best vendors. 15 mins.
5. Negotiate and get pressured into a monthly service contract. 5 mins.
6. Schedule time for the actual work.
7. Pay $40-$100 per mowing.

To:

1. Log in to LawnMowingOnline.com. (30 seconds)
2. Pick a date and time and pay $19-$25 fixed-fee. (2 minutes)
3. Receive confirmation. (5 minutes)
4. After the appointment, receive pictures of the mowed lawn.

That is real value. For every vendor I have to talk to, I could call an
additional prospective client or catch up with a friend--not to mention the
time suck it is to schedule meetings in person. I am a repeat customer.

My only gripe is that they don't currently offer additional services such as
hedge trimming, debris removal, or application of insect repellent.

## Business Model and Revenues

LawnMowingOnline.com creates an online marketplace that matches consumers with
lawn mowing needs and mowers who have excess capacity. Two sided markets tend
to have a [subsidized
side](https://hbr.org/2006/10/strategies-for-two-sided-markets). In this one,
the consumers are clearly the subsidized leg, as mowers are always looking for
more work because they have excess capacity. Consumers are subsidized via low
prices, and as long as those prices are above the mower [reservation
wage](https://en.wikipedia.org/wiki/Reservation_wage), then transactions should
occur. In a sense, this is a form of price discrimination that targets lawn
mowers with idle employees and equipment. To keep prices low, it offers them
below-market but above-reservation wage rates--it's still a lot better than
sitting there and doing nothing.

LawnMowingOnline.com reduces search costs thanks to technology, which provides
a trusted escrow for the consumer, and brokers the transaction. The consumer
demand is packaged into an attractive pre-paid request for service, complete
with location details, yard sizes, and pre-determined pricing. This request for
service is then presented to prospective workers as a fungible work "futures
contract". They make money by taking a $1 flat fee. From the website:

> *Do I have to pay any fees?*
>
> Out of the $19 for basic lawn mowing about $1 goes to credit card processing
> fees and $1 goes to LawnMowingOnline.com so the contractor receives $17 out
> of that $19.

Their [blog](https://lawnmowingonline.wordpress.com/) does not release exact
figures, but it states that tens of thousands to low hundreds of thousands of
lawns have been mowed by 2014, and reportedly, sales have been consistently
doubling through 2016. With these rough figures, we can attempt to deduce this
year's revenues:

$$ TLM_{2014} = \sum_{n=1}^{4} (2^{n-1})YLM_{1} \\
   \text{If }TLM_{2014} = 50000\text{, then }YLM_{1} \approx 3300 \text{, and }YLM_{7} \approx 420000 \\
   \text{If }TLM_{2014} = 200000\text{, then }YLM_{1} \approx 13000\text{, and }YLM_{7} \approx 3300000
$$

Where:

- `TLM` is Total Lawns Mowed.
- `YLM` is Lawns Mowed This Year.
- `n` is the years since founding (2009), starting at 2010 and stopping at 2014.

We multiply by \\(2^7\\) to get from 2010 to 2017. This translates to current
annual revenues of between $420k and $3.3MM, which are wonderful figures for a
bootstrapped tech company.

This company was founded in O Fallon, Missouri in 2009 by James Hassinger.
[Crunchbase](https://www.crunchbase.com/organization/lawnmowingonline#/entity)
reports 100-250 employees, which is a bit of a stretch assuming $70,000
fully-loaded annual per-FTE costs. I imagine that many employees are actually
1099 contractors.

The technology side of the platform, while important, should not require more
than a team of 1-3 skilled engineers.

## Defensibility 

The most obvious defensible aspect of this business is the network of lawn
mowers and buyers. I imagine the streamlined workflow and low price point
difficult to compete on for new entrants and existing. It would be difficult to
establish the same network given the budget constraints.

A similar company, Lawnlove.com, quoted nearly double the price of
LawnMowingOnline.com at $40 (vs. $24) for a basic mowing. Lawnlove.com is
venture-backed and has at least ten employees. It offers more sophisticated
service lines such as fertilizer and sprinklers, catering to wealthier people
who care more about appearances.

## Disruption

This company has some marks of disruptive technology:

- Using the Internet and software, it has the unique advantage of low-cost
  transactions and matchmaking.
- It is attacking the low-end of the market, namely people who just want their
  lawn mowed and don't care so deeply about lawn aesthetics.
- It has a simpler offering than standard lawn service companies. No hedges. No
  sidewalks. No leaf blowing. Just cheap lawn mowing.
- Its increased dimensions of value are in price and convenience.
- It is "good enough". Typical lawn mowing companies are professionals charging
  up to $50-100/hr for mowing and landscaping. Typical LawnMowingOnline.com
  contractors are people making minimum wage.

Aside from my purchases, I don't have any affiliation with LawnMowingOnline.com.
