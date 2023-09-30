|%
+$  advert-body  [title=@t cover=@t tags=(list @tas) description=@t]
+$  advert       [vendor=@p digest=@ux sig=@p when=@da advert-body]
+$  action
  $%  [%create body=advert-body]
      [%delete digest=@ux]
      [%update digest=@ux advert-body]
  ==
+$  update
  $%  [%gather adverts=(list advert)]
      action
  ==
--
