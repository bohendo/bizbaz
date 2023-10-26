# %bizbaz

**The Bizarre Bazaar**

Buy & sell stuff with pals-of-pals

## Live Installation

%bizbaz depends on %pals to propagate adverts so you must install %pals first (/1/desk/~paldev/pals).

Once you have some pals, install by running `|install ~dibmet-narren %bizbaz` or searching for apps by ~dibmet-narren from the landscape app.

App link: /1/desk/~dibmet-narren/bizbaz

## Usage

Note that you'll need to install bizbaz on at least 2 ships that are mutual pals to test out all of the features. For brevity, we'll refer to these two ships as ~zod and ~nec while describing usage.

If you have pals who have published adverts and you don't see them on the home page, click the refresh button in the top right. This is not normally necessary, but might help get your ship unstuck if an error has occurred.

Expected propagation: If we have 4 ships and ~zod is a mutual pal w ~nec, ~nec is a mutual pal w ~bud, and ~bud is a mutual pal w ~wes, then when ~zod creates an advert, casts a vote, or submits a review, this data will be propagated to ~nec and ~wes but not ~bud.

To create the first advert from ~zod, click the `+` button in the bottom right corner of the home page. Fill out the advert details and click "submit". Adverts are displayed as markdown, so you can add formatting or links to images, videos, and even 3D models in `glb` format! A new advert card will appear on the home page, click the card to view advert details. From here, the advert creator can use the button in the bottom right to edit or delete this advert.

This advert should be picked up by ~zod's pals and pals-of-pals (eg ~nec) and be displayed on the home page. If you click the advert card from ~nec, you'll see similar advert details but with a few new options.

You can upvote this advert from ~nec by clicking the up arrow if it's a high quality advert. You can un-upvote by clicking the up arrow again. If the advert is spam or distasteful, you can downvote it. A confirmation screen pops up warning you that this will delete the advert from your ship. After downvoting an advert, your ship will stop propagating info related to this advert such as votes and steps of the review flow.

You can click the "Message Vendor" button from ~nec to open the %talk app and chat with the vendor (eg ~zod).

You can click the "Express Intent" button from ~nec to signal your willingness to transact according to this advert. After clicking this button, your intention will be sent to ~zod.

*Client Tip: Do not start transacting after expressing intent. You will not be able to review until the vendor commits to the transaction.*

If, after chatting, ~zod agrees to transact with ~nec, ~zod can click "Commit" to commit to the transaction. At this point, either party is free to leave a review and both parties should proceed to uphold their end of the transaction.

After transacting, both parties should click "Review" on the associated commitment to create a review. Fill out the review form and click "Submit". This review will be broadcast to all pals-of-pals and be displayed below the associated advert.

All reviews of the vendor from other adverts will also be displayed on the advert page (below the reviews specifically regarding this advert). So if a vendor gets negative reviews and then deletes that advert, these negative reviews will still be displayed on other adverts created by the same vendor.

Navigation tips:
- All ship names are clickable links that will take you to that ship's profile. Your profile is accessible by clicking on your sigil in the top right. A ship's profile will display all of their open adverts, the reviews this ship has created, and the reviews of this ship created by other ships.
- All advert hashes are clickable links that will take you to that advert page.

Now you're up and running, have fun buying and selling stuff with your pals-of-pals!

For a step-by-step walkthrough of all bizbaz features, check out the tutorial in the next section.

## Tutorial

This tutorial is designed to be followed along from two local fake ships. Follow the instructions in the next section to install bizbaz on two fake ships before proceeding. We'll refer to these two ships as ~zod and ~nec.

From ~zod:
- create three adverts with titles like "good advert", "bad advert", and "ugly advert" by clicking the "+" button in the bottom right corner and submitting the advert creation form.
- click the good advert card and make it even better by hovering over the button in the bottom right and clicking "Edit"
- return to the home page by clicking the home icon in the top left
- open the ugly advert and delete it by hovering over the button in the bottom right and clicking "Delete".

From ~nec:
- the home page should display the (updated) good advert and the bad advert created by ~zod.
- open the bad advert and upvote it by clicking the up arrow, unvote by clicking the up arrow again, and downvote by clicking the down arrow. Note that after downvoting, it's deleted from ~nec but is still present on ~zod (with a score of -1)
- return home and click the good advert card.
- click "Message Vendor" to open the talk app and send a message to ~zod asking for more details.
- click "Express Intent" on the good advert page to move forward with the transaction.

From ~zod:
- open the talk app to respond to the message from ~nec then click "Commit" on the good advert's intent card once you're ready.
- at this point, both parties would uphold their end of the agreed upon transaction
- click "Review" on the commit card and thank ~nec for being such a great client.

From ~nec:
- click "Review" on the good advert's commit card and chastise ~zod for being a bad vendor.
- check out ~zod's review, feel guilty, click the "pencil" icon on ~nec's review and update your review of ~zod to be slightly nicer.
- click ~zod's name in the review or advert details to explore ~zod's profile including all of ~zod's adverts, reviews of ~zod, and reviews by ~zod.
- click an advert hash in one of the reviews on ~zod's profile to view that advert page.

## Local Installation

To experiment with a local copy of bizbaz, start by cloning this repo and `cd`ing into it.

Make sure you have [`just`](https://github.com/casey/just) installed or check the `justfile` and run the relevant commands manually.

Also, make sure you have either an `urbit` runtime ([`vere`](https://github.com/urbit/vere)) or `docker` installed if you want to run this app locally.

You can start up a fresh ~zod ship by running urbit directly, but this repo includes a start script with a few convenience features:
- `me@bizbaz$ just start` or `me@bizbaz$ just start <fake-ship-name>` (this will take a few mins the first time you do it. *NOTE* if no ship name is specified it defaults to start ~zod)
- `~zod:dojo> |exit` or hit `ctrl-d` (the start-fake-ship script will preserve a copy of the freshly booted ship so you can quickly reset if something breaks)
- `me@bizbaz$ just start` (this will use `sudo` to reset permissions and copy over the fresh ship's data, it should boot up instantly)

Create and mount new desks for both bizbaz and pals:
- `~zod:dojo> |new-desk %pals`
- `~zod:dojo> |mount %pals`
- `~zod:dojo> |new-desk %bizbaz`
- `~zod:dojo> |mount %bizbaz`

Open a 2nd terminal to run extra shell commands while the fake ship stays up in the 1st. Then, copy our files into your zod desks:
- `me@bizbaz$ just sync-lib zod pals`
- `me@bizbaz$ just sync-app zod`

Commit and install both pals and bizbaz. Make sure you install pals before you install bizbaz.
- `~zod:dojo> |commit %pals`
- `~zod:dojo> |install our %pals`
- `~zod:dojo> |commit %bizbaz`
- `~zod:dojo> |install our %bizbaz`
- `~zod:dojo> +code`

Visit http://localhost:8080 (confirm this link from the startup logs, sometimes urbit on mac uses an unusual port by default), login with the code printed to the console, and click the bizbaz tile to get started.

Follow the same instructions for additional ships (eg `~nec` and `~bud`) to test out interactions between ships. Don't forget to add these other ships as pals so bizbaz can communicate with them.

If you've added a new pal after installing bizbaz and the data doesn't seem to be syncing (or if an error occurs and a subscription breaks), click the refresh button in the top right corner to re-subscribe and re-broadcast this ship's data to all pals.

## Development

Run `just symlink zod` to link the `./desk` dir into `./data/zod/bizbaz` so that you can make changes to `./desk` and then `|commit` without needing to re-copy files over every time you edit a file.

Run `just start-ui` to start a vite development server. It will also install `node_modules` and add a `.env.local` file (ignored by git) to the `ui` subdirectory telling vite to look for an urbit server on port 8080. The vite development server will proxy all requests to the ship except for those powering the interface, allowing you to see live data.

If you have `nix` installed, run `nix develop` (or `direnv allow` if you're using direnv) then `just code` to start up an editor pre-configured with hoon, bash, and typescript syntax highlights (plus vim-mode).

## Deploying

Note: the dev server runs on port 3000 but, while deploying, we'll be talking directly to the local urbit server (usually at port 8080).

### Once per development env: Setting up the %globber desk 

We'll use this local %globber desk to create UI globs on our dev computer.

- `me@bizbaz$ just start` (if you don't already have a ~zod running)
- `~zod:dojo> |merge %globber our %base` to create a new globber desk from a fork of the built-in base desk, libs from the base desk are required to make globs
- `~zod:dojo> |mount %globber` to make our globber desk accessible from the host filesystem

### Build a deployable glob

- `me@bizbaz$ just build-ui` to install ui deps & build a prod bundle in `ui/dist`. This helper-command will auto-patch `type="module"` into the generated `index.html` script tags and `rsync` it into the %globber desk under a `bizbaz` sub directory.
- `~zod:dojo> |commit %globber` you should see a few newly built ui files logged in dojo
- `~zod:dojo> -landscape!make-glob %globber /bizbaz` this will compile all our files from the bizbaz dir of the globber desk into one glob file & export it to the host filesystem in `data/zod/.urb/put/`. The file name looks like `glob-0v5.fdf99.nph65.qecq3.ncpjn.q13mb.glob` where the characters between `glob-` and `.glob` are a hash of the glob's contents. Note this hash, you'll need it later.

### One-time per production env: setting up the %bizbaz desk 

Open the dojo of your production server and setup a new %bizbaz desk:

- `~sampel-palnet:dojo> |new-desk %bizbaz` to create the desk we'll use in production
- `~sampel-palnet:dojo> |mount %bizbaz` to make the prod desk available for modification via the host filesystem

You'll need to get this bizbaz code onto the same computer you use to host your urbit. One nice way to do this is to setup a remote git repo and push.

```
ssh myserver 'mkdir bizbaz && cd bizbaz && git init`
git remote add myserver ssh://myserver:/home/admin/bizbaz/
git push myserver main
ssh myserver 'cd bizbaz && git checkout --force main' # necessary bc just pushing doesn't update the working copy of the dir
```

### To deploy new glob to production

First, upload our glob to some internet-accessible storage like AWS S3 or ipfs. If your env includes a `$BLOG_URL` env var which points to a server that supports [POST requests to an ipfs node](https://github.com/bohendo/bloggit/blob/main/modules/server/src/ipfs/index.ts#L56-L68), you can run `just publish` and that will retrieve the newest glob file from `data/zod/.urb/put` and upload it to IPFS. Regardless of where you host it, note the url from which your glob will be accessible.

Then, edit the `desk/desk.docket-o` file. If, for example, your glob file is `glob-0v6.mj5re.5lvhd.qqkiq.5bplt.p35u4.glob` and it can be fetched from the url `https://bohendo.com/ipfs/QmWV7peZZPFH2rpaxeR7c2bAVNSkjniRQSidUJs8DSs18S`, then edit the `glob-http` entry of the docket file so it reads:
```
    glob-http+['https://bohendo.com/ipfs/QmWV7peZZPFH2rpaxeR7c2bAVNSkjniRQSidUJs8DSs18S' 0v6.mj5re.5lvhd.qqkiq.5bplt.p35u4]
```
Make sure you don't lose any single quotes `'` or brackets `]` while copy/pasting the new data in.

Commit your changes once you're all set and push the new code to production:

```
git commit -m "prep for prod"
git push myserver main
ssh myserver 'cd bizbaz && git checkout --force main'
```

Next, we'll `ssh myserver` and finish up, assuming you have an urbit pier at `~/sampel-palnet`

- `admin@myserver$ rm -rf sampel-palnet/bizbaz/*` remove old copy of the bizbaz code, if present
- `admin@myserver$ cp -f bizbaz/desk/* sampel-palnet/bizbaz/` copy our updated code into our urbit ship
- `~sampel-palnet:dojo> |commit %bizbaz`
- `~sampel-palnet:dojo> |install our %bizbaz`

Done. Now, visit your server's urbit endpoint and explore your newly installed %bizbaz

Check out these [other docs](https://developers.urbit.org/guides/core/app-school-full-stack/8-desk) if the above doesn't work..
