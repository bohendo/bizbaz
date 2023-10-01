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
    :~  create+(ot ~[title+so cover+so tags+(ar (se %tas)) description+so])
        delete+(ot ~[hash+(se %uvH)])
        update+(ot ~[hash+(se %uvH) title+so cover+so tags+(ar (se %tas)) description+so])
    ==
  --
++  grad  %noun
--
