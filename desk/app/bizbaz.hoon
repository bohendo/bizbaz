/-  advert
/-  vote
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
  ?>  |(?=(%advert-action mark) ?=(%vote-action mark) ?=(%review-action mark))
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
                  when=now.bowl
              ==
            =/  hash  (sham advert-body)
            =/  new-advert
              :*  hash=hash
                  vendor=(sign:signatures our.bowl now.bowl hash)
                  advert-body
              ==
            [~ this(adverts [new-advert adverts])]
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
          %upvote
            :: TODO: find & rm the one w matching hash
            !! :: [~ this(votes [new-vote votes])]
          %downvote
            =/  index  (find ~[advert.act] (turn adverts |=(ad=advert:advert hash.ad)))
            ?~  index
              ~|((weld "No advert with hash " (scow %uv advert.act)) !!)
            =/  ad  (snag (need index) adverts)
            =/  target  ship.vendor.ad
            =/  vote-body  [advert=advert.act vendor=target when=now.bowl]
            =/  hash  (sham vote-body)
            =/  new-vote
              :*  hash
                  vendor=(sign:signatures our.bowl now.bowl hash)
                  body=vote-body
              ==
            [~ this(votes [new-vote votes])]
          %unvote
            :: TODO: find & rm the one w matching hash
            !! :: [~ this(votes [new-vote votes])]
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
            =/  index  (find ~[commit.act] (turn commits |=(cmt=commit:review hash.cmt)))
            ?~  index
              ~|((weld "No commit with hash " (scow %uv commit.act)) !!)
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
    [%votes ~]
      ~&  "watching votes"
      [%give %fact ~ %vote-update !>(`update:vote`[%gather votes])]~
    [%reviews ~]
      ~&  "watching intents & commits & reviews"
      [%give %fact ~ %review-update !>(`update:review`[%gather intents commits reviews])]~
  ==
++  on-arvo   on-arvo:default
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--
