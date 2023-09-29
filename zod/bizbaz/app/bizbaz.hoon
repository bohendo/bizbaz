/-  review
/-  listing
/+  default-agent, dbug
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  [%0 reviews=(list review:review) listings=(list listing:listing)]
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
  ?>  |(?=(%review-action mark) ?=(%listing-action mark))
  ?+  mark
    !!
    %review-action
      =/  act  !<(action:review vase)
      ~&  act
      ~&  reviewee.review.act
      ?-  -.act
          %post-review  [~ this(reviews [review.act reviews])]
      == 
    %listing-action
      =/  act  !<(action:listing vase)
      ?-  -.act
          %create  [~ this(listings [listing.act listings])]
          %delete  [~ this(listings [listing.act listings])] :: find & rm the one w matching id
          %update  [~ this(listings [listing.act listings])] :: find & replace the one w matching id
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
  :: ?>  |(?=(%reviews path) ?=(%listings path))
  :: ~&  path
  :_  this
  ?+  path  !!
    [%reviews ~]
      ~&  "watching reviews"
      [%give %fact ~ %review-update !>(`update:review`[%init reviews])]~
    [%listings ~]
      ~&  "watching listings"
      [%give %fact ~ %listing-update !>(`update:listing`[%init listings])]~
  ==
++  on-arvo   on-arvo:default
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--
