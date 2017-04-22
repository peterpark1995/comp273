
#Name : Peter Park
#Student number : 260571481
findRoot:


#    ADD YOUR CODE HERE.   ONLY SUBMIT THIS CODE (INCLUDING findRoot LABEL above).   
#    WE WILL TEST YOUR CODE WITH DIFFERENT STARTER CODE. 

	#$f14 = epsilon


	#First store all the necessary register values in the stack. i.e a=$f12 and a=$f13
	sub $sp, $sp,  20
	sw $s0 , 0($sp) #Coefficient counter stored. Probably not necessary but stored just in case
	swc1 $f12 , 4($sp) #value of a stored in menmory
	swc1 $f13 , 8($sp) #value of c stored in memory
	swc1 $f15 , 12($sp) #value of b stored in memory
	sw $ra, 16($sp) #vaue of return address stored in memory

findRoot2:
	
 # b = (a + c) / 2
 	li $t0, 2 # turn this value into single
 	mtc1 $t0, $f16
 	cvt.s.w $f16, $f16	 #$f16 now hold value 2 
	
	add.s $f15, $f12, $f13 # store a+c in to $f15 temporarily
	div.s $f15, $f15, $f16 #$f15 has b with single precision
	
	
	
	#temporary store the values of $f12 on $f22
	mov.s  $f22, $f12
	#evaluate takes in the value of $f12 we want this to be b
	mov.s $f12, $f15
	jal evaluate
	mov.s $f12 ,$f22
	mov.s $f1, $f0 #$f1 is $f0 used as temporary registor
	mtc1 $zero, $f21
	cvt.w.s $f21, $f21
	#$f21 now stores the float 0.0
	c.eq.s $f1,$f21 # if ( p(b) == 0 ) 
	bc1t Endloop
	
	sub.s $f16, $f22, $f13 
	abs.s $f16 , $f16 #was not shown in class but I found after googling
	c.lt.s $f16 , $f14 #abs(a-c) < epsilon
	bc1t Endloop  #else if ( abs(a - c) < epsilon)

	jal evaluate
	
	#returns on $f0
	mov.s $f2, $f0 #f2 1 is $f0 used as temporary registor
	
	#else if ( p(a)*p(b) > 0 )
	mul.s $f3, $f2, $f1 #again $f2 is used as temporary registor for the product
	#t2 hold the product
	

	c.lt.s $f3 , $f21
	bc1t else
	mov.s $f12, $f15#storing value of a=b
	jal findRoot2

	
else:
	mov.s $f13 , $f15 #storing value of c=b
	jal findRoot2
	#we now have $t0 = f(a) and $t(1)= f(c)
	
	
		

	
	
Endloop:
	mov.s $f0 ,$f15
	lw $s0 , 0($sp) #Coefficient counter stored. Probably not necessary but stored just in case
	lwc1 $f11 , 4($sp) #value of a stored in menmory
	lwc1 $f13 , 8($sp) #value of c stored in memory
	lwc1 $f15 , 12($sp) #value of b stored in memory
	lw $ra, 16($sp) #vaue of return address stored in memory
	add $sp, $sp,  20
	jr $ra
	
	
	
		
		



