.eqv KEY_CODE 0xFFFF0004 # ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 # =1 if has a new keycode ?
# Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C # ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008 # =1 if the display has already to do
# Auto clear after sw

.data
exit_string:
    .asciiz "exit"   # Chuỗi để so sánh

.text
li $k0, KEY_CODE
li $k1, KEY_READY

li $s0, DISPLAY_CODE
li $s1, DISPLAY_READY

la $t3, exit_string # Lưu địa chỉ của chuỗi exit
li $t4, 0           # Lưu số kí tự trùng với exit tại thời điểm hiện tại

loop: nop
WaitForKey: lw $t1, 0($k1) # $t1 = [$k1] = KEY_READY
nop
beq $t1, $zero, WaitForKey # if $t1 == 0 then Polling
nop
#-----------------------------------------------------
ReadKey: lw $t0, 0($k0) # $t0 = [$k0] = KEY_CODE
nop
#-----------------------------------------------------
WaitForDis: lw $t2, 0($s1) # $t2 = [$s1] = DISPLAY_READY
nop
beq $t2, $zero, WaitForDis # if $t2 == 0 then Polling
nop
#-----------------------------------------------------
Encrypt: addi $t0, $t0, 0 # change input key
#-----------------------------------------------------
ShowKey: sw $t0, 0($s0) # show key
nop
#-----------------------------------------------------
CheckExit:
lb $t5, 0($t3)               # Nạp kí tự của chuỗi exit cần so sánh
bne $t0, $t5, NotExitChar    # Nếu phím không khớp với ký tự lệnh thoát hiện tại, bỏ qua
addi $t3, $t3, 1	      # Chuyển sang kí tự tiếp theo của chuỗi exit
addi $t4, $t4, 1             # Tăng kí tự hiện tại trùng với chuỗi exit lên 1
beq $t4,4, EndProgram	      # Nếu cả 4 kí tự mới nhất trùng với exit thì dừng
j loop
NotExitChar:
la $t3, exit_string          # Đặt lại bộ đếm lệnh thoát
li $t4, 0		      
j loop
    
# Nếu các ký tự bằng nhau thì kết thúc chương trình
EndProgram:
    li $v0, 10
    syscall                # Kết thúc chương trình
