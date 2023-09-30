/-  *review
|_  upd=update
++  grow
  |%
  ++  noun  upd
  ++  json
    =,  enjs:format
    ^-  ^json
    ?+    -.upd  !!
        %init
      %+  frond  'review'
      :-  %a
      ?~  reviews.upd  ~
      %+  turn  reviews.upd
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
