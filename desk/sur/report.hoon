|%
+$  report-body  [advert=@uw target=@p]  
+$  report  [tattle=@p digest=@uw sig=@uw body=report-body]  
+$  action
  $%  [%snitch advert=@uw]
  $%  [%redact digest=@uw]
  ==
+$  update
  $%  [%gather reports=(list report)]
      action
  ==
--

