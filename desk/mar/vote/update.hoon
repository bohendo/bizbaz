/-  *vote
|_  upd=update
++  grow
  |%
  ++  noun  upd
  ++  json
    =,  enjs:format
    ^-  ^json
    ?+    -.upd  !!
        %gather
      %+  frond  'votes'
      :-  %a
      ?~  votes.upd  ~
      %+  turn  votes.upd
      |=  =vote
      %-  pairs
      :~ 
        ['hash' s+(scot %uv hash.vote)]
        :-  'sig'
        %-  pairs
        :~  ['sig' s+(scot %uv sig.sig.vote)]
            ['ship' s+(scot %p ship.sig.vote)]
            ['life' s+(scot %ud life.sig.vote)]
        ==
        :-  'body'
        %-  pairs
        :~  ['advert' s+(scot %uv advert.body.vote)]
            ['vendor' s+(scot %p vendor.body.vote)]
            ['when' (sect when.body.vote)]
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

