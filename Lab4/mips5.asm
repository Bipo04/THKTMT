.text
li $s0,8
li $s1,15
Loop:
beq $s0,1,Exit #If $s0 = 1, exit
srl $s0,$s0,1 #shift right $s0 1 bit 
sll $s1,$s1,1 #shift left $s1 1 bit
j Loop
Exit: