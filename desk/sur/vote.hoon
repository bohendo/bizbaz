/-  *signature
|%
::
+$  vote-req
  $:  advert=hash
      choice=@tas
  ==
::
+$  vote-body
  $:  advert=hash
      choice=@tas
      voter=ship
      when=@da
  ==
::
+$  vote
  $:  hash=hash
      voter=signature
      body=vote-body
  ==
::
+$  votes  (list vote)
::
+$  action
  $%  [%vote req=vote-req]
  ==
+$  update
  $%  [%gather votes=(list vote)]
      [%vote vote=vote]
  ==
--

