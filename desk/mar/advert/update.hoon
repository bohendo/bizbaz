/-  *advert
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
      :-  %a
      %+  turn  adverts.upd
      |=  adv=advert
      %-  pairs
      :~  ['hash' s+(scot %uv hash.adv)]
          ['when' (sect when.adv)]
          ['title' s+title.body.adv]
          ['cover' s+cover.body.adv]
          ['tags' a+(turn (turn tags.body.adv trip) tape)]
          ['description' s+description.body.adv] :: TODO: change to wall
          :-  'sig'
            %-  pairs
              :~  ['sig' s+(scot %p ship.sig.adv)]
                  ['ship' s+(scot %p ship.sig.adv)]
                  ['life' s+(scot %p life.sig.adv)]
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
