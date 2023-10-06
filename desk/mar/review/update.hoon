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
        ::
        :-  'intents'
        :-  %a
        ?~  intents.upd  ~
        %+  turn  intents.upd
        |=  int=intent
        %-  pairs
        :~  ['hash' s+(scot %uv hash.int)]
            :-  'client'
            %-  pairs
            :~  ['sig' s+(scot %uv sig.client.int)]
                ['ship' s+(scot %p ship.client.int)]
                ['life' s+(scot %ud life.client.int)]
            ==
            :-  'body'
            %-  pairs
            :~  ['advert' s+(scot %uv advert.body.int)]
                :-  'vendor'
                %-  pairs
                :~  ['sig' s+(scot %uv sig.vendor.body.int)]
                    ['ship' s+(scot %p ship.vendor.body.int)]
                    ['life' s+(scot %ud life.vendor.body.int)]
                ==
                ['when' (sect when.body.int)]
            ==
        ==
        ::
        :-  'commits'
        :-  %a
        ?~  commits.upd  ~
        %+  turn  commits.upd
        |=  cmt=commit
        %-  pairs
        :~  ['hash' s+(scot %uv hash.cmt)]
            :-  'vendor'
            %-  pairs
            :~  ['sig' s+(scot %uv sig.vendor.cmt)]
                ['ship' s+(scot %p ship.vendor.cmt)]
                ['life' s+(scot %ud life.vendor.cmt)]
            ==
            :-  'body'
            %-  pairs
            :~  ['intent' s+(scot %uv intent.body.cmt)]
                :-  'client'
                %-  pairs
                :~  ['sig' s+(scot %uv sig.client.body.cmt)]
                    ['ship' s+(scot %p ship.client.body.cmt)]
                    ['life' s+(scot %ud life.client.body.cmt)]
                ==
                ['when' (sect when.body.cmt)]
            ==
            :-  'intent'
            %-  pairs
            :~  ['advert' s+(scot %uv advert.intent.cmt)]
                :-  'vendor'
                %-  pairs
                :~  ['sig' s+(scot %uv sig.vendor.intent.cmt)]
                    ['ship' s+(scot %p ship.vendor.intent.cmt)]
                    ['life' s+(scot %ud life.vendor.intent.cmt)]
                ==
                ['when' (sect when.intent.cmt)]
            ==
        ==
        ::
        :-  'reviews'
        :-  %a
        ?~  reviews.upd  ~
        %+  turn  reviews.upd
        |=  rev=review
        %-  pairs
        :~  ['hash' s+(scot %uv hash.rev)]
            :-  'reviewer'
            %-  pairs
            :~  ['sig' s+(scot %uv sig.reviewer.rev)]
                ['ship' s+(scot %p ship.reviewer.rev)]
                ['life' s+(scot %ud life.reviewer.rev)]
            ==
            :-  'body'
            %-  pairs
            :~  ['commit' s+(scot %uv commit.body.rev)]
                ['reviewee' s+(scot %p reviewee.body.rev)]
                ['score' (numb score.body.rev)]
                ['why' s+why.body.rev]
                ['when' (sect when.body.rev)]
            ==
            :-  'commit'
            %-  pairs
            :~  ['hash' s+(scot %uv hash.commit.rev)]
                :-  'vendor'
                %-  pairs
                :~  ['sig' s+(scot %uv sig.vendor.commit.rev)]
                    ['ship' s+(scot %p ship.vendor.commit.rev)]
                    ['life' s+(scot %ud life.vendor.commit.rev)]
                ==
                :-  'body'
                %-  pairs
                :~  ['intent' s+(scot %uv intent.body.commit.rev)]
                    :-  'client'
                    %-  pairs
                    :~  ['sig' s+(scot %uv sig.client.body.commit.rev)]
                        ['ship' s+(scot %p ship.client.body.commit.rev)]
                        ['life' s+(scot %ud life.client.body.commit.rev)]
                    ==
                    ['when' (sect when.body.commit.rev)]
                ==
                :-  'intent'
                %-  pairs
                :~  ['advert' s+(scot %uv advert.intent.commit.rev)]
                    :-  'vendor'
                    %-  pairs
                    :~  ['sig' s+(scot %uv sig.vendor.intent.commit.rev)]
                        ['ship' s+(scot %p ship.vendor.intent.commit.rev)]
                        ['life' s+(scot %ud life.vendor.intent.commit.rev)]
                    ==
                    ['when' (sect when.intent.commit.rev)]
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
