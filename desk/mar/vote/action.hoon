/-  *vote
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
    :~  [%upvote (ot ~[advert+(se %uv)])]
        [%downvote (ot ~[hash+(se %uv)])]
        [%unvote (ot ~[hash+(se %uv)])]
    ==
  --
++  grad  %noun
--

