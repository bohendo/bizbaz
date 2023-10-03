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
      %-  pairs
      :~
        :-  'commits'
        :-  %a
        ?~  commits.upd  ~
        %+  turn  commits.upd
        |=  cmt=commit
        %-  pairs
        :~  ['advert' s+(scot %uv advert.cmt)]
            ['when' (sect when.cmt)]
            :-  'vendor-sig'
            %-  pairs
            :~  ['sig' s+(scot %uv sig.vendor-sig.cmt)]
                ['ship' s+(scot %p ship.vendor-sig.cmt)]
                ['life' s+(scot %ud life.vendor-sig.cmt)]
            ==
            :-  'client-sig'
            %-  pairs
            :~  ['sig' s+(scot %uv sig.client-sig.cmt)]
                ['ship' s+(scot %p ship.client-sig.cmt)]
                ['life' s+(scot %ud life.client-sig.cmt)]
            ==
        ==
        :-  'reviews'
        :-  %a
        ?~  reviews.upd  ~
        %+  turn  reviews.upd
        |=  rev=review
        %-  pairs
        :~  ['hash' s+(scot %uv hash.rev)]
            :-  'sig'
            %-  pairs
            :~  ['sig' s+(scot %uv sig.sig.rev)]
                ['ship' s+(scot %p ship.sig.rev)]
                ['life' s+(scot %ud life.sig.rev)]
            ==
            ['when' (sect when.rev)]
            :-  'body'
            %-  pairs
            :~  ['reviewee' s+(scot %p reviewee.body.rev)]
                ['score' (numb score.body.rev)]
                ['why' s+why.body.rev]
            ==
            :-  'commit'
            %-  pairs
            :~  ['advert' s+(scot %uv advert.commit.rev)]
                ['when' (sect when.commit.rev)]
                :-  'vendor-sig'
                %-  pairs
                :~  ['sig' s+(scot %uv sig.vendor-sig.commit.rev)]
                    ['ship' s+(scot %p ship.vendor-sig.commit.rev)]
                    ['life' s+(scot %ud life.vendor-sig.commit.rev)]
                ==
                :-  'client-sig'
                %-  pairs
                :~  ['sig' s+(scot %uv sig.client-sig.commit.rev)]
                    ['ship' s+(scot %p ship.client-sig.commit.rev)]
                    ['life' s+(scot %ud life.client-sig.commit.rev)]
                ==
            ==
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
