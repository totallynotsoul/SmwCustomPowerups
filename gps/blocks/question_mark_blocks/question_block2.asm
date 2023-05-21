db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioInside : JMP MarioHead

!SoundEffect = $02
!APUPort = $1DFC|!addr

!bounce_num			= $03	; See RAM $1699 for more details
!bounce_direction	= $00	; Should be generally $00
!bounce_block		= $0D	; See RAM $9C for more details. Can be set to $1C or larger to change the tile manually
!bounce_properties	= $00	; YXPPCCCT properties

; If !bounce_block is $1C or larger.
!bounce_Map16 = $0132		; Changes into the Map16 tile directly

!item_memory_dependant = 0	; 0 for false, 1 for true

!RAM = $19	; This determines which item it spawns whether it is to the zero or not.
			; See the RAM map for more details

; The first argument is if Mario is small, the second for big
SpriteNumber:
db $74,$75

IsCustom:
db $00,$00	; $00 (or any other even number) for normal, $01 (or any other odd number) for custom

State:
db $08,$0A	; Should be either $08 or $09

RAM_1540_vals:
db $3E,$3E	; If you use powerups, this should be $3E
			; Carryable sprites uses it as the stun timer

XPlacement:
db $00,$00	; Remember: $01-$7F moves the sprite to the right and $80-$FF to the left.

YPlacement:
db $00,$00	; Remember: $01-$7F moves the sprite to the bottom and $80-$FF to the top.

Return:
MarioAbove:
MarioSide:
Fireball:
MarioCorner:
MarioInside:
MarioHead:
RTL

SpriteH:
	%check_sprite_kicked_horizontal()
	BCS SpriteShared
RTL

SpriteV:
	LDA !14C8,x
	CMP #$09
	BCC Return
	LDA !AA,x
	BPL Return
	LDA #$10
	STA !AA,x

SpriteShared:
	%sprite_block_position()

Cape:
MarioBelow:
SpawnItem:
	PHX
	PHY
	if !bounce_Map16 >= $1C
		REP #$20
		LDA.w #!bounce_Map16
		STA $02
		SEP #$20
	endif
	LDA #!bounce_num
	LDX #!bounce_block
	LDY #!bounce_direction
	%spawn_bounce_sprite()
	LDA #!bounce_properties
	STA $1901|!addr,y
	if !bounce_num >= $08
		%erase_block()
	endif
if !item_memory_dependant == 1
	PHK
	PEA .jsl_2_rts_return-1
	PEA $84CE
	JML $00C00D|!bank
.jsl_2_rts_return
	SEP #$10
endif
	LDA #!SoundEffect
	STA !APUPort

	LDY #$00
	LDA !RAM
	BEQ +
	LDY #$01
+	LDA IsCustom,y
	LSR
	LDA SpriteNumber,y
	PHY
	%spawn_sprite_block()
	TAX
	PLY
	LDA XPlacement,y
	STA $00
	LDA YPlacement,y
	STA $01
	TXA
	%move_spawn_relative()

	LDA State,y
	STA !14C8,x
	LDA RAM_1540_vals,y
	STA !1540,x
	LDA #$D0
	STA !AA,x
	LDA #$2C
	STA !154C,x

	LDA !190F,x
	BPL Return2
	LDA #$10
	STA !15AC,x
Return2:
	PLY
	PLX
RTL

print "A block which spawns by default a mushroom if Mario is small, else an fire flower."