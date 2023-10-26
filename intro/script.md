
# Intro

Hello, I am dibmet-narren but friends call me Bo. During this hackathon, I teamed up with talsyx-talsud, also known as Shiv.

We are both graduates of the fall 2023 Hoon School cohort and we are both app school dropouts.

Over the last couple months we built bizbaz, the bizarre bazaar, it's a simple marketplace where you can buy or sell goods and services with your pals of pals.

00:25

# Why

Bizbaz is built around free form adverts. They are simple text blobs that can offer or request anything that can be put into words. I am not yet aware of any marketplaces that have caught on in urbit and we weren't sure what exactly people want to buy or sell, so at every opportunity we've prioritized simplicity and flexibility.

It could be that a lot of urbit users want to sell ebooks. Or maybe a large market for free-lance hoon developers will form. If one use-case comes to dominate bizbaz, this is a signal to other developers that a specialized marketplace app would immediately find product market fit. Bizbaz is not destined to add specialized support for ebook distribution or the kinds of feedback on a work-in-progress that might aid a freelance developer, the goal of bizbaz is not to become a central market of everything like Amazon.

Bizbaz lets you add tags to your adverts. If a specialized ebook marketplace is published and we feel it's high-enough quality to refer, then, while creating an advert with the ebook tag, we would add a little pop-up suggesting they check out the dedicated marketplace instead. If only a few markets develop and specialized apps are born to serve each of them, bizbaz usage might dry up, which is fine because accelerating the development of more marketplace apps is a victory condition of bizbaz.

But, we expect a long tail of weird offerings to always be present, and bizbaz will always be there as a fallback option. To serve these unusual offerings well, bizbaz is designed to do one thing very well: reviews. We'll cover reviews in-depth later but they have been carefully designed so that spamming positive reviews of yourself is difficult, and suppressing your negative reviews is impossible.

These reviews are an information dense raw material that services such as aera can mine for higher quality reputation signals. Summarizing group chat interactions is an important way to bootstrap initial reputation scores, and maybe we'll integrate these kinds of scores into bizbaz someday. But once ships start transferring monetary value with each other and using bizbaz to review each others services, that's when other apps can start refining these reputation signals and putting them to real use.

3:00

# History

Before we get into technical details and demos, let's zoom out for a second.

A peer to peer marketplace is nothing new. Ebay and OpenSea already exist. But our goal is to create a general purpose marketplace like Ebay, that we can deploy without any ongoing hosting obligations like OpenSea.

Past urbit hackathons have built similar services and we even tried to build something like this during an Ethereum hackathon at the 2018 devcon conference in Prague.

Our previous attempt to build bizbaz was an abject failure. We did not have the required tools available to us and our hacking quickly devolved into heated arguments about how best to work around these limitations. We did not submit anything for that hackathon, and even if we did stay focused until we had something to deliver, it would have been a crude mockery of what we were able to build on urbit these last few months.

The biggest problem we faced while trying to build %bizbaz on a combination of traditional and web3 tech was sybil attacks, also known as manipulation via sock puppet accounts. Ethereum accounts are just key pairs, we can create a million of them per second. Although each one needs a few bucks of gas money to take any action, there is no expectation that an ethereum address is long lived and it's even a privacy best practice if addresses are not long lived. Preventing spam on Ethereum therefore devolves into applying higher on-boarding costs for all users. The stronger the spam protection is, the less pleasant it is for honest users to start using the service.

Email addresses are not much better, there's a little more friction involved in creating each new email address but it's free. Combatting spam on a site like ebay therefore requires privileged moderators who are stuck playing whack-a-mole while manually reviewing and banning individual offenders.

The second big problem we encountered is where to store the advert data. A blob of text is not a large amount of data, but when you're paying per-byte to save it on Ethereum, it adds up. We could host a big database in the cloud like Ebay does, maybe using ipfs. This would actually be cost-effective but then we're back to ongoing hosting obligations which we're not interested in.

When we were first trying to build bizbaz, we thought to ourselves "wow I really wish we could convince our users to host their own personal servers to store this data" but that's too much friction for users who aren't already hosting their own personal servers.

5:40

# How urbit enables %bizbaz

First and foremost, urbit users are already hosting their own personal server so we have a cost-effective place to store advert data that does not impose any burdens the marketplace developer. Pictures and videos are a little heavier, we still depend on some external hosting service for these, but this is icing on the cake and we aren't existentially dependent on external hosts to validate and propagate the advert bodies.

Urbit also gives us what we need to mitigate sybil attacks. Urbit IDs are expected to be long-lived and they're tangled up with a user's group chats, flappy bird high scores, and data from other apps. It's not painless to discard one identity and don a new one. And if you do, it's obvious.

And as a bonus, peer-to-peer communication on urbit is simple, easy, and comes with some really nice guarantees. Ethereum and ipfs nodes use libp2p, this is not an easy library to work with and we're grateful that we didn't have to.

6:45

# bizbaz features

So, let's get into bizbaz.

We can create, update and delete adverts and votes.

Creating reviews is a little involved because both parties need to commit to a transaction but once a review is made, it can be simply updated, but not deleted.

# Advert creation

We're starting out with two ships that are not direct pals, but they have a pal in common.

Here, you can see the advert creation form. We're adding a title, cover image link, some tags, and pasting in a description. Once it's created, our ship broadcasts this new advert to it's pals, and those pals broadcast it to their pals, but ships do not forward any info that did not come from a mutual pal.

7:45

# Advert updates

Advert updates use the same form as advert creation so you can update any of the fields. Updated adverts are distributed to pals of pals the same way as new ones, with the old one being replaced.

# Advert deletion

Same for deletions, the delete request is distributed to pals of pals who remove the advert from their ship.

8:20

# But wait

Some of you might be a little alarmed at this point. Like, aren't people going to create adverts selling human trafficking victims? Or illegal drugs laced with various amounts of fentanyl? Or pirated copies of copyrighted movies and music?

Now, don't get me wrong, I love sex, drugs, and rock & roll. But I do not want to draw the unwelcome attention of SESTA, DEA, or DMCA enforcement to urbit. And definitely not to my personal ship.

The first line of defense is that adverts are only distributed among pals of pals. Some random ship fed-posting into the void isn't going to put their adverts in front of anyone's eyes but their own. And, if you're pals with a fed poster, consider kicking them out of your circle of friends.

But, a second, more fine-grained line of defense comes in voting.

9:20

# Up Voting

We can upvote high-quality, wholesome ads. These votes are distributed to any of our pals of pals who have stored the advert being voted on.

And, you can also unvote by clicking on the up arrow again.

9:40

# Down Voting

Here, we're downvoting a naughty ad. Notice that it's deleted from the voter's ship but still exists on other ships and it has a score of negative one.

Because the advert is deleted, our ship will stop forwarding any advert update, votes, or reviews related to this ad.

This will at least protect our ship from the Eye of Sauron because we are no longer hosting the questionable advertisement.

Later, once we get more real world usage data, we could update bizbaz to auto-drop any ads that hit some negative vote threshold so that we're still dropping the naughtiest adverts even if we don't check in on bizbaz every day. We're still uncertain what this threshold should be and are open to suggestions.

10:45

# Review Overview

Now, let's talk more about the review process.

First, a vendor creates an advert. When anyone besides the vendor looks at this advert, they'll have the option to open up a chat with the vendor where they can hash out the details. We just use the talk app for this. Maybe we'll add a built-in chat feature later but the talk app works fine so whatever. The advert page also includes a button that the client can use to express intent, that's the first step towards completing a transaction.

Next, the vendor can commit to transacting with the client who expressed intent.

Once both ships have this commit object, they are free to transact. Ships should not start sending money or whatever until they both have a commit object because it's required to create a review.

When the deal is done, or when one of them gets impatient, they can each submit their reviews and then later update their review if so desired.

11:45

# Review Demo

The ship on the left is the client, they'll start out by expressing intent. The ship on the right is the vendor, they'll commit. Then, the client's going to submit the first review.. And the vendor submits the second review.

At the end, the vendor ship on the right clicked on the client's ship name in the review. That's just a link that opened the profile page for nec where you can see nec's open adverts, all the reviews they've created, and all the reviews of them by other ships.

Also, notice the advert on the left. The two new reviews are visible at the top, these were created for this advert. But below that, we can see all the other reviews of this vendor that came from other adverts.

12:45

# Live Advert #1

bizbaz is live and ready to use. Here's one of the real live adverts that shows off some fancy formatting. The advert description is formatted as markdown so you can add in-line pictures, videos, or even glb formatted 3D models as well as links, lists, and so on.

13:15

# Live Advert #2

Another live advert. Note that adverts don't need to be offers to sell anything, they could be requests to buy something too. And this is a real advert, if you install bizbaz and express intent, you really could get paid to help me refactor bizbaz.

We do a little dogfooding, It's called we do a little dogfooding.

13:35

# Welcome

Here's a link to the bizbaz repo, the readme has detailed installation and usage instructions so check that out if anything is still unclear.

And with that, you're ready to join us.

I'm ~dibmet-narren and my teammate is ~talsyx-talsud, add us as pals and install bizbaz to start buying and selling stuff with us & our pals.

Thank you.

14:00
