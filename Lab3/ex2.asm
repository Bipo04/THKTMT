.data
	A: .word 1,-2,-5,3
.text
	addi $s1,$zero, 0 #i=0
	la $s2,A #truy cap vao mang
	addi $s3,$zero,4 #so phan tu cua mang
	addi $s4,$zero,1 #step=1
	addi $s5,$zero,0 #max=0
	addi $s6,$zero,0 #index_max
loop: 
	add $t1,$s1,$s1 #t1=2*s1
	add $t1,$t1,$t1 #t1=4*s1
	add $t1,$t1,$s2 #t1 store the address of A[i]
	lw $t0,0($t1) #load value of A[i] in $t0
	slt $t2, $t0, $zero #A[i]<0
	bne $t2, $zero, duong
	beq $t2, $zero, check
duong: #lay tri tuyet doi
	sub $t0,$zero,$t0 #A[i]=|A[i]|
	j check
check: #kiem tra xem max<|A[i]|
	slt $t3,$s5,$t0 #max<|A[i]|
	bne $t3,$zero,max
	beq $t3,$zero,cont
max: #thay doi gia tri max
	add $s5,$t0,$zero 
	add $s6,$s1,$zero #index_max=i
	j cont
cont:
	add $s1,$s1,$s4 #i=i+step
	slt $t4,$s1,$s3 #i<n
	bne $t4,$zero, loop
end:
