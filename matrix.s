 # Filename: main.c
 # Description: file for computing transpose and reversing columns of a matrices using assembly
 # Date: March 8,2024
 # Names: Steven Dai Chuy
 
    .globl    copy
# ***** Version 2 *****
copy:
# A in %rdi, C in %rsi, N in %edx

# Using A and C as pointers

# This function is not a "caller", i.e., it does not call functions.
# It is a leaf function (a callee).
# Hence it does not have the responsibility of saving "caller-saved" registers
# such as %rax, %rdi, %rsi, %rdx, %rcx, %r8 and %r9.
# This signifies that it can use these registers without
# first saving their content if it needs to use registers.

# Set up registers
    xorl %eax, %eax            # set %eax to 0
    xorl %ecx, %ecx            # i = 0 (row index i is in %ecx)

# For each row
rowLoop:
    xorl %r8d, %r8d            # j = 0 (column index j in %r8d)
    cmpl %edx, %ecx            # while i < N (i - N < 0)
    jge doneWithRows

# For each cell of this row
colLoop:
    cmpl %edx, %r8d            # while j < N (j - N < 0)
    jge doneWithCells

# Copy the element A points to (%rdi) to the cell C points to (%rsi)
    movb (%rdi), %r9b          # temp = element A points to
    movb %r9b, (%rsi)          # cell C points to = temp

# Update A and C so they now point to their next element
    incq %rdi
    incq %rsi

    incl %r8d                  # j++ (column index in %r8d)
    jmp colLoop                # go to next cell

# Go to next row
doneWithCells:
    incl %ecx                  # i++ (row index in %ecx)
    jmp rowLoop                # go to next row

doneWithRows:                  # bye! bye!
    ret


#####################
.globl transpose
transpose:
    # int i, j;
    # for (i = 0; i < N; i++)
    #    for (j = 0; j < N; j++)
    #        A[i][j] = A[j][i]; swapping

xorl %ecx, %ecx # assign i = 0

xorl %r8d, %r8d # assign j = 0

# column loop
GOTO_nextcol:
incl %r8d # incrementing j(%r8d) j++

cmpl %esi, %r8d # loop while j - N hits zero

jge GOTO_nextrow # jump to GOTO_nextrow

jmp swapping # swap i and j while looping

# row loop
GOTO_nextrow:
incl %ecx # incrememting i(%ecx) i++

cmpl %esi, %ecx # loop while i - N hits zero

jge done # jump to done

movl %ecx, %r8d # j(%r8d) = i(%ecx) , were on the same element

jmp GOTO_nextcol # go to the next column, i and j not equal

# swapping and assigning A[i][j] and A[j][i]
swapping:
    # A[i][j] = A + L(i * C + j)
movl %esi, %r10d # assign first argument (%esi) to %r10d = C

    imull %ecx, %r10d # assign i(%ecx) * C(%r10d) = (i*C) to %r10d

    addl %r8d, %r10d # assign j(%r8d) + %r10d ^ to %r10d

    imull $1, %r10d # assign L(1 byte because of char,$1) * %r10d to %r10d

    addq %rdi, %r10 # assign quad word to A[i][j] = A(%rdi), first argument

    # A[j][i] = A + L(j * C + i)
movl %esi, %r11d # assign 2nd argument (%esi) to %r11d = C

    imull %r8d, %r11d # assign j(%r8d) * C(%r11d) = (j*C) to %r11d

addl %ecx, %r11d # assign i(%ecx) + %r11d ^ to %r11d

imull $1, %r11d # assign L(1 byte because of char,$1) * %r11d to %r11d

addq %rdi, %r11 # assign quad word to A[j][i] = A(%rdi), first argument

    #        A[i][j] = A[j][i];
movb (%r10), %r12b # temp = A[i][j]

movb (%r11), %r13b # temp2 = A[j][i]

movb %r13b, (%r10) # temp = temp2

movb %r12b, (%r11) # C[j][i] = temp

jmp GOTO_nextcol

done:
ret
#####################
.globl reverseColumns

 #   for(i = 0; i < n; i++) {
 #   for(j = 0; j < m/2; j++) {
 #       int temp = arr[i][j];
 #       arr[i][j] = arr[i][N-j-1];
 #       arr[i][N-j-1] = temp;
 #   }
 #}
reverseColumns:
xorl %eax, %eax # assign return value(%eax) to 0
xorl %ecx, %ecx # assign i(%ecx) = 0

movl %esi, %r13d # sets up temparary value which is equal to N/2
shrl $1, %r13d # The highest bit position is filled with a zero

GOTO_rowloopreverse:
movl $0, %r8d # set j(%r8d) to zero
cmpl %esi, %ecx # if row has been iterated through, go to done_reverse_loop
jge done_reverse_loop

GOTO_columnloopreverse:
cmpl %r13d, %r8d # check if column has been iterated through, go to stop_iterating_through_column
jge stop_iterating_through_column

    # arr[i][j] = A + L * (j + i*N)
movl %esi, %r10d # set %r10d equal to N
imull %ecx, %r10d # set %r10d equal to i(%ecx)*N
addl %r8d, %r10d # set %r10d equal to j(%r8d) + i(%ecx)*N
imull $1, %r10d # set %r10 = L * (j + i*N)

    # temp = arr[i][j-N-1]
movl %esi, %r14d # temp variable thats (N-j)
subl $1, %r14d # Minus 1 since the end of array is N-1
subl %r8d, %r14d # temp = N-j


movl %esi, %r11d # set N%r11d equal to N
imull %ecx, %r11d # set %r11d equal to  i*N
addl %r14d, %r11d # set %r11d (N-j) + i*N
imull $1, %r11d # set %r11d = L * ((N-j) + i*N) since char is 1 byte

addq %rdi, %r10 # r10 = C + L * (j + i*N)
addq %rdi, %r11 # r11 = C + L * ((N-j) + i*N)

# swapping
movb (%r10), %r9b # temp = C[L * (j + i*N)]
movb (%r11), %r12b # temp2 =
movb %r12b, (%r10) # C[L * (j + i*N)] = C[L * ((N-j) + i*N)]
movb %r9b, (%r11) # C[L * ((N-j) + i*N)] = temp

incl %r8d # increments j by 1 (goes to next cell)
jmp GOTO_columnloopreverse # jumps to back to start of GOTO_columnoopeverse

stop_iterating_through_column:
incl %ecx # increments i by 1 (goes to next row)
jmp GOTO_rowloopreverse # jumps back to GOTO_rowloopreverse

done_reverse_loop:
ret # returns