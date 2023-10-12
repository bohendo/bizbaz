|%
::  add a @da to every gossip to make it unique
::  %gossip will not broadcast repeated gossips
::
+$  gossip-peer            [@da peer=ship]
+$  peers  
    $:  friends=(set ship)   ::  mutual pals
        tracking=(set ship)  ::  know but not in $friends
        blocked=(set ship)   ::  blocklist
    ==
--
