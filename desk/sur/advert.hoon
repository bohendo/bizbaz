|%
+$  signature    [sig=@uvH =ship =life]
::  Do we need more entropy on the body,
::  to make sure that the hashes will never collide?
::
+$  advert-body  [title=@t cover=@t tags=(list @tas) description=@t]
+$  advert       [hash=@uvH sig=signature when=@da body=advert-body]
+$  action
  $%  [%create body=advert-body]
      [%delete hash=@uvH]
      [%update hash=@uvH body=advert-body]
  ==
+$  update
  $%  [%gather adverts=(list advert)]
      [%create =advert]
      [%update =advert]
  ==
--
