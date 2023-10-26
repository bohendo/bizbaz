# %bizbaz

**The Bizarre Bazaar**

Buy & sell stuff with pals-of-pals

## Live Installation

Go to `apps/landscape/search/~dibmet-narren/apps` on your urbit ship and install the `bizbaz` app.

## Usage



## Local Installation

To experiment with a local copy of bizbaz, start by cloning this repo and `cd`ing into it.

Make sure you have [`just`](https://github.com/casey/just) installed or check the `justfile` and run the relevant commands manually.

Also, make sure you have either an `urbit` runtime ([`vere`](https://github.com/urbit/vere)) or `docker` installed if you want to run this app locally.

You can start up a fresh zod ship by running urbit directly, but this repo includes a start script with a few convenience features:
- `me@bizbaz$ just start` or `me@bizbaz$ just start <fake-ship-name>` (this will take a few mins the first time you do it. *NOTE* if no ship name is specified it defaults to start zod)
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

Commit and install both pals and bizbaz
- `~zod:dojo> |commit %pals`
- `~zod:dojo> |install our %pals`
- `~zod:dojo> |commit %bizbaz`
- `~zod:dojo> |install our %bizbaz`
- `~zod:dojo> +code`

Visit http://localhost:8080 (confirm this link from the startup logs, sometimes urbit on mac uses an unusual port by default), login with the code printed to the console, and click the bizbaz tile to get started.

Follow the same instructions for additional ships (eg `nec` and `bud`) to test out interactions between ships. Don't forget to add these other ships as pals so bizbaz can communicate with them.

## Development

Run `just symlink zod` to link the `./desk` dir into `./data/zod/bizbaz` so that you can make changes to `./desk` and then `|commit` without needing to re-copy files over every time you edit a file.

Run `just start-ui` to start a vite development server. It will also install `node_modules` and add a `.env.local` file (ignored by git) to the `ui` subdirectory telling vite to look for an urbit server on port 8080. The vite development server will proxy all requests to the ship except for those powering the interface, allowing you to see live data.

If you have `nix` installed, run `nix develop` (or `direnv allow` if you're using direnv) then `just code` to start up an editor pre-configured with hoon, bash, and typescript syntax highlights (plus vim-mode).

## Deploying

Note: the dev server runs on port 3000 but, while deploying, we'll be talking directly to the local urbit server (at port 8080 by default).

### Once per development env: Setting up the %globber desk 

We'll use this local %globber desk to create UI globs on our dev computer.

- `me@bizbaz$ just start` (if you don't already have a zod running)
- `~zod:dojo> |merge %globber our %base` to create a new globber desk from a fork of the built-in base desk
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
