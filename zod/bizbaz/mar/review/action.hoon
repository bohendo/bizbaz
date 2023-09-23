/-  *review
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
    :~  [%post-review (ot ~[review+(ot ~[reviewee+(se %p) reviewer+(se %p) what+so when+du])])]
    ==
  --
++  grad  %noun
--