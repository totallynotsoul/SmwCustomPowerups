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

EggColour:
db $05,$09
; $01 for palette 8
; $03 for palette 9
; $05 for yellow
; $07 for blue
; $09 for red
; $0B for green
; $0D for palette E
; $0F for palette F

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

	LDA #$2C
	CLC
	%spawn_sprite_block()
	TAX
	%move_spawn_into_block()

	LDA #$09
	STA !14C8,x
	LDA #$D0
	STA !AA,x
	LDA #$2C
	STA !154C,x

	LDA !190F,x
	BPL +
	LDA #$10
	STA !15AC,x
+
; Copied and modified from LX5's egg blocks
	LDY #$00
	LDA !RAM
	BEQ +
	LDY #$01
+	LDA SpriteNumber,y
	STA	!151C,x
	LDA	!15F6,x
	AND	#$F1
	ORA	EggColour,y
	STA	!15F6,x
	%move_spawn_into_block()

	PLY
	PLX
RTL

print "A block which spawns by default a mushroom if Mario is small, else a fire flower. Both appear in an egg."