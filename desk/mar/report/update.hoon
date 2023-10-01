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
      %+  frond  'report'
      :-  %a
      ?~  report.upd  ~
      %+  turn  report.upd
      |=  rep=report
      %-  pairs
      :~  ['hash' s+(scot %uv hash.rep)]
          ['tattle' s+(scot %p target.rep)]
          ['sig' s+(scot %uv sig.rep)]
          ['advert' s+(scot %p advert.rep)]
          ['target' s+(scot %p target.rep)]
      ==
    ==
  --
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--

