|%
+$  hash  @uvH
+$  choice  ?(%up %down %un)
+$  signature  [sig=@uvH =ship =life]
::
+$  vote-body  [advert=hash vendor=@p when=@da choice=choice]
+$  vote  [hash=hash sig=signature body=vote-body]
::
+$  action
  $%  [%vote advert=hash choice=choice]
  ==
+$  update
  $%  [%gather votes=(list vote)]
      action
  ==
--

