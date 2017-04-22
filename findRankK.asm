
findRankK:  
#PLEASE PLEASE READ IF YOU ARE USING OTHER BRANCH THEN main THEN THIS CODE WILL NOT COMPILE. I JUST WANTED TO ADD THIS FUNCTION IN
		bge $a0, $a2, Limitexceeded
#storing all registors into stack
#STORING EVERYTHING
		subi $sp, $sp,  44
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $s3, 12($sp)
		sw $s4, 16($sp)
		sw $s5, 20($sp)
		sw $s6, 24($sp)
		sw $a0, 28($sp)
		sw $a1, 32($sp)
		sw $a2, 36($sp)
		sw $ra, 40($sp)
			

	#   $a0 holds k,  the index of the desired element
	#   $a1 is the base address of list  (list is size L words, buffer of size L words 
	#    - so array is of size 2L words)
	#   $a2 holds the length L of the list
	li $t0, 1
	beq $a2, $t0, basecase #basecase
	# we will use $t1 for index, $t2 for low and $t3 for high
	#we also use $a3 as the pivot throughout this function
	lw $a3, ($a1) #pivot loaded to $a3
	li $t1, 4 #$t1 now used as index i (4 =1 word )
	li $t2, 0 #$t2 now used as low
	sub $t3, $a2, 1 #$t3 now used as high
	sll $t3, $t3, 2 #multiplying 4
	la $s0, partitionedList #address of bufferadded
partitionloop:
############## buffer note####################
#s0 points to the base address of buffer always
#use $t5 for pointer used in buffer 


# NEED TO KEEP use $t1 registor and $t2 registor for same purpose throughout

#########################################
	sll $t4, $a2 ,2 #length of  $list stored in $t4
	slt $t0, $t1, $t4  #comparing 4*i and 4*length
	beq $t0, $zero, partitionloopExit#condition for while loop
	add $s1, $a1, $t1 #$s1 holds list[i]
	lw $s1, ($s1)
	#converted all into multiple of 4
	slt $t0, $s1 , $a3 #comparing the value of pivot to list [i]
	beqz $t0, elseif#condition for if statement list[i] < pivot
	addu $t5, $s0, $t2 #Assuming the order of the list does not matter in any case this now has baseaddress of partitionedlist + low (index of buffer) 
	sw $s1, 0($t5)   #the value of list[i] is stored in partitionedList[low] 
	addi $t2, $t2 , 4 #low++

	
elseif: #$t1 is the index
	sgt $t0, $s1 , $a3
	beqz $t0, Exit1
	addu $t6, $s0, $t3 #$t6 holds address of basee oflist + high (index of list)
	sw $s1, 0($t6)  #now the index is stored into correct address on $s3
	addi $t3, $t3 , -4
	
Exit1:
	addi $t1, $t1, 4 #the i++ is here since we need an offset it will call list[i]
Exit2:
	j partitionloop
partitionloopExit: #partitionloop exit computes the second while loop
	move $t7, $t2 # This is also used as index but in the 2nd while loop
	#for list that is equal to pivot
	#t7 has the value of low, which is equatl to i
partitionloopExit2:
	sge $t0 ,$t3,$t7
	beqz $t0, Exit3
	addu $t4, $s0, $t7
	sw  $a3, 0($t4) #pivot added $t4 which is $s0 offset by low
	addi $t7, $t7, 4
	
	j partitionloopExit2
Exit3:
	#NEED TO KEEP $t2 $t3 SAME THROUGHOUT THE CODE
	#The new list has to have the same element as partitioned list which includes L1,L2,L3 in this order
	#Now we replace the old list with the buffer list
	# while i<length-1, list[i]=buffer[i]
	add $t1, $zero, $a1 #in attempt to keep $a1 same
	sll $t7, $a2 , 2
	add $t4, $a1, $t7 #to keep $a2 same
	add $t5, $zero, $s0 #base adress of buffer stored
Listreplace:

	slt $t0, $t1, $t4
	beqz $t0, Replacecomplete
	move $t6, $t5
	lw $t6, ($t6)
	sw $t6, ($t1)
	add $t5, $t5, 4
	add $t1, $t1, 4
	j Listreplace
Replacecomplete:

	sll $t9, $a0, 2	
	slt $t0, $t9, $t2 #4k < 4low
	beqz $t0, exitif1 #if statement
#Now we are looking at the if statment for returning recursive function
 #######
 # Let $a0=k , $a2=$t2 (value divide by 4) this will be used as new length
 #
 ### 
 
 	#change length but baseadress and k is the same
 	srl $a2, $t2 ,2 
 	jal findRankK
 	j endload
 	
	#for (i = 0; i < low; i++)
        #    	newlist[i] = partitionedList[i];
	#		return findRankK(k, newlist);
	#set $t1 as index like last time
	
#	lw $t1, $zero
#	add $s5, $a0, $t1
#Forloop:
#	slt $t0, $t1,$t2
#	beqz $t0, $zero, ExitFL
#	addi $t1, $t1, 4
#	j Forloop


#We only need to change the address of $a1, We change this starting address of buffer list
#only thing that changes is the base address of the list and low we want to keep these two
#set low to high

	
	
	
exitif1:# now doing else if
	srl $t1, $t3, 2
	sll $t9, $a0, 2	
	sge $t0, $t1, $a0
	beqz $t0, exitelif
	move $v0, $a3
	jr $ra

		
exitelif:#now doing else
	sll $t1, $a2, 2 #length loaded to $t1
	#length - high-1
	move $t7, $t3
	addi $t7, $t7, 4  #%t7= (high+1)= i 
	move $t8, $t7 #for later use
forloop: #just realized that this for loop is redundant only need to change the base address k and length
	slt $t0, $t7, $a2
	beqz $t0, finalreturn

finalreturn:
	#change length and base address and k
	# k = $a0-$t8, 
	add $a1, $a1, $t8
	srl $t8, $t8,2 
	sub $a0, $a0, $t8
	sub $a2, $a2, $t8
	jal findRankK
	j endload
basecase:
	lw $v0, ($a1)		
	
	j endload
	#basecase moving the baseaddres to $v0
	
Limitexceeded:
	#PLEASE PLEASE READ IF YOU ARE USING OTHER BRANCH THEN main THEN THIS CODE WILL NOT COMPILE. I JUST WANTED TO ADD THIS FUNCTION IN
	j main
endload:
		#JUST STORING EVERYTHING			
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $a0, 28($sp)
		lw $a1, 32($sp)
		lw $a2, 36($sp)
		lw $ra, 40($sp)
		addi $sp, $sp,  44# allocate stack space: 1 values * 4 bytes each
			
			
		jr $ra

