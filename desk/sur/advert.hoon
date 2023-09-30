|%
+$  advert   [id=@ux vendor=@p vendor-sig=@p when=@da new-req]
+$  new-req  [title=@t cover=@t tags=(list @tas) description=@t]
+$  del-req  [id=@ux]
+$  upd-req  [id=@ux new-req]
+$  action
  $%  [%create =new-req]
      [%delete =del-req]
      [%update =upd-req]
  ==
+$  update
  $%  [%gather adverts=(list advert)]
      action
  ==
--
