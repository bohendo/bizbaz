
# Intro

Hello, I am dibmet-narren but friends call me Bo. During this hackathon, I teamed up with talsyx-talsud, also known as Shiv.

We are both graduates of the fall 2023 Hoon School cohort and we are both app school dropouts.

Over the last couple months we built bizbaz, the bizarre bazaar, it's a simple marketplace where you can buy or sell goods and services with your pals of pals.

00:25

# Why

Bizbaz is built around free form adverts. They are simple text blobs that can offer or request any good or service you can think of.

I am not yet aware of any general purpose marketplaces that have caught on in urbit and we weren't sure what exactly people want to buy or sell, so at every opportunity we've prioritized simplicity and flexibility.

It could be that a lot of urbit users want to sell ebooks. If one use-case dominates bizbaz, this is a signal to other developers that a specialized marketplace app would immediately find product market fit.

Bizbaz is not destined to add specialized support for ebook distribution, the goal of bizbaz is not to become a central market of everything.

Bizbaz lets you add tags to your adverts so if someone creates an advert and adds the nft tag, we would add a pop-up suggesting they check out the urbitswap marketplace that's dedicated to buying or selling NFTs.

If only a few markets develop and specialized apps are born to serve each of them, bizbaz usage might dry up, which is fine because accelerating the development of more marketplace apps is a victory condition of bizbaz.

But, we expect a long tail of weird offerings to always be present, and bizbaz will always be there as a general purpose fallback option.

To serve these unusual offerings well, bizbaz is designed to do one thing very well: reviews. We'll cover reviews in-depth later but they have been carefully designed so that spamming positive reviews of yourself is difficult, and suppressing your negative reviews is impossible.

These reviews put a little social skin in the game so, with trust proportional to the value being transacted, these reviews could play a similar role to an escrow + trusted 3rd party while trading crypto or buying something that needs to be shipped.

These reviews are also an information dense raw material that services such as aera could mine for higher quality reputation signals.

# History

Before we get into technical details and demos, let's zoom out for a second.

A peer to peer marketplace is nothing new. Ebay provides cost effective data storage and OpenSea is non-custodial, but I would really like something to exist that combines the best properties of both of these markets.

To that end, me and my hackathon partner tried to build bizbaz.eth at a past Ethereum hackathon using a combination of traditional web and blockchain tech.

That project was an abject failure, we didn't even submit anything and even if we did, it would have been a crude mockery of what we were able to build on urbit.

One of the biggest problems we faced is sybil attacks. Ethereum IDs are just key pairs, you can make a million a minute and mitigating spam devolves to just increasing on-boarding costs. And email addresses aren't much better. But urbit IDs are long lived and are tangled up with your group chats, flappy bird high scores, etc so it's not painless to shed an old ID and don a new one, and it's obvious when you do.

The second problem was data storage. A blob of text isn't a huge amount of data, but it gets pricey when you're paying per-byte to save it on ethereum. Ebay can save plenty of data cost effectively, but only by introducing a centralized custodian honestly and honestly we're not responsible enough for that. Urbit is the perfect solution, not only is it non-custodial and cost effective to store advert descriptions, but the built-in tools for sharing this data with our peers saved us from libp2p hell.

# bizbaz features

So, bizbaz manages 3 important types of data: adverts, votes, and reviews.

We can create, update and delete adverts and votes.

Creating reviews is a little involved because both parties need to commit to a transaction but once a review is made, it can be simply updated, but not deleted.

# Advert creation

We're starting out with two ships that are not direct pals, but they have a pal in common.

Here, you can see the advert creation form. We're adding a title, cover image link, some tags, and pasting in a description. Once it's created, our ship broadcasts this new advert to it's pals, and those pals broadcast it to their pals, but ships do not forward any info that did not come from a mutual pal.

# Advert updates

Advert updates use the same form as advert creation so you can update any of the fields. Updated adverts are distributed to pals of pals the same way as new ones, with the old one being replaced.

# Advert deletion

Same for deletions, the delete request is distributed to pals of pals who remove the advert from their ship.

# But wait

Some of you might be a little alarmed at this point. Like, aren't people going to create adverts selling human trafficking victims? Or illegal drugs laced with various amounts of fentanyl? Or pirated copies of copyrighted movies and music?

Now, don't get me wrong, I love sex, drugs, and rock & roll. But I do not want to draw the unwelcome attention of SESTA, DEA, or DMCA enforcement to urbit. And definitely not to my personal ship.

The first line of defense is that adverts are only distributed among pals of pals. Some random ship fed-posting into the void isn't going to put their adverts in front of anyone's eyes but their own. And, if you're pals with a fed poster, consider kicking them out of your circle of friends.

But, a second, more fine-grained line of defense comes in voting.

# Up Voting

We can upvote high-quality, wholesome ads. These votes are distributed to any of our pals of pals who have stored the advert being voted on.

And, you can also unvote by clicking on the up arrow again.

# Down Voting

Here, we're downvoting a naughty ad. Notice that it's deleted from the voter's ship but still exists on other ships and it has a score of negative one.

Because the advert is deleted, our ship will stop forwarding any advert update, votes, or reviews related to this ad.

This will at least protect our ship from the Eye of Sauron because we are no longer hosting the questionable advertisement.

Later, once we get more real world usage data, we could update bizbaz to auto-drop any ads that hit some negative vote threshold so that we're still dropping the naughtiest adverts even if we don't check in on bizbaz every day. We're still uncertain what this threshold should be and are open to suggestions.

# Review Overview

Now, let's talk more about the review process.

Actually, step zero of conducting a reviewable transaction is for the vendor to create an advert. From the advert page, the client can click to open a talk app to hash out the details w the vendor.

Then, step one is the client expressing intent, and the vendor can do a background check or whatever to make sure the client is trustworthy before committing.

Once both ships have this commit object, they are ready to transact. Ships should not start sending money or shipping stuff until they both have a commit object because it's required to create a review.

When the deal is done, or when one of them gets impatient, they can each submit their reviews and then later update their review if so desired.

# Review Demo

The ship on the left is the client, they'll start out by expressing intent. The ship on the right is the vendor, they'll commit. Then, the client's going to submit the first review.. And the vendor submits the second review.

At the end, the vendor ship on the right clicked on the client's ship name in the review. That's just a link that opened the profile page for nec where you can see nec's open adverts, all the reviews they've created, and all the reviews of them by other ships.

Also, notice the advert on the left. The two new reviews are visible at the top, these were created for this advert. But below that, we can see all the other reviews of this vendor that came from other adverts.

12:45

# Live Advert #1

Bizbaz is live and ready to use. Here's one of the real live adverts that shows off some fancy formatting. The advert description is formatted as markdown so you can add in-line pictures, videos, or even glb formatted 3D models as well as links, lists, and so on.

# Live Advert #2

Another live advert. Note that adverts don't need to be offers to sell anything, they could be requests to buy something too. And this is a real advert, if you install bizbaz and express intent, you really could get paid to help me refactor bizbaz.

We do a little dogfooding, It's called we do a little dogfooding.

# Welcome

Here's a link to the bizbaz repo, the readme has detailed installation and usage instructions so check that out if anything is still unclear.

And with that, you're ready to join us.

I'm ~dibmet-narren and my teammate is ~talsyx-talsud, add us as pals and install bizbaz to start buying and selling stuff with us & our pals.

Thank you.
