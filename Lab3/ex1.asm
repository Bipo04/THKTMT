.data 
	i: .word 5
	j: .word 6
.text
	la $t5, i
	lw $s1, ($t5)
	la $t6, j
	lw $s2, ($t6)
	li $t1, 10
	li $t2, 10
	li $t3, 10
	add $t7, $s1, $s2
	addi $t8, $zero, 7 #m
	addi $t9, $zero, 8 #n
	add $t4, $t8, $t9 #m+n
start:
	sgt $t0,$t7,$t4 # i+j>m+n
	beq $t0,$zero,else # branch to else if i+j<=m+n
	addi $t1,$t1,1 # then part: x=x+1
	addi $t3,$zero,1 # z=1
	j endif # skip “else” part
else: 
	addi $t2,$t2,-1 # begin else part: y=y-1
	add $t3,$t3,$t3 # z=2*z
endif:
