.subckt XOR_X4 A B Z vdd vdds gnd gnds



.param Wm=1u

.param Wn=4*Wm



* Pullup network

Xpmos1 vdd A net1 vdd pt_st w=2*Wn

Xpmos2 net1 B Z vdd pt_st w=2*Wn



Xpmos3 vdd B net2 vdd pt_st w=2*Wn

Xpmos4 net2 A Z vdd pt_st w=2*Wn



* Pulldown network

Xnmos1 Z A net3 gnd nt_st w=Wn

Xnmos2 net3 B gnd gnd nt_st w=Wn



Xnmos3 Z B net4 gnd nt_st w=Wn

Xnmos4 net4 A gnd gnd nt_st w=Wn



.ends
