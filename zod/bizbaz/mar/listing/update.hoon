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
          ['tags' (tank tags.listing.upd)]
          ['description' (tape description.listing.upd)] :: TODO: change to wall
      ==
    ::
        %delete
      %+  frond  'delete'
      %+  frond  'listing'
      %-  pairs
      :~  ['who' s+(scot %p who.listing.upd)]
          ['when' (sect when.listing.upd)]
          ['tags' (tank tags.listing.upd)]
          ['description' (tape description.listing.upd)] :: TODO: change to wall
      ==
    ::
        %spread
      %+  frond  'spread'
      %+  frond  'listing'
      %-  pairs
      :~  ['who' s+(scot %p who.listing.upd)]
          ['when' (sect when.listing.upd)]
          ['tags' (tank tags.listing.upd)]
          ['description' (tape description.listing.upd)] :: TODO: change to wall
      ==
    ::
        %init
      %+  frond  'init'
      %+  frond  'listings'
      %-  turn
      %-  pairs
      :~  ['who' s+(scot %p who.listing.upd)]
          ['when' (sect when.listing.upd)]
          ['tags' (tank tags.listing.upd)]
          ['description' (tape description.listing.upd)] :: TODO: change to wall
      ==
    ==
  --
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--
