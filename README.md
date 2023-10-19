# %bizbaz

**The Bizarre Bazaar**

Lets you buy & sell goods & services from your pals-of-pals

### Installation

Use the following app link to install bizbaz on the live urbit network:

`<coming soon>`

If you don't see any advertisements, add new pals or create your own
with the `+` button in the bottom right.

### Getting Started

To experiment with a local copy of bizbaz, start up a new fake ship and install bizbaz:
- `me@bizbaz$ bash start-fake-ship.sh zod # or 'just start'`
- `~zod:dojo> |new-desk %bizbaz`
- `~zod:dojo> |mount %bizbaz`
- Open 2nd terminal to run shell commands while the fake ship stays up in the 1st
- `me@bizbaz$ cp -rf desk zod/bizbaz # or 'just sync-app zod'`
- `~zod:dojo> |commit %bizbaz`
- `~zod:dojo> |install our %bizbaz`

To start a dev UI, you first need to add a `.env.local` file to the `ui` directory. This file will not be committed. Adding `VITE_SHIP_URL={URL}` where **{URL}** is the URL of the ship you would like to point to, will allow you to run `npm run dev`. This will proxy all requests to the ship except for those powering the interface, allowing you to see live data.

### Deploying

Note: the dev server runs on port 3000 but, while deploying, we'll be talking directly to the urbit server at port 8080.

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
