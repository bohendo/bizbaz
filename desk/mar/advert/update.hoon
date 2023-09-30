/-  *advert
|_  upd=update
++  grow
  |%
  ++  noun  upd
  ++  json
    =,  enjs:format
    ^-  ^json
    ?-    -.upd
        %gather
      :-  %a
      %+  turn  adverts.upd
      |=  adv=advert
      %-  pairs
      :~  ['id' s+(scot %uv id.adv)]
          ['who' s+(scot %p who.adv)]
          ['when' (sect when.adv)]
          ['tags' a+(turn (turn tags.adv trip) tape)]
          ['description' s+description.adv] :: TODO: change to wall
      ==
    ==
  --
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--
