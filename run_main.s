#Snir David Nahari - 205686538
#used tests from Yanir Buznah and Aviv Dimri
#this program getting from user lenght ,string of 2 pstrings and one opt (for jump table)
  .data

  .section  .rodata
int_fromat: .string "%d"
str_format: .string "%s"
end_str:    .string "\0"


  .text
  .globl run_main
  .extern run_func
  .type run_main, @function
#run_main - getting to pstring and opt number - and calling the run_func function
run_main:
#setup code
  pushq %rbp
  movq  %rsp, %rbp
  subq  $528, %rsp #allocating 256 bytes for each pstring and 8 bytes for length and 8 bytes for opt and alignment reasons
  push  %r12 #first pstring
  push  %r13 #second pstring

  #getting first string length
  movq  $int_fromat, %rdi  #insert scanf first parameter to %rdi
  leaq  -536(%rbp), %rsi  #insert scanf second parameter to %rsi
  xor   %rax, %rax
  call  scanf
  leaq  -528(%rbp), %r12 #puting first pstring in -528(%rbp)
  addq  $1, %r12    #moving  forward for saving string len

  #getting first string
  movq  $str_format, %rdi #insert scanf first parameter to %rdi
  movq  %r12, %rsi
  xor   %rax, %rax
  call  scanf
  #saving string with length in stack -528(%rbp)
  mov   -536(%rbp), %eax #extracting lenght from -536(%rbp)
  mov   %al, -528(%rbp) #puting string lenght in -528(%rbp) - start of string

  #getting second string length
  movq  $int_fromat, %rdi  #insert scanf first parameter to %rdi
  leaq  -536(%rbp), %rsi  #insert scanf second parameter to %rsi
  xor   %rax, %rax
  call  scanf
  leaq  -272(%rbp), %r13 #puting first pstring in -272(%rbp)
  addq  $1, %r13 #moving  forward for saving string

  #getting second string
  movq  $str_format, %rdi #insert scanf first parameter to %rdi
  movq  %r13, %rsi
  xor   %rax, %rax
  call  scanf
  mov   -536(%rbp), %eax #extracting lenght from -536(%rbp)
  mov   %al, -272(%rbp)  #puting string lenght in -272(%rbp) - start of string

  #getting opt
  movq  $int_fromat, %rdi  #insert scanf first parameter to %rdi
  leaq  -8(%rbp), %rsi  #insert scanf second parameter to %rsi
  xor   %rax, %rax
  call  scanf

  #setting up for calling run_func
  leaq  -528(%rbp), %rsi #%rsi = &pstring1
  leaq  -272(%rbp), %rdx #%rdx = &pstring2
  mov   -8(%rbp), %rdi #%rdi = opt
  call  run_func

  #finish
  xor  %rax, %rax # return 0
  pop  %r13
  pop  %r12
  addq $536, %rsp
  movq %rbp, %rsp
  pop  %rbp
  ret
