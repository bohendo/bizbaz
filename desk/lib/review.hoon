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
    =/  old-review-index  ((get-by-hash reviews) hash.new-review)
    ?~  old-review-index
      :: ~&  "Did not find existing review, adding a new one"
      [new-review reviews]
    =/  old-review  (snag (need old-review-index) reviews)
    ?:  (lth when.body.new-review when.body.old-review)
      :: ~&  "Ignoring updated review that's older than the existing one"
      reviews
    :: ~&  "Replacing existing review with updated review"
    (snap reviews (need old-review-index) new-review)
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
      :: ~&  "Commit included in this review is invalid"
      %.n
    ?.  =(hash.review (sham body.review))
      :: ~&  "Review hash does not match digest of the body"
      %.n
    ?.  (is-signature-valid:signatures [our.bowl reviewer.review hash.review now.bowl])
      :: ~&  "Reviewer sig on the review hash is invalid"
      %.n
    =/  reviewee  reviewee.body.review
    =/  reviewer  ship.reviewer.review
    =/  client    ship.client.body.commit.review
    =/  vendor    vendor.body.commit.review
    ?.  |(&(=(reviewee client) =(reviewer vendor)) &(=(reviewee vendor) =(reviewer client)))
      :: ~&  "Reviewer & reviewee are not the client & vendor"
      %.n
    ?.  |((lte score.body.review 5) (gte score.body.review 1))
      :: ~&  "Score is not 1 to 5"
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
            %intent
          %+  frond  'intent'
          (parse-intent:to-json:intlib intent.upd)
            %commit
          %+  frond  'commit'
          (parse-commit:to-json:cmtlib commit.upd)
            %review
          %+  frond  'review'
          (parse-review review.upd)
            %update
          %+  frond  'update'
          %-  pairs
          :~  ['old' s+(scot %uv old.upd)]
              ['new' (parse-review new.upd)]
          ==
            %gather
          %+  frond  'gather'
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
    ++  parse-update
        %-  ot
        :~  old+(se %uv)
            commit+(se %uv)
            score+ni
            why+so
        ==
    ::
    --
::
--
