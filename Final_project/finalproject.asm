.data
	mess_input: .asciiz "Nhap lenh: "
	mess_correct: .asciiz "Lenh vua nhap dung voi cu phap"
	mess_opcode: .asciiz "Opcode: "
	mess_operand: .asciiz "Toan hang: "
	mess_valid: .asciiz " hop le.\n"
	mess_cycle: .asciiz "So chu ki cua cau lenh: "
	mess_not_found: .asciiz "Khong tim duoc lenh nay!"
	mess_error: .asciiz " loi cu phap!"
	mess_incorrect: .asciiz "Lenh vua nhap sai voi cu phap"
	mess: .asciiz "\n=>"
	command: .space 100
	opcode: .space 10
	operand: .space 20
	#Cac lenh co cac kieu toan hang la: thanh ghi = 1, hang so imm = 2, label = 3
	CommandData: .asciiz "addi.112.4;andi.112.4;ori.112.4.;add.111.4.;and.111.4.;or.111.4..;nor.111.4.;sub.111.4.;slt.111.4.;beq.113.4.;j.3.3.....;jal.3.3...;lw.121.5..;sw.121.5..;lb.121.5..;sb.121.5..;"
	LabelCharData: .asciiz "0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_."
	NumberData: .asciiz "0123456789"
	HexaData: .asciiz "0123456789ABCDEFabcdef"
	RegisterData: .asciiz "zero at   v0   v1   a0   a1   a2   a3   t0   t1   t2   t3   t4   t5   t6   t7   s0   s1   s2   s3   s4   s5   s6   s7   t8   t9   k0   k1   gp   sp   fp   ra"
.text
main:

#Nhap va nhan lenh tu input
enter_input: li $v0,4
	la $a0,mess_input
	syscall
	li $v0,8
	la $a0,command 
	li $a1,100
	syscall
#Luu gia tri command $s0
la $s0,command

#---------------------------------------------------------------------------------
#Doc opcode
la $a1,opcode
li $t2,0
read_opcode: add $t3,$s0,$t2
	add $t4,$a1,$t2
	lb $t1,0($t3)
	beq $t1,32,compare_opcode #Neu la ki tu ' ' thi dung
	beq $t1,0,compare_opcode	#Neu la ki tu ket thuc xau thi dung
	beq $t1,10,compare_opcode	#Neu la ki tu '\n' thi dung
	sb $t1,0($t4)
	addi $t2,$t2,1
	j read_opcode
	
#---------------------------------------------------------------------------------
#Kiem tra opcode
compare_opcode: la $t0,opcode
	la $s1,CommandData
	li $t9,0
	j co_loop
co_next_loop: addi $s1,$s1,11
	li $t9,0
co_loop: add $t1,$s1,$t9
	lb $t2,0($t1)
	add $t3,$t0,$t9
	lb $t4,0($t3)
	beq $t2,46,check
	beq $t2,0,not_found
	bne $t2,$t4,co_next_loop
	addi $t9,$t9,1
	j co_loop
check: beq $t4,0,opcode_found
	j co_next_loop
#---------------------------------------------------------------------------------
#Kiem tra toan hang
check_operand: addi $t8,$t9,1
	li $s2,1
choose: beq $s2,1,read_operand_1
	beq $s2,2,read_operand_2
	beq $s2,3,read_operand_3
	beq $s2,4,cycle
read_operand_1: add $s2,$s2,1
	addi $t9,$t9,1
	add $t1,$s1,$t8
	addi $t8,$t8,1
	lb $t2,0($t1)
	beq $t2,46,cycle
	jal read_operand
	beq $t2,49,compare_register
	beq $t2,50,compare_imm
	beq $t2,51,compare_label
read_operand_2: add $s2,$s2,1
	addi $t9,$t9,1
	add $t1,$s1,$t8
	addi $t8,$t8,1
	lb $t2,0($t1)
	beq $t2,46,cycle
	jal read_operand
	beq $t2,49,compare_register
	beq $t2,50,compare_imm
	beq $t2,51,compare_label
read_operand_3: add $s2,$s2,1
	addi $t9,$t9,1
	add $t1,$s1,$t8
	addi $t8,$t8,2
	lb $t2,0($t1)
	beq $t2,46,cycle
	jal read_operand
	beq $t2,49,compare_register
	beq $t2,50,compare_imm
	beq $t2,51,compare_label
#---------------------------------------------------------------------------------
#Kiem tra thanh ghi
compare_register: la $t0,operand
	la $s3,RegisterData
	li $t7,0
	j ce_loop
ce_next_loop: addi $s3,$s3,5
	li $t7,0
ce_loop: add $t1,$s3,$t7
	lb $t2,0($t1)
	beq $t2,0,error	 #Neu la ki tu ket thuc xau thi ko thoa man
	beq $t2,32,operand_ok
	add $t3,$t0,$t7
	lb $t4,0($t3)
	bne $t2,$t4,ce_next_loop
	addi $t7,$t7,1
	j ce_loop
#---------------------------------------------------------------------------------
#Kiem tra imm
compare_imm: la $t0,operand
	lb $t5,1($t0)
	bne $t5,120,imm_number
	lb $t5,0($t0)
	bne $t5,48,error
	bgt $a3,10,error
	la $s3,HexaData
	li $t6,2
	li $t7,0
	add $t3,$t0,$t6
	lb $t4,0($t3)
	j ci_loop
imm_number: la $s3,NumberData
	li $t6,0
	li $t7,0
	add $t3,$t0,$t6
	lb $t4,0($t3)
	beq $t4,45,next_ci_loop
	j ci_loop
next_ci_loop:
	addi $t6,$t6,1
	add $t3,$t0,$t6
	lb $t4,0($t3)
	beq $t4,0,operand_ok
	li $t7,0
ci_loop: add $t1,$s3,$t7
	lb $t2,0($t1)
	beq $t2,0,error
	beq $t2,$t4,next_ci_loop
	addi $t7,$t7,1
	j ci_loop
#---------------------------------------------------------------------------------
#Kiem tra label
compare_label:  la $t0,operand
	lb $t5,0($t0)
	blt $t5,48,continue
	ble $t5,57,error
continue: la $s3,LabelCharData
	li $t6,0
	add $t3,$t0,$t6
	lb $t4,0($t3)
	j cl_loop
next_cl_loop: addi $t6,$t6,1
	add $t3,$t0,$t6
	lb $t4,0($t3)
	beq $t4,0,operand_ok
	li $t7,0
cl_loop: add $t1,$s3,$t7
	lb $t2,0($t1)
	beq $t2,0,error
	beq $t2,$t4,next_cl_loop
	addi $t7,$t7,1
	j cl_loop

#---------------------------------------------------------------------------------
#Hien thi chu ki
cycle: add $t1,$s1,$t8
	lb $t2,0($t1)
	addi $t2,$t2,-48
	li $v0, 4
	la $a0, mess_cycle
	syscall
	li $v0, 1
	add $a0,$t2,$zero
	syscall
	j confirm
#---------------------------------------------------------------------------------
not_found: li $v0, 4
	la $a0, mess_not_found
	syscall
	j end

opcode_found: li $v0,4
	la $a0,mess_opcode
	syscall
	li $v0,4
	la $a0,opcode
	syscall
	li $v0, 4
	la $a0, mess_valid
	syscall
	j check_operand
	
operand_ok: li $v0, 4
	la $a0, mess_operand
	syscall
	li $v0, 4
	la $a0, operand
	syscall
	li $v0, 4
	la $a0, mess_valid
	syscall
	j choose
	
error: li $v0, 4
	la $a0, mess_operand
	syscall
	li $v0, 4
	la $a0, operand
	syscall
	li $v0, 4
	la $a0, mess_error
	syscall
	li $v0, 4
	la $a0, mess
	syscall
	li $v0, 4
	la $a0, mess_incorrect
	syscall
	j end
	
confirm: li $v0, 4
	la $a0, mess
	syscall
	li $v0, 4
	la $a0, mess_correct
	syscall
	
#---------------------------------------------------------------------------------
#Ket thuc chuong trinh
end: li $v0,10
	syscall

#---------------------------------------------------------------------------------
#Doc toan hang
read_operand:
save:addi $sp,$sp,4 # Save $t1 because we may change it later
	sw $t1,0($sp)
	addi $sp,$sp,4 # Save $t2 because we may change it later
	sw $t2,0($sp)
	addi $sp,$sp,4 # Save $t3 because we may change it later
	sw $t3,0($sp)

li $t2,0
la $a1,operand

#Doc thanh ghi
read: 	add $t3,$s0,$t9
	add $t4,$a1,$t2
	lb $t1,0($t3)
	beq $t1,32,end_read	#Neu la ki tu ' ' thi dung
	beq $t1,0,end_read	#Neu la ki tu ket thuc xau thi dung
	beq $t1,10,end_read	#Neu la ki tu '\n' thi dung
	beq $t1,44,end_read	#Neu la ki tu ',' thi dung
	beq $t1,40,end_read	#Neu la ki tu '(' thi dung
	beq $t1,41,end_read	#Neu la ki tu ')' thi dung
	sb $t1,0($t4)
	addi $t2,$t2,1
	addi $t9,$t9,1
	j read

end_read: add $t4,$a1,$t2
	add $a3,$zero,$t2
	sb $zero,0($t4)
restore: lw $t3, 0($sp) # Restore the registers from stack
	addi $sp,$sp,-4
	lw $t2, 0($sp) # Restore the registers from stack
	addi $sp,$sp,-4
	lw $t1, 0($sp) # Restore the registers from stack
	addi $sp,$sp,-4

jr $ra




