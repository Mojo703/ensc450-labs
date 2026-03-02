.subckt NOR_X1 a b z vdd vdds gnd gnds

.param Wn=Wm#

* PMOS
Xpmos1 vdd a n1 vdd pt_st w=2*Wn
Xpmos2 n1 b z vdd pt_st w=2*Wn

* NMOS
Xnmos1 gnd a z gnd nt_st w=Wn
Xnmos2 gnd b z gnd nt_st w=Wn

.ends
