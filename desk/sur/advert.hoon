/-  *signature
|%
+$  advert-body  [title=@t cover=@t tags=(list @tas) description=@t when=@da]
+$  advert       [hash=hash vendor=signature body=advert-body]
+$  adverts      (list advert)
+$  action
  $%  [%create body=advert-body]
      [%delete advert=hash]
      [%update advert=hash body=advert-body]
  ==
+$  update
  $%  [%gather adverts=adverts]
      [%create advert=advert]
      [%delete advert=hash]
      [%update old=hash new=advert]
  ==
--
