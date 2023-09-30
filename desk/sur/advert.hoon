|%
+$  advert-body  [title=@t cover=@t tags=(list @tas) description=@t]
+$  advert       [vendor=@p digest=@uw sig=@uw when=@da advert-body]
+$  action
  $%  [%create body=advert-body]
      [%delete digest=@uw]
      [%update digest=@uw advert-body]
  ==
+$  update
  $%  [%gather adverts=(list advert)]
      action
  ==
--
