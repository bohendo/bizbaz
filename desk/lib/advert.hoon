/-  advert 
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
        |=  upd=update:advert
        ^-  json
        ?-    -.upd
            %create  !!
            %update  !!
            %delete  !!
            %gather  (parse-adverts adverts.upd)
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
