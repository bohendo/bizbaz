/-  *listing
|_  upd=update
++  grow
  |%
  ++  noun  upd
  ++  json
    =,  enjs:format
    ^-  ^json
    ?-    -.upd
        %create
      %+  frond  'listing'
      %-  pairs
      :~  ['who' s+(scot %p who.listing.upd)]
          ['when' (sect when.listing.upd)]
          ['tags' a+(turn (turn tags.listing.upd trip) tape)]
          ['description' s+description.listing.upd] :: TODO: change to wall
      ==
    ::
        %delete
      %+  frond  'listing'
      %-  pairs
      :~  ['who' s+(scot %p who.listing.upd)]
          ['when' (sect when.listing.upd)]
          ['tags' a+(turn (turn tags.listing.upd trip) tape)]
          ['description' s+description.listing.upd] :: TODO: change to wall
      ==
    ::
        %spread
      %+  frond  'listing'
      %-  pairs
      :~  ['who' s+(scot %p who.listing.upd)]
          ['when' (sect when.listing.upd)]
          ['tags' a+(turn (turn tags.listing.upd trip) tape)]
          ['description' s+description.listing.upd] :: TODO: change to wall
      ==
    ::
        %init
      %+  frond  'listings'
      :-  %a
      %+  turn  listings.upd
      |=  lis=listing
      %-  pairs
      :~  ['who' s+(scot %p who.lis)]
          ['when' (sect when.lis)]
          ['tags' a+(turn (turn tags.lis trip) tape)]
          ['description' s+description.lis] :: TODO: change to wall
      ==
    ==
  --
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--
