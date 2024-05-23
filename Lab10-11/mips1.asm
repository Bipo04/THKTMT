# Định nghĩa địa chỉ của các màn hình bảy đoạn
.eqv SEVENSEG_LEFT 0xFFFF0011  # Địa chỉ của màn hình bảy đoạn bên trái
.eqv SEVENSEG_RIGHT 0xFFFF0010 # Địa chỉ của màn hình bảy đoạn bên phải

.data
# Định nghĩa các mẫu bit cho các số 0-9 (theo dạng common cathode)
SEVENSEG_PATTERNS: .word 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F
Aend: .word

.text
main:
# Tạo mảng chứa các mẫu bit cho số từ 0 đến 9
la $t1, SEVENSEG_PATTERNS       # Địa chỉ của mẫu đầu tiên (số 0)
la $t2, Aend
reset:
add $t3,$t1,$zero
loop:
beq $t3,$t2,reset
lw $a0,0($t3) # set value for segments
jal SHOW_7SEG_LEFT # show
nop
jal sleep
addi $t3,$t3,4
j loop

exit: li $v0, 10
syscall
endmain:

#---------------------------------------------------------------
# Function SHOW_7SEG_LEFT : turn on/off the 7seg
# param[in] $a0 value to shown
# remark $t0 changed
#---------------------------------------------------------------
SHOW_7SEG_LEFT: li $t0, SEVENSEG_LEFT # assign port's address
sb $a0, 0($t0) # assign new value
nop
jr $ra
nop
#---------------------------------------------------------------
# Function SHOW_7SEG_RIGHT : turn on/off the 7seg
# param[in] $a0 value to shown
# remark $t0 changed
#---------------------------------------------------------------
SHOW_7SEG_RIGHT: li $t0, SEVENSEG_RIGHT # assign port's address
sb $a0, 0($t0) # assign new value
nop
jr $ra
nop

sleep: addi $v0,$zero,32 # Keep running by sleeping in 1000 ms
li $a0,1000
syscall
jr $ra
nop
