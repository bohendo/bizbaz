/-  *signature
|%
:: TODO add vendor ship to body to guarantee unique hash per advert
+$  advert-body  [title=@t cover=@t tags=(list @tas) description=@t when=@da]
+$  advert       [hash=hash vendor=signature body=advert-body]
+$  adverts      (list advert)
+$  action
  $%  [%create body=advert-body]
      [%update advert=hash body=advert-body]
      [%delete advert=hash]
  ==
+$  update
  $%  [%create advert=advert]
      [%update old=hash new=advert]
      [%delete advert=hash]
      [%gather adverts=adverts]
  ==
--
