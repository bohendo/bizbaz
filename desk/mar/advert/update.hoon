/-  *advert
/+  signatures
|_  upd=update
++  grow
  |%
  ++  noun  upd
  ++  json
    =,  enjs:format
    ^-  ^json
    ?-    -.upd
        %create  !!
        %update  !!
        %delete  !!
        %gather
      %+  frond  'adverts'
      :-  %a
      %+  turn  adverts.upd
      |=  adv=advert
      %-  pairs
      :~  ['hash' s+(scot %uv hash.adv)]
          ['vendor' (to-json:signatures vendor.adv)]
          :-  'body'
          %-  pairs
          :~  ['title' s+title.adv]
              ['cover' s+cover.adv]
              ['tags' a+(turn (turn tags.adv trip) tape)]
              ['description' s+description.adv] :: TODO: change to wall
              ['when' (sect when.adv)]
          ==
      ==
    ==
  --
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--
