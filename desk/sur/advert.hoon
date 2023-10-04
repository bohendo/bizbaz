|%
+$  signature    [sig=@uvH =ship =life]
+$  advert-body  [title=@t cover=@t tags=(list @tas) description=@t when=@da]
+$  advert       [hash=@uvH sig=signature advert-body]
+$  action
  $%  [%create body=advert-body]
      [%delete hash=@uvH]
      [%update hash=@uvH body=advert-body]
  ==
+$  update
  $%  [%gather adverts=(list advert)]
      action
  ==
--
