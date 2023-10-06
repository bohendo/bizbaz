/-  *advert
|_  act=action
++  grow
  |%
  ++  noun  act
  --
++  grab
  |%
  ++  noun  action
  ++  json
    =,  dejs:format
    |=  jon=json
    ^-  action
    %.  jon
    %-  of
    :~  create+(ot ~[title+so cover+so tags+(ar (se %tas)) description+so when+du])
        delete+(ot ~[hash+(se %uv)])
        update+(ot ~[hash+(se %uv) title+so cover+so tags+(ar (se %tas)) description+so when+du])
    ==
  --
++  grad  %noun
--
