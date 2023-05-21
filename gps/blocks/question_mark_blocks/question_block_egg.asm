db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioInside : JMP MarioHead

!egg_color		= $0B	; $01 for palette 8
						; $03 for palette 9
						; $05 for yellow
						; $07 for blue
						; $09 for red
						; $0B for green
						; $0D for palette E
						; $0F for palette F
						; Note: This value also affects the yoshi color!
				
!egg_sprite		= $35	; Sprite that will come from the egg
				
!egg_1up		= $78	; Sprite that will spawn if there is a yoshi. By default, 1up.
						; Note: This value WON'T be used if you aren't spawning Yoshi from an egg.

!SoundEffect = $02
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
if !egg_sprite == $2D || !egg_sprite == $35
	LDY	#$0B
.loop
	LDA	!14C8,y
	CMP	#$08
	BCC	.next_slot
	LDA	!9E,y
	CMP	#$2D
	BNE	.next_slot
	LDA	#!egg_1up
	BRA	.found_and_store
.next_slot
	DEY	
	BPL	.loop
	LDA	#!egg_sprite
	LDY	$18E2|!addr
	BEQ	.found_and_store
	LDA	#!egg_1up
.found_and_store
else
	LDA	#!egg_sprite
endif
	STA	!151C,x
	LDA	!15F6,x
	AND	#$F1
	ORA	#!egg_color
	STA	!15F6,x

	PLY
	PLX
RTL

if !egg_sprite == $2D || !egg_sprite == $35
print "Spawns sprite $",hex(!egg_1up)," if Yoshi already exists, else $",hex(!egg_sprite),"."
else
print "Spawns sprite $",hex(!egg_sprite)," in an egg."
endif