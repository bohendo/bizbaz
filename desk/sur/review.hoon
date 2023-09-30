|%
+$  review-body  [reviewee=@p reviewer=@p score=@ud why=@t]
+$  commit  [advert=@uw vendor=@p vendor-sig=@uw client=@p client-sig=@uw when=@da]  
+$  review  [commit=commit body=review-body digest=@uw sig=@uw]
+$  action
  $%  [%commit advert=@uw]
  $%  [%review body=review-body]
  $%  [%update digest=@uw body=review-body]
  ==
+$  update
  $%  [%init reviews=(list review)]
      action
  ==
--
