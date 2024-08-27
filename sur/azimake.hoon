|%
+$  id  @t
+$  ui  @t
+$  key  @t
+$  value  @t
+$  url  @t
+$  county  (map =ship (map =key =value))  :: state has counties
+$  app  [=ui =county published=?]
+$  apps  (map =id =app)
+$  app-action
  $%  [%put-in-map =key =value]
  ==
::
+$  create-action
  $%  [%save =id =ui]
      [%publish =id =url]
      [%unpublish =id =url]
      [%block-user =ship]
      [%unblock-user =ship]
      [%destroy-app =id]
      [%delete-user-data =id =ship]
  ==
--