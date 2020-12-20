#Snir David Nahari - 205686538
#used tests from Yanir Buznah and Aviv Dimri
#this program have 5 function (pstrlen,replaceChar, pstrijcpy, swapCase, pstrijcmp) that called from run_func(func_select)
  .data
  .section  .rodata
str_format: .string "%s\n"
invalid_case: .string "invalid input!\n"

  .text
  .globl pstrlen,replaceChar, pstrijcpy, swapCase, pstrijcmp

  .type pstrlen @function
#getting  pstring - return it's length
pstrlen:
# %rdi = *pstr
  movzbq  (%rdi), %rax #getting first byte - length of string
  ret

  .type replaceChar @function
#getting pstring, oldChar and newChar - finding oldChar in pstring and replacing it with newChar
replaceChar:
  # %rdi = *pstr, %rsi = oldChar, %rdx = newChar
  #setup
  push   %rbp
  mov    %rsp, %rbp
  push   %r12
  push   %r13
  push   %r14
  push   %r15
  # moving data to registers (calle saver - will resotre in the end)
  mov    %rdi, %r12  #r12 = *dst string
  addq   $1, %r12  #starting from text in str (not len)
  movq   %rsi, %r13  #r13 = oldChar
  movq   %rdx, %rax  #rax = newChar
  movzbq (%rdi), %r15  # r15 = str.length

#starting loop
.start_loop:
  xor   %r10, %r10  #int i = 0
  cmpq  %r10, %r15 # checking if i < str.len
  jbe  .replace_loop

.replace_loop:
  movzbq  (%r12), %r14  #%r14 = current char in src str
  cmp   %r14, %r13  #if current char == old Char
  jne   .char_not_eq
  mov   %al, (%r12)   #current place in str = newChar

.char_not_eq:
  addq  $1, %r10  #i++
  incq  %r12  #moving for next char
  cmpq  %r10, %r15  # checking if i < str.len
  jg    .replace_loop

  #finish the function
  subq  %r15, %r12
  subq  $1, %r12
  movq  %r12, %rax
  pop   %r15
  pop   %r14
  pop   %r13
  pop   %r12
  movq  %rbp, %rsp
  pop   %rbp
  ret

  .type pstrijcpy @function
#getting 2 pstring and two indexes - copying chars from src[i:j] pstring to dst[i:j]
pstrijcpy:
#rdi = *dst str, %rsi = *src str, %rdx = i , %rcx = j
  #setup
  push    %rbp
  movq    %rsp,%rbp
  push    %r12
  push    %r13
  push    %r14
  push    %r15
  # moving data to registers (calle saver - will resotre in the end)
  movq    %rdx, %r12 #r12 = i
  movq    %rcx, %r13 #r13 = j
  movq    %rdi, %r14 #r14 = *dst
  movq    %rsi, %r15 #r15 = *src
  addq    $1, %r13 # j +=1

  #checking if j bigger than  first str len
  movzbq (%r14), %r11 # pstr1-> length
  cmpq    %r13, %r11  #checking if j > pstr1.len
  jl  .invalid_input_cpy
  #checking if j bigger than  second str len
  movzbq (%r15), %r11 # pstr2-> length
  cmpq    %r13, %r11  #checking if j > pstr2.len
  jl .invalid_input_cpy


  #if input valid
  addq    $1, %r14 #starting from text in str (not len)
  addq    $1, %r15 #starting from text in str (not len)
  addq    %rdx, %r14 # moving address to i place
  addq    %rdx, %r15 # moving addres to i place

  jmp .check_ij

.copy_loop:
  movzbq (%r15), %rax #%rax = current char in src str
  movb   %al, (%r14) # current place in str = char in dst char
  addq   $1, %r12 # i++
  incq   %r14   #moving r14 one address forward
  incq   %r15   #moving r15 one address forward
.check_ij:
  cmp    %r12, %r13 # if i >j
  ja    .copy_loop
  jmp   .finish_back

.invalid_input_cpy:
  #print invalid input
  mov   $invalid_case, %rdi
  xor   %rax, %rax
  call  printf
  jmp   .finish_cpy

.finish_back:
  #finish - return %r14 to begining of string
  subq  %r13, %r14
  subq  $1, %r14
.finish_cpy:
  movq  %r14, %rax #retrun *dst str
  pop   %r15
  pop   %r14
  pop   %r13
  pop   %r12
  movq  %rbp, %rsp
  pop   %rbp
  retq

  .type swapCase @function
#getting pstring - replace bigger case with lower and opposite.
swapCase:
#rdi = *dst str
  #setup
  push  %rbp
  movq  %rsp,%rbp
  push  %r12
  push  %r13
  push  %r14
  push  %r15
  # moving data to registers (calle saver - will resotre in the end)
  movq  %rdi, %r12 #%r12 = str
  movzbq  (%r12), %r13  #%r13 = str->len
  addq  $1, %r12  #moving r12 one address forward
  xor   %r14, %r14 # int i = 0
  jmp .cmp_loop

.a_case:
  movzbq  (%r12), %rax #%rax = current char in src str
  cmpq   $97, %rax #checking if char is bigger case
  jge    .z_case #if ascii is bigger than 97 ('a' = 97) check if smaller than 122('z'= 122)
  cmpq   $90, %rax #if ascii is not bigger than 97. check if smaller than 90 ('Z' = 90)
  jle    .A_case  #if smaller than 90, check if bigger than 65 ('A' = 65)
  jg     .incq_i

.z_case:
  cmpq  $122, %rax #if ascii bigger than 123 not a letter in english, increase i, and continue loop
  jge   .incq_i
  subq  $32, %rax  #else, lower case - converting char to bigger case
  movb  %al, (%r12) # swapping to bigger case in char
  jmp   .incq_i #increase i

.A_case:
  cmpq  $65, %rax #if ascii less than 64 not a letter in english, increase i, and continue
  jl    .incq_i
  addq  $32, %rax     #else, bigger case - converting char to lower case
  movb  %al, (%r12) # swapping char in str to lower case
  jmp  .incq_i

.incq_i:
  addq  $1, %r14 # increas i - i++
  incq  %r12     #moving r12 one address forward to next char

.cmp_loop:
  cmp   %r14, %r13 # checking if str->len > i
  ja    .a_case
  #return r12 to original address and putting it in rax
  subq  %r13, %r12
  subq  $1, %r12
  movq  %r12, %rax #retrun *dst str
  #finish
  pop   %r15
  pop   %r14
  pop   %r13
  pop   %r12
  movq  %rbp, %rsp
  pop   %rbp
  retq

  .type pstrijcmp @function
#getting 2 pstring and two indexes - compare char by char from src[i:j] pstring to dst[i:j]
pstrijcmp:
#rdi = *dst str, %rsi = *src str, %rdx = i , %rcx = j
  #setup
  push  %rbp
  movq  %rsp,%rbp
  push  %r12
  push  %r13
  push  %r14
  push  %r15
  # moving data to registers (calle saver - will resotre in the end)
  movq  %rdx, %r12 #r12 = i
  movq  %rcx, %r13 #r13 = j
  movq  %rdi, %r14 #r14 = *dst
  movq  %rsi, %r15 #r15 = *src
  addq  $1, %r13 # j +=1

  #checking if j bigger than  first str len
  movzbq  (%r14), %r11 # pstr1-> length
  cmpq  %r13, %r11  #checking if j > pstr1.len
  jl    .invalid_input_cmp
  #checking if j bigger than  second str len
  movzbq  (%r15), %r11 # pstr2-> length
  cmpq  %r13, %r11  #checking if j > pstr2.len
  jl  .invalid_input_cmp

  #if input valid - preparation for function
  addq  $1, %r14 #starting from text in str (not len)
  addq  $1, %r15 #starting from text in str (not len)
  addq  %rdx, %r14 # moving address to i place
  addq  %rdx, %r15 # moving addres to i place
  jmp   .copmareij

.copmareij_loop:
  movzbq  (%r14), %rcx # %rcx = current char in dst str
  movzbq  (%r15), %rax # %rax = current char in src str
  cmpq  %rax, %rcx # checking dst char ? src char
  je    .eq_keep_loop #if chars equal - increase i, and go for next char
  jg    .dst_bigger   #if pstr1 char bigger than pstr 2 char
  jl    .src_bigger   #if pstr1 char smaller than pstr 2 char

.eq_keep_loop:
  addq  $1, %r12 # i++
  incq  %r14
  incq  %r15

.copmareij:
  cmp   %r12, %r13 # if i < j
  jg    .copmareij_loop

.char_eq:
  movq  $0, %rax
  jmp   .finish

.dst_bigger:
  movq  $1, %rax
  jmp   .finish

.src_bigger:
  mov  $-1, %rax
  jmp  .finish

.invalid_input_cmp:
  #print invalid input
  mov   $invalid_case, %rdi
  xor   %rax, %rax
  call  printf
  mov   $-2, %rax #put -2 in return value

.finish:
  #finish
  pop   %r15
  pop   %r14
  pop   %r13
  pop   %r12
  movq  %rbp, %rsp
  pop   %rbp
  retq
