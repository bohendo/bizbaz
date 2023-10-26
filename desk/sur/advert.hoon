/-  *signature
|%
::
+$  advert-req
  $:  title=@t
      cover=@t
      tags=(list @tas)
      description=@t
  ==
::
+$  advert-body
  $:  title=@t
      cover=@t
      tags=(list @tas)
      description=@t
      vendor=ship
      when=@da
  ==
::
+$  advert
  $:  hash=hash
      vendor=signature
      body=advert-body
  ==
::
+$  adverts  (list advert)
::
+$  action
  $%  [%create req=advert-req]
      [%update old=hash new=advert-req]
      [%delete advert=hash]
  ==
+$  update
  $%  [%create advert=advert]
      [%update old=hash new=advert]
      [%delete advert=hash]
      [%gather adverts=adverts]
  ==
--
