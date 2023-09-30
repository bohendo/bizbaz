
sync-lib dir: 
  rm -rf data/zod/{{dir}}
  cp -rf libs/{{dir}} data/zod/{{dir}}

start:
  bash start-fake-ship.sh

bind:
  mkdir -p ./zod/bizbaz
  sudo mount --bind $(pwd)/desk $(pwd)/zod/bizbaz

code:
  codium .
