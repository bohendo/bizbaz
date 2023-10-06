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
    :~  [%intent (ot ~[advert+(se %uv)])]
        [%commit (ot ~[intent+(se %uv)])]
        [%review (ot ~[body+(ot ~[commit+(se %uv) reviewee+(se %p) score+ni why+so when+du])])]
        [%update (ot ~[hash+(se %uv) body+(ot ~[commit+(se %uv) reviewee+(se %p) score+ni why+so when+du])])]
    ==
  --
++  grad  %noun
--
