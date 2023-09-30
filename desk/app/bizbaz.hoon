/-  advert
/-  report
/-  review
/+  default-agent, dbug
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  [%0 adverts=(list advert:advert) reports=(list report:report) reviews=(list review:review) commitments=(list commit:review)]
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
++  on-init   on-init:default
++  on-save   !>(state)
++  on-load
  |=  old=vase
  ^-  (quip card _this)
  `this(state !<(state-0 old))
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  |(?=(%review-action mark) ?=(%advert-action mark))
  ?+  mark
    !!
    %advert-action
      =/  act  !<(action:advert vase)
      ?-  -.act
          %create 
            =/  body  body.act
            :: TODO: sign digest
            =/  advert-body  [title=title.body cover=cover.body tags=`(list @tas)`tags.body description=description.body]
            =/  new-advert  [vendor=our.bowl digest=`@ux`(sham advert-body) sig=`@ux`0 when=now.bowl advert-body]
            [~ this(adverts [new-advert adverts])]
          %delete
            :: TODO: find & rm the one w matching digest
            !! ::[~ this(adverts [advert.act adverts])]
          %update
            :: TODO: find & replace the one w matching digest
            !! ::[~ this(adverts [advert.act adverts])]
      == 
    %report-action
      =/  act  !<(action:report vase)
      ~&  act
      ?-  -.act
          %snitch
            :: TODO: sign digest
            :: TODO: fetch target from advert
            =/  report-body  [advert=`@ux`0 target=~zod]
            =/  new-report  [tattle=our.bowl digest=`@ux`(sham report-body) sig=`@ux`0 advert=advert.act target=~zod]
            [~ this(reports [new-report reports])]
          %redact
            :: TODO: find & rm the one w matching digest
            !! :: [~ this(reports [new-report reports])]
      == 
    %review-action
      =/  act  !<(action:review vase)
      ~&  act
      ?-  -.act
          %commit
            !! :: [~ this(reviews [review.act reviews])]
          %review
            !! :: [~ this(reviews [review.act reviews])]
          %update
            :: TODO: find & replace the one w matching digest
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
      ~&  "watching reviews"
      [%give %fact ~ %review-update !>(`update:review`[%gather reviews])]~
  ==
++  on-arvo   on-arvo:default
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--
