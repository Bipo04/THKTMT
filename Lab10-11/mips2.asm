.eqv MONITOR_SCREEN 0x10010000 #Dia chi bat dau cua bo nho man hinh
.eqv RED    0x00FF0000 #Cac gia tri mau thuong su dung
.eqv GREEN  0x0000FF00
.eqv BLUE   0x000000FF
.eqv WHITE  0x00FFFFFF
.eqv YELLOW 0x00FFFF00
.eqv BLACK  0x00000000
.text
li $k0, MONITOR_SCREEN #Nap dia chi bat dau cua man hinh
addi $k0,$k0,60        #Dia chi cua mép bên phải màn hình
li $t0, RED		#Mau can to
li $t1, BLACK		#Mau cua nen
sw $t0, 0($k0)
nop
loop:
beq $k0, MONITOR_SCREEN, end 	#Đến địa chỉ bắt đầu của màn hình thì kết thúc
addi $k0, $k0,-4		#Giảm về địa chỉ ô bên phải
sw $t0, 0($k0)			#Tô màu đỏ ô hiện tại
sw $t1, 4($k0)			#Tô màu nền của ô trước đó
j loop

end:
li $v0,10
syscall
