/-  *signature
|%
+$  choice  ?(%up %down %un)
+$  vote-body  [advert=hash vendor=@p when=@da choice=choice]
+$  vote  [hash=hash voter=signature body=vote-body]
+$  votes  (list vote)
::
+$  action
  $%  [%vote advert=hash choice=choice]
  ==
+$  update
  $%  [%gather votes=(list vote)]
      action
  ==
--

