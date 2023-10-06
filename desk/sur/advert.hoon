|%
+$  hash  @uvH
+$  signature    [sig=@uvH =ship =life]
+$  advert-body  [title=@t cover=@t tags=(list @tas) description=@t when=@da]
+$  advert       [hash=hash vendor=signature advert-body]
+$  action
  $%  [%create body=advert-body]
      [%delete advert=hash]
      [%update advert=hash body=advert-body]
  ==
+$  update
  $%  [%gather adverts=(list advert)]
      action
  ==
--
