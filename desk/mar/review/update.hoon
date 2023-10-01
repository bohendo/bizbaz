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
      :~  ['hash' s+(scot %uv hash.rev)]
          ['reviewer' s+(scot %p reviewee.rev)]
          ['sig' s+(scot %uv sig.rev)]
          ['when' (sect when.rev)]
          ['body' o+(
            ['reviewee' s+(scot %p reviewee.body.rev)]
            ['score' n+score.body.rev]
            ['why' s+why.body.rev]
          )]
          ['commit' o+(
            ['advert' s+(scot %uv advert.commit.rev)]
            ['vendor' s+(scot %p vendor.commit.rev)]
            ['vendor-sig' s+(scot %uv vendor-sig.commit.rev)]
            ['client' s+(scot %p client.commit.rev)]
            ['client-sig' s+(scot %uv client-sig.commit.rev)]
            ['when' (sect when.commit.rev)]
          )]
      ==
    ==
  --
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--
