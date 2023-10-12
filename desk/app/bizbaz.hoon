/-  advert, report, review, discovery, bizbaz-lake
/+  default-agent, dbug, gossip, signatures, verb, sss
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
      $:  pubs=_(mk-pubs:sss bizbaz-lake sss-path)
          subs=_(mk-subs:sss bizbaz-lake sss-path)
      ==
      =peers:discovery
  ==
+$  card  card:agent:gall
+$  sss-path  [%sss-path ~]
--
::
::  we are using gossip to broadcast peers (and not listings)
::  the flow goes like:
::
::  1. %gossip will auto subscribe to a %pal that has the app
::  2. the %pal will give a response with the %friend mark
::  3. we add him to $friends
::  4. we gossip the new friend to our %pals and their %pals
::  5. when someone hear about our new friend they will:
::     5.1  add the friend to $tracking
::     5.2  poke the friend so that  also track on their side
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
=<
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %|) bowl)
    da-sub
      ::  `da` core handles SSS subscriptions
      ::
      =/  da  (da:sss bizbaz-lake sss-path)
      (da subs bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    ::
    du-pub
      ::  `du` core handles SSS publications
      ::
      =/  du  (du:sss bizbaz-lake sss-path)
      (du pubs bowl -:!>(*result:du))
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
  ?+    mark  (on-poke:default mark vase)
  ::
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
      ::  publish new ad
      :: 
      =^  cards  pubs
        (give:du-pub *sss-path [%create-advert new-advert])
      ::  tell the frontend
      ::
      =.  cards
        [[%give %fact ~[/adverts] %advert-update !>([%create new-advert])] cards]
      [cards this]
      ::
        %delete
      =/  exists  (get-advert-by-hash hash.act)
      ?~  exists
        ~|((weld "No advert with hash " (scow %uv hash.act)) !!)
      =^  cards  pubs
        (give:du-pub *sss-path [%delete-advert hash.act])
      =.  cards
      [[%give %fact ~[/adverts] %advert-update !>([%delete hash.act])] cards]
      [cards this]
      ::
        %update
      =/  advert  (get-advert-by-hash hash.act)
      ?~  advert
        ~|((weld "No advert with hash " (scow %uv hash.act)) !!)
      =.  body.advert  body.act
      =^  cards  pubs
        (give:du-pub *sss-path [%update-advert advert])
      =.  cards
      [[%give %fact ~[/adverts] %advert-update !>([%update advert])] cards]
      [cards this]
      ::
    == 
  ::
      %report-action
    =/  act  !<(action:report vase)
    ~&  act
    ?-  -.act
      ::
        %snitch
      =/  ad  (get-advert-by-hash advert.act)
      ?~  ad
        ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
      =/  target  ship.sig.ad
      =/  report-body  [advert=advert.act target]
      =/  hash  (sham report-body)
      =/  new-report
        :*  hash
            sig=(sign:signatures our.bowl now.bowl hash)
            report-body
        ==
      =^  cards  pubs
        (give:du-pub *sss-path [%create-report new-report])
      =.  cards
      [[%give %fact ~[/reports] %report-update !>([%update new-report])] cards]
      [cards this]
      ::
        %redact
      =/  exists  (get-report-by-hash hash.act)
      ?~  exists
        ~|((weld "No report with hash " (scow %uv hash.act)) !!)
      =^  cards  pubs
        (give:du-pub *sss-path [%delete-report hash.act])
      =.  cards
      [[%give %fact ~[/reports] %report-update !>([%delete hash.act])] cards]
      [cards this]
      ::
    == 
  ::
      %review-action
    =/  act  !<(action:review vase)
    ~&  act
    ?-  -.act
      ::
        %commit
      =/  ad  (get-advert-by-hash advert.act)
      ?~  ad
        ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
      =/  new-commit
        :*  advert=advert.act
            vendor-sig=sig.ad
            client-sig=(sign:signatures our.bowl now.bowl advert.act)
            when=now.bowl
        ==
      =^  cards  pubs
        (give:du-pub *sss-path [%create-commit new-commit])
      =.  cards
      [[%give %fact ~[/reports] %review-commit !>([%commit advert.act])] cards]
      [cards this]
      ::
        %review
          !! :: [~ this(reviews [review.act reviews])]
      ::
        %update
      =/  old-review  (get-review-by-hash hash.act)
      ?~  old-review
         ~|((weld "No review with hash " (scow %uv hash.act)) !!)
      =.  body.old-review  body.act
      =^  cards  pubs
        (give:du-pub *sss-path [%update-review old-review])
      =.  cards
      [[%give %fact ~[/reports] %review-update !>([%commit hash.act])] cards]
      [cards this]
    ==
  ::
      %discovery-heard
    ::  someone heard about us
    ::  do nothing if we already know
    ::
    ?:  ?|  (~(has in friends.peers) src.bowl)
            (~(has in blocked.peers) src.bowl)
            (is-subscribed src.bowl)
        ==
      `this
    ::  add to tracking
    ::
    =.  tracking.peers  (~(put in tracking.peers) src.bowl)
    ::  subscribe to state
    ::
    =^  sss-cards  subs
      (surf:da-sub src.bowl %bizbaz *sss-path)
    [sss-cards this]
  ::
      %sss-on-rock  :: someone published a new update
                    :: TODO: send update to the frontend
                    :: 
    ?-    msg=!<(from:da-sub (fled:sss vase))
      [sss-path *]
    ~?  ?=([~ ~ ~ ~] rock.msg)
    "last message from {<from.msg>} on {<src.msg>} is {<,.-.rock.msg>}"
    ?<  ?=([%crash *] rock.msg)
    `this
    ==
  ::
      %sss-to-pub  ::  SSS boilerplate
    ?-  msg=!<(into:du-pub (fled:sss vase))
        [sss-path *]
      =^  cards  pubs  (apply:du-pub msg)
      :: ~&  >  "pubs is: {<read:du-pub>}"
      [cards this]
    ==  
  ::  
      %sss-bizbaz  ::  SSS boilerplate
    =^  cards  subs
    (apply:da-sub !<(into:da-sub (fled:sss vase)))
    :: ~&  >  "subs is: {<read:da-sub>}"
    [cards this]
  ::
      %sss-fake-on-rock  ::  SSS boilerplate
    :_  this
    ?-  msg=!<(from:da-sub (fled:sss vase))
      [sss-path *]  (handle-fake-on-rock:da-sub msg)
    ==
  ==
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+  path  (on-peek:default path)
    [%x %review ~]
  ``noun+!>(get-reviews)
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  :_  this
  ?+    path  !!
      [%adverts ~]
    ~&  "watching our adverts"
    [%give %fact ~ %advert-update !>(`update:advert`[%gather get-adverts])]~
    ::
      [%reports ~]
    ~&  "watching reports"
    [%give %fact ~ %report-update !>(`update:report`[%gather get-reports])]~
    ::
      [%reviews ~]
    ~&  "watching reviews"
    [%give %fact ~ %review-update !>(`update:review`[%gather get-reviews])]~
    ::
      [%~.~ %gossip %source ~]  ::  a %pal will subscribe here
    ::  give an inital update to him
    ::
    [%give %fact ~ %discovery-friend !>([now.bowl our.bowl])]~
    ::
      [%their %adverts ~]  :: should this be a scry endpoint?
    ~&  "watching their adverts"
    ::  send all ads that we received
    ::  ordered by peer (the frontend needs to order by date)
    ::
    [%give %fact ~ %advert-update !>(`update:advert`[%gather get-their-adverts])]~
    ::
    ::  What orders endpoints do we need?
    ::  get all 'their' reviews/reports? reviews/reports by user?
    ::
  ==
++  on-arvo   on-arvo:default
::
++  on-leave  on-leave:default
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:default wire sign)
  ::
      [~ %sss %on-rock @ @ @ sss-path]  ::  SSS boilerplate
    =.  subs  (chit:da-sub |3:wire sign)
    :: ~&  >  "subs is: {<read:da-sub>}"
    `this 
  ::
      [~ %sss %scry-request @ @ @ sss-path]  ::  SSS boilerplate
    =^  cards  subs  (tell:da-sub |3:wire sign)
    :: ~&  >  "subs is: {<read:da-sub>}"
    [cards this]
  ::
      [~ %sss %scry-response @ @ @ sss-path]  ::  SSS boilerplate
    =^  cards  pubs  (tell:du-pub |3:wire sign)
    :: ~&  >  "pubs is: {<read:du-pub>}"
    [cards this]
  ::
      [%~.~ %gossip %gossip ~]
    ?>  ?=(%fact -.sign)
    ?+    p.cage.sign  (on-agent:default wire sign)
    ::
        %discovery-friend
      ::  we have a new friend
      ::
      ?:  ?|  ?&  (~(has in friends.peers) src.bowl) 
                  (is-subscribed src.bowl)
              ==
              (~(has in blocked.peers) src.bowl)
          ==
        ::  do nothing if already a friend
        ::  or it's blocked
        ::
        `this
      ::  remove from tracking (if there)
      ::
      =.  tracking.peers       (~(del in tracking.peers) src.bowl)
      ::  add to friends
      :: 
      =.  friends.peers        (~(put in friends.peers) src.bowl)
      ::  gossip the friend and subscribe to state
      ::
      =^  sss-cards  subs
      (surf:da-sub src.bowl %bizbaz *sss-path)
      :_  this
      :*  (invent:gossip %discovery-peer !>([now.bowl src.bowl]))
          sss-cards
      ==
      ::
      ::
        %discovery-peer
      ::  hearing about a peer
      ::
      =/  gossip         !<(gossip-peer:discovery q.cage.sign)
      ::  do nothing if we know already
      ::
      ?:  ?|  =(our.bowl peer.gossip)
              (~(has in blocked.peers) peer.gossip)
              (~(has in friends.peers) peer.gossip)
              !(is-subscribed src.bowl)
          ==
        `this
      ::  add to tracking
      ::
      =.  tracking.peers  (~(put in tracking.peers) peer.gossip)
      ::
      ::  subscribe to state and
      ::  poke to tell about us
      ::
      =^  sss-cards  subs
      (surf:da-sub src.bowl %bizbaz *sss-path)
      :_  this
      :-  :*  %pass
              /heard/(scot %p peer.gossip)
              %agent
              [peer.gossip %bizbaz]
              %poke
              %discovery-heard
              !>(peer.gossip)
          ==
          sss-cards
    ==
  ==
::
++  on-fail   on-fail:default
--
::  Helper core
::
|_  [=bowl:gall]
+*  this     .
    da-sub
      =/  da  (da:sss bizbaz-lake sss-path)
      (da subs bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    ::
    du-pub
      =/  du  (du:sss bizbaz-lake sss-path)
      (du pubs bowl -:!>(*result:du))
::
++  get-state                                 ::  returns the state that we published
    =/  state  (~(get by read:du-pub) *sss-path)
    ?~  state
      ~
    rock.u.state
::
++  get-adverts
  =/  state  get-state
  ?~(state ~ adverts.state)
::
++  get-reviews
  =/  state  get-state
  ?~(state ~ reviews.state)
::
++  get-reports
  =/  state  get-state
  ?~(state ~ reports.state)
::
++  get-their-adverts                          :: returns all ads that we received
  ^-  (list advert:advert)
  %-  ~(rep by read:da-sub)
  |=  $:  p=[[ship dude:agent:gall sss-path] [stale=? fail=? =rock:bizbaz-lake]]
          q=(list advert:advert)
      ==
  (weld adverts.rock.p q)
:: 
++  get-advert-by-hash
    |=  hash=@uvH
    =/  state  get-state
    ?~  state
      ~
    i.-:(skim adverts.state |=(a=advert:advert =(hash.a hash)))
::
++  get-report-by-hash
  |=  hash=@uvH
  =/  state  get-state
  ?~  state
    ~
  i.-:(skim reports.state |=(a=report:report =(hash.a hash)))
::
++  get-review-by-hash
    |=  hash=@uvH
    =/  state  get-state
    ?~  state
      ~
    i.-:(skim reviews.state |=(a=review:review =(hash.a hash)))
::
++  is-subscribed
    |=  =ship
    (~(has by read:da-sub) [ship %bizbaz *sss-path])
::
--
