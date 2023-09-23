
sync:
  rm -rf data/zod/bizbaz
  cp -rf desk data/zod/bizbaz

sync-lib dir: 
  rm -rf data/zod/{{dir}}
  cp -rf {{dir}} data/zod/{{dir}}
