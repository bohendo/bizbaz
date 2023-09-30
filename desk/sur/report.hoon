|%
+$  report-body  [advert=@ux target=@p]  
+$  report  [tattle=@p digest=@ux sig=@ux body=report-body]  
+$  action
  $%  [%snitch advert=@ux]
      [%redact digest=@ux]
  ==
+$  update
  $%  [%gather reports=(list report)]
      action
  ==
--

