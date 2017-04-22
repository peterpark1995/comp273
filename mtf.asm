# -----------   STARTER CODE -------------------------------

.data	  
	
sizeBuffer:	.word   0	# dummy value:  real value will be entered by user
stringRefArray:	.space 20       # allocate bytes for the array of 5 starting addresses of strings 
strings:	.space 100	# allocate 100 bytes for all the strings		
maxLenStrPrompt:
		.asciiz		"ENTER MAX LENGTH STRING: "	
stringPrompt:
		.asciiz		"ENTER STRING : "	
newline:	.asciiz		"\n"	
numStringsMessage:
		.asciiz		"NUMBER OF STRINGS IS "	
enumerate:	.asciiz		".) "	
MTF:		.asciiz		"MOVE TO FRONT ITEM (ENTER NUMBER) : "
exitMessage:	.asciiz		"BYE FOR NOW !"

.text  
       
main:  	 				

#  print prompt  to enter maximum length of a string
 
	la	$a0, maxLenStrPrompt	
	li	$v0, 4
	syscall 	

#  read maximum length of string buffer,  read value goes into $v0
	li	$v0, 5
	syscall 	
	

#  If user specifies that string is at most N characters, then we need a buffer for 
#  reading the string that is at least size = N+1 bytes.  The reason is that the
#  syscall will append a \0 character.  If the entered string is less than N
#  bytes, then the syscall will append \n\0, that is, a line feed followed by a null terminator.

#   Store the value size = N+1 in Memory.  This is the size of the buffer that syscall needs.

  	addi	$v0, $v0, 1  
	la	$t0,  sizeBuffer 
	sw	$v0, 0($t0)

# ---------------  ADD YOUR CODE BELOW HERE  -------------------------------
    # we use the following registors for the listed reasons
      	#t4: current address pointer
    	#t7: This points to the last string
    	#t6: pints where to put new string
    	#t9: length of each input is saved used as adder on string address
#MY 7th ATTEMPT AT THIS assignment!!!!! -____-; took me around 50 hours....
	la $t4 strings #load strings
	la $s1 stringRefArray # load stringrefarray
#We first note that $s0 is the counter for how many strings we have
	add $s2, $v0,0 #moving size buffer to s
 
Input:
	li $t1,0 # this holds count of how long the string is
	beq $s0,5,end # after we have maxnumber of strings in the stringsrefarray we branch to end to say how many inputs we have
	
	#t4 will point to where the current string address is

	 la $a0,stringPrompt #ask use to type string
   	 li $v0,4
   	 syscall
    	add  $t4, $t4, $t9 #points to free adress
    	add $a0 , $t4 , 0 
    	
    	add $a1, $s2, 0
    	addi $a1,$a1,1 #added for allocating space of the last character /n
    	li $v0, 8
    	syscall
	#So far here was almost like while loop for taking in the input
    	#	We now find the length of the string tro store on the memory
    	
  	add $t7,$a0, 0  # $t7 pointing at the most recent string
  	
  	subi $t3,$s2,1#  added 1 to $s2 earlier for sizebuffer so we subtract to get the original length
  	
  	# Noew we need to find the length of the string
  	Length:
  		# we attempt to count the length of the string by counting number of each byte
  		# remember that $t7 points to most recent string we want the pointer to point here
  		lb $t6,($t7)	# this will count the number of bytes (characters in the string)
        	# we have to define a function to finding where the end of string is and rreturns 0 to $t6
        	  beq $t6, $zero ,checkend	# if $t6 equal zero then checkend is called
        	 beq $t1,$t3,Endofstringsarray #this method checks if we have reached end, #t1 counts whether or not we have reached end 
              add $t7,$t7,1	# move pointer one character
               add $t1,$t1,1	# increment count

                j Length	# go round the loop again
    		


   

           
        Endofstringsarray:
           	li $v0,4
          	addi $t1,$t1,1	# counter increas
                lb $t2,($t7)       
            	li $t3,10	#we are using ascii value for skipping line
                sb $t3,($t7) 	#sets the last element to be \n
     
                beq $t2,10,checkend #checks last character whether or not is its \n
    		la $a0,newline
    		syscall   

   checkend:
        # checks if we reachd the end of string
        beq $t1,1 ,end 	#empty string will make it move to branch end
        addi $t9, $t1,1 		#set t9 with the input len + 1 to count the null byte
        
        #Print the user input again
        li $v0,4
        move $a0, $t4
		
        syscall			#print string
        
        
        
        sll $t6, $s0, 2     	# we shift 
        add $t6, $t6,$s1    	#get the adress of first free space      
        
        sw $t4, ($t6)     	 #move to beginning of the input    
        add $s0,$s0,1     	#counter increase
        j Input        
       	
   
  
                
	
end:
    #print number of strings message previously stored
    la $a0,numStringsMessage	
    li $v0,4
    syscall
    
    move $a0,$s0	
    li $v0,1
    syscall	   
    #Call new line
    li $v0,4
    la $a0,newline
    syscall


part2:
	la $t1, stringRefArray
	li $t6, 0
printinput:
	beq $t6, $s0, enddisplay
	li $v0,1
	add $a0, $t6, 0
	syscall
	
	#priting )
	li $v0,4
	la $a0, enumerate
	syscall
	
	#priting inputstring
	li $v0,4
	lw $a0, ($t1)
	syscall
	

	addi $t1,$t1,4
	
	addi $t6,$t6,1
	
	j printinput

enddisplay:
	#primpting MT
	li $v0,4
	la $a0, MTF
	syscall
	
	#wait for imput
	
	li $v0 5
	syscall
	
	slt $t6,$v0,$s0
	beq $t6, $zero, done # exits the program when its done to print the exit message
	
	add $t7, $s1, 0 
	add  $t6, $v0 0
	li $t1, 0
	
	sll $t9, $t6, 2
	add $t9, $s1, $t9
	add $t6 $t6 ,1 
	lw $t4, ($t9)
	

	
	
	# move to top
	
movetotop:
	beq $t1, $t6, part2 #move to part 2 when we reach the end
	lw $t3, ($t7)
	sw $t4, ($t7)
	add $t4, $t3, 0 
	addi $t1, $t1, 1
	addi $t7, $t7, 4
	j movetotop

done:

# ---------------  ADD YOUR CODE ABOVE HERE  ------------------------------
	la	$a0, exitMessage	
	li	$v0, 4
	syscall 

	li	$v0, 10			# exit
	syscall
	nop 
