/-  review 
/-  advert
/+  signatures
|% 
::
:: card that publishes info to all subscribers
++  pub-card
    |=  upd=update:review
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
      |=  intents=intents:review
      |=  intent=intent:review
      ^-  ?
      ?~  ((get-index intents) hash.intent)
        %.n
      %.y
  ++  get-index
      |=  intents=intents:review
      |=  hash=hash:signatures
      ^-  (unit @ud)
      %+  find
        ~[hash]
        (turn intents get-hash)
  ::
  ++  get-hash
      |=  intent=intent:review
      ^-  hash:signatures
      hash.intent
  ::
  ++  build
      |=  =bowl:gall
      |=  ad=advert:advert
      ^-  intent:review
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
      |=  intent=intent:review
      ^-  ?
      =/  true-hash  (sham body.intent)
      ?.  =(hash.intent true-hash)
        %.n
      ?.  (is-signature-valid:signatures [hash.intent ship.client.intent client.intent when.body.intent])
        %.n
      %.y
  ::
  --
++  to-json
    =,  enjs:format
    |%
    ::
    ++  parse-update
        |=  upd=update:review
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
        |=  ints=intents:review
        a+(turn ints parse-intent)
    ::
    ++  parse-intent
        |=  intent=intent:review
        ^-  json
        %-  pairs
        :~  ['hash' s+(scot %uv hash.intent)]
            ['client' (to-json:signatures client.intent)]
            ['body' (parse-intent-body body.intent)]
        ==
    ::
    ++  parse-intent-body
        |=  body=intent-body:review
        ^-  json
        %-  pairs
        :~  ['advert' s+(scot %uv advert.body)]
            ['vendor' (to-json:signatures vendor.body)]
            ['client' s+(scot %p client.body)]
            ['when' (sect when.body)]
        ==
    ::
    ++  parse-commits
        |=  coms=commits:review
        a+(turn coms parse-commit)
    ::
    ++  parse-commit
        |=  commit=commit:review
        ^-  json
        %-  pairs
        :~  ['hash' s+(scot %uv hash.commit)]
            ['vendor' (to-json:signatures vendor.commit)]
            ['body' (parse-commit-body body.commit)]
            ['intent' (parse-intent-body intent.commit)]
        ==
    ::
    ++  parse-commit-body
        |=  body=commit-body:review
        ^-  json
        %-  pairs
        :~  ['intent' s+(scot %uv intent.body)]
            ['client' (to-json:signatures client.body)]
            ['when' (sect when.body)]
        ==
    ::
    ++  parse-reviews
        |=  revs=reviews:review
        a+(turn revs parse-review)
    ::
    ++  parse-review
        |=  review=review:review
        ^-  json
        %-  pairs
        :~  ['hash' s+(scot %uv hash.review)]
            ['reviewer' (to-json:signatures reviewer.review)]
            ['body' (parse-review-body body.review)]
            ['commit' (parse-commit commit.review)]
        ==
    ::
    ++  parse-review-body
        |=  body=review-body:review
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
        ^-  action:review
        %.  jon
        %-  of
        :~  [%intent parse-advert]
            [%commit parse-intent]
            [%review parse-review]
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
    ++  parse-review
        %-  ot
        :~  [%body parse-review-body]
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
            reviewee+(se %p)
            score+ni
            why+so
            when+du
        ==
    ::
    --
::
--
