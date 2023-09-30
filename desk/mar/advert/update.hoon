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
      :~  ['digest' s+(scot %uv digest.adv)]
          ['vendor' s+(scot %p vendor.adv)]
          ['sig' s+(scot %uv vendor-sig.adv)]
          ['when' (sect when.adv)]
          ['title' s+title.adv]
          ['cover' s+cover.adv]
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
