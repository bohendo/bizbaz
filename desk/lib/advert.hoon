/-  advert 
/+  signatures
|% 
::
++  build-advert
    |=  =bowl:gall
    |=  body=advert-body:advert
    ^-  advert:advert
    :: update when in the body
    =/  advert-body
      :*  title=title.body
          cover=cover.body
          tags=`(list @tas)`tags.body
          description=description.body
          when=now.bowl
      ==
    :: set advert hash and sign it
    =/  hash  (sham advert-body)
    =/  new-advert
      :*  hash=hash
          vendor=(sign:signatures our.bowl now.bowl hash)
          advert-body
      ==
    :: crash if our new advert is invalid
    ?>  (validate new-advert)
    new-advert
::
++  get-hash
    |=  ad=advert:advert
    ^-  hash:signatures
    hash.ad
::
++  advert-exists
    |=  adverts=adverts:advert
    |=  advert=advert:advert
    ^-  ?
    ?~  (find ~[hash.advert] (turn adverts get-hash))
      %.n
    %.y
::
++  validate
    |=  advert=advert:advert
    ^-  @f
    =/  true-hash  (sham body.advert)
    ?.  =(hash.advert true-hash)
      %.n
    ?.  (is-signature-valid:signatures [hash.advert ship.vendor.advert vendor.advert when.body.advert])
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
            when+du
        ==
    ::
    ++  parse-update
        %-  ot
        :~  hash+(se %uv)
            title+so
            cover+so
            tags+(ar (se %tas))
            description+so
            when+du
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
