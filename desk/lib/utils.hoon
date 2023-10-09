|% 
::
++  log-gather
    |=  [got=@ud new=@ud from=@p type=tape]
    ^-  tape
    %+  weld  "%gather: received "
    %+  weld  (scow %ud got)
    %+  weld  " ("
    %+  weld  (scow %ud new)
    %+  weld  " new) "
    %+  weld  type
    %+  weld  "s from "
              (scow %p from)
--
