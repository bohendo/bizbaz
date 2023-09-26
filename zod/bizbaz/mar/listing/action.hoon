/-  *listing
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
    :~  [%create (ot ~[listing+(ot ~[who+(se %p) tags+(ar (se %tas)) description+so when+du])])]
        [%delete (ot ~[listing+(ot ~[who+(se %p) tags+(ar (se %tas)) description+so when+du])])]
        [%spread (ot ~[listing+(ot ~[who+(se %p) tags+(ar (se %tas)) description+so when+du])])]
    ==
  --
++  grad  %noun
--