/-  *review
/+  signatures
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
            ['client' (to-json:signatures client.int)]
            :-  'body'
            %-  pairs
            :~  ['advert' s+(scot %uv advert.body.int)]
                ['vendor' (to-json:signatures vendor.body.int)]
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
            ['vendor' (to-json:signatures vendor.cmt)]
            :-  'body'
            %-  pairs
            :~  ['intent' s+(scot %uv intent.body.cmt)]
                ['client' (to-json:signatures client.body.cmt)]
                ['when' (sect when.body.cmt)]
            ==
            :-  'intent'
            %-  pairs
            :~  ['advert' s+(scot %uv advert.intent.cmt)]
                ['vendor' (to-json:signatures vendor.intent.cmt)]
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
            ['reviewer' (to-json:signatures reviewer.rev)]
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
                ['vendor' (to-json:signatures vendor.commit.rev)]
                :-  'body'
                %-  pairs
                :~  ['intent' s+(scot %uv intent.body.commit.rev)]
                    ['client' (to-json:signatures client.body.commit.rev)]
                    ['when' (sect when.body.commit.rev)]
                ==
                :-  'intent'
                %-  pairs
                :~  ['advert' s+(scot %uv advert.intent.commit.rev)]
                    ['vendor' (to-json:signatures vendor.intent.commit.rev)]
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
