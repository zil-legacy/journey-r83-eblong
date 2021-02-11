
	.SEGMENT "0"


	.FUNCT	ANONF-6:ANY:0:0
	CALL	FIRST-IN-PARTY,ESHER,HURTH,MINAR,PRAXIX >LEADER
	CALL	ADD-TRAVEL-COMMAND,LEADER,GET-ADVICE-COMMAND
	RSTACK	


	.FUNCT	ANONF-7:ANY:0:0
	ICALL	REMOVE-TRAVEL-COMMAND,LEADER,GET-ADVICE-COMMAND
	SET	'LEADER,BERGON
	RETURN	LEADER


	.FUNCT	ANONF-8:ANY:0:0
	CALL	FIRST-IN-PARTY,HURTH,MINAR
	ZERO?	STACK \FALSE
	ICALL	ADD-TRAVEL-COMMAND,ESHER,SCOUT-COMMAND
	CALL	ADD-PROVISION-COMMAND,ESHER,LOOK-AROUND-COMMAND
	RSTACK	


	.FUNCT	ANONF-9:ANY:0:0
	EQUAL?	ESHER,LEADER \FALSE
	CALL	FIRST-IN-PARTY,BERGON,HURTH,MINAR,PRAXIX >LEADER
	RETURN	LEADER


	.FUNCT	ANONF-10:ANY:0:0
	FSET	MINAR,DONT-DROP
	FSET?	HURTH,IN-PARTY /FALSE
	FSET?	ESHER,IN-PARTY \FALSE
	ICALL	REMOVE-TRAVEL-COMMAND,ESHER,SCOUT-COMMAND
	CALL	REMOVE-PROVISION-COMMAND,ESHER,LOOK-AROUND-COMMAND
	RSTACK	


	.FUNCT	ANONF-11:ANY:0:0
	FSET?	HURTH,IN-PARTY /FALSE
	FSET?	ESHER,IN-PARTY \FALSE
	ICALL	ADD-TRAVEL-COMMAND,ESHER,SCOUT-COMMAND
	CALL	ADD-PROVISION-COMMAND,ESHER,LOOK-AROUND-COMMAND
	RSTACK	


	.FUNCT	ANONF-12:ANY:0:0,F
	EQUAL?	HURTH,LEADER \?CND1
	CALL	FIRST-IN-PARTY,BERGON,ESHER,MINAR,PRAXIX >LEADER
?CND1:	CALL	FIRST-IN-PARTY,MINAR,ESHER >F
	ZERO?	F /FALSE
	ICALL	ADD-TRAVEL-COMMAND,F,SCOUT-COMMAND
	CALL	ADD-PROVISION-COMMAND,F,LOOK-AROUND-COMMAND
	RSTACK	


	.FUNCT	ANONF-13:ANY:0:0,F
	CALL	FIRST-IN-PARTY,MINAR,ESHER >F
	ZERO?	F /FALSE
	ICALL	REMOVE-TRAVEL-COMMAND,F,SCOUT-COMMAND
	CALL	REMOVE-PROVISION-COMMAND,F,LOOK-AROUND-COMMAND
	RSTACK	


	.FUNCT	CLEAR-PARTY-BIT:ANY:1:1,BIT,OFF
?PRG1:	IGRTR?	'OFF,PARTY-MAX /TRUE
	GET	PARTY,OFF
	FCLEAR	STACK,BIT
	JUMP	?PRG1


	.FUNCT	MAKE-UNBUSY:ANY:1:1,ACT
	FCLEAR	ACT,BUSY
	SET	'UPDATE-FLAG,TRUE-VALUE
	RETURN	UPDATE-FLAG


	.FUNCT	MAKE-BUSY:ANY:1:2,ACT,CMD,OFF,TBL
	ASSIGNED?	'CMD /?CND1
	SET	'CMD,BUSY-COMMAND
?CND1:	CALL2	PARTY-PCM,ACT >OFF
	ZERO?	OFF /FALSE
	FSET	ACT,BUSY
	GET	CHARACTER-INPUT-TBL,OFF >TBL
	PUT	TBL,0,CMD
	PUT	TBL,1,NUL-COMMAND
	PUT	TBL,2,NUL-COMMAND
	CALL2	NORMAL-ALL,OFF
	RSTACK	


	.FUNCT	CLEAR-BUSY:ANY:0:0
	CALL2	CLEAR-PARTY-BIT,BUSY
	RSTACK	


	.FUNCT	NEW-CHARACTER:ANY:1:1,CHR,ACT
	SET	'ACT,ACTOR
	ICALL2	PURIFY-CHARACTER,CHR
	SET	'UPDATE-FLAG,TRUE-VALUE
	ICALL1	PRINT-CHARACTER-COMMANDS
	SET	'ACTOR,ACT
	RETURN	ACTOR


	.FUNCT	PURIFY-CHARACTER:ANY:1:1,CHR
	FCLEAR	CHR,BUSY
	FCLEAR	CHR,SUBGROUP
	PUTP	CHR,P?STATUS,100
	RTRUE	


	.FUNCT	PARTY-ADD:ANY:1:1,CHR,NC
	ADD	PARTY-MAX,1 >NC
	GRTR?	NC,5 \?CND1
	PRINTI	"[Error: Attempt to add 6th party member]"
	ICALL2	WPRINTD,CHR
	RTRUE	
?CND1:	PUT	PARTY,PARTY-MAX,CHR
	PUT	PARTY,NC,TAG
	SET	'PARTY-MAX,NC
	FSET	CHR,IN-PARTY
	ICALL1	SORT-PARTY
	ICALL2	NEW-CHARACTER,CHR
	GETP	CHR,P?ADD
	CALL	STACK >NC
	SET	'UPDATE-FLAG,TRUE-VALUE
	RTRUE	


	.FUNCT	PARTY-CHANGE:ANY:2:2,CHR1,CHR2,CNT,TMP
	GET	PARTY,0 >CNT
?PRG1:	LESS?	CNT,1 /FALSE
	GET	PARTY,CNT
	EQUAL?	STACK,CHR1 \?CND3
	PUT	PARTY,CNT,CHR2
	FSET	CHR2,IN-PARTY
	FCLEAR	CHR1,IN-PARTY
	ICALL1	SORT-PARTY
	ICALL2	NEW-CHARACTER,CHR2
	GETP	CHR1,P?REMOVE
	CALL	STACK >TMP
	GETP	CHR2,P?ADD
	CALL	STACK >TMP
	SET	'UPDATE-FLAG,TRUE-VALUE
	RTRUE	
?CND3:	DEC	'CNT
	JUMP	?PRG1


	.FUNCT	PARTY-REMOVE:ANY:1:1,CHR,CNT,C,ACT,?TMP1,?TMP2
	SET	'ACT,ACTOR
?PRG1:	IGRTR?	'CNT,PARTY-MAX /FALSE
	GET	PARTY,CNT
	EQUAL?	STACK,CHR \?PRG1
	ADD	CNT,1
	MUL	STACK,2
	ADD	PARTY,STACK >?TMP2
	MUL	CNT,2
	ADD	PARTY,STACK >?TMP1
	SUB	PARTY-MAX,CNT
	MUL	STACK,2
	COPYT	?TMP2,?TMP1,STACK
	MUL	PARTY-MAX,2
	ADD	PARTY,STACK
	COPYT	STACK,0,2
	DEC	'PARTY-MAX
	FCLEAR	CHR,IN-PARTY
	ICALL1	SORT-PARTY
	SET	'UPDATE-FLAG,TRUE-VALUE
	ICALL1	PRINT-CHARACTER-COMMANDS
	SET	'ACTOR,ACT
	GETP	CHR,P?REMOVE
	CALL	STACK >C
	RTRUE	


	.FUNCT	SORT-PARTY:ANY:0:0,CNT
	SET	'CNT,1
	FSET?	BERGON,IN-PARTY \?CND1
	PUT	PARTY-SORT-TBL,CNT,BERGON
	INC	'CNT
?CND1:	FSET?	PRAXIX,IN-PARTY \?CND3
	PUT	PARTY-SORT-TBL,CNT,PRAXIX
	INC	'CNT
?CND3:	FSET?	ESHER,IN-PARTY \?CND5
	PUT	PARTY-SORT-TBL,CNT,ESHER
	INC	'CNT
?CND5:	FSET?	MINAR,IN-PARTY \?CND7
	PUT	PARTY-SORT-TBL,CNT,MINAR
	INC	'CNT
?CND7:	FSET?	HURTH,IN-PARTY \?CND9
	PUT	PARTY-SORT-TBL,CNT,HURTH
	INC	'CNT
?CND9:	FSET?	UMBER,IN-PARTY \?CND11
	PUT	PARTY-SORT-TBL,CNT,UMBER
	INC	'CNT
?CND11:	FSET?	TAG,IN-PARTY \?CND13
	PUT	PARTY-SORT-TBL,CNT,TAG
	INC	'CNT
?CND13:	MUL	PARTY-MAX,2
	ADD	STACK,2
	COPYT	PARTY-SORT-TBL,PARTY,STACK
	RTRUE	

	.ENDSEG

	.ENDI
