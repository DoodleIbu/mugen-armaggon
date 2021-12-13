[Statedef -3]

;---------------------------------------------------------------------------
; Hit voice
[State -3]
type = PlaySnd
trigger1 = stateno = 5000 || stateno = 5010 || stateno = 5020 || stateno = 5070 || stateno = 5080 || stateno = 5100
trigger1 = alive && Time = 1 && random < 250
value = S5000, 0
channel = 0

[State -3]
type = PlaySnd
trigger1 = stateno = 5100 || stateno = 5160 || stateno = 5110 && prevstateno != 5081 || stateno = 5111 && prevstateno = 5071
trigger1 = Time = 1
value = S5100, 0
channel = 1

;---------------------------------------------------------------------------
; POTS corner push code
[State -3, Corner Push]; Reset
type= varset
trigger1= fvar(5)
trigger1= numtarget
trigger1= (target, hitover) || (target, gethitvar(hitshaketime) > 0 && target, time <= 0)
fvar(5)= 0

[State -3, Corner Push]; Get initial velocity.
type= varset
trigger1= movecontact=1 && numtarget
fvar(5)= (target, gethitvar(xvel))
ignorehitpause= 1

[State -3, Corner Push]; Apply corner push
type= posadd
triggerall= fvar(5)
triggerall= (statetype = S || statetype = C) && numtarget
triggerall= !hitpausetime && (target, gethitvar(hitshaketime) <= 0)
triggerall= (target, statetype = S || target, statetype = C) && !(target, gethitvar(yvel)) && !(target, hitfall); See note below
trigger1= target, frontedgebodydist <= abs(target, vel x)
trigger1= (target, gethitvar(xvel) * target, facing) > 0
trigger2= target, backedgebodydist <= abs(target, vel x)
trigger2= (target, gethitvar(xvel) * target, facing) < 0
x= ifelse(target, frontedgebodydist <= 0, -1, 1) * (target, facing) * fvar(5)

[State -3, Corner Push]; Apply friction to the velocity
type= varset
trigger1= numtarget
trigger1= target, gethitvar(hitshaketime) <= 0
fvar(5)= fvar(5) * 0.82

;---------------------------------------------------------------------------
; POTS underground juggle code
[State -3, Underground Juggle Prevention]
type = targetbind
trigger1 = movecontact = 1
trigger1 = numtarget && numenemy
trigger1 = (target, time = 0) && (target, ID = enemynear, ID)
trigger1 = !(target, hitshakeover) && (target, pos y > 0)
pos = ceil(p2dist x), ceil(-pos y)
ignorehitpause = 1
