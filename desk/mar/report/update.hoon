/-  *report
|_  upd=update
++  grow
  |%
  ++  noun  upd
  ++  json
    =,  enjs:format
    ^-  ^json
    ?+    -.upd  !!
        %gather
      %+  frond  'reports'
      :-  %a
      ?~  reports.upd  ~
      %+  turn  reports.upd
      |=  rep=report
      %-  pairs
      :~ 
        ['hash' s+(scot %uv hash.rep)]
        :-  'sig'
        %-  pairs
        :~  ['sig' s+(scot %uv sig.sig.rep)]
            ['ship' s+(scot %p ship.sig.rep)]
            ['life' s+(scot %ud life.sig.rep)]
        ==
        :-  'body'
        %-  pairs
        :~  ['advert' s+(scot %uv advert.body.rep)]
            ['target' s+(scot %p target.body.rep)]
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

