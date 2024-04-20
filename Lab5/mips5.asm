# Dao nguoc str va luu vao reverse_str
.data
str: .space 50
reverse_str: .space 50
mess: .asciiz "Chuoi dao nguoc la: "
.text
	la 	$a3, reverse_str #nap dia chi cua reverse_str
read_str:
	li	$v0,8
	la	$a0,str
	li	$a1,21 #20 ky tu
	syscall
reverse:	
#Dem do dai xau str
	xor	 $t3,$0,$0 #t3 = 0
	li 	 $t0,0 #t0 = i =0	
length:	add 	 $t1,$a0,$t0 #t1 = diachi str[i]
	lb 	 $t2,0($t1) #load byte t1 vao t2
	beq 	 $t2,$0,end_length #t2 = null -> ket thuc
	addi 	 $t0,$t0,1 #i++
	addi 	 $t3,$t3,1 #t3++
	j length	
end_length:
	subi 	 $t3,$t3,1	
	andi	 $t0,$t0,0 #reset lai bien i
change: add 	 $t1,$a0,$t3 #t1 = diachi str[i]
	lb 	 $t2,0($t1) #load byte t1 vao t2
	add 	 $t4,$a3,$t0 # t4 = dia chi reverse_str[i]
	sb	 $t2,0($t4) #luu t2 vao t4
	beq 	 $t2,$0,end_change #t2=null -> end
	addi 	 $t0,$t0,1 #i++
	subi     $t3,$t3,1 #t3--
	j change
end_change:
printf: # In xau reverse_str
	li $v0,4
	la $a0,mess
	syscall
	
	li $v0,4
	la $a0, reverse_str
	syscall
