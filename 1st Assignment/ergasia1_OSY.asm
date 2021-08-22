# Author: Dikea Sotiropoulou, p3160172
# Date: 19/11/2017
# Description: To programma auto zitaei apo ton xristi ena xrhmatiko poso kai emfanzei poso einai ta resta
# $s0 = 524 = fee (xreosi)
# $s1 = 2099 = maximum amount of money the user can give
# $t8 = axia (ksekinaei apo 2000 (20euros) kai ftanei mexri 1 (1cent)
# $s3 = euros (to poso se euro pou dinei o xristis)
# $s4 = cents (to poso se cents pou dinei o xristis)
# $t9 = total (ta synolika resta)
# 
#

.data
	giveEuros: .asciiz "Fee: 5 euros and 24 cents.\nEuros (<=20):"
	giveCents: .asciiz "Cents (<=99):"
	errorLess: .asciiz "Error! Not enough money!"
	errorMore: .asciiz "Error! Please try again!"
	noChange:  .asciiz "Change = 0"
	Change:    .asciiz "Change: "
	msg_x:     .asciiz " x "
	msgEuros:  .asciiz " euros "
	msgCents:  .asciiz " cents "
	nextLine:  .asciiz "\n"

.text
	main:
	  addi $s0, $zero, 524 #fee=524cents = 5euros, 24cents
	  addi $s1, $zero, 2099 #maximum money = 2099cents = 20euros, 99cents
	  addi $t8, $zero, 2000 # axia = 2000
	  
	  li $v0, 4
	  la $a0, giveEuros # print "Fee: 5 euros and 24 cents.\nEuros (<=20): "
	  syscall
      
	  li $v0, 5 #read euros
	  syscall
      
	  move $s3, $v0 #store euros
	  
	  li $v0, 4
	  la $a0, giveCents # print "Cents (<=99): "
	  syscall
      
          li $v0, 5 #read cents
 	  syscall
      
	  move $s4, $v0 #store cents
      
      
	  mul $t1, $s3, 100 # t1 = 100*euros
	  add $t9, $t1, $s4 # t9 = total = 100*euros + cents
	  slt $t0, $t9, $s0 # if total < 524
 	  bne $t0, $zero, error1
	  #exit
      
	  slt $t1, $s1, $t9 # if total >2099
	  bne $t1, $zero, error2
	  #exit
      
	  beq $t9, $s0, exactAmount # if total == 524
	  #exit
      
	  ble $t9, $s1, changeNeeded # if total < 2099
	  #exit
      
	  j exit #exit main
      
	error1:
	  li $v0, 4
	  la $a0, errorLess # print "Error! Not enough money!"
	  syscall
	  
	  jal exit # end the program
	  
	error2:
	  li $v0, 4
	  la $a0, errorMore # print "Error! Please try again!"
	  syscall
	  
	  jal exit # end the program
      	  
	exactAmount:
	  li $v0, 4
	  la $a0, noChange # print "Change = 0"
	  syscall
	  
	  jal exit # end the program
	  
	changeNeeded:
	  sub $t9, $t9, $s0 # total= total-fee (524)
	  
	  li $v0, 4
	  la $a0, Change # print "Change: "
	  syscall
	  	  
	  jal while # go to while loop  
	  
	while:
	  blt $t8, 1, exit # if (axia < 1) go to exit
	  div $s7, $t9, $t8 # posotita = total / axia
	  
	posotita:
	  blez, $s7, continue #if (posotita <=0 ) go to continue
	  
	  li $v0, 1
	  move $a0,$s7 # print posotita
	  syscall
	  
	  li $v0, 4
	  la $a0, msg_x # print " x "
	  syscall
	  
	printEuros:
	  blt $t8,100, printCents # if (axia<100) go to printCents
	  
	  add $t2, $zero, $t8 # t2=axia
	  div $t2, $t2, 100 # $t2 = axia/100
	  
	  li $v0, 1
	  move $a0,$t2 # print axia
	  syscall
	  
	  li $v0, 4
	  la $a0, msgEuros # print " euros"
	  syscall
	  
	  li $v0, 4
	  la $a0, nextLine # print "\n"
	  syscall
	  
	  j continue # continue the while loop
	  
	printCents:
	  li $v0, 1
	  move $a0, $t8 # print axia
	  syscall
	
	  li $v0, 4
	  la $a0, msgCents # print " cents"
	  syscall
	  
	  li $v0, 4
	  la $a0, nextLine # print "\n"
	  syscall
 	  
	  j continue # continue the while loop
	  	  
	continue: # einai synexeia tis while
	  mul $t7, $s7, $t8 # posotita * axia
	  sub $t9, $t9, $t7 # total = total - posotita*axia
	  div $t8 ,$t8, 2 # axia=axia / 2
	  
	  beq $t8, 250, axia200 # if (axia==250) axia = 200
	  beq $t8, 25, axia20 #if (axia==25) axia = 20
	  
	  j while # return to the while loop
	  
	axia200: 
	  addi $t8, $zero, 200 # axia=200
	  j while # return to the while loop
	
	axia20:
	  addi $t8, $zero, 20 # axia=20
	  j while # return to the while loop
	 
	  
	exit:
	  li $v0, 10
      	  syscall #end programm
	  
