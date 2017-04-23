.ORG    0
JMP	ENTRY
VAR1	.BSC 0x5b
VAR2	.BSC 0x5c
STACK	.BSS 32
ENTRY:	
		LHI	$0, 0	
		LHI	$0, 0
		WWD	$0	; TEST #1-1 : LHI (= 0x0000)
		LHI	$1, 0
		WWD	$1	; TEST #1-2 : LHI (= 0x0000)
		LHI	$2, 0
		WWD	$2	; TEST #1-3 : LHI (= 0x0000)
		LHI	$3, 0
		WWD	$3	; TEST #1-4 : LHI (= 0x0000)

		ADI	$0, $1, 1
		WWD	$0	; TEST #2-1 : ADI (= 0x0001)
		ADI	$0, $0, 1
		WWD	$0	; TEST #2-2 : ADI (= 0x0002)

		ORI	$1, $2, 1
		WWD	$1	; TEST #3-1 : ORI (= 0x0001)
		ORI	$1, $1, 2
		WWD	$1	; TEST #3-2 : ORI (= 0x0003)
		ORI	$1, $1, 3
		WWD	$1	; TEST #3-3 : ORI (= 0x0003)

		ADD	$3, $0, $2
		WWD	$3	; TEST #4-1 : ADD (= 0x0002)
		ADD	$3, $1, $2
		WWD	$3	; TEST #4-2 : ADD (= 0x0003)
		ADD	$3, $0, $1
		WWD	$3	; TEST #4-3 : ADD (= 0x0005)

		SUB	$3, $0, $2
		WWD	$3	; TEST #5-1 : SUB (= 0x0002)
		SUB	$3, $2, $0
		WWD	$3	; TEST #5-2 : SUB (= 0xFFFE)
		SUB	$3, $1, $2
		WWD	$3	; TEST #5-3 : SUB (= 0x0003)
		SUB	$3, $2, $1
		WWD	$3	; TEST #5-4 : SUB (= 0xFFFD)
		SUB	$3, $0, $1
		WWD	$3	; TEST #5-5 : SUB (= 0xFFFF)
		SUB	$3, $1, $0
		WWD	$3	; TEST #5-6 : SUB (= 0x0001)

		AND	$3, $0, $2
		WWD	$3	; TEST #6-1 : AND (= 0x0000)
		AND	$3, $1, $2
		WWD	$3	; TEST #6-2 : AND (= 0x0000)
		AND	$3, $0, $1
		WWD	$3	; TEST #6-3 : AND (= 0x0002)

		ORR	$3, $0, $2
		WWD	$3	; TEST #7-1 : ORR (= 0x0002)
		ORR	$3, $1, $2
		WWD	$3	; TEST #7-2 : ORR (= 0x0003)
		ORR	$3, $0, $1
		WWD	$3	; TEST #7-3 : ORR (= 0x0003)

		NOT	$3, $0
		WWD	$3	; TEST #8-1 : NOT (= 0xFFFD)
		NOT	$3, $1
		WWD	$3	; TEST #8-2 : NOT (= 0xFFFC)
		NOT	$3, $2
		WWD	$3	; TEST #8-3 : NOT (= 0xFFFF)

		TCP	$3, $0
		WWD	$3	; TEST #9-1 : TCP (= 0xFFFE)
		TCP	$3, $1
		WWD	$3	; TEST #9-2 : TCP (= 0xFFFD)
		TCP	$3, $2
		WWD	$3	; TEST #9-3 : TCP (= 0x0000)

		SHL	$3, $0
		WWD	$3	; TEST #10-1 : SHL (= 0x0004)
		SHL	$3, $1
		WWD	$3	; TEST #10-2 : SHL (= 0x0006)
		SHL	$3, $2
		WWD	$3	; TEST #10-3 : SHL (= 0x0000)

		SHR	$3, $0
		WWD	$3	; TEST #11-1 : SHR (= 0x0001)
		SHR	$3, $1
		WWD	$3	; TEST #11-2 : SHR (= 0x0001)
		SHR	$3, $2
		WWD	$3	; TEST #11-3 : SHR (= 0x0000)

		LWD	$0, $2, VAR1
		WWD	$0	; TEST #12-1 : LWD (= 0x0001)
		LWD	$1, $2, VAR2
		WWD	$1	; TEST #12-2 : LWD (= 0xFFFF)

		SWD	$1, $2, VAR1
		SWD	$0, $2, VAR2

		LWD	$0, $2, VAR1
		WWD	$0	; TEST #13-1 : WWD (= 0xFFFF)
		LWD	$1, $2, VAR2
		WWD	$1	; TEST #13-2 : WWD (= 0x0001)
HLT
	.END