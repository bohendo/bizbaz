
start:
  bash start-fake-ship.sh

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

sync-app ship: 
  rm -rf data/{{ship}}/bizbaz
  cp -rf desk data/{{ship}}/bizbaz

sync-lib ship dir: 
  rm -rf data/{{ship}}/{{dir}}
  cp -rf libs/{{dir}} data/{{ship}}/{{dir}}

symlink ship:
  rm -rf data/{{ship}}/bizbaz
  ln -s $(pwd)/desk data/{{ship}}/bizbaz

unsymlink ship:
  rm -rf data/{{ship}}/bizbaz

bind ship:
  mkdir -p ./data/{{ship}}/bizbaz
  sudo mount --bind $(pwd)/desk $(pwd)/data/{{ship}}/bizbaz

unbind ship:
  sudo umount $(pwd)/data/{{ship}}/bizbaz

code:
  codium .
