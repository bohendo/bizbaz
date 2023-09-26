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
      %+  frond  'create'
      %+  frond  'listing'
      %-  pairs
      :~  ['who' s+(scot %p who.listing.upd)]
          ['when' (sect when.listing.upd)]
          ['tags' a+(turn (turn tags.listing.upd trip) tape)]
          ['description' (cord description.listing.upd)] :: TODO: change to wall
      ==
    ::
        %delete
      %+  frond  'delete'
      %+  frond  'listing'
      %-  pairs
      :~  ['who' s+(scot %p who.listing.upd)]
          ['when' (sect when.listing.upd)]
          ['tags' a+(turn (turn tags.listing.upd trip) tape)]
          ['description' (tape description.listing.upd)] :: TODO: change to wall
      ==
    ::
        %spread
      %+  frond  'spread'
      %+  frond  'listing'
      %-  pairs
      :~  ['who' s+(scot %p who.listing.upd)]
          ['when' (sect when.listing.upd)]
          ['tags' a+(turn (turn tags.listing.upd trip) tape)]
          ['description' (tape description.listing.upd)] :: TODO: change to wall
      ==
    ::
        %init
      %+  frond  'init'
      %+  frond  'listings'  a+(turn listings.upd |=(lis=listing (tape description.lis)))
      :: :-  %a
      :: %-  turn  listings.upd
      :: |=  lis=listing
      :: %-  pairs
      :: :~  ['who' s+(scot %p who.lis)]
      ::     ['when' (sect when.lis)]
      ::     ['tags' a+(turn tags.lis tape)]
      ::     ['description' (tape description.lis)] :: TODO: change to wall
      :: ==
    ==
  --
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--
