/-  *advert
|_  upd=update
++  grow
  |%
  ++  noun  upd
  ++  json
    =,  enjs:format
    ^-  ^json
    ?-    -.upd
        %create
      %+  frond  'advert'
      %-  pairs
      :~  ['who' s+(scot %p who.advert.upd)]
          ['when' (sect when.advert.upd)]
          ['tags' a+(turn (turn tags.advert.upd trip) tape)]
          ['description' s+description.advert.upd] :: TODO: change to wall
      ==
    ::
        %init
      %+  frond  'adverts'
      :-  %a
      %+  turn  adverts.upd
      |=  adv=advert
      %-  pairs
      :~  ['who' s+(scot %p who.adv)]
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
