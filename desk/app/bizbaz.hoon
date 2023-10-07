/-  advert
/-  vote
/-  review
/-  pals
/+  signatures
/+  default-agent, dbug
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  %0
      adverts=(list advert:advert)
      votes=(list vote:vote)
      intents=(list intent:review)
      commits=(list commit:review)
      reviews=(list review:review)
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
++  on-init  :: runs one time after installing to set up the initial state
  ^-  (quip card _this)
  ~&  >  "%bizbaz initialized successfully."
  :_  this
  :~  [%pass /eyre %arvo %e %connect [~ /apps/bizbaz] %bizbaz]
  ==
++  on-save  :: exports the state before suspending or uninstalling
  !>(state)  
++  on-load  :: imports the state after resuming or reinstalling
  |=  old=vase
  ^-  (quip card _this)
  `this(state !<(state-0 old))
++  on-poke  :: handles one-off requests that may change the data
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?:  ?=(%resubscribe mark)
    =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
    ~&  (weld "mutual pals: " (spud (turn ~(tap in pals) |=(pal=ship (scot %p pal)))))
    :_  this
    (turn ~(tap in pals) |=(pal=ship [%pass /noun/adverts %agent [pal %bizbaz] %watch /noun/adverts]))
  ?:  ?=(%syncsubs mark)
    =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
    ~&  (weld "mutual pals: " (spud (turn ~(tap in pals) |=(pal=ship (scot %p pal)))))
    :_  this
    (turn ~(tap in pals) |=(pal=ship [%give %fact ~[/noun/adverts] %advert-update !>(`update:advert`[%gather adverts])]))
  ?>  |(?=(%advert-action mark) ?=(%vote-action mark) ?=(%review-action mark))
  ?+  mark  !!
    %advert-action
      =/  act  !<(action:advert vase)
      ?-  -.act
          %create 
            =/  advert-body
              :*  title=title.body.act
                  cover=cover.body.act
                  tags=`(list @tas)`tags.body.act
                  description=description.body.act
                  when=now.bowl
              ==
            =/  hash  (sham advert-body)
            =/  new-advert
              :*  hash=hash
                  vendor=(sign:signatures our.bowl now.bowl hash)
                  advert-body
              ==
              :_  this(adverts [new-advert adverts])
              :~  [%give %fact ~[/json/adverts] %advert-update !>(`update:advert`[%gather [new-advert adverts]])]
                  [%give %fact ~[/noun/adverts] %advert-update !>(`update:advert`[%create new-advert])]
              ==
          %delete
            =/  index  (find ~[advert.act] (turn adverts |=(ad=advert:advert hash.ad)))
            ?~  index
              ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
            [~ this(adverts (oust [(need index) 1] adverts))]
          %update
            =/  index  (find ~[advert.act] (turn adverts |=(ad=advert:advert hash.ad)))
            ?~  index
              ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
            =/  advert-body
              :*  title=title.body.act
                  cover=cover.body.act
                  tags=`(list @tas)`tags.body.act
                  description=description.body.act
                  when=now.bowl
              ==
            =/  hash  (sham advert-body)
            =/  new-advert
              :*  hash=hash
                  vendor=(sign:signatures our.bowl now.bowl hash)
                  advert-body
              ==
            [~ this(adverts (snap adverts (need index) new-advert))]
      == 
    %vote-action
      =/  act  !<(action:vote vase)
      ~&  act
      ?-  -.act
          %vote
            =/  index  (find ~[advert.act] (turn adverts |=(ad=advert:advert hash.ad)))
            ?~  index
              ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
            =/  ad  (snag (need index) adverts)
            =/  target  ship.vendor.ad
            =/  vote-body  [advert=advert.act vendor=target when=now.bowl choice=choice.act]
            =/  hash  (sham vote-body)
            =/  new-vote
              :*  hash
                  voter=(sign:signatures our.bowl now.bowl hash)
                  body=vote-body
              ==
            [~ this(votes [new-vote votes])]
      == 
    %review-action
      =/  act  !<(action:review vase)
      ~&  act
      ?-  -.act
          %intent
            =/  index  (find ~[advert.act] (turn adverts |=(ad=advert:advert hash.ad)))
            ?~  index
              ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
            =/  ad  (snag (need index) adverts)
            =/  intent-body 
              :*  advert=advert.act
                  vendor=vendor.ad
                  when=now.bowl
              ==
            =/  hash  (sham intent-body)
            =/  new-intent
              :*  hash=hash
                  client=(sign:signatures our.bowl now.bowl advert.act)
                  body=intent-body
              ==
            [~ this(intents [new-intent intents])]
          %commit
            =/  index  (find ~[intent.act] (turn intents |=(ad=intent:review hash.ad)))
            ?~  index
              ~|((weld "No intent with hash " (scow %uv intent.act)) !!)
            =/  intent  (snag (need index) intents)
            =/  commit-body
              :*  intent=intent.act
                  client=client.intent
                  when=now.bowl
              ==
            =/  hash  (sham commit-body)
            =/  new-commit
              :*  hash=hash
                  vendor=(sign:signatures our.bowl now.bowl intent.act)
                  body=commit-body
                  intent=body.intent
              ==
            [~ this(commits [new-commit commits])] :: todo: remove relevant intent from state
          %review
            =/  index  (find ~[commit.body.act] (turn commits |=(cmt=commit:review hash.cmt)))
            ?~  index
              ~|((weld "No commit with hash " (scow %uv commit.body.act)) !!)
            =/  commit  (snag (need index) commits)
            =/  review-body
              :*  commit=hash.commit
                  reviewee=reviewee.body.act
                  score=score.body.act
                  why=why.body.act
                  when=now.bowl
              ==
            =/  hash  (sham review-body)
            =/  new-review
              :*  hash=hash
                  reviewer=(sign:signatures our.bowl now.bowl hash)
                  body=review-body
                  commit=commit
              ==
            [~ this(reviews [new-review reviews])]
          %update
            :: TODO: find & replace the one w matching hash
            !! :: [~ this(reviews [review.act reviews])]
      == 
  ==
++  on-peek  :: handles one-off read-only requests
  |=  =path
  ^-  (unit (unit cage))
  ?+  path  (on-peek:default path)
    [%x %review ~]  ``noun+!>(reviews)
  ==
++  on-watch  :: handles subscription requests
  |=  =path
  ^-  (quip card _this)
  :: ?>  |(?=(%reviews path) ?=(%adverts path))
  :: ~&  path
  :_  this
  ?+  path  (on-watch:default path)
    :: paths for serving noun data to other ships
    [%noun %adverts ~]
      =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
      ?>  (~(has in pals) src.bowl)
      [%give %fact ~ %advert-update !>(`update:advert`[%gather adverts])]~
    :: paths for serving json data to the UI
    [%json %adverts ~]
      =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
      ~&  (weld "mutual pals: " (spud (turn ~(tap in pals) |=(pal=ship (scot %p pal)))))
      ~&  "watching adverts"
      [%give %fact ~ %advert-update !>(`update:advert`[%gather adverts])]~
    [%json %votes ~]
      ~&  "watching votes"
      [%give %fact ~ %vote-update !>(`update:vote`[%gather votes])]~
    [%json %reviews ~]
      ~&  "watching intents & commits & reviews"
      [%give %fact ~ %review-update !>(`update:review`[%gather intents commits reviews])]~
  ==
++  on-arvo  :: handles responses from vanes
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?.  ?=([%eyre %bound *] sign-arvo)
    (on-arvo:default [wire sign-arvo])
  ?:  accepted.sign-arvo
    %-  (slog leaf+"/apps/bizbaz bound successfully!" ~)
    `this
  %-  (slog leaf+"Binding /apps/bizbaz failed!" ~)
  `this
++  on-leave  :: handles unsubscription notifications, etc
  on-leave:default
++  on-agent  :: handles subscription updates and request acknowledgements from other agents
    |=  [=wire =sign:agent:gall]
    ^-  (quip card _this)
    ?+  wire  (on-agent:default wire sign)
        [%noun %adverts ~]
      ?+  -.sign  (on-agent:default wire sign)
        %fact
        ?+  p.cage.sign  (on-agent:default wire sign)
            %advert-update
          =/  upd  !<(update:advert q.cage.sign)
          ~&  upd
          ?+  -.upd  !!
              %gather
            ~&  "%gather: new adverts received"
            [~ this(adverts +.upd)]  :: todo: don't do this
              %create
            ~&  "%create: new advert received"
            :: validate that this advert is valid, if not drop it
            :: if (came from a pal) broadcast to all other pals
            :: else don't
            [~ this(adverts [+.upd adverts])]
          ==
        ==
      ==
      :: [%newpals ~]
      :: ?+  -.sign  `this
      ::   %fact
      ::   ?+  p.cage.sign  `this
      ::       %pals-effect
      ::     =/  fx  !<(effect:pals q.cage.sign)
      ::     ?+    -.fx  (on-agent:default wire sign)
      ::         %meet
      ::       :_  this ::(adverts adverts.upd)
      ::       :~  [%pass /bizbaz %agent [+.fx %gather] %watch /bizbaz]
      ::       ==
      ::         %part
      ::       :_  this(adverts adverts.upd)
      ::       :~  [%pass /bizbaz %agent [+.fx %gather] %leave /bizbaz]
      ::       ==
      ::     ==
      ::   ==
      :: ==
    ==

++  on-fail  :: runs during certain types of crashes
  on-fail:default
--

