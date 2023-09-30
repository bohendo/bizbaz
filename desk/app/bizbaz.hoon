/-  advert
/-  report
/-  review
/+  default-agent, dbug
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  [%0 reviews=(list adverts=(list advert:advert) reports=(list report:report) review:review)]
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
            =/  new-advert  [id=0x0 who=our.bowl when=now.bowl new-req.act]
            [~ this(adverts [new-advert adverts])]
          %delete  !!::[~ this(adverts [advert.act adverts])] :: find & rm the one w matching id
          %update  !!::[~ this(adverts [advert.act adverts])] :: find & replace the one w matching id
      == 
    %report-action
      =/  act  !<(action:report vase)
      ~&  act
      ~&  reportee.report.act
      ?-  -.act
          %snitch  [~ this(reports [report.act reports])]
      == 
    %review-action
      =/  act  !<(action:review vase)
      ~&  act
      ~&  reviewee.review.act
      ?-  -.act
          %post-review  [~ this(reviews [review.act reviews])]
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
    [%reviews ~]
      ~&  "watching reviews"
      [%give %fact ~ %review-update !>(`update:review`[%init reviews])]~
    [%adverts ~]
      ~&  "watching adverts"
      [%give %fact ~ %advert-update !>(`update:advert`[%init adverts])]~
  ==
++  on-arvo   on-arvo:default
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--
