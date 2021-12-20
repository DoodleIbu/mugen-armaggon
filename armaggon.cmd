;-| Button Remapping |-----------------------------------------------------
; This section lets you remap the player's buttons (to easily change the
; button configuration). The format is:
;   old_button = new_button
; If new_button is left blank, the button cannot be pressed.
[Remap]
x = x
y = y
z = z
a = a
b = b
c = c
s = s

;-| Default Values |-------------------------------------------------------
[Defaults]
; Default value for the "time" parameter of a Command. Minimum 1.
command.time = 15

; Default value for the "buffer.time" parameter of a Command. Minimum 1,
; maximum 30.
command.buffer.time = 1

;-| Special Motions |------------------------------------------------------
[Command]
name = "backchargeac"
command = ~30$B, $F, x+y
time = 10

[Command]
name = "backchargea"
command = ~30$B, $F, x
time = 10

[Command]
name = "backchargec"
command = ~30$B, $F, y
time = 10

[Command]
name = "downchargeab"
command = ~30$D, $U, a+b
time = 10

[Command]
name = "downchargeb"
command = ~30$D, $U, a
time = 10

[Command]
name = "downcharged"
command = ~30$D, $U, b
time = 10

[Command]
name = "super"
command = y+b
time = 1

[Command]
name = "blowback"
command = x+a
time = 1

;-| Double Tap |-----------------------------------------------------------
[Command]
name = "FF"     ;Required (do not remove)
command = F, F
time = 10

[Command]
name = "BB"     ;Required (do not remove)
command = B, B
time = 10

;-| 2/3 Button Combination |-----------------------------------------------
[Command]
name = "recovery";Required (do not remove)
command = x+y
time = 1

;-| Single Button |---------------------------------------------------------
[Command]
name = "a"
command = a
time = 1

[Command]
name = "b"
command = b
time = 1

[Command]
name = "c"
command = c
time = 1

[Command]
name = "x"
command = x
time = 1

[Command]
name = "y"
command = y
time = 1

[Command]
name = "z"
command = z
time = 1

[Command]
name = "start"
command = s
time = 1

;-| Hold Dir |--------------------------------------------------------------
[Command]
name = "holdfwd";Required (do not remove)
command = /$F
time = 1

[Command]
name = "holdback";Required (do not remove)
command = /$B
time = 1

[Command]
name = "holdup" ;Required (do not remove)
command = /$U
time = 1

[Command]
name = "holddown";Required (do not remove)
command = /$D
time = 1

;---------------------------------------------------------------------------
; 2. State entry
; --------------
; This is where you define what commands bring you to what states.
;
; Each state entry block looks like:
;   [State -1, Label]           ;Change Label to any name you want to use to
;                               ;identify the state with.
;   type = ChangeState          ;Don't change this
;   value = new_state_number
;   trigger1 = command = command_name
;   . . .  (any additional triggers)
;
; - new_state_number is the number of the state to change to
; - command_name is the name of the command (from the section above)
; - Useful triggers to know:
;   - statetype
;       S, C or A : current state-type of player (stand, crouch, air)
;   - ctrl
;       0 or 1 : 1 if player has control. Unless "interrupting" another
;                move, you'll want ctrl = 1
;   - stateno
;       number of state player is in - useful for "move interrupts"
;   - movecontact
;       0 or 1 : 1 if player's last attack touched the opponent
;                useful for "move interrupts"
;
; Note: The order of state entry is important.
;   State entry with a certain command must come before another state
;   entry with a command that is the subset of the first.
;   For example, command "fwd_a" must be listed before "a", and
;   "fwd_ab" should come before both of the others.
;
; For reference on triggers, see CNS documentation.
;
; Just for your information (skip if you're not interested):
; This part is an extension of the CNS. "State -1" is a special state
; that is executed once every game-tick, regardless of what other state
; you are in.


; Don't remove the following line. It's required by the CMD standard.
[Statedef -1]

; Special buffer.
[State -1, Buffer]
type = VarSet
triggerall = var(20) = 0
trigger1 = command = "backchargeac"
trigger1 = var(20) := 1110
trigger2 = command = "backchargea"
trigger2 = var(20) := 1100
trigger3 = command = "backchargec"
trigger3 = var(20) := 1105
trigger4 = command = "downchargeab"
trigger4 = var(20) := 1210
trigger5 = command = "downchargeb"
trigger5 = var(20) := 1200
trigger6 = command = "downcharged"
trigger6 = var(20) := 1205
trigger7 = command = "super"
trigger7 = var(20) := 2000
trigger8 = command = "blowback"
trigger8 = var(20) := 900
var(21) = 5
ignorehitpause = 1

; Normal buffer.
[State -1, Buffer]
type = VarSet
triggerall = var(20) = 0
trigger1 = command = "holdback" && command = "a" && command != "holddown"
trigger1 = var(20) := 235
trigger2 = command = "x" && command = "holddown"
trigger2 = var(20) := 400
trigger3 = command = "y" && command = "holddown"
trigger3 = var(20) := 410
trigger4 = command = "a" && command = "holddown"
trigger4 = var(20) := 430
trigger5 = command = "b" && command = "holddown"
trigger5 = var(20) := 440
trigger6 = command = "x" && command != "holddown"
trigger6 = var(20) := 200
trigger7 = command = "y" && command != "holddown"
trigger7 = var(20) := 210
trigger8 = command = "a" && command != "holddown"
trigger8 = var(20) := 230
trigger9 = command = "b" && command != "holddown"
trigger9 = var(20) := 240
var(21) = 5
ignorehitpause = 1

[State -1, Unbuffer]
type = VarSet
trigger1 = !(var(21) := var(21) - 1)
trigger2 = Time = 1 && StateNo = [200, 4000]
var(20) = 0
ignorehitpause = 1

;===========================================================================
; SPECIALS
;===========================================================================
; Big Wave
[State -1]
type = ChangeState
value = 2000
triggerall = command = "super" || var(20) = 2000
triggerall = statetype != A
triggerall = power >= 2000
trigger1 = ctrl

;---------------------------------------------------------------------------
; Guard cancel
[State -1]
type = ChangeState
value = 900
triggerall = command = "blowback" || var(20) = 900
triggerall = statetype != A
triggerall = power >= 1000
trigger1 = stateno = [150,153]

;---------------------------------------------------------------------------
; Blowback attack
[State -1]
type = ChangeState
value = 910
triggerall = command = "blowback" || var(20) = 900
triggerall = statetype != A
triggerall = power >= 1000
trigger1 = ctrl

;---------------------------------------------------------------------------
; Yuuei Zutsuki
; Can be done ~3 frames after jump
[State -1]
type = ChangeState
value = 1000
triggerall = command = "y" && command = "holddown" || var(20) = 410
triggerall = statetype = A
trigger1 = ctrl

;---------------------------------------------------------------------------
; Cyclone Wave EX
[State -1]
type = ChangeState
value = 1110
triggerall = command = "backchargeac" || var(20) = 1110
triggerall = statetype != A
triggerall = !var(0)
triggerall = power >= 1000
trigger1 = ctrl
trigger2 = (stateno = 200 || stateno = 215 || stateno = 230 || stateno = 240) && MoveContact
trigger3 = (stateno = 400 || stateno = 410 || stateno = 430 || stateno = 440) && MoveContact
trigger4 = (stateno = 235) && MoveContact

;---------------------------------------------------------------------------
; Cyclone Wave A
[State -1]
type = ChangeState
value = 1100
triggerall = command = "backchargea" || var(20) = 1100
triggerall = statetype != A
triggerall = !var(0)
trigger1 = ctrl
trigger2 = (stateno = 200 || stateno = 215 || stateno = 230 || stateno = 240) && MoveContact
trigger3 = (stateno = 400 || stateno = 410 || stateno = 430 || stateno = 440) && MoveContact
trigger4 = (stateno = 235) && MoveContact

;---------------------------------------------------------------------------
; Cyclone Wave C
[State -1]
type = ChangeState
value = 1105
triggerall = command = "backchargec" || var(20) = 1105
triggerall = statetype != A
triggerall = !var(0)
trigger1 = ctrl
trigger2 = (stateno = 200 || stateno = 215 || stateno = 230 || stateno = 240) && MoveContact
trigger3 = (stateno = 400 || stateno = 410 || stateno = 430 || stateno = 440) && MoveContact
trigger4 = (stateno = 235) && MoveContact

;---------------------------------------------------------------------------
; Jaws Upper EX
[State -1]
type = ChangeState
value = 1210
triggerall = command = "downchargeab" || var(20) = 1210
triggerall = statetype != A
triggerall = power >= 1000
trigger1 = ctrl || stateno = 40
trigger2 = (stateno = 200 || stateno = 215 || stateno = 230 || stateno = 240) && MoveContact
trigger3 = (stateno = 400 || stateno = 410 || stateno = 430 || stateno = 440) && MoveContact
trigger4 = (stateno = 235) && MoveContact

;---------------------------------------------------------------------------
; Jaws Upper B
[State -1]
type = ChangeState
value = 1200
triggerall = command = "downchargeb" || var(20) = 1200
triggerall = statetype != A
trigger1 = ctrl || stateno = 40
trigger2 = (stateno = 200 || stateno = 215 || stateno = 230 || stateno = 240) && MoveContact
trigger3 = (stateno = 400 || stateno = 410 || stateno = 430 || stateno = 440) && MoveContact
trigger4 = (stateno = 235) && MoveContact

;---------------------------------------------------------------------------
; Jaws Upper D
[State -1]
type = ChangeState
value = 1205
triggerall = command = "downcharged" || var(20) = 1205
triggerall = statetype != A
trigger1 = ctrl || stateno = 40
trigger2 = (stateno = 200 || stateno = 215 || stateno = 230 || stateno = 240) && MoveContact
trigger3 = (stateno = 400 || stateno = 410 || stateno = 430 || stateno = 440) && MoveContact
trigger4 = (stateno = 235) && MoveContact

;===========================================================================
;---------------------------------------------------------------------------
; st.A
[State -1]
type = ChangeState
value = 200
triggerall = (command = "x" && command != "holddown") || var(20) = 200
triggerall = statetype != A
trigger1 = ctrl
trigger2 = stateno = 200 && AnimElem = 2, > 2 && MoveContact
trigger3 = stateno = 400 && AnimElem = 3, > 2
trigger4 = stateno = 430 && AnimElem = 2, > 2

;---------------------------------------------------------------------------
; cl.C
[State -1]
type = ChangeState
value = 215
triggerall = (command = "y" && command != "holddown") || var(20) = 210
triggerall = P2BodyDist X < 25
triggerall = statetype != A
trigger1 = ctrl

;---------------------------------------------------------------------------
; st.C
[State -1]
type = ChangeState
value = 210
triggerall = (command = "y" && command != "holddown") || var(20) = 210
triggerall = statetype != A
trigger1 = ctrl

;---------------------------------------------------------------------------
; b+B
[State -1]
type = ChangeState
value = 235
triggerall = (command = "holdback" && command = "a" && command != "holddown") || var(20) = 235
triggerall = statetype != A
trigger1 = ctrl
trigger2 = (stateno = 200 || stateno = 215 || stateno = 230 || stateno = 240) && MoveContact
trigger3 = (stateno = 400 || stateno = 410 || stateno = 430 || stateno = 440) && MoveContact

;---------------------------------------------------------------------------
; st.B
[State -1]
type = ChangeState
value = 230
triggerall = (command = "a" && command != "holddown") || var(20) = 230
triggerall = statetype != A
trigger1 = ctrl
trigger2 = stateno = 200 && AnimElem = 2, > 2 && MoveContact
trigger3 = stateno = 400 && AnimElem = 3, > 2
trigger4 = stateno = 430 && AnimElem = 2, > 2

;---------------------------------------------------------------------------
; st.D
[State -1]
type = ChangeState
value = 240
triggerall = (command = "b" && command != "holddown") || var(20) = 240
trigger1 = statetype != A
trigger1 = ctrl

;---------------------------------------------------------------------------
; cr.A
[State -1]
type = ChangeState
value = 400
triggerall = (command = "x" && command = "holddown") || var(20) = 400
triggerall = statetype != A
trigger1 = ctrl
trigger2 = stateno = 200 && AnimElem = 2, > 2 && MoveContact
trigger3 = stateno = 400 && AnimElem = 3, > 2
trigger4 = stateno = 430 && AnimElem = 2, > 2

;---------------------------------------------------------------------------
; cr.C
[State -1]
type = ChangeState
value = 410
triggerall = (command = "y" && command = "holddown") || var(20) = 410
triggerall = statetype != A
trigger1 = ctrl

;---------------------------------------------------------------------------
; cr.B
[State -1]
type = ChangeState
value = 430
triggerall = (command = "a" && command = "holddown") || var(20) = 430
triggerall = statetype != A
trigger1 = ctrl
trigger2 = stateno = 200 && AnimElem = 2, > 2 && MoveContact
trigger3 = stateno = 400 && AnimElem = 3, > 2
trigger4 = stateno = 430 && AnimElem = 2, > 2

;---------------------------------------------------------------------------
; cr.D
[State -1]
type = ChangeState
value = 440
triggerall = (command = "b" && command = "holddown") || var(20) = 440
trigger1 = statetype != A
trigger1 = ctrl

;---------------------------------------------------------------------------
; nj.A
[State -1]
type = ChangeState
value = 605
triggerall = command = "x" || var(20) = 200 || var(20) = 400
triggerall = Vel X = 0
triggerall = statetype = A
trigger1 = ctrl

;---------------------------------------------------------------------------
; j.A
[State -1]
type = ChangeState
value = 600
triggerall = command = "x" || var(20) = 200 || var(20) = 400
triggerall = statetype = A
trigger1 = ctrl

;---------------------------------------------------------------------------
; j.C
[State -1]
type = ChangeState
value = 610
triggerall = command = "y" || var(20) = 210 || var(20) = 410
triggerall = statetype = A
trigger1 = ctrl

;---------------------------------------------------------------------------
; j.B
[State -1]
type = ChangeState
value = 630
triggerall = command = "a" || var(20) = 230 || var(20) = 230
triggerall = statetype = A
trigger1 = ctrl

;---------------------------------------------------------------------------
; j.D
[State -1]
type = ChangeState
value = 640
triggerall = command = "b" || var(20) = 240 || var(20) = 440
triggerall = statetype = A
trigger1 = ctrl

;---------------------------------------------------------------------------
;Taunt
[State -1]
type = ChangeState
value = 195
triggerall = command = "start"
trigger1 = statetype != A
trigger1 = ctrl
