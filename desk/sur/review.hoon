|%
+$  commit  [advert=@uw vendor=@p vendor-sig=@uw client=@p client-sig=@uw when=@da]  
+$  review-body  [reviewee=@p score=@ud why=@t]
+$  review  [commit=commit body=review-body reviewer=@p digest=@uw sig=@uw]
+$  action
  $%  [%commit advert=@uw]
  $%  [%review review-body]
  $%  [%update digest=@uw review-body]
  ==
+$  update
  $%  [%gather reviews=(list review)]
      action
  ==
--
