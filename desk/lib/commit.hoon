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
