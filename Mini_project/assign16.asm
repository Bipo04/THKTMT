.data
	A: .word 1,4,3,4
	Aend: .word       
	mes1: .asciiz "True"
	mes2: .asciiz "False"
.text
	la $a0, A             # $a0 trỏ đến phần tử đầu tiên của mảng A
	la $a1, Aend          
	addi $a1, $a1, -4     # $a1 trỏ đến phần tử cuối cùng của mảng A
	add $t0, $a0, $zero   # $t0 trỏ đến phần tử hiện tại của mảng A
	jal almostIncreasingSequence
	beq $v1,1, true
	j false
true:
	la $a0,mes1
	li $v0,4
	syscall
	j end_main
false:
	la $a0,mes2
	li $v0,4
	syscall

end_main:
	li $v0, 10            # Exit syscall
	syscall

almostIncreasingSequence:
	addi $v1, $zero, 1    # Khởi tạo biến kết quả $v1 = 1 (True)
	j check
#--------------------------------------------------------------
# Thanh ghi sử dụng:
# $a0: Con trỏ đến phần tử đầu tiên của mảng A
# $a1: Con trỏ đến phần tử cuối cùng của mảng A
# $t0: Con trỏ đến phần tử hiện tại của mảng A
# $s0: Giá trị hiện tại của phần tử A[i]
# $s1: Giá trị của phần tử kế tiếp A[i+1]
# $s2: Giá trị của phần tử trước đó A[i+1]
# $v1: Biến kết quả, 1 = True, 0 = False
#--------------------------------------------------------------

check:
	beq $t0, $a1, end      # Nếu đã đến phần tử cuối cùng của mảng, kết thúc
	lw $s0, 0($t0)         # Load giá trị A[i] vào $s0
	lw $s1, 4($t0)         # Load giá trị A[i+1] vào $s1
	addi $t0, $t0, 4       # Tăng con trỏ $t0 để trỏ đến phần tử tiếp theo
	blt $s0, $s1, check    # Nếu A[i] < A[i+1], kiểm tra tiếp
	addi $t1,$t0,4		
	bgt $t1,$a1,end
	lw $s2,0($t1)		# Load giá trị A[i+2] vào $s2 nếu tồn tại
	bge $s0, $s2, wrong   
have_deleted: # Kiểm tra dãy còn lại có là dãy tăng dần hay không
	addi $t0, $t0, 4       # Tăng con trỏ $t0 để trỏ đến phần tử tiếp theo
	beq $t0, $a1, end      # Nếu đã đến phần tử cuối cùng của mảng, kết thúc
	lw $s0, 0($t0)         # Load giá trị hiện tại từ mảng A vào $s0
	lw $s1, 4($t0)         # Load giá trị kế tiếp từ mảng A vào $s1
	bge $s0, $s1, wrong    # Nếu A[i] >= A[i+1], sai
	j have_deleted         # Nếu không, kiểm tra phần tử tiếp theo trong dãy
wrong:
	addi $v1, $zero, 0     # Gán kết quả là False
end:
	jr $ra                  # Trả về nơi gọi hàm
