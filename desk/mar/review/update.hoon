/-  *review
|_  upd=update
++  grow
  |%
  ++  noun  upd
  ++  json
    =,  enjs:format
    ^-  ^json
    ?+    -.upd  !!
        %gather
      %+  frond  'review'
      :-  %a
      ?~  reviews.upd  ~
      %+  turn  reviews.upd
      |=  rev=review
      %-  pairs
      :: ^-  (list [@t json])
      :~  ['hash' s+(scot %uv hash.rev)]
          :: ['reviewer' s+(scot %p reviewee.rev)]
          ['sig' s+(scot %uv sig.sig.rev)]
          ['when' (sect when.rev)]
          :-  'body'  %-  pairs
                          :~ 
                            ['reviewee' s+(scot %p reviewee.body.rev)]
                            ['score' n+(scot %ud score.body.rev)]
                            ['why' s+why.body.rev]
                          ==    
          :-  'commit'  %-  pairs 
                          :~ 
                            ['advert' s+(scot %uv advert.commit.rev)]
                            :: ['vendor' s+(scot %p vendor.commit.rev)]
                            ['vendor-sig' s+(scot %uv sig.vendor-sig.commit.rev)]
                            :: ['client' s+(scot %p client.commit.rev)]
                            ['client-sig' s+(scot %uv sig.client-sig.commit.rev)]
                            ['when' (sect when.commit.rev)]
                          ==
      ==
      ::
      ::   :-  'commits'
      ::   :-  %a
      ::   ?~  commits.upd  ~
      ::   %+  turn  commits.upd
      ::   |=  cmt=commit
      ::   %-  pairs
      ::   :~  ['advert' s+(scot %uv advert.commit.rev)]
      ::       ['vendor-sig' o+(
      ::         ['sig' s+(scot %uv sig.vendor-sig.commit.rev)]
      ::         ['ship' s+(scot %p ship.vendor-sig.commit.rev)]
      ::         ['life' s+(scot %ud life.vendor-sig.commit.rev)]
      ::       )]
      ::       ['client-sig' o+(
      ::         ['sig' s+(scot %uv sig.client-sig.commit.rev)]
      ::         ['ship' s+(scot %p ship.client-sig.commit.rev)]
      ::         ['life' s+(scot %ud life.client-sig.commit.rev)]
      ::       )]
      ::       ['when' (sect when.cmt)]
      ::   ==
      :: ==
    ==
  --
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--
