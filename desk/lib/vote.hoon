/-  vote 
/-  advert
/+  signatures
|% 
::
++  build-vote
    |=  =bowl:gall
    |=  [advert=hash:signatures choice=@tas voter=ship]
    ^-  vote:vote
    :: update when in the body
    =/  vote-body
      :*  advert=advert
          choice=choice
          voter=voter
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
    ?>  (validate new-vote)
    new-vote
::
++  validate
    |=  vote=vote:vote
    ^-  @f
    =/  true-hash  (sham body.vote)
    ?.  =(hash.vote true-hash)
      %.n
    ?.  (is-signature-valid:signatures [hash.vote ship.voter.vote voter.vote when.body.vote])
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
            %vote  !!
            %gather  (parse-votes votes.upd)
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
