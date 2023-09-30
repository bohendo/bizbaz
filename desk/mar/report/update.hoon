/-  *report
|_  upd=update
++  grow
  |%
  ++  noun  upd
  ++  json
    =,  enjs:format
    ^-  ^json
    ?+    -.upd  !!
        %init
      %+  frond  'report'
      :-  %a
      ?~  report.upd  ~
      %+  turn  report.upd
      |=  rev=report
      %-  pairs
      :~  ['target' s+(scot %p target.rev)]
          ['tattle' s+(scot %p tattle.rev)]
          ['advert-id' s+advert-id.rev]
      ==
    ==
  --
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--

