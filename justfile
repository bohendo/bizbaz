
sync:
  rm -rf data/zod/bizbaz
  cp -rf zod/bizbaz data/zod/bizbaz

sync-lib dir: 
  rm -rf data/zod/{{dir}}
  cp -rf libs/{{dir}} data/zod/{{dir}}

start:
  bash start-fake-ship.sh
