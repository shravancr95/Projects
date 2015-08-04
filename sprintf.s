#sprintf!
#$a0 has the pointer to the buffer to be printed to
#$a1 has the pointer to the format string
#$a2 and $a3 have (possibly) the first two substitutions for the format string
#the rest are on the stack
#return the number of characters (ommitting the trailing '\0') put in the buffer

        .text

sprintf:
	addi $sp, $sp, -32
	sb $ra, 16($sp)
	sb $a0, 12($sp)
	sb $a1, 8($sp)
	sb $a2, 4($sp)
	sb $a3, 0($sp)
	li $s0, 0 

loop:	lb  $t1, 0($a1)
	beq $t1, '%', modFound
	bne $t1, '\0', epi
	sb $t1, 0($a0)
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j loop
	
	 
modFound: 
	addi $s0, $s0, 1
	addi $a1, $a1, 1
	lb $t1, 0($a1)
	beq $t1, 'u', uDecimal
	beq $t1, 'x', uHex
	beq $t1, 'o', uOctal
	beq $t1, 's', String
	slti $t4, $t1, 9
	beq $t4, 1, String
	
uOctal:
	li $t5, 8
	lb $t1, 0($a2)
	div $t1, $t5
	mfhi $t3 #The remainder is set in t3
	mflo $t1 #quotient is set in $t1
	sb $t3, 0($a0)
	addi $a0, $a0, 1
	beq $t1, 0, loop
	bne $t1, 0, uOctal

uDecimal:
	li $t5, 10
	lb $t1, 0($a2)
	div $t1, $t5
	mfhi $t3 #The remainder is set in t3
	mflo $t1 #quotient is set in $t1
	sb $t3, 0($a0)
	addi $a0, $a0, 1
	beq $t1, 0, loop
	bne $t1, 0, uDecimal

uHex: 
	li $t5, 16
	lb $t1, 0($a2)
	div $t1, $t5
	mfhi $t3 #The remainder is set in t3
	mflo $t1 #quotient is set in $t1
	beq $t3, 10, HexA
	beq $t3, 11, HexB
	beq $t3, 12, HexC
	beq $t3, 13, HexD
	beq $t3, 14, HexE
	beq $t3, 15, HexF
	sb $t3, 0($a0)
	addi $a0, $a0, 1
	beq $t1, 0, loop
	bne $t1, 0, uHex
	
HexA:	lb $t3, 'A'
	sb $t3, 0($a0)
	addi $a0, $a0, 1
	beq $t1, 0, loop
	bne $t1, 0, uHex

HexB:	lb $t3, 'B'
	sb $t3, 0($a0)
	addi $a0, $a0, 1
	beq $t1, 0, loop
	bne $t1, 0, uDecimal

HexC:	lb $t3, 'C'
	sb $t3, 0($a0)
	addi $a0, $a0, 1
	beq $t1, 0, loop
	bne $t1, 0, uHex

HexD:	lb $t3, 'D'
	sb $t3, 0($a0)
	addi $a0, $a0, 1
	beq $t1, 0, loop
	bne $t1, 0, uHex

HexE:	lb $t3, 'E'
	sb $t3, 0($a0)
	addi $a0, $a0, 1
	beq $t1, 0, loop
	bne $t1, 0, uHex

HexF:	lb $t3, 'F'
	sb $t3, 0($a0)
	addi $a0, $a0, 1
	beq $t1, 0, loop
	bne $t1, 0, uHex
	
String: 


epi:		
	

	jr	$ra		#this sprintf implementation rocks!
