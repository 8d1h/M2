--		Copyright 1995 by Daniel R. Grayson

Sequence _ ZZ := List _ ZZ := (s,i) -> s#i

String _ ZZ := (s,i) -> s#i
String _ Sequence := (s,i) -> ((j,k) -> substring(s,j,k)) i



