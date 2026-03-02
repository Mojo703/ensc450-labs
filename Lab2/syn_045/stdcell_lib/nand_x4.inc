.subckt NAND_X4 a b z vdd vdds gnd gnds

.param Wn=4*Wm#

* PMOS
Xpmos1 vdd a z vdd pt_st w=2*Wn
Xpmos2 vdd b z vdd pt_st w=2*Wn

* NMOS
Xnmos1 gnd a n1 gnd nt_st w=Wn
Xnmos2 n1 b z gnd nt_st w=Wn

.ends
