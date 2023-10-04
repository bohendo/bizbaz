|%
+$  signature  [sig=@uvH =ship =life]
+$  commit  [advert=@uvH vendor-sig=signature client-sig=signature when=@da]  
+$  review-body  [reviewee=ship score=@ud why=@t]
+$  review  [hash=@uvH sig=signature when=@da body=review-body commit=commit]
+$  action
  $%  [%commit advert=@uvH]
      [%review advert=@uvH body=review-body]
      [%update hash=@uvH body=review-body]
  ==
+$  update
  $%  [%gather reviews=(list review) commits=(list commit)]
      action
  ==
--
