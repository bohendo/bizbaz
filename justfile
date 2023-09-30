
sync-lib dir: 
  rm -rf data/zod/{{dir}}
  cp -rf libs/{{dir}} data/zod/{{dir}}

start:
  bash start-fake-ship.sh

bind-zod:
  mkdir -p ./zod/bizbaz
  sudo mount --bind $(pwd)/desk $(pwd)/zod/bizbaz

unbind-zod:
  sudo umount $(pwd)/zod/bizbaz

bind-data-zod:
  mkdir -p ./data/zod/bizbaz
  sudo mount --bind $(pwd)/desk $(pwd)/data/zod/bizbaz

unbind-data-zod:
  sudo umount $(pwd)/data/zod/bizbaz

code:
  codium .
