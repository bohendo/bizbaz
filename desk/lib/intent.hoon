/-  revsur=review 
/-  advert
/+  signatures
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
    ?:  =(ship.vendor.body.intent ship.client.intent)
      ~&  "vendor and client are the same ship"
      %.n
    ?.  =(client.body.intent ship.client.intent)
      ~&  "client specified in the body did not sign this commit"
      %.n
    ?.  (is-signature-valid:signatures [advert.body.intent ship.vendor.body.intent vendor.body.intent when.body.intent])
      ~&  "vendor sig on the advert hash is invalid"
      %.n
    ?.  =(hash.intent (sham body.intent))
      ~&  "intent hash does not match digest of the body"
      %.n
    ?.  (is-signature-valid:signatures [hash.intent ship.client.intent client.intent when.body.intent])
      ~&  "client sig on the intent hash is invalid"
      %.n
    %.y
::
++  to-json
    =,  enjs:format
    |%
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
    --
::
++  from-json
    =,  dejs:format
    |%
    ::
    ++  parse-advert
        %-  ot
        :~  advert+(se %uv)
        ==
    ::
    --
::
--
