[Statedef -2]

;---------------------------------------------------------------------------
[State -2, Disallow air blocking]
type = AssertSpecial
trigger1 = 1
flag = noairguard

;---------------------------------------------------------------------------
; Projectile count correction.
[State -2, Projectile Count Correction]
type = VarSet
trigger1 = NumHelper(1150) = 0
var(0) = 0
ignorehitpause = 1

;---------------------------------------------------------------------------
; Hitpause time of moves.
[State -2, Hit]
type = VarSet
trigger1 = var(42) < 0
trigger1 = MoveContact = 1
var(42) = HitPauseTime
ignorehitpause = 1

;---------------------------------------------------------------------------
; Hitpause time of moves + check for airborne opponent. Used for juggle tracking.
; Hack. Done because opponent is considered airborne on second pausetime tick.
[State -2, When am I first airborne?]
type = VarAdd
trigger1 = HitPauseTime
trigger1 = P2StateType = A
var(43) = 1
ignorehitpause = 1

[State -2, Reset Airborne Ticks]
type = VarSet
trigger1 = !HitPauseTime
var(43) = -1
ignorehitpause = 1

;---------------------------------------------------------------------------
; Create hitsparks.
[State -2, Create Hit/Guard Spark]
type = Explod
trigger1 = var(42) = HitPauseTime && var(5) > 0 && var(6) > 0
anim = ifelse(MoveHit, var(5), var(6))
ID = 7000
sprpriority = 5
postype = p1
pos = ceil(cond(P2Dist X < var(7), P2Dist X, var(7)) * const(size.xscale)), ceil(var(8) * const(size.yscale))
pausemovetime = 60
ownpal = 1
scale = 0.5, 0.5
ignorehitpause = 1

[State -2, VarSet]
type = Null
trigger1 = (var(5) := 0) || (var(6) := 0)
ignorehitpause = 1

;---------------------------------------------------------------------------
; Custom juggle point tracking
[State -2, Use Own Juggle]
type = AssertSpecial
trigger1 = 1
flag = nojugglecheck

; If opponent is in neutral, then reset juggle.
[State -2, Reset Juggle Points]
type = VarSet
trigger1 = P2MoveType != H
var(10) = 15
ignorehitpause = 1

; Moves decrement the juggle point counter once.
; If a special move connects, the rest of the special move connects.
[State -2, Decrement Juggle Points]
type = VarAdd
trigger1 = var(43) = 1 && !var(13)
var(10) = -1 * var(11)
ignorehitpause = 1

; Immediately after the move hits, reset the move juggle property to 0.
[State -2, Reset Move Juggle]
type = VarSet
trigger1 = var(43) = 1 && !var(13)
var(11) = 0
ignorehitpause = 1

; Throws are not comboable.
[State -2, No Juggle on Throw]
type = VarSet
trigger1 = stateno = 800 || stateno = 810
var(10) = 0
ignorehitpause = 1

; MOVE POINT SETTER
; -----------------

; Everything has 15 juggle points.
[State -2, Set Juggle Point Cost on Normals and Specials]
type = null
triggerall = (stateno = [200,4000])
trigger1 = (Time = 1 || p2movetype != H)
trigger1 = (var(11) := 15 || 1)
ignorehitpause = 1

;---------------------------------------------------------------------------
; Disable HitDefs
[State -2, Set Chain ID]
type = null
trigger1 = movetype = A
trigger1 = movecontact = 1
trigger1 = (var(41) := var(40) || 1)
trigger2 = movetype != A || Time <= 1
trigger2 = (var(40) := -1 || var(41) := -2 || 1)
ignorehitpause = 1

;---------------------------------------------------------------------------
; Opponent in CH state?
[State -2]
type = Helper
trigger1 = !NumHelper(10000)
trigger1 = P2MoveType = H && var(12)
helpertype = normal
name = "Counter Hit"
ID = 10000
stateno = 10000
postype = left
pausemovetime = 255
supermovetime = 255
ignorehitpause = 1

; var(12) used for the CH flash, damage & stun increase.
[State -2]
type = VarSet
trigger1 = P2MoveType = H
var(12) = 0
ignorehitpause = 1

; var(13) used for juggle point checking.
[State -2]
type = VarSet
trigger1 = !HitPauseTime
var(13) = 0
ignorehitpause = 1

; If opponent not in hit state, check for counter hits.
[State -2]
type = Null
trigger1 = P2MoveType != H
trigger1 = var(12) := (P2MoveType = A) || var(13) := (P2MoveType = A) || 1
ignorehitpause = 1

;---------------------------------------------------------------------------
; Damage scaling. Handles scaling with the exception of helpers.
[State -2, Calculating damage scaling based on hits]
type = VarSet
trigger1 = MoveHit && var(42) = HitPauseTime
fvar(0) = fvar(0) - 0.1
ignorehitpause = 1

[State -2, Reset damage scaling to 0.2 if below 0.2]
type = VarSet
trigger1 = fvar(0) < 0.2
fvar(0) = 0.2

[State -2, Reset damage scaling to 1 if enemy not in hitstun]
type = VarSet
trigger1 = numenemy
trigger1 = (enemynear, movetype != H)
trigger2 = !numenemy
fvar(0) = 1

[State -2, Damage scaling with multipliers]
type = VarSet
trigger1 = 1
fvar(1) = fvar(0) * (1 + var(12) * 0.25)
ignorehitpause = 1

;---------------------------------------------------------------------------
; Reset hitpausetime.
[State -2, Reset]
type = VarSet
trigger1 = 1
var(42) = -1

;---------------------------------------------------------------------------
; Throw condition
[State -2, Tick Down]
type = VarAdd
trigger1 = var(30) > 0
v = 30
value = -1

[State -2, Throws Allowed]
type = VarSet
triggerall = var(30) = -1
triggerall = numenemy
trigger1 = enemynear, movetype != H
trigger1 = enemynear, stateno != 140
trigger1 = (enemynear, ctrl && enemynear, time >= 1) || (enemynear, time >= 8)
trigger2 = enemynear, movetype = A
trigger3 = (enemynear, stateno != [0, 52]) && (enemynear, stateno != [150, 155]) && (enemynear, stateno != [5000, 5120])
var(30) = 5

[State -2, Throws Disallowed]
type = VarSet
triggerall = numenemy
trigger1 = enemynear, stateno = [150, 155]
trigger2 = (enemynear, stateno = 51 || enemynear, stateno = 140) && (enemynear, prevstateno = [150, 155])
trigger3 = enemynear, movetype = H
trigger4 = (enemynear, stateno = [5020, 5040]) && enemynear, hitfall = 0
trigger5 = enemynear, stateno = 40 && enemynear, prevstateno != 52 && (enemynear, anim != [0, 29])
var(30) = -1
ignorehitpause = 1

;---------------------------------------------------------------------------
; Debug
[State -1, DTCB]
type = DisplayToClipboard
trigger1 = 1
text = "Juggle: %d Move: %d Throw Tick: %d HPT: %d var(33): %d fvar(1): %f"
params = var(10), var(11), var(30), HitPauseTime, var(33), fvar(1)
ignorehitpause = 1
