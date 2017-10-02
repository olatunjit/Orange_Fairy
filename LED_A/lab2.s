			AREA myData, DATA
			ALIGN
array 		DCD 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71	; array from 0-F
size		DCD 16

E			RN  r6
H			RN  r7
A			RN  r8


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
			



			ENTRY
__main		PROC
			LDR r0, =0x40021000		; Enable clock
			LDR r1, [r0]
			ORR r1, r1, #0x1
			STR r1, [r0]
			
			LDR r0, =0x40021008		; Choose MSI as clock
			LDR r1, [r0]
			AND r1, r1, #~(0x3)
			STR r1, [r0]
			
			LDR r0, =0x40021000		
			LDR r1, [r0]
			AND r1, r1, #~(0xF0)
			ORR r1, r1, #0x70				; set MSI to 8MHz
			ORR r1, r1, #0x8				; use MSIRANGE in CR
			STR r1, [r0]
			
			;BL	pE_init
			LDR	E, =0x48001000 ; GPIOE_BASE     
			
			LDR r1, [E,#0]
			LDR	r2, =~0xFFF00000
			AND r1, r1, r2  ;GPIOE->MODER   &=  ~(0xFFF00000)  		
			LDR r2, =0x55500000
			ORR	r1, r1, r2	;GPIOE->MODER   |=   (0x55500000)								
			STR	r1, [E,#0]
			
			;;Sets the type to push pull
			LDRH r1, [E,#4]		;GPIOE->OTYPER ??location
			AND	 r1,#~(0x3F)
			STRH r1, [E,#4]
			
			;;Sets the Pupdr
			LDR r1, [E,#0xC]		;GPIOE->PUPDR
			LDR r11, [r1] 
			LDR r2, =~0xFFF00000											
			AND	r1, r1, r2			
			STR r1, [E,#0xC]
			
			
			
			LDR	H, =0x48001C00 ;GPIOH_BASE     
			
			LDR r3, [H,#0]
			LDR	r4, =0x00000003
			AND r3, r4  ;GPIOH->MODER   &=  ~(0x00000003) 
			LDR r2, =0x55500000
			ORR	r3, r4	;GPIOH->MODER   |=   (0x00000001)								
			STR	r3, [H,#0]
			
			LDRH r3, [H,#4]		;GPIOH->OTYPER 
			AND	 r3, #0x00000001
			STRH r3, [H,#4]
			
			LDR r3, [H,#0xC]		;GPIOH->PUPDR
			LDR r4, =0x000000003												
			AND	r3, r4																		
			STR r3, [H,#0x0C]
			
			
			LDR	r0, =0x40000000 ;PERIPH_BASE
			ADD r0, #0x08000000	;AHBPERIPH_BASE
			ADD r0, #0x1000		;GPIOE_BASE
			
			LDR r0, =0x48001014 ;GPIOE ODR
			MOV r1, #0x5B ; change this later to zero
			AND r1, r1, #0X3F
			LSL r1, #10		; shifting 10 to the left
			STR r1, [r0]
			
			LDR r0, =0x48001C14 ;GPIOH ODR
			MOV r1, #0x5B ;Segment zero
			AND r1, r1, #0x40
			LSR r1, #6
			STR r1, [r0]

			END