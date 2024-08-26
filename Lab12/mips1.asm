.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014
.data
mess: .asciiz "\n"
.text
main:
li $t1, IN_ADRESS_HEXA_KEYBOARD
li $t2, OUT_ADRESS_HEXA_KEYBOARD
li $t3, 0x01 # check row 4 with key 0, 1, 2, 3
li $t4, 0x02 # check row 4 with key 4, 5, 6, 7
li $t5, 0x04 # check row 4 with key 8, 9, A, B
li $t6, 0x08 # check row 4 with key C, D, E, F

polling:
sb $t3, 0($t1) # must reassign expected row
lbu $a0, 0($t2) # read scan code of key button
bne $a0, $zero, print
sb $t4, 0($t1) # must reassign expected row
lbu $a0, 0($t2) # read scan code of key button
bne $a0, $zero, print
sb $t5, 0($t1) # must reassign expected row
lbu $a0, 0($t2) # read scan code of key button
bne $a0, $zero, print
sb $t6, 0($t1) # must reassign expected row
lbu $a0, 0($t2) # read scan code of key button
bne $a0, $zero, print
j sleep
print:
li $v0, 34 # print integer (hexa)
syscall
la $a0, mess #print "\n"
li $v0, 4
syscall
sleep:
li $a0, 3000 # sleep 3000ms
li $v0, 32
syscall
back_to_polling:
j polling # continue polling
exit: 
