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
    :~  [%create (ot ~[listing+(ot ~[who+(se %p) when+du tags+(as (se %tas)) description+sa])])]
        [%delete (ot ~[listing+(ot ~[who+(se %p) when+du tags+(as (se %tas)) description+sa])])]
        [%spread (ot ~[listing+(ot ~[who+(se %p) when+du tags+(as (se %tas)) description+sa])])]
    ==
  --
++  grad  %noun
--

