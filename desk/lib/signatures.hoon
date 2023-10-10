/-  *signature
|%
++  jael-scry
  |*  [=mold our=ship desk=term now=time =path]
  .^  mold
    %j
    (scot %p our)
    desk
    (scot %da now)
    path
  ==
++  sign
  |=  [our=ship now=time =hash]
  ^-  signature
  =+  (jael-scry ,=life our %life now /(scot %p our))
  =+  (jael-scry ,=ring our %vein now /(scot %ud life))
  :+  `@uvH`(sign:as:(nol:nu:crub:crypto ring) hash)
    our
  life
::
++  is-signature-valid
  |=  [=hash our=ship =signature now=time]
  ^-  ?
  ::  ~&  (weld (weld (weld "validating signature by " (scow %p ship)) " on ") (scow %da now))
  =+  (jael-scry ,lyf=(unit @) our %lyfe now /(scot %p ship.signature))
  ::
  ::  we do not have a public key from ship at this life
  ?~  lyf  %.y
  ?.  =(u.lyf life.signature)  %.y
  =+  %:  jael-scry
        ,deed=[a=life b=pass c=(unit @uvH)]
        our  %deed  now  /(scot %p ship.signature)/(scot %ud life.signature)
      ==
  ::  if signature is from a past life, skip validation
  ::  XX: should be visualised on frontend, not great.
  ?.  =(a.deed life.signature)  %.y
  ::  verify signature from ship at life
  ::
  =/  them
    (com:nu:crub:crypto b.deed)
  =(`hash (sure:as.them sig.signature))
::
++  are-signatures-valid
  |=  [=ship =signatures =hash now=time]
  ^-  ?
  =/  signature-list  ~(tap in signatures)
  |-
  ?~  signature-list
    %.y
  ?:  (is-signature-valid hash ship i.signature-list now)
    $(signature-list t.signature-list)
  %.n
::
++  to-json
  =,  enjs:format
  |=  sig=signature
  ^-  json
  %-  pairs
  :~  ['sig' s+(scot %uv ship.sig)]
      ['ship' s+(scot %p ship.sig)]
      ['life' s+(scot %ud life.sig)]
  ==
::
++  from-json
  =,  dejs:format
  |=  jon=json
  ^-  signature
  %.  jon
  %-  ot
  :~  [%sig (se %uv)]
      [%ship (se %p)]
      [%life ni]
  ==
--
