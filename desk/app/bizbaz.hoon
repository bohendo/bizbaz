/-  advert, report, review, discovery
/+  default-agent, dbug, gossip, signatures, verb
:: import to force compilation during dev
::
/=  p-  /mar/discovery/friend
/=  p-  /mar/discovery/heard
/=  p-  /mar/discovery/peer
/=  p-  /mar/advert/action
/=  p-  /mar/advert/update
/=  p-  /mar/review/action
/=  p-  /mar/review/update
/=  p-  /mar/report/action
/=  p-  /mar/report/update
::
/$  grab-peer    %noun  %discovery-peer
/$  grab-friend  %noun  %discovery-friend
::
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
      peers=peers:discovery
  ==
+$  card  card:agent:gall
--
::
::  we are using gossip to broadcast peers (and not listings)
::  the flow goes like:
::
::  1. %gossip will auto subscribe to a %pal that has the app
::  2. the %pal will give a response
::  3. we add him to $friends
::  4. we gossip the new friend to our %pals and their %pals
::  5. when someone hear about our new friend they will:
::     5.1  add the friend to $tracking
::     5.2  poke the friend so that he also track on their side
::
::  %gossip config bellow
::
::  2                       the distance that the gossip will propagate
::  %mutuals %mutuals       it will propagate to mutual %pals
::  %.n                     will the propagation be random? (no)
::  %discovery-peer         used to propagate a peer 
::  %discovery-friend       used to give initial response to a friend
::
%-  %+  agent:gossip
      [2 %mutuals %mutuals %.n]
    %-  malt
    ^-  (list [mark $-(* vase)])
    :~  [%discovery-peer |=(n=* !>((grab-peer n)))]
        [%discovery-friend |=(n=* !>((grab-friend n)))]
    ==
::
%-  agent:dbug
%+  verb  &
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %|) bowl)
::
++  on-init   on-init:default
::
++  on-save   !>(state)
::
++  on-load
  |=  old=vase
  ^-  (quip card _this)
  `this(state !<(state-0 old))
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
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
                  when=now.bowl
                  advert-body
              ==
            [~ this(adverts [new-advert adverts])]
          %delete
            :: TODO: find & rm the one w matching hash
            !! ::[~ this(adverts [advert.act adverts])]
          %update
            :: TODO: find & replace the one w matching hash
            !! ::[~ this(adverts [advert.act adverts])]
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
            !! :: [~ this(reviews [review.act reviews])]
          %update
            :: TODO: find & replace the one w matching hash
            !! :: [~ this(reviews [review.act reviews])]
      ==
    %discovery-heard
      ::  someone heard about us
      ::  do nothing if we know about him
      ::  or if he is blocked
      ::
      ?:  ?|  (~(has in tracking.peers) src.bowl)
              (~(has in blocked.peers) src.bowl)
          ==
        `this
      ::  add him to tracking if he is not in friends
      ::
      =?  tracking.peers  !(~(has in friends.peers) src.bowl)
        (~(put in tracking.peers) src.bowl)
      `this
  ==
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+  path  (on-peek:default path)
    [%x %review ~]  ``noun+!>(reviews)
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
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
    [%~.~ %gossip %source ~]  ::  a pal will subscribe here
    ::  give an inital update to him
    ::
      [%give %fact ~ %discovery-friend !>([now.bowl our.bowl])]~
  ==
++  on-arvo   on-arvo:default
::
++  on-leave  on-leave:default
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?.  ?&  =(/~/gossip/gossip wire)
          ?=(%fact -.sign)
      ==
   (on-agent:default wire sign)
  ?+    p.cage.sign  (on-agent:default wire sign)
    ::
      %discovery-friend
    ::  we have a new friend
    ::
    ?:  ?|   (~(has in friends.peers) src.bowl)
             (~(has in blocked.peers) src.bowl)
        ==
      ::  do nothing if he is already a friend
      ::  or it's blocked
      ::
      `this
    ::  remove him from tracking (if he is there)
    ::
    =.  tracking.peers       (~(del in tracking.peers) src.bowl)
    ::  add him to friends
    :: 
    =.  friends.peers        (~(put in friends.peers) src.bowl)
    ::  gossip the friend
    ::
    :_  this
    :~  [(invent:gossip %discovery-peer !>([now.bowl src.bowl]))]
    ==
    ::
      %discovery-peer
    ::  hearing about a peer
    ::
    =/  gossip         !<(gossip-peer:discovery q.cage.sign)
    ::  do nothing if it's us
    ::  or it's blocked
    ::
    ?:  ?|  =(our.bowl peer.gossip)
            (~(has in blocked.peers) peer.gossip)
        ==
      `this
    ::  add him to tracking if he is not in friends
    ::
    =?  tracking.peers  !(~(has in friends.peers) peer.gossip)
      (~(put in tracking.peers) peer.gossip)
    ::  poke for him to know about us (in case he doesn't)
    ::
    :_  this
    :~  :*  %pass
            /heard/(scot %p peer.gossip)
            %agent
            [peer.gossip %bizbaz]
            %poke
            %discovery-heard
            !>(peer.gossip)
         ==
    ==
  ==
::
++  on-fail   on-fail:default
--
