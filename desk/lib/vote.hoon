/-  vote 
/-  advert 
/+  advlib=advert 
/+  signatures
|% 
::
++  upsert-vote
    |=  votes=votes:vote
    |=  new-vote=vote:vote
    ^-  (list vote:vote)
    =/  vote-is-duplicate  ((vote-exists votes) new-vote)
    ?:  vote-is-duplicate
      :: ~&  "Ignoring duplicate vote"
      votes
    =/  recast-vote  ((get-recast-vote votes) new-vote)
    ?~  recast-vote
      :: ~&  "Did not find existing vote, adding a new one"
      ?:  ?=(%un choice.body.new-vote)
        :: ~&  "Ignoring new unvote"
        votes
      [new-vote votes]
    =/  old-vote  (snag (need recast-vote) votes)
    ?:  (lth when.body.new-vote when.body.old-vote)
      :: ~&  "Ignoring updated vote that's older than the existing one"
      votes
    :: ~&  "Found an existing vote, updating it"
    ?:  ?=(%un choice.body.new-vote)
      :: ~&  "Removing unvote"
      (oust [(need recast-vote) 1] votes)
    (snap votes (need recast-vote) new-vote)
::
:: card that publishes info to all subscribers
++  pub-card
    |=  upd=update:vote
    ^-  (list card:agent:gall)
    :~  [%give %fact ~[noun-wire] %vote-update !>(upd)]
        [%give %fact ~[json-wire] %vote-update !>(upd)]
    ==
::
:: card that asks to subscribe to some pal
++  sub-card
    |=  pal=ship
    ^-  card:agent:gall
    [%pass noun-wire %agent [pal %bizbaz] %watch noun-wire]
::
++  noun-wire
    /noun/votes
::
++  json-wire
    /json/votes
::
++  get-recast-vote
    |=  votes=votes:vote
    |=  new-vote=vote:vote
    ^-  (unit @ud)
    ::  get a list of votes where the advert + voter match this new-vote
    =/  recasts
        %+  skim  votes
            |=  v=vote:vote
            ?&  =(advert.body.v advert.body.new-vote)
                =(ship.voter.v ship.voter.new-vote)
            ==
    =/  num-recasts  (lent recasts)
    ?:  =(num-recasts 0)
        ~
    ?>  =(num-recasts 1)
    =/  recast  (scag 1 recasts)
    %+  find  recast  votes
::
++  vote-exists
    |=  votes=votes:vote
    |=  vote=vote:vote
    ^-  ?
    ?~  ((get-vote-index-by-hash votes) hash.vote)
      %.n
    %.y
::
++  get-vote-index-by-hash
    |=  votes=votes:vote
    |=  hash=hash:signatures
    ^-  (unit @ud)
    %+  find
      ~[hash]
      (turn votes get-hash)
::
++  get-hash
    |=  =vote:vote
    ^-  hash:signatures
    hash.vote
::
++  build-vote
    |=  =bowl:gall
    |=  adverts=adverts:advert
    |=  req=vote-req:vote
    ^-  vote:vote
    :: update when in the body
    =/  vote-body
      :*  advert=advert.req
          choice=choice.req
          voter=our.bowl
          when=now.bowl
      ==
    :: set vote hash and sign it
    =/  hash  (sham vote-body)
    =/  new-vote
      :*  hash=hash
          voter=(sign:signatures our.bowl now.bowl hash)
          vote-body
      ==
    :: crash if our new vote is invalid
    ?>  (((validate bowl) adverts) new-vote)
    new-vote
::
++  validate
    |=  =bowl:gall
    |=  adverts=adverts:advert
    |=  vote=vote:vote
    ^-  ?
    ?.  =(hash.vote (sham body.vote))
      :: ~&  "Vote hash does not match digest of the body"
      %.n
    ?.  (is-signature-valid:signatures [our.bowl voter.vote hash.vote now.bowl])
      :: ~&  "Voter sig on the vote hash is invalid"
      %.n
    =/  adv-index  ((get-by-hash:advlib adverts) advert.body.vote)
    ?~  adv-index
      :: ~&  "No advert exists for this vote"
      %.n
    =/  adv  (snag (need adv-index) adverts)
    ?:  =(ship.vendor.adv ship.voter.vote)
      :: ~&  "Voting on your own advert is not allowed"
      %.n
    %.y
::
++  to-json
    =,  enjs:format
    |%
    ::
    ++  parse-update
        |=  upd=update:vote
        ^-  json
        ?-    -.upd
            %vote  (frond 'vote' (parse-vote vote.upd))
            %gather  (frond 'gather' (parse-votes votes.upd))
        ==
    ::
    ++  parse-votes
        |=  votes=votes:vote
        ^-  json
        %-  pairs
        :~  ['votes' %a (turn votes parse-vote)]
        ==
    ::
    ++  parse-vote
        |=  adv=vote:vote
        ^-  json
        %-  pairs
        :~  ['hash' s+(scot %uv hash.adv)]
            ['voter' (to-json:signatures voter.adv)]
            ['body' (parse-body body.adv)]
        ==
    ::
    ++  parse-body
        |=  body=vote-body:vote
        ^-  json
        %-  pairs
        :~  ['advert' s+(scot %uv advert.body)]
            ['voter' s+(scot %p voter.body)]
            ['choice' s+choice.body]
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
        :: ^-  action:vote
        %.  jon
        %-  of
        :~  [%vote parse-vote]
        ==
    ::
    ++  parse-vote
        %-  ot
        :~  advert+(se %uv)
            choice+(se %tas)
        ==
    ::
    --
::
--
