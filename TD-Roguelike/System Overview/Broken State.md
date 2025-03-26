
![[Pasted image 20250325214608.png]]![[Pasted image 20250325214839.png]]

Bug: highlighted path cant find a way to the exit, so it doesnt recalculate a new path.  

Fix: If you can't find a path to the exit, from node (1), backtrack to the previous node (2), store node 1, if we can find the exit from node 2, then the new path is 1 -> 2 -> exit. 





![[Pasted image 20250326172158.png]]![[Pasted image 20250326180705.png]]