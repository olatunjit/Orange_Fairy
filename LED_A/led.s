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
init		PROC
			; output initialization
			LDR r0, =0x4002104C			; enable clocks for GPIOE and GPIOH and GPIOA
			LDR r1, [r0]
			ORR r1, r1, #0x00000001
			ORR r1, r1, #0x10
			ORR r1, r1, #0x80
			STR r1, [r0]
			
			
			
			
			;;Sets the type to push pull
			LDR E, =0x48001000
			LDR r1, [E,#0]
			LDR	r2, =~0xFFF00000
			AND r1, r1, r2  ;GPIOE->MODER   &=  ~(0xFFF00000)  		
			LDR r2, =0x55500000
			ORR	r1, r1, r2	;GPIOE->MODER   |=   (0x55500000)								
			STR	r1, [E,#0]
			
			
			
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
			LDR	r4, =~0x00000003
			AND r3, r3, r4  ;GPIOH->MODER   &=  ~(0x00000003) 
			ORR	r3, r3, #0x01	;GPIOH->MODER   |=   (0x00000001)								
			STR	r3, [H,#0]
			
			LDRH r3, [H,#4]		;GPIOH->OTYPER 
			AND	 r3, r3, #~(0x00000001)
			STRH r3, [H,#4]
			
			LDR r3, [H,#0xC]		;GPIOH->PUPDR
			LDR r4, =~0x000000003												
			AND	r3, r3, r4																		
			STR r3, [H,#0x0C]
			
			
			
			
			
			
			LDR r0, =0x48000000 		;Setting mode of GPIOA to input
			LDR r1, [r0]
			AND r1, r1, #~(0xCC0)
			STR r1, [r0]
			
			LDR r0, =0x48000004 		;Setting type of GPIOA to push pull
			LDR r1, [r0]
			AND r1, r1, #~(0x28)
			STR r1, [r0]
			
			LDR r0, =0x4800000C 		;Setting port a to pull down 
			LDR r1, [r0]
			AND r1, r1, #~(0xCC0)
			ORR r1, r1, #0x880
			STR r1, [r0]	
			BX LR
			ENDP



			ENTRY
__main		PROC
			BL init
			;;MAKE SHURE YOURE CHANGE THIDDSFSBD DSKFNASL
			
			
			LDR r0, =0x48001014 ;GPIOE ODR
			MOV r1, #0x66 ; change this later to zero
			AND r1, r1, #0x3F
			LSL r1, #10		; shifting 10 to the left
			STR r1, [r0]
			
			LDR r0, =0x48001C14 ;GPIOH ODR
			MOV r1, #0x66			;Segment zero
			AND r1, r1, #0x40
			LSR r1, #6
			STR r1, [r0]
	

			END
		