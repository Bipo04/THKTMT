.eqv KEY_CODE 0xFFFF0004  # Địa chỉ của mã ASCII từ bàn phím (1 byte)
.eqv KEY_READY 0xFFFF0000 # =1 nếu có mã phím mới
.eqv DISPLAY_CODE 0xFFFF000C # Địa chỉ để hiển thị (1 byte)
.eqv DISPLAY_READY 0xFFFF0008 # =1 nếu màn hình sẵn sàng

# Dung lượng tối đa cho chuỗi nhập vào
.eqv MAX_INPUT 20

.data
exit_string:
    .asciiz "exit"   # Chuỗi để so sánh
input_buffer:
    .space 10        # Bộ nhớ để lưu trữ chuỗi nhập vào (tối đa 10 byte)

.text
li $k0, KEY_CODE
li $k1, KEY_READY
li $s0, DISPLAY_CODE
li $s1, DISPLAY_READY
la $t3, exit_string
la $t6, input_buffer
li $t4, 0 

loop: nop
WaitForKey: 
    lw $t1, 0($k1)         # Đọc giá trị từ địa chỉ KEY_READY vào thanh ghi $t1
    nop
    beq $t1, $zero, WaitForKey # Nếu $t1 == 0 (không có phím mới), quay lại WaitForKey để chờ
    nop

ReadKey: 
    lw $t0, 0($k0)         # Đọc mã phím từ địa chỉ KEY_CODE vào thanh ghi $t0
    nop
# Lưu ký tự vào input_buffer
SaveInput:
    sb $t0, 0($t6)         # Lưu ký tự vào buffer
    addi $t6, $t6, 1       # Tăng con trỏ bộ đệm
    addi $t4, $t4, 1       # Tăng biến đếm

# Hiển thị ký tự
WaitForDis: 
    lw $t2, 0($s1)         # Đọc giá trị từ địa chỉ DISPLAY_READY vào thanh ghi $t2
    nop
    beq $t2, $zero, WaitForDis # Nếu $t2 == 0 (màn hình chưa sẵn sàng), quay lại WaitForDis để chờ
    nop

ShowKey: 
    sw $t0, 0($s0)         # Hiển thị mã phím
    nop
    
CheckSpace:
    beq $t0, 32, Reset
# Kiểm tra nếu nhập đủ 4 ký tự để so sánh với "exit"
    li $t7, 4
    bne $t4, $t7, loop     # Nếu chưa đủ 4 ký tự thì quay lại loop

# So sánh chuỗi nhập vào với "exit"
CheckExit:
    la $t8, input_buffer   # Địa chỉ của buffer

    lb $t9, 0($t8)         # Lấy ký tự đầu tiên từ input_buffer
    lb $t5, 0($t3)         # Lấy ký tự đầu tiên của "exit"
    bne $t9, $t5, NotEqual # Nếu không bằng thì tiếp tục vòng lặp

    lb $t9, 1($t8)         # Lấy ký tự thứ hai từ input_buffer
    lb $t5, 1($t3)         # Lấy ký tự thứ hai của "exit"
    bne $t9, $t5, NotEqual # Nếu không bằng thì tiếp tục vòng lặp

    lb $t9, 2($t8)         # Lấy ký tự thứ ba từ input_buffer
    lb $t5, 2($t3)         # Lấy ký tự thứ ba của "exit"
    bne $t9, $t5, NotEqual # Nếu không bằng thì tiếp tục vòng lặp

    lb $t9, 3($t8)         # Lấy ký tự thứ tư từ input_buffer
    lb $t5, 3($t3)         # Lấy ký tự thứ tư của "exit"
    bne $t9, $t5, NotEqual # Nếu không bằng thì tiếp tục vòng lặp

# Nếu các ký tự bằng nhau thì kết thúc chương trình
EndProgram:
    li $v0, 10
    syscall                # Kết thúc chương trình

NotEqual:
j loop

Reset:
    li $t4, 0              # Đặt lại biến đếm
    la $t6, input_buffer   # Đặt lại con trỏ bộ đệm
    j loop                 # Quay lại đầu vòng lặp