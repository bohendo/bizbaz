|%
+$  advert-body  [title=@t cover=@t tags=(list @tas) description=@t]
+$  advert       [digest=@ux vendor=@p vendor-sig=@p when=@da advert-body]
+$  action
  $%  [%create advert-body]
      [%delete digest=@ux]
      [%update [digest=@ux advert-body]
  ==
+$  update
  $%  [%gather (list advert)]
      action
  ==
--
