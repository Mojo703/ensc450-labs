.subckt INV_X1 a z vdd vdds gnd gnds

.param Wn=Wm#

Xpmos vdd a z vdd pt_st w=2*Wn
Xnmos gnd a z gnd nt_st w=Wn

.ends
