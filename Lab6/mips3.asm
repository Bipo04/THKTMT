.data
	A: .word 7, -2, 5, 1, 5,6,7,3,6,8,8,59,5
	Aend: .word
.text
main: 
	la $a0,A #$a0 = Address(A[0])
	la $a1,Aend
	addi $a1,$a1,-4 #$a1 = Address(A[n-2])
	j sort #sort
after_sort: 
	li $v0, 10 #exit
	syscall
end_main:
#--------------------------------------------------------------
#procedure sort (ascending bubble sort using pointer)
#register usage in sort program
#$a0 trỏ đến phần tử đầu tiền của mảng
#$a1 trỏ đến phần tử cuối cùng của mảng
#$t0 check = 1 nếu có phần tử được hoán đổi, = 0 nếu ko có phần tử nào được hoán đổi
#$t1 trỏ đến A[i]
#$t2 trỏ đến A[i+1]
#$v0 = A[i]
#$v1 = A[i+1]
#--------------------------------------------------------------
sort:
	add $t1,$a0,$zero #$t1 trỏ đến A[0]
	add $t0,$zero,$zero #$t0 = 0
	j loop
check: 
	beq $t0,$zero,done #nếu ko có phần tử nào được hoán đổi thì nhảy đến done
	j reset #tiep tu vong lap moi
reset:
	add $t0,$zero,$zero
	add $t1,$a0,$zero
	j loop
swap: 
	sw $v0,0($t2) 
	sw $v1,0($t1)
	li $t0,1
	j next_loop #tiếp tục vòng lặp với phần tử tiếp theo
next_loop:
	addi $t1,$t1,4 
	j loop
loop:
	beq $t1,$a1,check
	lw $v0,0($t1) #$v0 = A[i]
	addi $t2,$t1,4
	lw $v1,0($t2) #$v0 = A[i+1]
	sgt $t5,$v0,$v1 #$v0>$v1
	bne $t5,$zero,swap #Nếu $v0>$v1 thì swap
	j next_loop #tiếp tục vòng lặp với phần tử tiếp theo
done: 
	j after_sort