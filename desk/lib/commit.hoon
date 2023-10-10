/-  revsur=review 
/-  advert
/+  signatures
/+  intlib=intent
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
    ?>  ((validate bowl) new-commit)
    new-commit
::
++  validate
    |=  =bowl:gall
    |=  commit=commit:revsur
    ^-  ?
    ?.  ((validate:intlib bowl) [hash=intent.body.commit client=client.body.commit body=intent.commit])
      ~&  "intent included in this commit is invalid"
      %.n
    ?.  =(ship.vendor.commit ship.vendor.intent.commit)
      ~&  "vendor specified in intent body did not sign this commit"
      %.n
    ?.  =(ship.vendor.commit vendor.body.commit)
      ~&  "vendor specified in commit body did not sign this commit"
      %.n
    ?.  =(hash.commit (sham body.commit))
      ~&  "commit hash does not match digest of the body"
      %.n
    ?.  (is-signature-valid:signatures [hash.commit our.bowl vendor.commit when.body.commit])
      ~&  "vendor sig on the commit hash is invalid"
      %.n
    %.y
::
++  to-json
    =,  enjs:format
    |%
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
            ['intent' (parse-intent-body:to-json:intlib intent.commit)]
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
    --
::
++  from-json
    =,  dejs:format
    |%
    ::
    ++  parse-intent
        %-  ot
        :~  intent+(se %uv)
        ==
    ::
    --
::
--
