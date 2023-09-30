|%
+$  commit  [advert=@ux vendor=@p vendor-sig=@ux client=@p client-sig=@ux when=@da]  
+$  review-body  [reviewee=@p score=@ud why=@t]
+$  review  [reviewer=@p digest=@ux sig=@ux when=@da body=review-body commit=commit]
+$  action
  $%  [%commit advert=@ux]
      [%review body=review-body]
      [%update digest=@ux body=review-body]
  ==
+$  update
  $%  [%gather reviews=(list review)]
      action
  ==
--
