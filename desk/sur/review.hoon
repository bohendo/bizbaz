/-  *signature
|%
::
::  a client expresses intent to consume the vendor's goods/services
+$  intent-body  [advert=hash vendor=signature client=ship when=@da]
+$  intent  [=hash client=signature body=intent-body]
+$  intents  (list intent)
::
::  a vendor commits to to producing goods/services for the client
+$  commit-body  [intent=hash client=signature vendor=ship when=@da]
+$  commit  [=hash vendor=signature body=commit-body intent=intent-body]
+$  commits  (list commit)
::  a commit is valid if:
::  - the vendor's signature of the advert hash is valid
::  the client:
::  - receives a commit from the vendor via ames
::  - validates it (drops it if invalid)
::  - at this point, the client can proceed to provide payment/etc to move the transaction forward
::  - uses the commit to build, broadcast, and update their review
::  the vendor:
::  - receives a commit request from the UI
::  - builds & validates the commit (crash if invalid)
::  - sends the commit to the client
::  - at this point the vendor can proceed to provide the good/service to move the transaction forward
::
::  either the vendor or the client submits a review of the other party
+$  review-req  [commit=hash score=@ud why=@t]
+$  review-body  [commit=hash reviewee=ship score=@ud why=@t when=@da]
+$  review  [=hash reviewer=signature body=review-body commit=commit]
+$  reviews  (list review)
::  a review is valid if:
::  - the commit hash matches a known, valid commit
::  - hash.review matches sham(review-body)
::  - the reviewee's signature of the commit hash is valid
::  - the reviewer's signature of the review body is valid
::  - the reviewee and reviewer are the client and vendor (in either order)
::  - score is one of: [1, 2, 3, 4, 5]
::  both parties:
::  - receive a review request from the UI
::  - use the stored commit to build & validate their review (crash if invalid)
::  - broadcast their review
::  - accept, store, and forward reviews received from other ships
::
+$  action
  $%  [%intent advert=hash]
      [%commit intent=hash]
      [%review req=review-req]
      [%update old=hash new=review-req]
  ==
+$  update
  $%  [%gather intents=intents commits=commits reviews=reviews]
      [%intent intent=intent]
      [%commit commit=commit]
      [%review review=review]
      [%update old=hash new=review]
  ==
--
