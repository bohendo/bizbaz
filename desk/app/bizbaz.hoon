/-  advert
/-  report
/-  review
/+  signatures
/+  default-agent, dbug
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  %0
      adverts=(list advert:advert)
      reports=(list report:report)
      reviews=(list review:review)
      commits=(list commit:review)
  ==
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %|) bowl)
++  on-init
  ^-  (quip card _this)
  ~&  >  "%bizbaz initialized successfully."
  :_  this
  :~  [%pass /eyre %arvo %e %connect [~ /apps/bizbaz] %bizbaz]
  ==
++  on-save   !>(state)
++  on-load
  |=  old=vase
  ^-  (quip card _this)
  `this(state !<(state-0 old))
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  |(?=(%advert-action mark) ?=(%report-action mark) ?=(%review-action mark))
  ?+  mark
    !!
    %advert-action
      =/  act  !<(action:advert vase)
      ?-  -.act
          %create 
            =/  advert-body
              :*  title=title.body.act
                  cover=cover.body.act
                  tags=`(list @tas)`tags.body.act
                  description=description.body.act
              ==
            =/  hash  (sham advert-body)
            =/  new-advert
              :*  hash=hash
                  sig=(sign:signatures our.bowl now.bowl hash)
                  advert-body
                  when=now.bowl
              ==
            [~ this(adverts [new-advert adverts])]
          %delete
            =/  index  (find ~[hash.act] (turn adverts |=(ad=advert:advert hash.ad)))
            ?~  index
              ~|((weld "No advert with hash " (scow %uv hash.act)) !!)
            [~ this(adverts (oust [(need index) 1] adverts))]
          %update
            =/  index  (find ~[hash.act] (turn adverts |=(ad=advert:advert hash.ad)))
            ?~  index
              ~|((weld "No advert with hash " (scow %uv hash.act)) !!)
            =/  advert-body
              :*  title=title.body.act
                  cover=cover.body.act
                  tags=`(list @tas)`tags.body.act
                  description=description.body.act
              ==
            =/  hash  (sham advert-body)
            =/  new-advert
              :*  hash=hash
                  sig=(sign:signatures our.bowl now.bowl hash)
                  when=now.bowl
                  advert-body
              ==
            [~ this(adverts (snap adverts (need index) new-advert))]
      == 
    %report-action
      =/  act  !<(action:report vase)
      ~&  act
      ?-  -.act
          %snitch
            =/  index  (find ~[advert.act] (turn adverts |=(ad=advert:advert hash.ad)))
            ?~  index
              ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
            =/  ad  (snag (need index) adverts)
            =/  target  ship.sig.ad
            =/  report-body  [advert=advert.act target]
            =/  hash  (sham report-body)
            =/  new-report
              :*  hash
                  sig=(sign:signatures our.bowl now.bowl hash)
                  report-body
              ==
            [~ this(reports [new-report reports])]
          %redact
            :: TODO: find & rm the one w matching hash
            !! :: [~ this(reports [new-report reports])]
      == 
    %review-action
      =/  act  !<(action:review vase)
      ~&  act
      ?-  -.act
          %commit
            =/  index  (find ~[advert.act] (turn adverts |=(ad=advert:advert hash.ad)))
            ?~  index
              ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
            =/  ad  (snag (need index) adverts)
            =/  new-commit
              :*  advert=advert.act
                  vendor-sig=sig.ad
                  client-sig=(sign:signatures our.bowl now.bowl advert.act)
                  when=now.bowl
              ==
            [~ this(commits [new-commit commits])]
          %review
            =/  index  (find ~[advert.act] (turn commits |=(cmt=commit:review advert.cmt)))
            ?~  index
              ~|((weld "No commit matches advert " (scow %uv advert.act)) !!)
            =/  commit  (snag (need index) commits)
            =/  review-body  [reviewee=reviewee.body.act score=score.body.act why=why.body.act]
            =/  hash  (sham review-body)
            =/  new-review
              :*  hash=hash
                  sig=(sign:signatures our.bowl now.bowl hash)
                  when=now.bowl
                  body=review-body
                  commit=commit
              ==
            [~ this(reviews [new-review reviews])]
          %update
            :: TODO: find & replace the one w matching hash
            !! :: [~ this(reviews [review.act reviews])]
      == 
  ==
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+  path  (on-peek:default path)
    [%x %review ~]  ``noun+!>(reviews)
  ==
++  on-watch
  |=  =path
  ^-  (quip card _this)
  :: ?>  |(?=(%reviews path) ?=(%adverts path))
  :: ~&  path
  :_  this
  ?+  path  !!
    [%adverts ~]
      ~&  "watching adverts"
      [%give %fact ~ %advert-update !>(`update:advert`[%gather adverts])]~
    [%reports ~]
      ~&  "watching reports"
      [%give %fact ~ %report-update !>(`update:report`[%gather reports])]~
    [%reviews ~]
      ~&  "watching reviews & commits"
      [%give %fact ~ %review-update !>(`update:review`[%gather reviews commits])]~
  ==
++  on-arvo   on-arvo:default
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--
