db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioInside : JMP MarioHead

!XPlacement = $00	; Remember: $01-$7F moves the coin to the right and $80-$FF to the left.
!YPlacement = $F0	; Remember: $01-$7F moves the coin to the bottom and $80-$FF to the top.

!bounce_num			= $03	; See RAM $1699 for more details. If set to 0, the block changes into the Map16 tile directly
!bounce_direction	= $00	; Should be generally $00
!bounce_block		= $0D	; See RAM $9C for more details. Can be set to $FF to change the tile manually
!bounce_properties	= $00	; YXPPCCCT properties

; If !bounce_block is $FF.
!bounce_Map16 = $0132		; Changes into the Map16 tile directly (also used if !bounce_num is 0x00)
!bounce_tile = $2A			; The tile number (low byte) if BBU is enabled

!item_memory_dependent = 0	; Makes the block stay collected (though you may need to change the collected block)
!InvisibleBlock = 0			; Not solid, doesn't detect sprites, can only be hit from below
!ActivatePerSpinJump = 1	; Activatable with a spin jump (doesn't work if invisible)
; 0 for false, 1 for true

if !ActivatePerSpinJump
MarioCorner:
MarioAbove:
	LDA $140D|!addr
	BEQ Return
	LDA $7D
	BMI Return
	LDA #$D0
	STA $7D
	BRA Cape
else
MarioCorner:
MarioAbove:
endif

Return:
MarioSide:
Fireball:
MarioInside:
MarioHead:

if !InvisibleBlock
SpriteH:
SpriteV:
Cape:
RTL


MarioBelow:
	LDA $7D
	BPL Return
else
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

MarioBelow:
Cape:
endif

SpawnItem:
	PHX
	PHY
if !bounce_num
	if !bounce_block == $FF
		LDA #!bounce_tile
		STA $02
		LDA.b #!bounce_Map16
		STA $03
		LDA.b #!bounce_Map16>>8
		STA $04
	endif
	LDA #!bounce_num
	LDX #!bounce_block
	LDY #!bounce_direction
	%spawn_bounce_sprite()
	LDA #!bounce_properties
	STA $1901|!addr,y
else
	REP #$10
	LDX #!bounce_Map16
	%change_map16()
	SEP #$10
endif

if !item_memory_dependent == 1
	PHK
	PEA .jsl_2_rts_return-1
	PEA $84CE
	JML $00C00D|!bank
.jsl_2_rts_return
	SEP #$10
endif

; Spawns a coin
	LDX #$03
-	LDA $17D0|!addr,x
	BEQ .found_free
	DEX
	BPL -
	DEC $1865|!addr
	BPL .dont_reset
	LDA #$03
	STA $1865|!addr
.dont_reset
	LDX $1865|!addr
.found_free
	JSL $05B34A|!bank
	INC $17D0|!addr,x
	LDA $9A
	AND #$F0
	CLC : ADC #!XPlacement
	STA $17E0|!addr,x
	LDA $9B
if !XPlacement < $80
	ADC #$00
else
	SBC #$00
endif
	STA $17EC|!addr,x
	LDA $98
	AND #$F0
	CLC : ADC #!YPlacement
	STA $17D4|!addr,x
	LDA $99
if !YPlacement < $80
	ADC #$00
else
	SBC #$00
endif
	STA $17E8|!addr,x
	LDA $1933|!addr
	STA $17E4|!addr,x
	LDA #$D0
	STA $17D8|!addr,x

	PLY
	PLX
RTL

print "Spawns a coin."