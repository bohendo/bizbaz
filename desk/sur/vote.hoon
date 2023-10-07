/-  *signature
|%
+$  vote-body  [advert=hash vendor=@p when=@da]  
+$  vote  [hash=hash voter=signature body=vote-body]
::
+$  action
  $%  [%upvote advert=hash]
      [%downvote advert=hash]
      [%unvote hash=hash]
  ==
+$  update
  $%  [%gather votes=(list vote)]
      action
  ==
--

