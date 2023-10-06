|%
+$  signature  [sig=@uvH =ship =life]
::
+$  report-body  [advert=@uvH vendor=@p when=@da]  
+$  report  [hash=@uvH sig=signature body=report-body]
::
+$  action
  $%  [%cheer advert=@uvH]  :: up vote
      [%gloom advert=@uvH]  :: down vote
      [%abate hash=@uvH]    :: un-vote
  ==
+$  update
  $%  [%gather reports=(list report)]
      action
  ==
--

