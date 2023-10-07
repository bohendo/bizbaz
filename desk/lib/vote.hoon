/-  vote 
/+  signatures
|% 
::
++  validate  !!
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
            ['vendor' s+(scot %p vendor.body)]
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
