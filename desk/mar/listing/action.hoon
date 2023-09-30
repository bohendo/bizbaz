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
    :~  create+(ot ~[new-req+(ot ~[title+so cover+so tags+(ar (se %tas)) description+so])])
        delete+(ot ~[del-req+(ot ~[id+nu])])
        delete+(ot ~[upd-req+(ot ~[id+nu title+so cover+so tags+(ar (se %tas)) description+so])])
    ==
  --
++  grad  %noun
--
