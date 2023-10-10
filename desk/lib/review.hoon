/-  revsur=review 
/-  advert
/+  signatures
/+  intlib=intent
/+  cmtlib=commit
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
    ?>  ((validate bowl) new-review)
    new-review
::
++  validate
    |=  =bowl:gall
    |=  review=review:revsur
    ^-  ?
    ?.  ((validate:cmtlib bowl) commit.review)
      ~&  "commit included in this review is invalid"
      %.n
    ?.  =(hash.review (sham body.review))
      ~&  "review hash does not match digest of the body"
      %.n
    ?.  (is-signature-valid:signatures [hash.review our.bowl reviewer.review when.body.review])
      ~&  "reviewer sig on the review hash is invalid"
      %.n
    =/  reviewee  reviewee.body.review
    =/  reviewer  ship.reviewer.review
    =/  client    ship.client.body.commit.review
    =/  vendor    vendor.body.commit.review
    ?.  |(&(=(reviewee client) =(reviewer vendor)) &(=(reviewee vendor) =(reviewer client)))
      ~&  "reviewer & reviewee are not the client & vendor"
      %.n
    ?.  |((lte score.body.review 5) (gte score.body.review 1))
      ~&  "score is not 1 to 5"
      %.n
    %.y
::
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
          :~  ['intents' (parse-intents:to-json:intlib intents.upd)]
              ['commits' (parse-commits:to-json:cmtlib commits.upd)]
              ['reviews' (parse-reviews reviews.upd)]
          ==
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
            ['commit' (parse-commit:to-json:cmtlib commit.review)]
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
        :~  [%intent parse-advert:from-json:intlib]
            [%commit parse-intent:from-json:cmtlib]
            [%review parse-revreq]
            [%update parse-update]
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
