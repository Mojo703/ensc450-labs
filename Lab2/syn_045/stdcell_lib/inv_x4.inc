.subckt INV_X4 a z vdd vdds gnd gnds

.param Wn=4*Wm#

Xpmos vdd a z vdd pt_st w=2*Wn
Xnmos gnd a z gnd nt_st w=Wn

.ends
