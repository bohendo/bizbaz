/-  *signature
|%
+$  advert-body  [title=@t cover=@t tags=(list @tas) description=@t when=@da]
+$  advert       [hash=hash vendor=signature advert-body]
+$  action
  $%  [%create body=advert-body]
      [%delete advert=hash]
      [%update advert=hash body=advert-body]
  ==
+$  update
  $%  [%gather adverts=(list advert)]
      [%create advert=advert]
      [%delete advert=hash]
      [%update old=hash new=advert]
  ==
--
