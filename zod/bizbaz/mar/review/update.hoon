/-  *review
|_  upd=update
++  grow
  |%
  ++  noun  upd
  ++  json
    =,  enjs:format
    ^-  ^json
    ~&  upd
    ~&  -.upd
    ~&  reviews.upd
    ?+    -.upd  !!
        %init
      =/  reviews  +.upd
      %+  frond  'review'
      :-  %a
      %+  turn  reviews
      |=  rev=review
      %-  pairs
      :~  ['reviewee' s+(scot %p reviewee.rev)]
          ['reviewer' s+(scot %p reviewer.rev)]
          ['what' s+what.rev]
          ['when' (sect when.rev)]
      ==
    ==
  --
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--
