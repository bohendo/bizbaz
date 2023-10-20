# %bizbaz

**The Bizarre Bazaar**

Buy & sell stuff with pals-of-pals

### Live Installation

Use the following app link to install bizbaz on the live urbit network:

`<coming soon>`

### Local Installation

To experiment with a local copy of bizbaz, start by cloning this repo and `cd`ing into it.

Make sure you have [`just`](https://github.com/casey/just) installed or check the `justfile` and run the relevant commands manually.

Also, make sure you have either an `urbit` runtime ([`vere`](https://github.com/urbit/vere)) or `docker` installed if you want to run this app locally.

You can start up a fresh zod ship by running urbit directly, but this repo includes a start script with a few convenience features:
- `me@bizbaz$ just start` (this will take a few mins the first time you do it)
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

### Development

Run `just symlink zod` to link the `./desk` dir into `./data/zod/bizbaz` so that you can make changes to `./desk` and then `|commit` without needing to re-copy files over every time you edit a file.

Run `just start-ui` to start a vite development server. It will also install `node_modules` and add a `.env.local` file (ignored by git) to the `ui` subdirectory telling vite to look for an urbit server on port 8080. The vite development server will proxy all requests to the ship except for those powering the interface, allowing you to see live data.

### Deploying

Note: the dev server runs on port 3000 but, while deploying, we'll be talking directly to the local urbit server (at port 8080 by default).

### One-time per development env: Setting up a development desk

- bash: `bash start-fake-ship.sh` to create or launch a fake urbit ship, keep this terminal open & use it to enter all dojo commands
- dojo: `+code` to generate an access code, visit `http://localhost:8080` and enter this code to login.
- dojo: `|merge %globber our %base` to create a new globber desk from a fork of the built-in base desk
- dojo: `|mount %globber` to make our globber desk accessible from the host filesystem at `data/zod/globber` where `data/zod` is the fake urbit's pier.

### Build a deployable glob

- bash: `(cd ui && npm install && npm run build)` to install ui deps & build a prod bundle in `ui/dist` (from a 2nd terminal tab bc first one should still have dojo open)
- bash: `rsync -avL --delete ui/dist/ data/zod/globber/bizbaz` to copy prod js bundle into the urbit globber desk. Note the trailing slashes, they're important.
- dojo: `|commit %globber` to import filesystem changes into urbit, you should see new files logged in dojo
- dojo: `=dir /=garden=` to change to the garden desk, arg to `=dir` (aka `cd`) is a 3-part `beak` (like a `path`) composed of the ship, desk, and revision (`=` for any of these three uses the default value)
- dojo: `-make-glob %globber /bizbaz` to call the `-make-glob` utility function that the garden desk provides, this util groups files from the bizbaz dir of the globber desk into one file & puts that file into the host filesystem at `data/zod/.urb/put/`. The file name looks like `glob-0v5.fdf99.nph65.qecq3.ncpjn.q13mb.glob` where the characters between `glob-` and `.glob` are a hash of the glob's contents.

### One-time per production env: setting up a prod desk

- dojo: `|merge %bizbaz our %garden` to create new production desk, we need to use garden as the base bc it has necessary libs
- dojo: `|mount %bizbaz` to make prod desk available for update via the host fs

### To deploy glob to urbit ship

- dev bash: `bash publish.sh data/zod/.urb/put/glob-0v1.hgamp.m7c2c.bomag.81l5r.d71h6.glob $BLOG_URL/ipfs` to upload the glob to ipfs or upload somewhere else like AWS S3
  - where `$BLOG_URL` can include a username and password eg `https://admin:password@myblog.com`
  - change the glob name to one from your own `zod/.urb/put` dir
- dev bash: `vim desk/desk.docket-0`
  - Both the full URL and the hash of the `glob-http` key should be updated to match the glob we just created
  - That line should look something like this when you're done: `glob-http+['https://myblog.com/ipfs/Qmabc123' 0v5.fdf99.nph65.qecq3.ncpjn.q13mb]`
  - Update info & other stuff if needed
- dev bash: `git commit --all -m "update deployment"` to save the updated deployment info
- dev bash: `ssh://blog:/home/admin/bizbaz/` or similar to push updated deployment info to remote server
- prod bash: `cp -f desk/* data/zod/bizbaz/` to copy our updated docket into the prod desk
- prod dojo: `|commit %bizbaz` to load fs updates into urbit
- prod dojo: `|install our %bizbaz` to activate this desk as an app (only needed once, it'll auto update next time)
- browser: visit your homepage at http://localhost:8080 and explore your newly installed app

[Other docs](https://developers.urbit.org/guides/core/app-school-full-stack/8-desk) to check out if the above doesn't work..

[react]: https://reactjs.org/
[tailwind css]: https://tailwindcss.com/
[vite]: https://vitejs.dev/
