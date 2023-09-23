/-  *listing
|_  upd=update
++  grow
  |%
  ++  noun  upd
  ++  json
    =,  enjs:format
    ^-  ^json
    ?-    -.upd

      %create  %+  frond  'create'
               %+  frond  'listing'
               %-  pairs
               :~  ['who' s+(scot %p target.upd)]
                   ['when' (sect when.upd)]
                   ['tags' (tank tags.upd)]
                   ['description' (tape description.upd)] :: TODO: change to wall
                ==

      %delete  %+  frond  'create'
               %+  frond  'listing'
               %-  pairs
               :~  ['who' s+(scot %p target.upd)]
                   ['when' (sect when.upd)]
                   ['tags' (tank tags.upd)]
                   ['description' (tape description.upd)] :: TODO: change to wall
                ==

      %spread  %+  frond  'create'
               %+  frond  'listing'
               %-  pairs
               :~  ['who' s+(scot %p target.upd)]
                   ['when' (sect when.upd)]
                   ['tags' (tank tags.upd)]
                   ['description' (tape description.upd)] :: TODO: change to wall
                ==

      %init  %+  frond  'create'
             %+  frond  'listings'
             %+  turn
             %-  pairs
             :~  ['who' s+(scot %p target.upd)]
                 ['when' (sect when.upd)]
                 ['tags' (tank tags.upd)]
                 ['description' (tape description.upd)] :: TODO: change to wall
              ==

  --
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--
