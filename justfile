
sync: 
  rm -rf zod/bizbaz
  cp -rf desk zod/bizbaz

sync-lib dir: 
  rm -rf data/zod/{{dir}}
  cp -rf libs/{{dir}} data/zod/{{dir}}

start:
  bash start-fake-ship.sh

bind-zod:
  rm -rf zod/bizbaz
  ln -s $(pwd)/desk zod/bizbaz

unbind-zod:
  rm -rf zod/data

bind-data-zod:
  mkdir -p ./data/zod/bizbaz
  sudo mount --bind $(pwd)/desk $(pwd)/data/zod/bizbaz

unbind-data-zod:
  sudo umount $(pwd)/data/zod/bizbaz

code:
  codium .
