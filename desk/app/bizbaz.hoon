/-  pals, advert, review, vote
/+  advert-lib=advert
/+  vote-lib=vote
/+  review-lib=review
/+  default-agent, dbug, signatures, utils
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  %0 :: TODO: split adverts into myAdverts w sigs & palAdverts where the sigs are validated and then dropped
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
  =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
  ~&  (weld "mutual pals: " (spud (turn ~(tap in pals) |=(pal=ship (scot %p pal)))))
  =/  advert-subs  (turn ~(tap in pals) |=(pal=ship (sub-card:advert-lib pal)))
  =/  vote-subs  (turn ~(tap in pals) |=(pal=ship (sub-card:vote-lib pal)))
  =/  review-subs  (turn ~(tap in pals) |=(pal=ship (sub-card:review-lib pal)))
  :_  this
  %+  weld  advert-subs
  %+  weld  vote-subs
  %+  weld  review-subs
      `(list card)`~[[%pass /eyre %arvo %e %connect [~ /apps/bizbaz] %bizbaz]]
::
++  on-save  :: exports the state before suspending or uninstalling
  !>(state)  
++  on-load  :: imports the state after resuming or reinstalling
  |=  old=vase
  ^-  (quip card _this)
  `this(state !<(state-0 old))
++  on-poke  :: handles one-off requests that may change the data
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?:  ?=(%sub-to-pals mark)
    =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
    ~&  (weld "Subscribing to mutual pals: " (spud (turn ~(tap in pals) |=(pal=ship (scot %p pal)))))
    =/  advert-subs  (turn ~(tap in pals) |=(pal=ship (sub-card:advert-lib pal)))
    =/  vote-subs  (turn ~(tap in pals) |=(pal=ship (sub-card:vote-lib pal)))
    =/  review-subs  (turn ~(tap in pals) |=(pal=ship (sub-card:review-lib pal)))
    :_  this
    %+  weld
        advert-subs
        vote-subs
  ?:  ?=(%syncsubs mark)
    =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
    ~&  (weld "Syncing data w mutual pals: " (spud (turn ~(tap in pals) |=(pal=ship (scot %p pal)))))
    :_  this
    :~  [%give %fact ~[/noun/adverts] %advert-update !>(`update:advert`[%gather adverts])]
        [%give %fact ~[/noun/votes] %vote-update !>(`update:vote`[%gather votes])]
        [%give %fact ~[/noun/reviews] %review-update !>(`update:review`[%gather intents commits reviews])]
    ==
  ?>  |(?=(%advert-action mark) ?=(%vote-action mark) ?=(%review-action mark))
  ?+  mark  !!
    %advert-action
      =/  act  !<(action:advert vase)
      ?-  -.act
          ::
          %create 
        =/  new-advert  ((build:advert-lib bowl) req.act)
        :_  this(adverts [new-advert adverts])
        (pub-card:advert-lib `update:advert`[%create new-advert])
          ::
          %update
        =/  index  ((get-by-hash:advert-lib adverts) advert.act)
        ?~  index
          ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
        =/  new-advert  ((build:advert-lib bowl) req.act)
        :_  this(adverts (snap adverts (need index) new-advert))
        (pub-card:advert-lib `update:advert`[%update advert.act new-advert])
          ::
          %delete
        =/  index  ((get-by-hash:advert-lib adverts) advert.act)
        ?~  index
          ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
        :_  this(adverts (oust [(need index) 1] adverts))
        (pub-card:advert-lib `update:advert`[%delete advert.act])
      == 
    %vote-action
      =/  act  !<(action:vote vase)
      ~&  act
      ?-  -.act
          %vote
            =/  adv-index  ((get-by-hash:advert-lib adverts) advert.req.act)
            ?~  adv-index
              ~|((weld "No advert with hash " (scow %uv advert.req.act)) !!)
            =/  new-vote  ((build-vote:vote-lib bowl) req.act)
            =/  new-votes  ((upsert-vote:vote-lib votes) new-vote)
            :_  this(votes new-votes)
            (pub-card:vote-lib `update:vote`[%vote new-vote])
      == 
    %review-action
      =/  act  !<(action:review vase)
      ~&  act
      ?-  -.act
          %intent
            =/  adv-index  ((get-by-hash:advert-lib adverts) advert.act)
            ?~  adv-index
              ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
            =/  ad  (snag (need adv-index) adverts)
            =/  new-intent  ((build:intent:review-lib bowl) ad)
            ?:  ((exists:intent:review-lib intents) new-intent)
              ~&  "Ignoring duplicate intent"  
              [~ this]
            :_  this(intents [new-intent intents])
            (pub-card:review-lib `update:review`[%intent new-intent])
          %commit
            =/  int-index  ((get-by-hash:intent:review-lib intents) intent.act)
            ?~  int-index
              ~|((weld "No intent with hash " (scow %uv intent.act)) !!)
            =/  int  (snag (need int-index) intents)
            =/  new-commit  ((build:commit:review-lib bowl) int)
            ?:  ((exists:commit:review-lib commits) new-commit)
              ~&  "Ignoring duplicate commit"  
              [~ this]
            =/  new-intents  (oust [(need int-index) 1] intents)  :: remove old intent
            =/  new-commits  [new-commit commits]  :: add new commit
            :_  this(intents new-intents, commits new-commits)
            (pub-card:review-lib `update:review`[%commit new-commit])
          %review
            =/  cmt-index  (find ~[commit.req.act] (turn commits |=(cmt=commit:review hash.cmt)))
            ?~  cmt-index
              ~|((weld "No commit with hash " (scow %uv commit.req.act)) !!)
            =/  cmt  (snag (need cmt-index) commits)
            =/  new-review  (((build:review:review-lib bowl) cmt) req.act)
            ?:  ((exists:review:review-lib reviews) new-review)
              ~&  "Ignoring duplicate review"  
              [~ this]
            =/  new-commits  (oust [(need cmt-index) 1] commits)  :: remove old commit
            =/  new-reviews  [new-review reviews]  :: add new review
            :_  this(commits new-commits, reviews new-reviews)
            (pub-card:review-lib `update:review`[%review new-review])
          %update
            =/  old-index  (find ~[old.act] (turn reviews |=(rev=review:review hash.rev)))
            ?~  old-index
              ~|((weld "No review with hash " (scow %uv old.act)) !!)
            =/  rev  (snag (need old-index) reviews)
            =/  new-review  (((build:review:review-lib bowl) commit.rev) new.act)
            ?:  ((exists:review:review-lib reviews) new-review)
              ~&  "Ignoring no-op review update"  
              [~ this]
            =/  new-reviews  [new-review reviews]  :: add new review
            :_  this(reviews (snap reviews (need old-index) new-review))
            (pub-card:review-lib `update:review`[%update old=old.act new=new-review])
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
      ::  only allow subscriptions by our pals
      ?>  (~(has in pals) src.bowl)
      ::  only share adverts created by our pals, filter out those from pals-of-pals
      =/  pal-adverts  (skim adverts |=(ad=advert:advert (~(has in pals) ship.vendor.ad)))
      [%give %fact ~ %advert-update !>(`update:advert`[%gather pal-adverts])]~
    [%noun %votes ~]
      =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
      ::  only allow subscriptions by our pals
      ?>  (~(has in pals) src.bowl)
      ::  only share votes created by our pals, filter out those from pals-of-pals
      =/  pal-votes  (skim votes |=(vote=vote:vote (~(has in pals) ship.voter.vote)))
      [%give %fact ~ %vote-update !>(`update:vote`[%gather pal-votes])]~
    [%noun %reviews ~]
      =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
      ::  only allow subscriptions by our pals
      ?>  (~(has in pals) src.bowl)
      ::  only share reviews created by our pals, filter out those from pals-of-pals
      =/  pal-intents  (skim intents |=(intent=intent:review (~(has in pals) ship.client.intent)))
      =/  pal-commits  (skim commits |=(commit=commit:review (~(has in pals) ship.vendor.commit)))
      =/  pal-reviews  (skim reviews |=(review=review:review (~(has in pals) ship.reviewer.review)))
      [%give %fact ~ %review-update !>(`update:review`[%gather pal-intents pal-commits pal-reviews])]~
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
      ::
      :: advert subscription updates
      ::
        [%noun %adverts ~]
      ?+  -.sign  (on-agent:default wire sign)
          %fact
        ?+  p.cage.sign  (on-agent:default wire sign)
            %advert-update
          =/  upd  !<(update:advert q.cage.sign)
          ?+  -.upd  !!
              ::
              %gather
            =/  new-adverts  (skip adverts.upd (exists:advert-lib adverts))
            ~&  (log-gather:utils [got=(lent adverts.upd) new=(lent new-adverts) from=src.bowl type="advert"])
            [~ this(adverts (weld new-adverts adverts))]
              ::
              %create
            ~&  "Got a %create %advert-update from our subscription"
            =/  new-advert  advert.upd
            =/  existing-index  (find ~[hash.new-advert] (turn adverts |=(ad=advert:advert hash.ad)))
            ?.  ?~(existing-index %.y %.n)
              ~&  "we already have this advert, doing nothing"
              [~ this]
            :: check if this advert is a duplicate
            ~&  "validating newly created advert:"
            ~&  new-advert
            :: TODO: jael-scry is broken on fake ships, uncomment before live deployment
            :: ?.  (validate:advert-lib new-advert)
            ::   ~&  "Crashing, received advert is invalid"
            ::   !!
            :: TODO: ensure the new when.body is newer than the existing one
            ~&  (weld "%create: valid advert received from " (scow %p src.bowl))
            =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
            =/  is-pal  ?~((find ~[ship.vendor.new-advert] ~(tap in pals)) %.n %.y)
            ?:  is-pal
              ~&  "new advert was created by our pal, re-broadcasting to our pals"
              :_  this(adverts [new-advert adverts])
              :~  [%give %fact ~[/json/adverts] %advert-update !>(`update:advert`[%create new-advert])]
                  [%give %fact ~[/noun/adverts] %advert-update !>(`update:advert`[%create new-advert])]
              ==
            ~&  "new advert was NOT created by our pal, not re-broadcasting"
            :_  this(adverts [new-advert adverts])
            :~  [%give %fact ~[/json/adverts] %advert-update !>(`update:advert`[%create new-advert])]
            ==
            ::   %update
            :: ~&  "%update: replacemet advert received"
            :: !!
            ::   %delete
            :: ~&  "%delete: removing old advert"
            :: !!
          ==
        ==
      ==
      ::
      :: vote subscription updates
      ::
        [%noun %votes ~]
      ?+  -.sign  (on-agent:default wire sign)
        %fact
        ?+  p.cage.sign  (on-agent:default wire sign)
            %vote-update
          =/  upd  !<(update:vote q.cage.sign)
          ?-  -.upd
              ::
              %gather
            =/  new-votes  (skip votes.upd (vote-exists:vote-lib votes))
            ~&  (log-gather:utils [got=(lent votes.upd) new=(lent new-votes) from=src.bowl type="vote"])
            [~ this(votes (weld new-votes votes))]
              ::
              %vote
            ~&  "Got a %create %vote-update from our subscription"
            =/  new-vote  vote.upd
            =/  adv-index  ((get-by-hash:advert-lib adverts) advert.body.new-vote)
            ?~  adv-index
              ~|((weld "No advert with hash " (scow %uv advert.body.new-vote)) !!)
            :: TODO: jael-scry is broken on fake ships, uncomment before live deployment
            :: ?.  (validate:vote-lib new-vote)
            ::   ~&  "Crashing, received vote is invalid"
            ::   !!
            ~&  (weld "%vote: valid vote received from " (scow %p src.bowl))
            =/  new-votes  ((upsert-vote:vote-lib votes) new-vote)
            =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
            =/  is-pal  ?~((find ~[ship.voter.new-vote] ~(tap in pals)) %.n %.y)
            :: TODO: upsert
            ?:  is-pal
              ~&  "new vote was created by our pal, re-broadcasting to our pals"
              :_  this(votes new-votes)
              :~  [%give %fact ~[/json/votes] %vote-update !>(`update:vote`[%vote new-vote])]
                  [%give %fact ~[/noun/votes] %vote-update !>(`update:vote`[%vote new-vote])]
              ==
            ~&  "new vote was NOT created by our pal, not re-broadcasting"
            :_  this(votes new-votes)
            :~  [%give %fact ~[/json/votes] %vote-update !>(`update:vote`[%vote new-vote])]
            ==
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
