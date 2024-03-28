.text
start:
li $t0,0 #Default $t0 = 0 no overflow
li $s1, 0x7fffffff
li $s2, 2
addu $s3, $s1, $s2 # s3 = s1 + s2
xor $t1, $s1, $s2 #Test if $s1 and $s2 have the same sign
bltz $t1, EXIT #If not, exit
xor $t2, $s3, $s1 #Test if $s1 and $s3 have the same sign
bgtz $t2, EXIT #Neu $t2 > 0, exit
j OVERFLOW
OVERFLOW:
li $t0,1 #The result is overflow
EXIT:
