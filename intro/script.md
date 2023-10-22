
# Intro

Hello, I am dibmet-narren but friends call me Bo. During this hackathon, I teamed up with talsyx-talsud, also known as Shiv.

We are both graduates of the fall 2023 Hoon School cohort and app school dropouts.

Over the last couple months we built bizbaz, the bizarre bazaar, it's a simple marketplace where you can buy or sell goods and services with your pals of pals.

# Why

Bizbaz is built around free form adverts, simple text blobs that can offer or request anything that can be put into words. I am not yet aware of any marketplaces that have caught on in urbit and we weren't sure what exactly people want to buy or sell, so at every opportunity we've prioritized simplicity and flexibility.

It could be that a lot of urbit users want to sell ebooks. Or maybe a large market for free-lance hoon developers will form. If one use-case comes to dominate bizbaz, this is a signal to other developers that a specialized marketplace app would immediately find product market fit. Bizbaz is not destined to add specialized support for ebook distribution or the kinds of feedback on a work-in-progress that might aid a freelance developer, the goal of bizbaz is not to become a central market of everything like Amazon.

Bizbaz lets you add tags to your adverts. If a specialized ebook marketplace is published and we feel it's high-enough quality to refer, then we will add a pop-up to adverts with the ebook tag suggesting users to check out the dedicated marketplace instead. If a small number of markets develop and specialized apps are born to serve each of them, bizbaz usage might dry up, which is fine because accelerating such secondary marketplaces is a victory condition of bizbaz.

But, we expect a long tail of weird offerings to always be present, and bizbaz will always be there as a fallback option. To serve these unusual offerings well, bizbaz is designed to do one thing very well: reviews. We'll cover reviews in-depth later but they have been carefully designed so that spamming positive reviews of yourself is difficult, and suppressing your negative reviews is impossible.

These reviews are an information dense raw material that services such as aera can mine for higher quality reputation signals. Summarizing group chat interactions is an important way to bootstrap initial reputation scores, and this first-take at a reputation may one day fit into bizbaz nicely. But once ships start transferring monetary value with each other and using bizbaz to review each others services, that's when other apps can start refining these reputation signals and putting them to real use.

# History

Before we continue into technical details and demos, let's zoom out for a second.

A peer to peer marketplace is hardly a new idea. Ebay and OpenSea already exist. But our goal is to create a general purpose marketplace like Ebay, that we can deploy without any ongoing hosting obligations like OpenSea.

Past urbit hackathons have built similar services and we even tried to build something like this during an Ethereum hackathon at the 2018 devcon conference in Prague.

Our previous attempt to build %bizbaz was an abject failure. We did not have the required tools available to us and our hacking quickly devolved into heated arguments about how best to work around these limitations. We did not submit anything for that hackathon, and even if we did stay focused until we had something to deliver, it would have been a crude mockery of what we were able to build on urbit these last few months.

The biggest problem we faced while trying to build %bizbaz on a combination of traditional and web3 tech was sybil attacks, also known as manipulation via sock puppet accounts. Ethereum accounts are just key pairs, we can create a million of them per second. Although each one needs a few bucks of gas money to take any action, there is no expectation that an ethereum address is long lived and it's even a privacy best practice if addresses are not long lived. Preventing spam on Ethereum therefore devolves into applying higher on-boarding costs for all users. The stronger the spam protection is, the less pleasant it is for honest users to start using the service.

Email addresses are not much better, there's a little more friction involved in creating each new email address but it's free. Combatting spam on a site like ebay therefore requires privileged moderators who are stuck playing whack-a-mole while manually reviewing and banning individual offenders. AI might make this more efficient, but it will also make the spam harder to identify so I'd call that a draw.

The second big problem we encountered is where to store the advert data. A blob of text is not a large amount of data, but when you're paying per-byte to save it on Ethereum, it adds up. We could host a big database in the cloud like Ebay does, maybe using ipfs. This would actually be cost-effective but then we're back to ongoing hosting obligations which we're not interested in.

When we were first trying to build bizbaz, we thought to ourselves "wow I really wish we could convince our users to host their own personal servers to store this data" but that's too much friction for users who aren't already hosting their own personal servers.

# How urbit enables %bizbaz

First and foremost, urbit users are already hosting their own personal server so we have a cost-effective place to store advert data that does not impose any burdens the marketplace developer. Pictures and videos are a little heavier, we still depend on some external hosting service for these, but this is icing on the cake and we aren't existentially dependent on external hosts to validate and propagate the advert bodies.

Urbit also gives us what we need to mitigate sybil attacks. Urbit IDs are expected to be long-lived and they're tangled up with a user's group chats, flappy high scores, and data from other apps. It's not painless to discard one identity and don a new one. And if you do, it's readily apparent.

And as a bonus, peer-to-peer communications on urbit are simple, easy, and come with some really nice guarantees. Ethereum and ipfs nodes use libp2p, this is not an easy library to work with and we're grateful that we didn't have to.

# bizbaz features

advert crud