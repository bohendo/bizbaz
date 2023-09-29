|%
+$  listing  [id=@ux who=@p when=@da new-req]
+$  new-req  [title=@t cover=@t tags=(list @tas) description=@t]
+$  del-req  [id=@ux]
+$  upd-req  [id=@ux new-req]
+$  action
  $%  [%create new-req]
  $%  [%delete del-req]
  $%  [%update upd-req]
  ==
+$  update
  $%  [%init listings=(list listing)]
      action
  ==
--
