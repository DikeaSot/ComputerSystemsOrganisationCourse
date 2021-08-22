#t1 = the string that is given from the user	
#t2 = address of the first character of the string

	.data
p: 	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
msg:	.asciiz "Please, type the word you want: \n"
buffer:	.space 20

	.text
	.globl main
main:
	li $v0,4	#print string
	la $a0,msg
	syscall		#print msg
	
	li $v0,8
	la $a0, buffer
	li $a1,20
	syscall		#read string
	
	move $t0,$v0	#t0=v0
	
	la $t2,($t0)	#t2 = address of the first character of the string
	li $t3,97
	la $t9,p	#t9 = address of the array
	
loop:
	lb $t6,($t2)		#t6 has the character of the string
	beqz $t6,print		#if there are no characters left in the string goto print
	bne $t6,$t3,return	#if the character of the string does not equal a small english letter goto return
	
	lw $t7,($t9)		#t7 = the element that is in the array
	
	addi $t7,$t7,1		#update the sum of the array
	
	addi $t2,$t2,1	#go to the next character of the string
		
	beq $t3,122,initAgain
	
return:
	addi $t3,$t3,1	#go to the next letter of the alphabet
	addi $t9,$t9,4
	j loop
	
initAgain:
	li $t3,97
	la $t9,p
	j loop
print:
	li $v0,4
	move $a0,$t0 
	syscall		#print the string that was given
	li $t3,97
	la $t9,p	#t9 = address of the array
	
	
alphabet:
	ble $t3,122,exit
	lw $t7,($t9)
	beqz $t7, returnAlpha
	
	li $v0,11
	move $a0,$t3
	syscall			
	
	li $v0,1
	move $a0,$t7
	syscall		#print the element in the array
	
	addi $t3,$t3,1
	
	j alphabet
	#ektipwse ton pinaka kai ena minima
returnAlpha:
	addi $t9,$t9,4
	addi $t3,$t3,1
	j alphabet
exit:
	li $v0,10
	syscall