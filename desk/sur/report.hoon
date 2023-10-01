|%
+$  signature  [sig=@uvH =ship =life]
+$  report-body  [advert=@uvH target=@p]  
+$  report  [hash=@uvH sig=signature body=report-body]  
+$  action
  $%  [%snitch advert=@uvH]
      [%redact hash=@uvH]
  ==
+$  update
  $%  [%gather reports=(list report)]
      action
  ==
--

