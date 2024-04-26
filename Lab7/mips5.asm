.data 
msg1: .asciiz "Largest:" 
msg2: .asciiz "\nSmallest:" 
.text 
main: 
# Khởi tạo giá trị từ thanh ghi $s0 đến thanh ghi $s7
li $s0, 5
li $s1, 2 
li $s2, -2 
li $s3, 9 
li $s4, -12 
li $s5, 20
li $s6, -3
li $s7, -15

jal produce 
nop 
 
li $v0, 4 
la $a0, msg1 
syscall  
add $a0, $t0, $zero
li $v0,1 
syscall  
li $v0,11 
li $a0, ',' 
syscall 
add $a0, $a1, $zero 
li $v0,1 
syscall 
li $v0, 4 
la $a0, msg2 
syscall  
add $a0, $t1, $zero
li $v0,1 
syscall  
li $v0,11 
li $a0, ',' 
syscall 
add $a0, $a2, $zero 
li $v0,1 
syscall 
li $v0, 10 
syscall  
endmain: 

swapMax: add $t0,$t3,$zero 
add $a1,$t2,$zero  
jr $ra 

swapMin: add $t1,$t3,$zero 
add $a2,$t2,$zero 
jr $ra

produce: #find largest vs smallest 
add $a3,$sp,$zero # Save address of origin $sp 
addi $sp, $sp, -32 # integerS in stack 
sw $s1, 0($sp) 
sw $s2, 4($sp) 
sw $s3, 8($sp) 
sw $s4, 12($sp) 
sw $s5, 16($sp) 
sw $s6, 20($sp) 
sw $s7, 24($sp) 
sw $ra, 28($sp) 
add $t0,$s0,$zero # Max = $s0 
add $t1,$s0,$zero # Min = $s0 
li $a1, 0 # Index of Max  
li $a2, 0 # Index of Min  
li $t2, 0 # i = 0 
loop: 
addi $sp, $sp, 4 
lw $t3, -4($sp) 
sub $t6, $sp, $a3  
beq $t6,$zero, done # If $sp = $fp branch to the 'done' 
nop 
addi $t2,$t2,1 # i++ 
sub $t6,$t0,$t3  
bltzal $t6, swapMax # If $t3 > Max branch to the swapMax 
nop 
sub $t6,$t3,$t1 
bltzal $t6, swapMin # If $t3 < Min branch to the swapMin 
nop 
j loop  
done: 
lw $ra, -4($sp) 
jr $ra # Return to calling program