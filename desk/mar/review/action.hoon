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
    :~  [%commit (ot ~[advert+(se %uv)])]
        [%review (ot ~[advert+(se %uv) body+(ot ~[reviewee+(se %p) score+ni why+so])])]
        [%update (ot ~[hash+(se %uv) reviewee+(se %p) score+ni why+so])]
    ==
  --
++  grad  %noun
--
