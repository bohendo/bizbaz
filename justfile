
start:
  bash start-fake-ship.sh

start-ui:
  cd ui && npm run dev

install:
  cd ui && npm install

build-ui:
  cd ui && npm run build
  cp ui/dist/index.html ui/dist/index.html.backup
  sed 's/<script src=/<script type="module" src=/' ui/dist/index.html.backup > ui/dist/index.html
  rm ui/dist/index.html.backup

sync-app ship: 
  rm -rf {{ship}}/bizbaz
  cp -rf desk {{ship}}/bizbaz

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
