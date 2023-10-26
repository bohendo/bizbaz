
start ship="zod":
  bash bin/start-fake-ship.sh {{ship}}

start-comet:
  cd data && urbit -c mycomet

install:
  cd ui && npm install

init-ui: install
  echo 'VITE_SHIP_URL=http://127.0.0.1:8080' > ui/.env.local

start-ui: init-ui
  cd ui && npm run dev

build-ui: install
  cd ui && npm run build
  cp ui/dist/index.html ui/dist/index.html.backup
  sed 's/<script src=/<script type="module" src=/' ui/dist/index.html.backup > ui/dist/index.html
  rm ui/dist/index.html.backup
  if [[ -d data/zod/globber ]]; then rsync -avL --delete ui/dist/ data/zod/globber/bizbaz; fi

publish:
  bash bin/ipfs-upload.sh

sync-app ship="zod": 
  rm -rf data/{{ship}}/bizbaz
  cp -rf desk data/{{ship}}/bizbaz

sync-lib ship="zod" dir="pals": 
  rm -rf data/{{ship}}/{{dir}}
  cp -rf libs/{{dir}} data/{{ship}}/{{dir}}

symlink ship="zod":
  rm -rf data/{{ship}}/bizbaz
  ln -s $(pwd)/desk data/{{ship}}/bizbaz

unsymlink ship="zod":
  rm -rf data/{{ship}}/bizbaz

prod-init server="blog":
  ssh {{server}} 'mkdir bizbaz && cd bizbaz && git init`
  git remote add {{server}} ssh://{{server}}:/home/admin/bizbaz/
  git push {{server}} main
  ssh {{server}} 'cd bizbaz && git checkout --force main'

prod-push server="blog":
  git push {{server}} main
  ssh {{server}} 'cd bizbaz && git checkout --force main'

code:
  codium .
