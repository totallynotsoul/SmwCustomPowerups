db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioInside : JMP MarioHead

!Sprite = $04	; sprite number
!IsCustom = CLC ; CLC for normal, SEC custom sprite
!State = $09	; $08 for normal, $09 for carryable sprites
!1540_val = $00	; If you use powerups, this should be $3E
				; Carryable sprites uses it as the stun timer

!XPlacement = $00	; Remember: $01-$7F moves the sprite to the right and $80-$FF to the left.
!YPlacement = $00	; Remember: $01-$7F moves the sprite to the bottom and $80-$FF to the top.

!SoundEffect = $03
!APUPort = $1DFC|!addr

!bounce_num			= $03	; See RAM $1699 for more details
!bounce_direction	= $00	; Should be generally $00
!bounce_block		= $0D	; See RAM $9C for more details. Can be set to $1C or larger to change the tile manually
!bounce_properties	= $00	; YXPPCCCT properties

; If !bounce_block is $1C or larger.
!bounce_Map16 = $0132		; Changes into the Map16 tile directly

!item_memory_dependant = 0	; 0 for false, 1 for true

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
	JSR Spawn_Sprite
	BCS Return2
	TAX
	if !XPlacement
		LDA #!XPlacement
		STA $00
	else
		STZ $00
	endif
	if !YPlacement
		LDA #!YPlacement
		STA $01
	else
		STZ $01
	endif
	TXA
	%move_spawn_relative()

	LDA #!1540_val
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

Spawn_Sprite:
	JSL $02A9E4|!bank
	BMI .no_sprite_found
	TYX
	STX $185E|!addr
	LDA #!Sprite
	STA !9E,x
	JSL $07F7D2|!bank
	!IsCustom
	BCC .not_custom
	LDA !9E,x
	STA !7FAB9E,x
	JSL $0187A7|!bank
	LDA #$08
	STA !7FAB10,x
.not_custom
	LDA #!State
	STA !14C8,x
	TXA
	CLC
RTS
.no_sprite_found
	SEC
RTS

print "Spawns enemy sprite $",hex(!Sprite),"."