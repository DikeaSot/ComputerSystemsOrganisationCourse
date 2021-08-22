#author : Xristos Xydeas, Dikea Sotiropoulou
#date: 15/1/18

	.text
	.globl main

main:
	li $v0, 4	#print string
	la $a0, msg
	syscall		#print msg
	
	li $v0, 4
	la $a0, addEl
	syscall		#print addEl
	
	li $v0, 4
	la $a0, delEl
	syscall		#print delEl
	
	li $v0, 4
	la $a0, showAscendingOrder
	syscall		#print showAscendingOrder
	
	li $v0, 4
	la $a0, showDescendingOrder
	syscall		#print showDescendingOrder
	
	li $v0, 4
	la $a0, exitMsg
	syscall		#print exitMsg

	li $v0, 5
	syscall		#read int for action 
	
	move $t1,$v0	#t0=v0   answer

	beq $t1,1,addElement	#if t1==1 goto addElement
	beq $t1,2,delelement	#if t1==2 goto delement
	beq $t1,3,print		#if t1==3 goto print
	beq $t1,4,printback	#if t1==4 goto printback
	beq $t1,0,exit		#if t1==0 goto exit
	
addElement:
	li $v0, 4	#print string
	la $a0, readEl
	syscall		#print readEl
	
	li $v0,5
	la $a0, 4($t1)
	syscall		#read int(element)

	move $t4,$v0	#t1=v0  

	beqz $s2,firstnode
	j restnode
	
	# create the linked list
	# $s1 --- current node in creation loop
	# $s2 --- loop counter
firstnode:
	# create the first node 
	li $v0,9	# allocate memory
	li $a0,8	# 8 bytes
	syscall		# $v0 <-- address
	move $s1,$v0  	# $s1 = &(first node)
	
        # copy the pointer to first
        sw $s1,first
        
	# initialize the first node
	move $t0,$t4 	# store 1
	sw $t0,0($s1)	# at displacement 0

	# create the remaining nodes in a counting loop
	li $s2,2	# counter = 2
	li $s3,8	# upper limit
	j main
        
restnode: 
	# create a node 
	li $v0,9	# allocate memory
	li $a0,8	# 8 bytes
	syscall		# $v0 <-- address

	# link this node to the previous
			# $s1 = &(previous node)
	sw $v0,4($s1)	# copy address of the new node
			# into the previous node
        
	# make the new node the current node
	move $s1,$v0
        
	# initialize the node
	sw $t4,0($s1)	# at displacement 0

	addi $s2,$s2,1	# counter++
	j done
done:
	# end the list
	sw $0,4($s1)	# put null in the link field
			# of the current node, which   is the last node.
	j ascedingorder	# do the sort          

ascedingorder:
	move $t5,$s2	#set t5=lenght of list
	add $t5,$t5,-1
	lw $s0,first	# get a pointer to the first node
	move $s4,$s0
	
makeascedingorder:
	beq $t5,0,main	# t5=0 jump main print completed
	move $t7,$0
	move $s3,$s4
	j lpa1
	
swap:
	move   $t7,$t6
	 
lpa1:
	beqz $s3,endlpa	# while the pointer is not null
	lw $t6,0($s3)	#get the data of this node
	lw $s3,4($s3)	#get the pointer to the next node
	bgt $t6,$t7,swap
	b lpa1
       
endlpa:
	lw $t6,0($s4)	#get the value from this node
	beq $t6,$t7,exception
	sw $t7,0($s4)	#set the data of this node as the max
	lw $s3,4($s4)
	
lpa2:
	beqz $s3,exception	#while the pointer is not null
	lw $t4,0($s3)		#get the data of this node
	bne $t7,$t4,continue	#if (t7=t4) go to continue1
	sw $t6,0($s3)
	j exception
	
continue:
	lw $s3,4($s3)	#get the pointer to the next node
	b lpa2

exception:
	lw $s4,4($s4)	#set the pointer to the next node as the first
	add $t5,$t5,-1	#counter loops $t5-=1     
	b makeascedingorder

delelement:
	li $v0, 4	#print string
	la $a0, removeEl
	syscall		#print readEl
	li $v0,5
	la $a0, 4($t1)
	syscall		#read int(element)		
	move $t2,$v0	#t1=v0  
	lw $s0,first	# get a pointer to the first node
	move $s3,$s0
	move $s4,$s0
	
search:	 
	beqz $s3,notfound	# while the pointer is not null
	lw $t6,0($s3)		#get the data of this node
	bne $t6,$t2,next	#if(t6!=t2){go to next}
	beq $s3,$s0,delfirst	#if node is first go delete it 
	add $s2,$s2,-1		#add +1 to counter
	sw $0,0($s3)		#make data of node 0
	lw $t1,4($s3)		#get the next node adress and store it in t1
	sw $t1,4($s4)		#store t1 in outer loop next node
	j endlpal1
	
delfirst:
	add $s2,$s2,-1	#decrease counter
	sw $0,0($s3)	#make data node zero 
	lw $t1,4($s3) 	#get the next node adress and store it in t1
	# copy the pointer to first
	sw $t1,first	#store new head in first
	j endlpal1
         	
next:
	move $s4,$s3		
	lw $s3,4($s3)	#get the pointer to the next node
	b search
	
endlpal1:
	li $v0,4
	la $a0,delelcomp	#print msg that delete process is completed successfull
	syscall
	j main
	
notfound:
	li $v0,4
	la $a0,delelerror	#print msg that the element is not found
	syscall
	j main

print:      
        # print out the list
        # $s0 --- current node in print loop
                                       
	lw     $s0,first          # get a pointer to the first node
	
lp:     
	beqz $s0,printemptyline	# while the pointer is not null
	lw $a0,0($s0)		#get the data of this node
	li $v0,1		#print it
	syscall
	la $a0,sep		#print separator
	li $v0,4
	syscall
        
	lw $s0,4($s0)		#get the pointer to the next node
	b lp
	
printemptyline:
	la $a0,emptylinemsg	#print new line
	li $v0,4
	syscall      
	j main      

printback:
	lw $s0,first	#get a pointer to the first node
loop:    
	beqz $s0,printstack	# while the pointer is not null
	sub $sp,$sp,4		#make space in stack
	lw $t1, 0($s0)		#t1=data,node()
	sw $t1,($sp)		#push t1 into stack
        lw $s0,4($s0)		#get the pointer to the next node
        b loop
        
printstack:
	lw $s0,first		# get a pointer to the first node
	
printstackmain:
	beqz $s0,printemptyanline	# while the pointer is not null
	lw $t1,($sp)			#pop t1 from stack
	addi $sp,$sp,4			#restore memory
	lw $s0,4($s0)			#get the pointer to the next node
	move $a0,$t1			#print the data of this register from stack
	li $v0,1			#print it
	syscall
	la $a0,sep			#print separator
	li $v0,4
	syscall               
        
	b printstackmain

printemptyanline:
	la $a0,emptylinemsg	#print new line
	li $v0,4
	syscall      
	j main      
 
exit:   
	li $v0,10	#end program
	syscall       
	
	.data
first:			.word   0
sep:			.asciiz " "
delelcomp:		.asciiz "Delete element completed successfully"
delelerror: 		.asciiz "Delete element has an error probably the element you want to delete does not exist"
msg:			.asciiz "Please, select your action.\n"
addEl:			.asciiz "1: Add an element to the list.\n"
delEl:			.asciiz "2: Delete an element from the list.\n"
showAscendingOrder:	.asciiz "3: Show the list in ascending order.\n"
showDescendingOrder:	.asciiz "4: Show the list in descending order.\n"
readEl:			.asciiz "Please, give the integer you want to add to the list: \n"
removeEl:		.asciiz "Please, type the integer you want to remove from the list: \n"
emptylinemsg:		.asciiz "\n"
exitMsg:		.asciiz "0: Exit the programm.\n"
head:			.word 0
