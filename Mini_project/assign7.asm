.data
a: .word -1,150,-1,190,-1,-1,180,170,-1,160    # Mảng đầu vào
heights: .space 100                             # Mảng để lưu chiều cao được trích xuất

.text
main:

#--------------------------------------------------------------
# $a0: Con trỏ đến phần tử đầu tiên của mảng a
# $a1: Con trỏ đến phần tử cuối cùng của mảng a
# $a2: Con trỏ đến phần tử hiện tại của mảng heights
# $a3: Con trỏ đến phần tử hiện tại của mảng heights
#--------------------------------------------------------------

    la $a0,a           # Load địa chỉ của mảng a vào $a0
    la $a1,heights     # Load địa chỉ để lưu chiều cao heights vào $a1
    addi $a2,$a1,-4    # Lưu địa chỉ của phần tử cuối của mảng a vào $a2
    jal load_height    # Gọi hàm load_height
    nop

    add $a3,$v1,$zero  # Lưu địa chỉ của phần tử cuối của mảng heights vào $a3
    jal bubble_sort    # Gọi hàm bubble_sort để sắp xếp các chiều cao trong heights
    nop

    jal insert_array   # Gọi hàm insert_array để nhập lại các chiều cao đã được sắp xếp vào mảng a
    nop

    li $v0, 10     
        # Exit system call
    syscall

#--------------------------------------------------------------
# Thanh ghi sử dụng hàm load_height:
# $t1: Con trỏ đến phần tử hiện tại của mảng a
# $t2: Con trỏ đến phần tử hiện tại của mảng heights
# $t3: Con trỏ đến phần tử cuối của mảng a
# $t4: Lưu giá trị của phần tử hiện tại của mảng a
# $v1: Lưu địa chỉ của phần tử cuối mảng heights
#--------------------------------------------------------------

load_height: 
# Hàm này trích xuất các chiều cao từ mảng đầu vào lưu vào mảng heights và trả ra vị trí của phần tử cuối mảng
    add $t1,$a0,$zero  # $t1 lưu địa chỉ của mảng a
    add $t2,$a1,$zero  # $t2 lưu địa chỉ của mảng heights
    add $t3,$a2,$zero  # $t3 lưu địa chỉ của phần tử cuối cùng của mảng a

loop_load_height: 
    bgt $t1,$t3,end_load_height  # Nếu đến cuối mảng, nhảy đến sắp xếp chiều cao
    lw $t4,0($t1)                # Lấy giá trị từ mảng a vào $t4
    beq $t4,-1, skip_height      # Nếu là -1 (cây), bỏ qua phần tử này
    sw $t4,0($t2)                # Lưu chiều cao vào mảng heights
    addi $t2,$t2,4               # Tăng chỉ mục cho mảng heights

skip_height:
    addi $t1,$t1,4        # Tăng địa chỉ cho mảng đầu vào
    j loop_load_height    # Tiếp tục trích xuất chiều cao

end_load_height:
    addi $v1,$t2,-4       # Trả về địa chỉ phần tử cuối cùng của mảng heights
    jr $ra

#--------------------------------------------------------------
# Thanh ghi sử dụng hàm bubble_sort:
# $t0: Biến bool, = 1 nếu có phần tử được hoán đổi, ngược lại thì = 0
# $t1: Con trỏ đến phần tử hiện tại heights[i] của mảng heights
# $t2: Con trỏ đến phần tử cuối của mảng heights
# $t3: Con trỏ đến phần tử kế tiếp của $t1 heights[i+1] của mảng heights
# $s0: Lưu giá trị heights[i]
# $s1: Lưu giá trị heights[i+1]
#--------------------------------------------------------------

bubble_sort: 
# Hàm sắp xếp các chiều cao trong mảng heights bằng phương pháp bubble sort
    add $t0,$zero,$zero    # $t0 = 0
    add $t1,$a1,$zero      # $t1 trỏ đến heights[0]
    add $t2,$a3,$zero      # $t2 trỏ đến phần tử cuối của mảng heights
    j loop_sort

check: # Kiểm tra có phần tử được hoán đổi không
    beq $t0,$zero,end_sort     # Nếu không có phần tử nào được hoán đổi, kết thúc sắp xếp
    j reset                    # Tiếp tục vòng lặp mới

reset: # Reset lại trạng thái ban đầu
    add $t0,$zero,$zero       # $t0 = 0
    add $t1,$a1,$zero         # $t1 trỏ đến heights[0]
    j loop_sort

swap: # Hoán đổi giá trị của 2 phần tử
    sw $s0,0($t3) 
    sw $s1,0($t1)
    li $t0,1                  # Đánh dấu có phần tử được hoán đổi
    j next_loop               # Tiếp tục vòng lặp với phần tử tiếp theo

next_loop:
    addi $t1,$t1,4 
    j loop_sort

loop_sort:
    beq $t1,$t2,check
    lw $s0,0($t1)             # $s0 = heights[i]
    addi $t3,$t1,4
    lw $s1,0($t3)             # $s1 = heights[i+1]
    sgt $t5,$s0,$s1           # $s0 > $s1 ?
    bne $t5,$zero,swap        # Nếu $s0 > $s1 thì hoán đổi
    j next_loop               # Tiếp tục vòng lặp với phần tử tiếp theo

end_sort: 
    jr $ra

#--------------------------------------------------------------
# Thanh ghi sử dụng hàm insert_array:
# $t1: Con trỏ đến phần tử hiện tại a[i] của mảng a
# $t2: Con trỏ đến phần tử hiện tại heights[j] của mảng heights
# $s0: Lưu giá trị a[i]
# $s1: Lưu giá trị heights[j]
#--------------------------------------------------------------

insert_array:
    # Hàm này nhập lại các chiều cao đã được sắp xếp từ mảng heights vào mảng a.
    add $t1,$a0,$zero	# $t1 lưu địa chỉ của mảng a
    add $t2,$a1,$zero	# $t2 lưu địa chỉ của mảng heights
    j loop_insert

next_loop_insert:
    add $t1,$t1,4

loop_insert:
    beq $t1,$a1,end_insert        # Nếu đến phần tử cuối của mảng a thì kết thúc chường trình
    lw $s0,0($t1)
    beq $s0,-1,next_loop_insert   # Nếu a[i] == -1 thì tăng đến phần tử tiếp theo
    lw $s1,0($t2)		   # Lấy giá trị của mảng heights
    sw $s1,0($t1)		   # Lưu lại giá trị mới đã sắp xếp vào mảng a
    add $t2,$t2,4
    j next_loop_insert

end_insert:
    jr $ra
