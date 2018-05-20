	LDI R16,LOW(RAMEND)
	OUT SPL,R16
	LDI R16,HIGH(RAMEND)
	OUT SPH,R16
	LDI R16,0XFF
	OUT DDRC,R16//
	OUT DDRA,R16
	OUT DDRA,R16//
	LDI R16,0XF0
	OUT DDRD,R16
	OUT PORTD,R16
	
L10:
	LDI R21,0
	LDI R22,0
	LDI R23,0
	LDI R24,0
	LDI R25,1
	
L0:
	CALL REFRESH 
	CALL DELAY
	CALL READ_KEY
	CPI R16,100
	BREQ L0
///////////////CHECK KEY IF KEY IS +
      CPI R16,15
	  BREQ L14
	  JMP L15
	  L14:

	MOV R30,R24
	MOV R29,R23
	MOV R28,R22
	MOV R27,R21
	CALL HAND_UP
	
	JMP L10
	/////////////////////////////////

	L15:

	///////CHECK KEY IF KEY IS =
	 CPI R16,11
	  BREQ L16
	  JMP L17
	  L16:

	/*MOV R21, R27
	MOV R22, R28
	MOV R23, R29
	MOV R24, R30*/
	CLC
	ADC R21,R27
	CPI R21,10
	BRLO L21
	SUBI R21,10
	SEC
	JMP L212
	L21: CLC
	L212:ADC R22,R28
	CPI R22,10
	BRLO L18
	SUBI R22,10
	SEC
	JMP L22
	L18:
	CLC
	L22:
	ADC R23,R29
	CPI R23,10
	BRLO L19
	SUBI R23,10
	SEC
	JMP L23
	L19:
	CLC
	L23:
	ADC R24,R30
	CPI R24,10
	BRLO L20
	SUBI R24,10
	SEC
	L20:
	CALL HAND_UP


	 JMP L0
	///////////////////////
	L17:

	

	

	MOV R24,R23
	MOV R23,R22
	MOV R22,R21
	MOV R21,R16
	CALL HAND_UP
	



	JMP L0


	
;==============================================================
HAND_UP:
	HU0:
	 CALL READ_KEY
	 
	 CPI R16,100
	 BRNE HU0
	 CALL DELAY
	HU1:
	 CALL READ_KEY
	 CPI R16,100
	 BRNE HU1
	RET
;==============================================================
READ_KEY:
	;-----FOR COL 1
	LDI R16,0B11101111
	OUT PORTD,R16
	NOP
	LDI R16,100
	SBIS PIND,0//
		LDI R16,1
	SBIS PIND,1//
		LDI R16,4
	SBIS PIND,2
		LDI R16,7
	SBIS PIND,3
		LDI R16,10
	
	CPI R16,100
	BRNE RK_RET
	;-----FOR COL 2
	LDI R16,0B11011111
	OUT PORTD,R16
	NOP
	LDI R16,100
	SBIS PIND,0
		LDI R16,2
	SBIS PIND,1
		LDI R16,5
	SBIS PIND,2
		LDI R16,8
	SBIS PIND,3
		LDI R16,0

		CPI R16,100
	BRNE RK_RET
		;-----FOR COL 3
	LDI R16,0B10111111
	OUT PORTD,R16
	NOP
	LDI R16,100
	SBIS PIND,0
		LDI R16,3
	SBIS PIND,1
		LDI R16,6
	SBIS PIND,2
		LDI R16,9
	SBIS PIND,3
		LDI R16,11 //11 for =
	
	CPI R16,100
	BRNE RK_RET

		;-----FOR COL 4
	LDI R16,0B01111111
	OUT PORTD,R16
	NOP
	LDI R16,100
	SBIS PIND,0
		LDI R16,12 // 12 for /
	SBIS PIND,1
		LDI R16,13 // 13 for *
	SBIS PIND,2
		LDI R16,14 //14 for -
	SBIS PIND,3
		LDI R16,15 //15 for +
	
	CPI R16,100
	BRNE RK_RET

RK_RET:
	RET
;==============================================================
REFRESH:
	LDI R16,0B11111111
	OUT PORTC,R16//
	CPI R25,1
	BRNE REF2
		MOV R16,R21
		CALL CONVERT_CODE_FOR_SEGMENT
		OUT PORTA,R16//
		LDI R16,0B01111111
		OUT PORTC,R16//
		INC R25
		JMP REF_RET
REF2:
	CPI R25,2
	BRNE REF3
		MOV R16,R22
		CALL CONVERT_CODE_FOR_SEGMENT
		OUT PORTA,R16//
		LDI R16,0B10111111
		OUT PORTC,R16//
		INC R25
		JMP REF_RET
REF3:
	CPI R25,3
	BRNE REF4
		MOV R16,R23
		CALL CONVERT_CODE_FOR_SEGMENT
		OUT PORTA,R16//
		LDI R16,0B11011111
		OUT PORTC,R16//
		INC R25
		JMP REF_RET

	REF4:
		MOV R16,R24
		CALL CONVERT_CODE_FOR_SEGMENT
		OUT PORTA,R16//
		LDI R16,0B11101111
		OUT PORTC,R16//
		LDI R25,1
		JMP REF_RET
	
REF_RET:
	RET


;==============================================================
CONVERT_CODE_FOR_SEGMENT:
	CPI R16,00
BRNE CF7S00
LDI R16,0B00111111
JMP FOR_RET

CF7S00:
CPI R16,01
BRNE CF7S01
LDI R16,0B00000110
JMP FOR_RET

CF7S01:
CPI R16,02
BRNE CF7S02
LDI R16,0B1011011
JMP FOR_RET

CF7S02:
CPI R16,03
BRNE CF7S03
LDI R16,0B1001111
JMP FOR_RET

CF7S03:
CPI R16,04
BRNE CF7S04
LDI R16,0B1100110
JMP FOR_RET

CF7S04:
CPI R16,05
BRNE CF7S05
LDI R16,0B1101101
JMP FOR_RET

CF7S05:
CPI R16,06
BRNE CF7S06
LDI R16,0B1111101
JMP FOR_RET

CF7S06:
CPI R16,07
BRNE CF7S07
LDI R16,0B0000111
JMP FOR_RET

CF7S07:
CPI R16,8
BRNE CF7S08
LDI R16,0B1111111
JMP FOR_RET

CF7S08:
CPI R16,9
BRNE CF7S09
LDI R16,0B1100111
JMP FOR_RET

CF7S09:
FOR_RET:
RET

;==============================================================

DELAY:
	PUSH R17
	PUSH R18
	PUSH R19
	LDI R19,5
	D0:
		LDI R18,20
		D1:	
			LDI R17,250
			D2:
				NOP
				DEC R17
			BRNE D2
			DEC R18
		BRNE D1
		DEC R19
	BRNE D0
	POP R19
	POP R18
	POP R17

	RET