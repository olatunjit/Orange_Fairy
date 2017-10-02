	AREA mycode, CODE, READONLY
	EXPORT __main

PERIPH_BASE EQU 0x40000000
Delay 		PROC 
			push {r1}
			ldr r1, =0x60000   ;initial value for loop counter
again  		NOP  		     ;execute two no-operation instructions
			NOP
			subs r1, #1
			bne again
			pop {r1}
			bx lr
			ENDP
			
pb2_init	PROC
			LDR	r0, =PERIPH_BASE
			ADD r0, #0x20000 	;AHB1PERIPH_BASE
			ADD r0, #0x1000		;RCC_BASE
			LDR	r1, [r0,#0x4C]  ;RCC->AHB2ENR
			ORR  r1,#2
			STR	r1, [r0,#0x4C]

			LDR	r0, =0x40000000 ;PERIPH_BASE
			ADD r0, #0x08000000	;AHB2PERIPH_BASE
			ADD r0, #0x0400		;GPIOB_BASE
			
			LDR r1, [r0,#0]
			AND r1,#0xFFFFFFCF  ;GPIOB->MODER   &=  ~(0x00000030)
			ORR	r1, #0x00000010	;GPIOB->MODER   |=   (0x00000010)
			STR	r1, [r0,#0]
			
			LDRH r1, [r0,#4]		;GPIOB->OTYPER
			AND	 r1,#0xFFFFFFFB
			STRH r1, [r0,#4]
			
			LDR r1, [r0,#8]		;GPIOB->OSPEEDR
			AND	r1,#0xFFFFFFCF
			ORR  r1, #0x00000010
			STR r1, [r0,#8]
			
			LDR r1, [r0,#0x0C]		;GPIOB->PUPDR
			AND	r1,#0xFFFFFFCF
			STR r1, [r0,#0x0C]
			
			bx	lr
			ENDP

			ENTRY
__main		PROC
	
			BL	pb2_init
			
			LDR	r0, =0x40000000 ;PERIPH_BASE
			ADD r0, #0x08000000	;AHBPERIPH_BASE
			ADD r0, #0x0400		;GPIOB_BASE
loop
			LDR  r1, =0x04
			STRH r1, [r0,#0x18]
			BL 	Delay
			
			STRH r1,[r0,#0x1A]
			BL 	Delay
			B	loop	
			
			ENDP
			END