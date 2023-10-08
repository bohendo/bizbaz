/-  *signature
|%
+$  vote-body  [advert=hash vendor=@p when=@da choice=@tas]
+$  vote  [hash=hash voter=signature body=vote-body]
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

