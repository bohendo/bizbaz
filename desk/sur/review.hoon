|%
+$  commit  [advert=@uw vendor=@p vendor-sig=@uw client=@p client-sig=@uw when=@da]  
+$  review-body  [reviewee=@p score=@ud why=@t]
+$  review  [reviewer=@p digest=@uw sig=@uw when=@da body=review-body commit=commit]
+$  action
  $%  [%commit advert=@uw]
      [%review body=review-body]
      [%update digest=@uw body=review-body]
  ==
+$  update
  $%  [%gather reviews=(list review)]
      action
  ==
--
