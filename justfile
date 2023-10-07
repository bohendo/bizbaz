
start:
  bash start-fake-ship.sh

start-ui:
  cd ui && npm run dev

sync-app ship: 
  rm -rf {{ship}}/bizbaz
  cp -rf desk {{ship}}/bizbaz

sync-lib ship dir: 
  rm -rf data/{{ship}}/{{dir}}
  cp -rf libs/{{dir}} data/{{ship}}/{{dir}}

symlink ship:
  rm -rf {{ship}}/bizbaz
  ln -s $(pwd)/desk {{ship}}/bizbaz

unsymlink ship:
  rm -rf {{ship}}/bizbaz

bind ship:
  mkdir -p ./data/{{ship}}/bizbaz
  sudo mount --bind $(pwd)/desk $(pwd)/data/{{ship}}/bizbaz

unbind ship:
  sudo umount $(pwd)/data/{{ship}}/bizbaz

code:
  codium .
