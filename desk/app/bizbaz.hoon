/-  pals, advert, review, vote
/+  advlib=advert
/+  votlib=vote
/+  intlib=intent
/+  cmtlib=commit
/+  revlib=review
/+  default-agent, dbug, signatures, utils
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
  :: TODO: warn user if pals is not installed yet
  =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
  ~&  (weld "subscribing to mutual pals: " (spud (turn ~(tap in pals) |=(pal=ship (scot %p pal)))))
  =/  advsubs  (turn ~(tap in pals) |=(pal=ship (sub-card:advlib pal)))
  =/  votsubs  (turn ~(tap in pals) |=(pal=ship (sub-card:votlib pal)))
  =/  revsubs  (turn ~(tap in pals) |=(pal=ship (sub-card:revlib pal)))
  :_  this
  %+  weld  advsubs
  %+  weld  votsubs  revsubs
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
  ?:  ?=(%sync mark)
    =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
    ~&  (weld "Syncing data w mutual pals: " (spud (turn ~(tap in pals) |=(pal=ship (scot %p pal)))))
    ::  only share data from our direct pals
    =/  paladvs  (skim adverts |=(adv=advert:advert |((~(has in pals) ship.vendor.adv) =(our.bowl ship.vendor.adv))))
    =/  palvots  (skim votes |=(vote=vote:vote |((~(has in pals) ship.voter.vote) =(our.bowl ship.voter.vote))))
    =/  palints  (skim intents |=(int=intent:review |((~(has in pals) ship.client.int) =(our.bowl ship.client.int))))
    =/  palcmts  (skim commits |=(cmt=commit:review |((~(has in pals) ship.vendor.cmt) =(our.bowl ship.vendor.cmt))))
    =/  palrevs  (skim reviews |=(rev=review:review |((~(has in pals) ship.reviewer.rev) =(our.bowl ship.reviewer.rev))))
    ::  gather list of subscription cards
    =/  advsubs  `(list card)`(turn ~(tap in pals) |=(pal=ship (sub-card:advlib pal)))
    =/  votsubs  `(list card)`(turn ~(tap in pals) |=(pal=ship (sub-card:votlib pal)))
    =/  revsubs  `(list card)`(turn ~(tap in pals) |=(pal=ship (sub-card:revlib pal)))
    :_  this
    ::  weld subscription cards to data push cards
    %+  weld  advsubs
    %+  weld  votsubs
    %+  weld  revsubs
    :~  `card`[%give %fact ~[/noun/adverts] %advert-update !>(`update:advert`[%gather paladvs])]
        `card`[%give %fact ~[/noun/votes] %vote-update !>(`update:vote`[%gather palvots])]
        `card`[%give %fact ~[/noun/reviews] %review-update !>(`update:review`[%gather palints palcmts palrevs])]
        :: subscribe to pals updates
        `card`[%give %fact ~[/noun/reviews] %review-update !>(`update:review`[%gather palints palcmts palrevs])]
        :: `card`[%pass /pals/targets %agent [our.bowl %pals] %watch /targets]
        :: `card`[%pass /pals/leeches %agent [our.bowl %pals] %watch /leeches]
    ==
  ?>  |(?=(%advert-action mark) ?=(%vote-action mark) ?=(%review-action mark))
  ?+    mark  !!
  ::
  :: advert poke responses
  ::
      %advert-action
    =/  act  !<(action:advert vase)
    ?-    -.act
    ::
        %create 
      =/  new-advert  ((build:advlib bowl) req.act)
      :_  this(adverts [new-advert adverts])
      ~&  "Created new advert, publishing it"
      (pub-card:advlib `update:advert`[%create new-advert])
    ::
        %update
      =/  index  ((get-by-hash:advlib adverts) advert.act)
      ?~  index
        ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
      =/  new-advert  ((build:advlib bowl) req.act)
      :_  this(adverts (snap adverts (need index) new-advert))
      (pub-card:advlib `update:advert`[%update advert.act new-advert])
    ::
        %delete
      =/  index  ((get-by-hash:advlib adverts) advert.act)
      ?~  index
        ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
      :_  this(adverts (oust [(need index) 1] adverts))
      (pub-card:advlib `update:advert`[%delete advert.act])
    == 
  ::
  :: vote poke responses
  ::
      %vote-action
    =/  act  !<(action:vote vase)
    ~&  act
    ?-    -.act
    ::
        %vote
      =/  adv-index  ((get-by-hash:advlib adverts) advert.req.act)
      ?~  adv-index
        ~|((weld "No advert with hash " (scow %uv advert.req.act)) !!)
      =/  new-vote  (((build-vote:votlib bowl) adverts) req.act)
      =/  new-votes  ((upsert-vote:votlib votes) new-vote)
      ?:  ?&(=(ship.voter.new-vote src.bowl) =(choice.body.new-vote %down))
          :_  this(votes new-votes, adverts (oust [(need adv-index) 1] adverts))
          (pub-card:votlib `update:vote`[%vote new-vote])
      :_  this(votes new-votes)
      (pub-card:votlib `update:vote`[%vote new-vote])
    == 
  ::
  :: review poke responses
  ::
      %review-action
    =/  act  !<(action:review vase)
    ~&  act
    ?-    -.act
    ::
        %intent
      =/  adv-index  ((get-by-hash:advlib adverts) advert.act)
      ?~  adv-index
        ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
      =/  ad  (snag (need adv-index) adverts)
      =/  new-intent  ((build:intlib bowl) ad)
      ?:  ((exists:intlib intents) new-intent)
        ~&  "Ignoring duplicate intent"  
        [~ this]
      :_  this(intents [new-intent intents])
      (pub-card:revlib `update:review`[%intent new-intent])
    ::
        %commit
      =/  int-index  ((get-by-hash:intlib intents) intent.act)
      ?~  int-index
        ~|((weld "No intent with hash " (scow %uv intent.act)) !!)
      =/  int  (snag (need int-index) intents)
      =/  new-commit  ((build:cmtlib bowl) int)
      ?:  ((exists:cmtlib commits) new-commit)
        ~&  "Ignoring duplicate commit"  
        [~ this]
      =/  new-intents  (oust [(need int-index) 1] intents)  :: remove old intent
      =/  new-commits  [new-commit commits]  :: add new commit
      :_  this(intents new-intents, commits new-commits)
      (pub-card:revlib `update:review`[%commit new-commit])
    ::
        %review
      =/  cmt-index  (find ~[commit.req.act] (turn commits |=(cmt=commit:review hash.cmt)))
      ?~  cmt-index
        ~|((weld "No commit with hash " (scow %uv commit.req.act)) !!)
      =/  cmt  (snag (need cmt-index) commits)
      =/  new-review  (((build:revlib bowl) cmt) req.act)
      ?:  ((exists:revlib reviews) new-review)
        ~&  "Ignoring duplicate review"  
        [~ this]
      =/  new-commits  (oust [(need cmt-index) 1] commits)  :: remove old commit
      =/  new-reviews  [new-review reviews]  :: add new review
      :_  this(commits new-commits, reviews new-reviews)
      (pub-card:revlib `update:review`[%review new-review])
    ::
        %update
      =/  old-index  (find ~[old.act] (turn reviews |=(rev=review:review hash.rev)))
      ?~  old-index
        ~|((weld "No review with hash " (scow %uv old.act)) !!)
      =/  rev  (snag (need old-index) reviews)
      =/  new-review  (((build:revlib bowl) commit.rev) new.act)
      ?:  ((exists:revlib reviews) new-review)
        ~&  "Ignoring no-op review update"  
        [~ this]
      =/  new-reviews  [new-review reviews]  :: add new review
      :_  this(reviews (snap reviews (need old-index) new-review))
      (pub-card:revlib `update:review`[%update old=old.act new=new-review])
    == 
  ==
++  on-peek  :: handles one-off read-only requests
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:default path)
    [%x %review ~]  ``noun+!>(reviews)
  ==
++  on-watch  :: handles subscription requests
  |=  =path
  ^-  (quip card _this)
  :: ~&  path
  :_  this
  ?+    path  (on-watch:default path)
  ::
  :: paths for serving noun data to other ships
  ::
      [%noun %adverts ~]
    =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
    ::  only allow subscriptions by our pals
    ?>  (~(has in pals) src.bowl)
    ::  only share adverts created by our pals, filter out those from pals-of-pals
    =/  pal-adverts  (skim adverts |=(ad=advert:advert (~(has in pals) ship.vendor.ad)))
    [%give %fact ~ %advert-update !>(`update:advert`[%gather pal-adverts])]~
  ::
      [%noun %votes ~]
    =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
    ::  only allow subscriptions by our pals
    ?>  (~(has in pals) src.bowl)
    ::  only share votes created by our pals, filter out those from pals-of-pals
    =/  pal-votes  (skim votes |=(vote=vote:vote (~(has in pals) ship.voter.vote)))
    [%give %fact ~ %vote-update !>(`update:vote`[%gather pal-votes])]~
  ::
      [%noun %reviews ~]
    =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
    ::  only allow subscriptions by our pals
    ?>  (~(has in pals) src.bowl)
    ::  only share reviews created by our pals, filter out those from pals-of-pals
    =/  pal-intents  (skim intents |=(intent=intent:review (~(has in pals) ship.client.intent)))
    =/  pal-commits  (skim commits |=(commit=commit:review (~(has in pals) ship.vendor.commit)))
    =/  pal-reviews  (skim reviews |=(review=review:review (~(has in pals) ship.reviewer.review)))
    [%give %fact ~ %review-update !>(`update:review`[%gather pal-intents pal-commits pal-reviews])]~
  ::
  :: paths for serving json data to the UI
  ::
      [%json %adverts ~]
    =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
    ~&  (weld "mutual pals: " (spud (turn ~(tap in pals) |=(pal=ship (scot %p pal)))))
    :: ~&  "watching adverts"
      [%give %fact ~ %advert-update !>(`update:advert`[%gather adverts])]~
  ::
      [%json %votes ~]
    ~&  "watching votes"
    [%give %fact ~ %vote-update !>(`update:vote`[%gather votes])]~
  ::
      [%json %reviews ~]
    :: ~&  "watching intents & commits & reviews"
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
  ~&  (weld "got new subscription update from wire: " (spud wire))
  ?+    wire  (on-agent:default wire sign)
  ::
  :: advert subscription updates
  ::
      [%noun %adverts ~]
    ?+    -.sign  (on-agent:default wire sign)
        %fact
      :: this wire only handles advert updates
      ?.  =(p.cage.sign %advert-update)
        (on-agent:default wire sign)
      =/  upd  !<(update:advert q.cage.sign)
      ?-    -.upd
      ::
          %gather
        =/  new-adverts  (skip adverts.upd (exists:advlib adverts))
        =/  gud-adverts  (skim new-adverts (validate:advlib bowl))
        ~&  (log-gather:utils [got=(lent adverts.upd) new=(lent gud-adverts) from=src.bowl type="advert"])
        [~ this(adverts (weld gud-adverts adverts))]
      ::
          %create
        ~&  "Got a %create %advert-update from our subscription"
        =/  new-advert  advert.upd
        =/  existing-index  (find ~[hash.new-advert] (turn adverts |=(ad=advert:advert hash.ad)))
        ?.  ?~(existing-index %.y %.n)
          ~&  "we already have this advert, doing nothing"
          [~ this]
        ~&  "validating newly created advert"
        ?.  ((validate:advlib bowl) new-advert)
          ~&  "Crashing, received advert is invalid"
          !!
        ~&  (weld "%create: valid advert received from " (scow %p src.bowl))
        =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
        =/  is-pal  ?~((find ~[ship.vendor.new-advert] ~(tap in pals)) %.n %.y)
        ?:  is-pal
          ~&  "new advert was created by our pal, re-broadcasting to our pals"
          :_  this(adverts [new-advert adverts])
          (pub-card:advlib [%create new-advert])
        ~&  "new advert was NOT created by our pal, not re-broadcasting"
        :_  this(adverts [new-advert adverts])
        :~  [%give %fact ~[/json/adverts] %advert-update !>(`update:advert`[%create new-advert])]
        ==
      ::
          %update
        ~&  (weld "Got an advert %update from " (scow %p src.bowl))
        =/  old-hash  old.upd
        =/  new-advert  new.upd
        =/  existing-index  ((get-by-hash:advlib adverts) hash.new-advert)
        ?.  ?~(existing-index %.y %.n)
          ~&  "we already have this advert, doing nothing"
          [~ this]
        =/  old-ad-index  ((get-by-hash:advlib adverts) old-hash)
        =/  old-advert  (snag (need old-ad-index) adverts)
        ?:  (lth when.body.new-advert when.body.old-advert)
          ~&  "Ignoring updated advert that's older than the existing one"
          [~ this]
        ~&  new-advert
        ?.  ((validate:advlib bowl) new-advert)
          ~&  "Crashing, received advert is invalid"
          !!
        =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
        =/  is-pal  ?~((find ~[ship.vendor.new-advert] ~(tap in pals)) %.n %.y)
        ?:  is-pal
          ~&  "new advert was updated by our pal, re-broadcasting to our pals"
          ?.  ?~(old-ad-index %.y %.n)
            :_  this(adverts (snap adverts (need old-ad-index) new-advert))
            (pub-card:advlib [%update old-hash new-advert])
          :_  this(adverts [new-advert adverts])
          (pub-card:advlib [%update old-hash new-advert])
        ~&  "new advert was NOT updated by our pal, not re-broadcasting"
        ?.  ?~(old-ad-index %.y %.n)
          :_  this(adverts (snap adverts (need old-ad-index) new-advert))
          :~  [%give %fact ~[/json/adverts] %advert-update !>(`update:advert`[%update old-hash new-advert])]
          ==
        :_  this(adverts [new-advert adverts])
        :~  [%give %fact ~[/json/adverts] %advert-update !>(`update:advert`[%update old-hash new-advert])]
        ==
      ::
          %delete
        ~&  "Got a %delete %advert-update from our subscription"
        =/  hash  advert.upd
        =/  index  ((get-by-hash:advlib adverts) hash)
        =/  ad  (snag (need index) adverts)
        ?:  ?~(index %.y %.n)
          ~&  "we do not have this advert, doing nothing"
          [~ this]
        :: TODO: think of validation logic for delete request so
        :: that a malicious ship cannot shadow ban ad advert by
        :: sending a delete update to network
        ?.  ((validate:advlib bowl) ad)
          ~&  "Crashing, received advert is invalid"
          !!
        =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
        =/  is-pal  ?~((find ~[ship.vendor.ad] ~(tap in pals)) %.n %.y)
        ?:  is-pal
          ~&  "advert was deleted by our pal, re-broadcasting to our pals"
          :_  this(adverts (oust [(need index) 1] adverts))
          :~  [%give %fact ~[/json/adverts] %advert-update !>(`update:advert`[%delete hash])]
              [%give %fact ~[/noun/adverts] %advert-update !>(`update:advert`[%delete hash])]
          ==
        ~&  "advert was NOT deleted by our pal, not re-broadcasting"
        :_  this(adverts (oust [(need index) 1] adverts))
        :~  [%give %fact ~[/json/adverts] %advert-update !>(`update:advert`[%delete hash])]
        ==
      ==
    ==
  ::
  :: vote subscription updates
  ::
      [%noun %votes ~]
    ?+    -.sign  (on-agent:default wire sign)
        %fact
      :: this wire only handles vote updates
      ?.  =(p.cage.sign %vote-update)
        (on-agent:default wire sign)
      =/  upd  !<(update:vote q.cage.sign)
      ?-    -.upd
      ::
          %gather
        =/  new-votes  (skip votes.upd (vote-exists:votlib votes))
        =/  gud-votes  (skim new-votes ((validate:votlib bowl) adverts))
        ~&  (log-gather:utils [got=(lent votes.upd) new=(lent gud-votes) from=src.bowl type="vote"])
        [~ this(votes (weld gud-votes votes))]
      ::
          %vote
        ~&  (weld "Got a %vote update from " (scow %p src.bowl))
        =/  new-vote  vote.upd
        ?.  (((validate:votlib bowl) adverts) new-vote)
          ~&  "Crashing, invalid vote received"
          !!
        :: TODO: drop adverts that we downvote therefore, only allow unvotes on upvotes
        =/  new-votes  ((upsert-vote:votlib votes) new-vote)
        =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
        =/  is-pal  ?~((find ~[ship.voter.new-vote] ~(tap in pals)) %.n %.y)
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
  ::
  :: review subscription updates
  ::
      [%noun %reviews ~]
    ?+    -.sign  (on-agent:default wire sign)
        %fact
      :: this wire only handles review updates
      ?.  =(p.cage.sign %review-update)
        (on-agent:default wire sign)
      =/  upd  !<(update:review q.cage.sign)
      ?-    -.upd
      ::
          %gather
        :: handle new intents
        =/  new-intents  (skip intents.upd (exists:intlib intents))
        =/  gud-intents  (skim new-intents (validate:intlib bowl))
        ~&  (log-gather:utils [got=(lent intents.upd) new=(lent new-intents) from=src.bowl type="intent"])
        =/  set-intents  (weld gud-intents intents)
        :: handle new commits
        =/  new-commits  (skip commits.upd (exists:cmtlib commits))
        =/  gud-commits  (skim new-commits (validate:cmtlib bowl))
        ~&  (log-gather:utils [got=(lent commits.upd) new=(lent new-commits) from=src.bowl type="commit"])
        =/  set-commits  (weld new-commits commits)
        :: handle new reviews
        =/  new-reviews  (skip reviews.upd (exists:revlib reviews))
        =/  gud-reviews  (skim new-reviews (validate:revlib bowl))
        ~&  (log-gather:utils [got=(lent reviews.upd) new=(lent new-reviews) from=src.bowl type="review"])
        =/  set-reviews  (weld gud-reviews reviews)
        :: add new data to state
        [~ this(intents set-intents, commits set-commits, reviews set-reviews)]
      ::
          %intent
        ~&  "Got a new intent from our subscription"
        =/  new-intent  intent.upd
        =/  adv-index  ((get-by-hash:advlib adverts) advert.body.new-intent)
        ?~  adv-index
          ~&  "Ignoring intent without an associated advert"
          [~ this]
        =/  int-index  ((get-by-hash:intlib intents) hash.new-intent)
        ?.  ?~(int-index %.y %.n)
          ~&  "Ignoring duplicate intent"
          [~ this]
        ?.  ((validate:intlib bowl) new-intent)
          ~&  "Crashing, received intent is invalid"
          !!
        ?.  =(ship.vendor.body.new-intent our.bowl)
          =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
          =/  is-pal  ?~((find ~[ship.client.new-intent] ~(tap in pals)) %.n %.y)
          ?:  is-pal
            ~&  "new intent by pal doesn't concern us, re-broadcasting to our pals"
            :_  this
            :~  [%give %fact ~[/noun/reviews] %review-update !>(`update:review`[%intent new-intent])]
            ==
          ~&  "new intent by non-pal doesn't concern us, ignoring it"
          [~ this]
        ~&  (weld "%intent received from " (scow %p src.bowl))
        :_  this(intents [new-intent intents])
        :~  [%give %fact ~[/json/reviews] %review-update !>(upd)]
        ==
      ::
          %commit
        ~&  "Got a new commit from our subscription"
        =/  new-commit  commit.upd
        =/  cmt-index  ((get-by-hash:cmtlib commits) hash.new-commit)
        ?.  ?~(cmt-index %.y %.n)
          ~&  "Ignoring duplicate commit"
          [~ this]
        ?.  ((validate:cmtlib bowl) new-commit)
          ~&  "Crashing, received commit is invalid"
          !!
        ?.  =(ship.client.body.new-commit our.bowl)
          =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
          =/  is-pal  ?~((find ~[ship.vendor.new-commit] ~(tap in pals)) %.n %.y)
          ?:  is-pal
            ~&  "new commit by pal doesn't concern us, re-broadcasting to our pals"
            :_  this
            :~  [%give %fact ~[/noun/reviews] %review-update !>(`update:review`[%commit new-commit])]
            ==
          ~&  "new commit by non-pal doesn't concern us, ignoring it"
          [~ this]
        ~&  (weld "%commit received from " (scow %p src.bowl))
        =/  int-index  ((get-by-hash:intlib intents) intent.body.new-commit)
        =/  new-intents  (oust [(need int-index) 1] intents)  :: remove old intent
        =/  new-commits  [new-commit commits]  :: add new commit
        :_  this(intents new-intents, commits new-commits)
        :~  [%give %fact ~[/json/reviews] %review-update !>(upd)]
        ==
      ::
          %review
        ~&  "Got a new review from our subscription"
        =/  new-review  review.upd
        =/  rev-index  ((get-by-hash:revlib reviews) hash.new-review)
        ?.  ?~(rev-index %.y %.n)
          ~&  "Ignoring duplicate review"
          [~ this]
        ?.  ((validate:revlib bowl) new-review)
          ~&  "Crashing, received review is invalid"
          !!
        ~&  (weld "valid review received from " (scow %p src.bowl))
        =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
        =/  is-pal  ?~((find ~[ship.reviewer.new-review] ~(tap in pals)) %.n %.y)
        ?:  is-pal
          ~&  "new review was created by our pal, re-broadcasting to our pals"
          :_  this(reviews [new-review reviews])
          :~  [%give %fact ~[/json/reviews] %review-update !>(`update:review`[%review new-review])]
              [%give %fact ~[/noun/reviews] %review-update !>(`update:review`[%review new-review])]
          ==
        ~&  "new review was NOT created by our pal, not re-broadcasting"
        :_  this(reviews [new-review reviews])
        :~  [%give %fact ~[/json/reviews] %review-update !>(`update:review`[%review new-review])]
        ==
      ::
          %update
        ~&  "Got a review update from our subscription"
        =/  new-review  new.upd
        =/  rev-index  ((get-by-hash:revlib reviews) hash.new-review)
        ?~  rev-index
          ~&  "Ignoring duplicate review"
          [~ this]
        ?.  ((validate:revlib bowl) new-review)
          ~&  "Crashing, received review is invalid"
          !!
        :: TODO: ensure the new when.body is newer than the existing one
        ~&  (weld "%review: valid review update received from " (scow %p src.bowl))
        =/  new-reviews  ((upsert:revlib reviews) new-review)
        =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
        =/  is-pal  ?~((find ~[ship.reviewer.new-review] ~(tap in pals)) %.n %.y)
        ?:  is-pal
          ~&  "new review was updated by our pal, re-broadcasting to our pals"
          :_  this(reviews new-reviews)
          (pub-card:revlib `update:review`[%update old=old.upd new=new-review])
        ~&  "new review was NOT updated by our pal, not re-broadcasting"
        :_  this(reviews new-reviews)
        :~  [%give %fact ~[/json/reviews] %review-update !>(upd)]
        ==
      ==
    ==
  ::
  :: pals subscription updates
  ::
    ::   [%pals %target ~]
    :: ?+    -.sign  (on-agent:default wire sign)
    ::     %fact
    ::   :: this wire only handles pal effects
    ::   ~&  "Got pals target cage:"
    ::   ~&  cage.sign
    ::   ?.  =(p.cage.sign %pals-effect)
    ::     (on-agent:default wire sign)
    ::   =/  fx  !<(effect:pals q.cage.sign)
    ::   ?+    -.fx  (on-agent:default wire sign)
    ::   ::
    ::       %target
    ::     ~&  (weld "Subscribing to new pal: " "?") :: (scot %p pal)
    ::     ~&  fx
    ::     =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
    ::     =/  pal  ~zod :: TODO set to our real, new pal
    ::     ::  only share data from our direct pals
    ::     =/  paladvs  (skim adverts |=(adv=advert:advert (~(has in pals) ship.vendor.adv)))
    ::     =/  palvots  (skim votes |=(vote=vote:vote (~(has in pals) ship.voter.vote)))
    ::     =/  palints  (skim intents |=(int=intent:review (~(has in pals) ship.client.int)))
    ::     =/  palcmts  (skim commits |=(cmt=commit:review (~(has in pals) ship.vendor.cmt)))
    ::     =/  palrevs  (skim reviews |=(rev=review:review (~(has in pals) ship.reviewer.rev)))
    ::     ::  gather list of subscription cards
    ::     =/  advsub  `card`(sub-card:advlib pal)
    ::     =/  votsub  `card`(sub-card:votlib pal)
    ::     =/  revsub  `card`(sub-card:revlib pal)
    ::     :_  this
    ::     ::  subscription to all 3 wires on our new pal
    ::     %+  weld  ~[advsub votsub revsub]
    ::     :: broadcast all of our data so the new pal can grab it
    ::     :~  `card`[%give %fact ~[/noun/adverts] %advert-update !>(`update:advert`[%gather paladvs])]
    ::         `card`[%give %fact ~[/noun/votes] %vote-update !>(`update:vote`[%gather palvots])]
    ::         `card`[%give %fact ~[/noun/reviews] %review-update !>(`update:review`[%gather palints palcmts palrevs])]
    ::     ==
    ::   ==
    :: ==
  ::
      [%pals %leeche ~]
    ?+    -.sign  (on-agent:default wire sign)
        %fact
      :: this wire only handles pal effects
      ~&  "Got pals leeche cage:"
      ~&  cage.sign
      !!
    ==
  ==
++  on-fail  :: runs during certain types of crashes
  on-fail:default
--
