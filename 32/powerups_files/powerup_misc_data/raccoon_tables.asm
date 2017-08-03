@includefrom raccoon_engine.asm

;; Cape info tables, but for Raccoon tail.
;; and some misc exceptions

;32x32
cape_00E18E:
raccoon_00E18E:
db $00,$00,$00,$00,$00,$00,$00,$00	;[00-07]
db $00,$00,$00,$00,$00,$0D,$00,$10	;[08-0F]
db $13,$22,$25,$28,$00,$16,$00,$00	;[10-17]
db $00,$00,$00,$00,$00,$08,$19,$1C	;[18-1F]
db $04,$1F,$10,$10,$00,$16,$10,$06	;[20-27]
db $04,$08,$FF,$FF,$FF,$FF,$FF,$43	;[28-2F]
db $00,$00,$00,$00,$00,$00,$00,$00	;[30-37]
db $16,$16,$00,$00,$08			;[38-3C]
db $00,$00,$00,$00,$00,$00,$10,$04	;[3D-44]
db $00					;[45]



TailData_00E18E:
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$0D,$00,$10
	db $13,$22,$25,$28,$00,$16,$00,$00
	db $00,$00,$00,$00,$00,$08,$19,$1C
	db $04,$1F,$10,$10,$00,$16,$10,$06
	db $04,$08,$2B,$30,$35,$3A,$3F,$43
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $16,$16,$00,$00,$08,$00,$00,$00
	db $00,$00,$00,$10,$04,$00
TailData_00E1D4:
	db $06
TailData_00E1D5:
	db $00
TailData_00E1D6:
	db $06
TailData_00E1D7:
	db $00
TailData_00E1D8:
	db $86,$02,$06,$03,$06,$01,$06,$CE
	db $06,$06,$E8,$00,$06,$EC,$06,$06
	db $C8,$0E,$86,$EC,$06,$86,$EC,$E8
	db $86,$E8,$08,$06,$E8,$02,$06,$CC
	db $10,$06,$EC,$10,$06,$CC,$10,$00
	db $8C,$14,$14,$2E,$00,$CA,$16,$16
	db $00,$8E,$18,$18,$2E,$00,$EB,$1A
	db $1A,$2E,$04,$ED,$1C,$1C,$82,$06
	db $92,$1E 
TailData_00E21A:
	db $84,$86,$88,$8A,$8C,$8E,$90,$90
	db $92,$94,$96,$98,$9A,$9C,$9E,$A0
	db $A2,$A4,$A6,$A8,$AA,$B0,$B6,$BC
	db $C2,$C8,$CE,$D4,$DA,$DE,$E2,$E2
	
TailData_00E23A:		;tilemap
	db $E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8
	db $E8,$E8,$E8,$E8,$C8,$C8,$C8,$C8
	db $EA,$EA,$EA,$EA,$E8,$E8,$E8,$E8
	db $EA,$EA,$EA,$EA,$E8,$E8,$E8,$E8
	db $CC,$CC,$CC,$CC,$EA,$EA,$EA,$EA
	db $EA,$EA,$EA,$EA

TailData_00E266:
	db $02,$02,$02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02
