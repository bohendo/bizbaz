/-  *signature
|%
+$  advert-body  [title=@t cover=@t tags=(list @tas) description=@t when=@da]
+$  advert       [hash=hash vendor=signature body=advert-body]
+$  adverts      (list advert)
+$  action
  $%  [%create body=advert-body]
      [%update advert=hash body=advert-body]
      [%delete advert=hash]
  ==
+$  update
  $%  [%gather adverts=adverts]
      [%create advert=advert]
      [%update old=hash new=advert]
      [%delete advert=hash]
  ==
--
