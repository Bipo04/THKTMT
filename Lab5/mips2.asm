.data
string1: .asciiz "The sum of "
string2: .asciiz " and "
string3: .asciiz " is "
.text
li $s0,4
li $s1,5
add $t1,$s0,$s1

#Print string1
la $a0,string1
li $v0,4
syscall
#Print $s0
move $a0,$s0
li $v0,1
syscall
#Print string2
la $a0,string2
li $v0,4
syscall
#Print $s1
move $a0,$s1
li $v0,1
syscall
#Print string3
la $a0,string3
li $v0,4
syscall
#Print $t1
move $a0,$t1
li $v0,1
syscall



