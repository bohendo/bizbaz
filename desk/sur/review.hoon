|%
+$  review  [reviewee=@p reviewer=@p what=@t when=@da]  
+$  listing  [when=@da tag=?(%services %for-sale) description=@t rate=@rs]
+$  action
  $%  [%post-review review=review]
      [%post-listing listing=listing]
  ==
+$  update
  $%  [%init reviews=(list @)]
      action
  ==
--