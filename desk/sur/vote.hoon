/-  *signature
|%
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
  $%  [%vote advert=hash choice=@tas]
  ==
+$  update
  $%  [%gather votes=(list vote)]
      action
  ==
--

