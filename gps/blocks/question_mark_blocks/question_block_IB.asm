db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioInside : JMP MarioHead

!UseItemBoxSpecial	= 0	; 1 = true, 0 = false, anything else is bad

!Sprite = $74	; This depends whether you use the item box special or not
; If you don't use it, it simply is the $9E (sprite number) value.
; If you do use it, however, the value is stored into $0DC2 directly.

!SoundEffect = $0B
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

	LDA.b #!Sprite-($73*(1-!UseItemBoxSpecial))	; Shift offset
	STA $0DC2|!addr
Return2:
	PLY
	PLX
RTL

if !UseItemBoxSpecial
	print "Sets the item box item to $",hex(!Sprite),"."
else
	print "Puts sprite $",hex(!Sprite)," into the item box."
endif
