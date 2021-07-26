//%attributes = {"shared":true}
$toto:=cwFormatValide("date"; "00/00/0000")

var oParent; oFils; oFusion : Object
var $a; $b : Object

oParent:=New object:C1471()
oFils:=New object:C1471()

$a:=New object:C1471("toto"; "tutu"; "momo"; "mumuPere")
$b:=New object:C1471("toto1"; "tutu"; "momo"; "mumuFils")

col_c:=New collection:C1472()
col_c.push(New object:C1471("obCol110"; "coucou110"; "obCol120"; "hell120"))
col_c.push(New object:C1471("obCol111"; "coucou110"; "obCol121"; "hello110"))
col_c.push("A")
col_c.push("B")

colFils_c:=New collection:C1472()
colFils_c.push(New object:C1471("obCol110"; "coucou110"; "obCol120"; "hell120"))
colFils_c.push(New object:C1471("obCol112"; "coucou110"; "obCol121"; "hello110"))
colFils_c.push("A")
colFils_c.push("C")

oParent.cle1:="val1"
oParent.cle10:=col_c
oParent.cle2:="val2"
oParent.cle3:="val3"
oParent.cle4:="val4"
oParent.cle5:=$a
oParent.cle6:=1

oFils.cle1:="val1bis"
oFils.cle10:=colFils_c
oFils.cle2:="val2"
oFils.cle3:="val3bis"
oFils.cle5:=$b
oFils.cle6:=1

oFusion:=cwToolObjectMerge(oParent; oFils)