@includefrom extended_sprites.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; vvv --- Here goes your blocks tables --- vvv



;; ^^^ --- Here goes your blocks tables --- ^^^
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


InteractPointers:
	dw	.Smoke					;00
	dw	.BreakNormal				;01
	dw	.BreakRainbow				;02
	dw	.KillHammerBoomerang			;03
	dw	.BreakNormalKillHammerBoomerang		;04
	dw	.BreakRainbowKillHammerBoomerang	;05
	dw	.TriggerOnOffBlock			;06
	dw	.SmokeKillHammerBoomerang		;07
	dw	.CollectCoin				;08
	dw	.ReleaseItemFromBoomerang		;09

.Smoke
	%prepare()
	%generate_smoke()
	%generate_smw_tile($02)
	%return()
.BreakNormal
	%prepare()
	%shatter_block($00)
	%generate_smw_tile($02)
	%return()
.BreakRainbow
	%prepare()
	%shatter_block($01)
	%generate_smw_tile($02)
	%return()
.KillHammerBoomerang
	%prepare()
	%kill_hammer_boomerang()
	%generate_sound($03,$1DF9)
	%return()
.BreakNormalKillHammerBoomerang
	%prepare()
	%shatter_block($00)
	%generate_smw_tile($02)
	%kill_hammer_boomerang()
	%generate_sound($03,$1DF9)
	%return()
.BreakRainbowKillHammerBoomerang
	%prepare()
	%shatter_block($01)
	%generate_smw_tile($02)
	%kill_hammer_boomerang()
	%generate_sound($03,$1DF9)
	%return()
.TriggerOnOffBlock
	%prepare()
	%trigger_on_off()
	%kill_hammer_boomerang()
	%generate_sound($03,$1DF9)
	%return()
.SmokeKillHammerBoomerang
	%prepare()
	%generate_smoke()
	%generate_smw_tile($02)
	%kill_hammer_boomerang()
	%return()
.CollectCoin
	%prepare()
	%generate_smw_tile($01)
	%give_coins($01)
	%create_glitter()
	%return()
.ReleaseItemFromBoomerang
	%prepare()
	%release_item_from_boomerang()
	%return()