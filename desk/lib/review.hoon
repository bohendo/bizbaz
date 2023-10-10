/-  revsur=review 
/-  advert
/+  signatures
|% 
::
:: card that publishes info to all subscribers
++  pub-card
    |=  upd=update:revsur
    ^-  (list card:agent:gall)
    :~  [%give %fact ~[noun-wire] %review-update !>(upd)]
        [%give %fact ~[json-wire] %review-update !>(upd)]
    ==
::
:: card that asks to subscribe to some pal
++  sub-card
    |=  pal=ship
    ^-  card:agent:gall
    [%pass noun-wire %agent [pal %bizbaz] %watch noun-wire]
::
++  noun-wire
    /noun/reviews
::
++  json-wire
    /json/reviews
::
++  intent
  |% 
  ::
  ++  exists
      |=  intents=intents:revsur
      |=  intent=intent:revsur
      ^-  ?
      ?~  ((get-by-hash intents) hash.intent)
        %.n
      %.y
  ++  get-by-hash
      |=  intents=intents:revsur
      |=  hash=hash:signatures
      ^-  (unit @ud)
      %+  find
        ~[hash]
        (turn intents get-hash)
  ::
  ++  get-hash
      |=  intent=intent:revsur
      ^-  hash:signatures
      hash.intent
  ::
  ++  build
      |=  =bowl:gall
      |=  ad=advert:advert
      ^-  intent:revsur
      =/  intent-body
        :*  advert=hash.ad
            vendor=vendor.ad
            client=our.bowl
            when=now.bowl
        ==
      :: set intent hash and sign it
      =/  hash  (sham intent-body)
      =/  new-intent
        :*  hash=hash
            client=(sign:signatures our.bowl now.bowl hash)
            body=intent-body
        ==
      :: crash if our new intent is invalid
      ?>  (validate new-intent)
      new-intent
  ::
  ++  validate
      |=  intent=intent:revsur
      ^-  ?
      =/  true-hash  (sham body.intent)
      ?.  =(hash.intent true-hash)
        %.n
      ?.  (is-signature-valid:signatures [hash.intent ship.client.intent client.intent when.body.intent])
        %.n
      %.y
  ::
  --
++  commit
  |% 
  ::
  ++  exists
      |=  commits=commits:revsur
      |=  commit=commit:revsur
      ^-  ?
      ?~  ((get-by-hash commits) hash.commit)
        %.n
      %.y
  ++  get-by-hash
      |=  commits=commits:revsur
      |=  hash=hash:signatures
      ^-  (unit @ud)
      %+  find
        ~[hash]
        (turn commits get-hash)
  ::
  ++  get-hash
      |=  commit=commit:revsur
      ^-  hash:signatures
      hash.commit
  ::
  ++  build
      |=  =bowl:gall
      |=  int=intent:revsur
      ^-  commit:revsur
      =/  commit-body
        :*  intent=hash.int
            client=client.int
            vendor=our.bowl
            when=now.bowl
        ==
      :: set commit hash and sign it
      =/  hash  (sham commit-body)
      =/  new-commit
        :*  hash=hash
            vendor=(sign:signatures our.bowl now.bowl hash)
            body=commit-body
            intent=body.int
        ==
      :: crash if our new commit is invalid
      ?>  (validate new-commit)
      new-commit
  ::
  ++  validate
      |=  commit=commit:revsur
      ^-  ?
      =/  true-hash  (sham body.commit)
      ?.  =(hash.commit true-hash)
        %.n
      ?.  (is-signature-valid:signatures [hash.commit ship.vendor.commit vendor.commit when.body.commit])
        %.n
      %.y
  ::
  --
++  review
  |% 
  ::
  ++  upsert
      |=  reviews=reviews:revsur
      |=  new-review=review:revsur
      ^-  (list review:revsur)
      =/  existing-review  ((get-by-hash reviews) hash.new-review)
      ?~  existing-review
        ~&  "did not find existing review, adding a new one"
        [new-review reviews]
      ~&  "found an existing review, updating it"
      (snap reviews (need existing-review) new-review)
  ::
  ++  exists
      |=  reviews=reviews:revsur
      |=  review=review:revsur
      ^-  ?
      ?~  ((get-by-hash reviews) hash.review)
        %.n
      %.y
  ++  get-by-hash
      |=  reviews=reviews:revsur
      |=  hash=hash:signatures
      ^-  (unit @ud)
      %+  find
        ~[hash]
        (turn reviews get-hash)
  ::
  ++  get-hash
      |=  rev=review:revsur
      ^-  hash:signatures
      hash.rev
  ::
  ++  build
      |=  =bowl:gall
      |=  cmt=commit:revsur
      |=  req=review-req:revsur
      ^-  review:revsur
      =/  client  ship.client.body.cmt
      =/  vendor  vendor.body.cmt
      =/  reviewee  ?:(=(our.bowl vendor) client vendor)
      =/  review-body
        :*  commit=hash.cmt
            reviewee=reviewee
            score=score.req
            why=why.req
            when=now.bowl
        ==
      =/  hash  (sham review-body)
      =/  new-review
        :*  hash=hash
            reviewer=(sign:signatures our.bowl now.bowl hash)
            body=review-body
            commit=cmt
        ==
      :: crash if our new review is invalid
      ?>  (validate new-review)
      new-review
  ::
  ++  validate
      |=  review=review:revsur
      ^-  ?
      =/  true-hash  (sham body.review)
      ?.  =(hash.review true-hash)
        %.n
      ?.  (is-signature-valid:signatures [hash.review ship.reviewer.review reviewer.review when.body.review])
        %.n
      %.y
  ::
  --
++  to-json
    =,  enjs:format
    |%
    ::
    ++  parse-update
        |=  upd=update:revsur
        ^-  json
        ?-    -.upd
            %intent  !!
            %commit  !!
            %review  !!
            %update  !!
            %gather
          %-  pairs
          :~  ['intents' (parse-intents intents.upd)]
              ['commits' (parse-commits commits.upd)]
              ['reviews' (parse-reviews reviews.upd)]
          ==
        ==
    ::
    ++  parse-intents
        |=  ints=intents:revsur
        a+(turn ints parse-intent)
    ::
    ++  parse-intent
        |=  intent=intent:revsur
        ^-  json
        %-  pairs
        :~  ['hash' s+(scot %uv hash.intent)]
            ['client' (to-json:signatures client.intent)]
            ['body' (parse-intent-body body.intent)]
        ==
    ::
    ++  parse-intent-body
        |=  body=intent-body:revsur
        ^-  json
        %-  pairs
        :~  ['advert' s+(scot %uv advert.body)]
            ['vendor' (to-json:signatures vendor.body)]
            ['client' s+(scot %p client.body)]
            ['when' (sect when.body)]
        ==
    ::
    ++  parse-commits
        |=  coms=commits:revsur
        a+(turn coms parse-commit)
    ::
    ++  parse-commit
        |=  commit=commit:revsur
        ^-  json
        %-  pairs
        :~  ['hash' s+(scot %uv hash.commit)]
            ['vendor' (to-json:signatures vendor.commit)]
            ['body' (parse-commit-body body.commit)]
            ['intent' (parse-intent-body intent.commit)]
        ==
    ::
    ++  parse-commit-body
        |=  body=commit-body:revsur
        ^-  json
        %-  pairs
        :~  ['intent' s+(scot %uv intent.body)]
            ['client' (to-json:signatures client.body)]
            ['when' (sect when.body)]
        ==
    ::
    ++  parse-reviews
        |=  revs=reviews:revsur
        a+(turn revs parse-review)
    ::
    ++  parse-review
        |=  review=review:revsur
        ^-  json
        %-  pairs
        :~  ['hash' s+(scot %uv hash.review)]
            ['reviewer' (to-json:signatures reviewer.review)]
            ['body' (parse-review-body body.review)]
            ['commit' (parse-commit commit.review)]
        ==
    ::
    ++  parse-review-body
        |=  body=review-body:revsur
        ^-  json
        %-  pairs
        :~  ['commit' s+(scot %uv commit.body)]
            ['reviewee' s+(scot %p reviewee.body)]
            ['score' (numb score.body)]
            ['why' s+why.body]
            ['when' (sect when.body)]
        ==
    ::
    --
::
++  from-json
    =,  dejs:format
    |%
    ::
    ++  parse-action
        |=  jon=json
        ^-  action:revsur
        %.  jon
        %-  of
        :~  [%intent parse-advert]
            [%commit parse-intent]
            [%review parse-revreq]
            [%update parse-update]
        ==
    ::
    ++  parse-advert
        %-  ot
        :~  advert+(se %uv)
        ==
    ::
    ++  parse-intent
        %-  ot
        :~  intent+(se %uv)
        ==
    ::
    ++  parse-revreq
        %-  ot
        :~  commit+(se %uv)
            score+ni
            why+so
        ==
    ::
    ++  parse-review-body
        %-  ot
        :~  commit+(se %uv)
            reviewee+(se %p)
            score+ni
            why+so
            when+du
        ==
    ::
    ++  parse-update
        %-  ot
        :~  hash+(se %uv)
            commit+(se %uv)
            score+ni
            why+so
        ==
    ::
    --
::
--
