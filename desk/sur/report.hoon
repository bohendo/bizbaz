|%
+$  report-body  [advert=@uw target=@p]  
+$  report  [body=report-body digest=@uw tattle=@p sig=@uw]  
+$  action
  $%  [%snitch report-body]
  $%  [%redact digest=@uw]
  ==
+$  update
  $%  [%gather report=(list report)]
      action
  ==
--

