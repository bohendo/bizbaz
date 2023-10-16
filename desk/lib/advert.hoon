/-  advert
/+  signatures
|% 
::
:: card that publishes info to all subscribers
++  pub-card
    |=  upd=update:advert
    ^-  (list card:agent:gall)
    :~  [%give %fact ~[noun-wire] %advert-update !>(upd)]
        [%give %fact ~[json-wire] %advert-update !>(upd)]
    ==
::
:: card that asks to subscribe to some pal
++  sub-card
    |=  pal=ship
    ^-  card:agent:gall
    [%pass noun-wire %agent [pal %bizbaz] %watch noun-wire]
::
++  noun-wire
    /noun/adverts
::
++  json-wire
    /json/adverts
::
++  exists
    |=  adverts=adverts:advert
    |=  advert=advert:advert
    ^-  ?
    ?~  ((get-by-hash adverts) hash.advert)
      %.n
    %.y
::
++  get-by-hash
    |=  adverts=adverts:advert
    |=  hash=hash:signatures
    ^-  (unit @ud)
    %+  find
      ~[hash]
      (turn adverts get-hash)
::
++  get-hash
    |=  ad=advert:advert
    ^-  hash:signatures
    hash.ad
::
++  build
    |=  =bowl:gall
    |=  req=advert-req:advert
    ^-  advert:advert
    :: update when in the body
    =/  advert-body
      :*  title=title.req
          cover=cover.req
          tags=`(list @tas)`tags.req
          description=description.req
          vendor=our.bowl
          when=now.bowl
      ==
    :: set advert hash and sign it
    =/  hash  (sham advert-body)
    =/  new-advert
      :*  hash=hash
          vendor=(sign:signatures our.bowl now.bowl hash)
          body=advert-body
      ==
    :: crash if our new advert is invalid
    ?>  ((validate bowl) new-advert)
    new-advert
::
++  validate
    |=  =bowl:gall
    |=  advert=advert:advert
    ^-  ?
    =/  true-hash  (sham body.advert)
    ?.  =(hash.advert true-hash)
      %.n
    ?.  (is-signature-valid:signatures [our.bowl vendor.advert hash.advert now.bowl])
      %.n
    %.y
::
++  to-json
    =,  enjs:format
    |%
    ::
    ++  parse-update
        |=  upd=update:advert
        ^-  json
        ?-    -.upd
            %create  (frond 'create' (frond 'advert' (parse-advert advert.upd)))
            %update  (frond 'update' (en-update +.upd))
            %delete  (frond 'delete' (frond 'advert' (parse-hash advert.upd)))
            %gather  (frond 'gather' (parse-adverts adverts.upd))
        ==
    ::
    ++  en-update
        |=  [old=hash:signatures new=advert:advert]
        ^-  json
        %+  frond  'update'
        %-  pairs
        :~  ['old' (parse-hash old)]
            ['new' (parse-advert new)]
        ==
    ::
    ++  parse-adverts
        |=  advs=adverts:advert
        ^-  json
        %-  pairs
        :~  ['adverts' %a (turn advs parse-advert)]
        ==
    ::
    ++  parse-advert
        |=  adv=advert:advert
        ^-  json
        %-  pairs
        :~  ['hash' s+(scot %uv hash.adv)]
            ['vendor' (to-json:signatures vendor.adv)]
            ['body' (parse-body body.adv)]
        ==
    ::
    ++  parse-body
        |=  body=advert-body:advert
        ^-  json
        %-  pairs
        :~  ['title' s+title.body]
            ['cover' s+cover.body]
            ['tags' a+(turn (turn tags.body trip) tape)]
            ['description' s+description.body] :: TODO: change to wall?
            ['vendor' s+(scot %p vendor.body)]
            ['when' (sect when.body)]
        ==
    ::
    ++  parse-hash
        |=  hash=hash:signatures
        s+(scot %uv hash)
    ::
    --
::
++  from-json
    =,  dejs:format
    |%
    ::
    ++  parse-action
        |=  jon=json
        ^-  action:advert
        %.  jon
        %-  of
        :~  [%create parse-create]
            [%update parse-update]
            [%delete parse-delete]
        ==
    ::
    ++  parse-create
        %-  ot
        :~  title+so
            cover+so
            tags+(ar (se %tas))
            description+so
        ==
    ::
    ++  parse-update
        %-  ot
        :~  hash+(se %uv)
            title+so
            cover+so
            tags+(ar (se %tas))
            description+so
        ==
    ::
    ++  parse-delete
        %-  ot
        :~  hash+(se %uv)
        ==
    ::
    --
::
--
