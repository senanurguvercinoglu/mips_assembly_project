	.text
main:
	li $v0, 4 	#print_string syscall code is 4
	la $a0, hello 	#loading the address of the hello message
	syscall

	while:	
		#printg menu
		li $v0, 4 	#print_string syscall code is 4
		la $a0, Menu #loading the address of the menu
		syscall
		
		#get input 
		li $v0, 5 #read_int syscall code is 5
		syscall
		move $t1, $v0	#result is returned in $t1
		
		#if statements for menu option which is chosen by the user
		
		beq $t1, 1, callSortLetters	
		beq $t1, 2, callSortNum	#if $t1 is 2 calling sortNum function
		beq $t1, 3, callPrime	#if $t1 is 3 calling prime function
		beq $t1, 4, callHuffman	#if $t1 is 4 calling huffman function
		beq $t1,5, exit	#if $t1 is 5 exit
		
		j while	
		
	callSortLetters:
		jal sort
		j while 
		
	callSortNum:
		jal sortNum
		j while	
	
	callPrime:
		jal prime
		j while
	callHuffman:
		jal huffman
		j while
	
	exit:
		li $v0, 4	#print_string
		la $a0, goodbye		#loading goodbye message
		syscall
		
		li $v0, 10 #exit code
		syscall

#SORT LETTERS FUNCTION		
sort:
	addi $sp, $sp, -4	#because this function calls another function we should keep the return addres in stack
	sw $ra, 0($sp)

    li $v0, 4  #syscall to print command string
    la $a0, command
    syscall 

    li $v0, 8 #syscall to read the string
    la $a0, input
    li $a1, 100
    syscall

    jal length

    li $t0, 0

 
    frLoop:
        slt $t3, $t0, $v0    #$t3=0 if($t0>=$v0) /if(i>=length)
        beqz $t3, sortLetters    #if $t3=0 exit
        add $t4, $a0, $t0
        lb $t5, 0($t4) 

        bge $t5, 0x41, upper #0x41 is the ascii value of A it is for checking whether the char is between A-Z or not
        bge $t5, 0x61, lower #0x61 is the ascii value of a it is for checking whether the char is between a-z or not
        addi $t0, $t0, 1     #to increment iterator i++

        j frLoop

        upper:
            bgt $t5, 0x5A, upperExit #if the char is greater than 0x5A which means uppercase Z, then we should exit
            addi $t5,$t5, -65 #checks the order of each letter corresponds in the alphabet
            sll $t5, $t5, 2
            lw $t6, array($t5) 
            addi $t6, $t6, 1
            sw $t6, array($t5) #adds occurences of each letter in the array
            addi $t0, $t0, 1   #to increment iterator i++

            j frLoop

        lower:
            bgt $t5, 0x7A, lowerExit #if the char is greater than 0x7A which means lowercase z, then we should exit
            addi $t5,$t5 -97 #checks the order of each letter corresponds in the alphabet
            sll $t5, $t5, 2
            lw $t6, array($t5)
            addi $t6, $t6, 1
            sw $t6, array($t5) #adds occurences of each letter in the array
            addi $t0, $t0, 1   #to increment iterator i++

            j frLoop
          
          upperExit:
          	bge $t5, 0x61, lower
          	addi $t0, $t0, 1   #to increment iterator i++
           	j frLoop
           	
          lowerExit:
          	addi $t0, $t0, 1   #to increment iterator i++
            	j frLoop        	

sortLetters:
	
	

	li $v0, 4
	la $a0, charOc
	syscall
	
	li $t0,0
	li $t1, 26	#length
	
	loopOne:
		slt $t3, $t0, $t1
		beqz $t3, loopOneExit #if $t3=0 exit
		sll $t4, $t0,2
		lw $t3, array($t4)
		beqz $t3, ifExit
		move $t5, $t3	#int temp=a[i];         
		move $t6, $t0	#int letter=i;
		li $t2, 0
	loopTwo:
		slt $t3, $t2, $t1
		beqz $t3, loopTwoExit #if $t3=0 exit
		sll $t4, $t2,2
		lw $t3, array($t4)
		beqz $t3, secondIfExit #if $t3=0 exit
		blt $t5, $t3, isLess #if $t5<$t3 (temp<a[j]) go to isLess
		beq $t5, $t3, isEqual #if $t3=$t5 (temp==a[j]) go to isEqual
	isEqual:
		addi $t7, $t2, 65 #$t7=$t2+65 (j+65)
		addi $t8, $t6, 65 #$t8=$t6+65 (letter+65)
		blt $t7, $t8, isLess #if $t7<$t8 go to isLess
		addi $t2, $t2, 1
		j loopTwo
		
	 isLess:
	 	move $t5, $t3
	 	move $t6, $t2 
	 	addi $t0, $t0, -1 #to decrement iterator i--
	 	j loopTwo
	
	secondIfExit:
		addi $t2, $t2, 1 #to incerement iterator j++
		j loopTwo	
		
		
	ifExit:
		addi $t0,$t0,1 #to incerement iterator i++
		j loopOne
		
	loopTwoExit:
		
	
		addi $t8, $t6, 65
		li $v0, 11	#ascii value
		move $a0, $t8
		syscall
		
		li $v0, 4
		la $a0, tab
		syscall
		
		li $v0, 1
		move $a0, $t5
		syscall
		
		li $v0, 4
		la $a0, line
		syscall
		
		sll $t9, $t6, 2
		sw $zero, array($t9)
		
		addi $t0,$t0,1
		j loopOne
	
		
	loopOneExit:	
		lw $ra, 0($sp)		#loads the return value
		addi $sp, $sp, 4	
		jr $ra
		
#SORTNUM FUNCTION
sortNum:
	addi $sp, $sp, -4	#because this function calls another function we should keep the return addres in stack
	sw $ra, 0($sp)
	
	
	li $v0, 4
	la $a0, Input	#prints input message
	syscall
		
	li $v0, 8 		#read_string
	la $a0, userInput 	#address to place string
	li $a1, 50 		#max string length, we assumed input size might be 50 at most
	syscall
	
	jal length
    
	#initialization of the necessary elements:
	li $t1, 0	#digit location decCounter=0
	li $t2, 0	#array element location index=0
	li $s2, 0	#num initialized to 0 num=0
	
	
	#in this for loop chars are being converted to int and they are added to an array
	li $t0, 0	#iterator starting 0 i=0
	forLoop:
		slt $t3, $t0, $v0	#$t3=0 if($t0>=$v0) /if(i>=length)
		beqz $t3, forLoopExit	#if $t3=0 exit
		add $t4, $a0, $t0
		lb $t5, 0($t4)		#$t5= char at the positon of the string input
		beq $t5, 0x20, space	#0x20 is the ascii value of space it controls if the char is space
		beq $t5, 0x2D, dash	#0x2D is the ascii value of - it controls if the char is dash
		bnez $t1, moreThanOneDigit
		addi $t6, $t5, -48	#convert to integer
		add $s2, $s2, $t6	#add to $s2
		addi $t1, $t1, 1	#increment digit location
		addi $t0, $t0, 1	#increment iterator i++
		
		j forLoop	
		
		moreThanOneDigit:
			addi $t6, $t5, -48	#convert to integer
			addi $t7, $zero, 10
			mul $s2, $s2, $t7	# $s2*10
			add $s2, $s2, $t6
			addi $t1, $t1, 1	#increment digit location
			addi $t0, $t0, 1	#increment iterator i++
		
			j forLoop			
		
		space:
			sw $s2, numbersArray($t2)
			addi $t2, $t2, 4	#inceremnt array index 
			li $t1, 0		#digit location is zeroized for new number
			addi $t0, $t0, 1	#increment iterator i++
			li $s2, 0		#$s2=0 for new number
		
			j forLoop
		
		dash:
			li $t7, 0
			addi $t7, $t0, 1	#new for loop iterator is j and j=1+1
			lp:
				add $t4, $a0, $t7
				lb $t5, 0($t4)			#$t5= char at the positon of the string input
				beq $t5, 0x20, exitlp	#0x20 is the ascii value of space it controls if the char is space
				beq $t5, 0x0a, exitlp
				beq $t5, $zero, exitlp
				bnez $t1, mtod		#moreThanOneDigit for this loop
				addi $t6, $t5, -48	#convert to integer
				add $s2, $s2, $t6	#add to num
				addi $t1, $t1, 1	#incerement digit location
				addi $t7, $t7,1		#incerement loop iterator j
				
				j lp
				
				mtod:
					addi $t6, $t5, -48	#convert to integer
					addi $t3, $zero, 10
					mul $s2, $s2, $t3	#$s2*10
					add $s2, $s2, $t6
					addi $t1, $t1, 1	#incerement digit location
					addi $t7, $t7,1		#incerement loop iterator j
				
					j lp
						
				
				
				exitlp:
					move $t0, $t7		#i=j cuz we finished the negative number
					sub $s2, $zero, $s2		#$s2=0-num convert negative
					
					j forLoop	
		
		
		forLoopExit:
			sw $s2, numbersArray($t2)	#for the last number cuz there is no space at the end of it
			move $s5, $t2			#store the lenght of the array in $s5
			sra $s5, $s5, 2			#dived 4 to find lenght
			addi $s5, $s5,1			
			
			j sortTheArray
			
	sortTheArray:
		li $t0, 0
		li $t1, 0
		
		
		outerLoop:
			slt $t3, $t0, $s5	#is greater than the length of the aray	
			beqz $t3, printArrayElement	#if $t3=0 exit
			addi $t1, $t0, -1		#j=i-1		
		innerLoop:
			slti $t3, $t1, 0		#j>=0 $t3=1
			bnez $t3, innerExit
			sll $t2, $t1, 2			#$t1*4
			addi $t3, $t2, 4		#t2+4			
			lw $t4, numbersArray($t2)	#load the element in the $t2 location
			lw $t5, numbersArray($t3)	#load the element in the $t3 location		
			slt $t2, $t5, $t4		#is it greater 
			beqz $t2, innerExit
			sll $t7, $t1, 2	
			addi $t3, $t7, 4
			lw $t8, numbersArray($t7)	#swapping 
			lw $t9, numbersArray($t3)
			sw $t9, numbersArray($t7)
			sw $t8, numbersArray($t3)
			addi $t1,$t1,-1
			j innerLoop
			
			innerExit:
				addi $t0, $t0,1		#increment outerloop index
				j outerLoop		
	
	printArrayElement:
		li $t0, 0
		move $t4, $v0
		sll $s5, $s5,2		#$s2*4 we are gonna need array lenght*4
		
		li $v0, 4
		la $a0, Output		#prints output message
		syscall
		
		printLoop:
			slt $t3, $t0, $s5	#is it greater than array length
			beqz $t3, printArrayElementExit		#if it is than exit
			lw $t1, numbersArray($t0)	#loads the number in the $t0 index in to $t1
			
			li $v0, 1
			move $a0, $t1	#prints $t1
			syscall
			
			li $v0, 4
			la $a0, spc	#prints space 
			syscall
			
			addi $t0, $t0,4		#increment the array for loop index by 4
			
			j printLoop	
		
		
		printArrayElementExit:
			lw $ra, 0($sp)		#loads the return value
			addi $sp, $sp, 4	
			jr $ra	
#PRIME FUNCTION
prime:
	
	li $v0, 4
	la $a0, message
	syscall
	
	li $v0, 5  #reads an integer, v0 = n
	syscall
	
	move $s0, $v0	 #n stored in $s0
	addi $s2, $s0,1	
	
	li $t0, 0	#first loop variable i=0
	li $t1, 1	
	li $s1, 0	#array index 
	li $s5, 0	#counter for prme numbers
	li $s6,2	#count numbers loop variable
	
	
	li $t2, 2	#outer loop variable p=2
	
firstLoop:
	slt $t3, $t0, $s2	#i <= n
	beqz $t3, oLoop	#if $t3=0 exit
	sw $t1, primesArray($s1)	#prime[i] = true
	addi $t0,$t0, 1		#i++
	addi $s1, $s1,4		#index++
	j firstLoop

oLoop:
	mul $t3, $t2, $t2	#n*n
	slt $t4, $t3, $s2	#i<= n*n
	beqz $t4, countNumber	 #count the prime numbers
	sll $s3, $t2, 2		#n*4
	lw $t5, primesArray($s3)	#prime[i]=1
	beq $t5, $t1, iLoop	#if prime[i]=1 go to iLoop
	
iLoop:
	slt $t4, $t3, $s2	#t4=0 if t3>s2
	beqz $t4, exitInnerLoop	#if prime[i]=0, go to exitInnerLoop
	sll $s4, $t3, 2	 #s4=j*4
	sw $zero, primesArray($s4)	#prime[i] = false
	add $t3, $t3, $t2	#i += p
	j iLoop

exitInnerLoop:
	addi $t2, $t2, 1	#p++
	j oLoop
	
countNumber:
	#this loop counts the number of prime numbers 
	slt $t4, $s6, $s2
	beqz $t4, printNumber
	sll $s3, $s6, 2
	lw $t5, primesArray($s3)
	bne $t5, $t1, countNumberEx
	addi $s5, $s5, 1
	addi $s6, $s6, 1
	j countNumber
	
countNumberEx:
	addi $s6, $s6, 1
	j countNumber	
	
printNumber:
	li $v0, 4
	la $a0, inputMessage
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, pr
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	
	jr $ra	
	
#HUFFMAN FUNCTION
huffman:
	addi $sp, $sp, -4	#because this function calls another function we should keep the return addres in stack
	sw $ra, 0($sp)

	li $v0, 4
	la $a0, huffmanMes	#prints message
	syscall
		
	li $v0, 8 		#read_string
	la $a0, huffmanInput 	#address to place string
	li $a1, 50 		#max string length, we assumed input size might be 50 at most
	syscall
	
	jal length
	
	
	#$s0=A $s1=B $s2=C $s3= D $s4=E $s5=F
	
	li $s6, 0	#counter for occurrences
	li $t0, 0	#loop index i=0
	
	#these nested loops count the letters' occurrences and add the numbers into array
	countLettersOuterLoop:
		slt $t3, $t0, $v0	#$t3=0 if($t0>=$v0) /if(i>=length)
		beqz $t3, countLettersOuterLoopExit	#if $t3=0 exit
		li $t1, 0		#inner loop index j=0	
		add $t4, $t0, $a0	#$t4 contains the character addres at the index $t0	
	countLettersInnerLoop:
		slt $t3, $t1, $v0	#$t3=0 if($t0>=$v0) /if(i>=length)
		beqz $t3, countLettersInnerLoopExit
		lb $t5, 0($t4)		#loads the character at $t4 into $t5
		add $t6, $t1, $a0
		lb $t7, 0($t6)		#loads the character at $t6 into $t7
		bne $t5, $t7, IfExit	#if $t7 and $t5 is not equal that means characters not same so exit
		addi $s6, $s6, 1	#increment counter
		addi $t1, $t1, 1	#increment loop index
		j countLettersInnerLoop
	
	IfExit:
		addi $t1, $t1, 1	#increment loop index
		j countLettersInnerLoop
		
	
	#in this exit part 2nd array which contains te letters created.
	countLettersInnerLoopExit:
		addi $t0, $t0, 1	#increment outer loop index
		
		#$t1 contains the counter value of the letter 
		
		li $t1, 'A'			#if $t1 equals to occurence of A than add the occurrence of A into array 		
		beq $t5, $t1, itIsA
		li $t1, 'B'			#if $t1 equals to occurence of B than add the occurrence of B into array 
		beq $t5, $t1, itIsB
		li $t1, 'C'			#if $t1 equals to occurence of C than add the occurrence of C into array 
		beq $t5, $t1, itIsC
		li $t1, 'D'			#if $t1 equals to occurence of D than add the occurrence of D into array 
		beq $t5, $t1, itIsD
		li $t1, 'E'			#if $t1 equals to occurence of E than add the occurrence of E into array 
		beq $t5, $t1, itIsE
		li $t1, 'F'			#if $t1 equals to occurence of F than add the occurrence of F into array 
		beq $t5, $t1, itIsF
	
	itIsA:
		move $s0, $s6	#A=counter
		add $t1, $zero, $zero
		sw $s0, lettersOccurrence($t1)	#in $t1 index of the letter array adds the occurrence of A
		li $s6, 0	#counter=0
		j countLettersOuterLoop	
		
	itIsB:
		move $s1, $s6	#B=counter
		li $t1, 1
		sll $t1, $t1, 2
		sw $s1, lettersOccurrence($t1)	#in $t1 index of the letter array adds the occurrence of B
		li $s6, 0	#counter=0
		j countLettersOuterLoop	
	itIsC:
		move $s2, $s6	#C=counter
		li $t1, 2
		sll $t1, $t1, 2
		sw $s2, lettersOccurrence($t1)	#in $t1 index of the letter array adds the occurrence of C
		li $s6, 0	#counter=0
		j countLettersOuterLoop	
	itIsD:
		move $s3, $s6	#D=counter
		li $t1, 3
		sll $t1, $t1, 2
		sw $s3, lettersOccurrence($t1)	#in $t1 index of the letter array adds the occurrence of D
		li $s6, 0	#counter=0
		j countLettersOuterLoop	
	itIsE:
		move $s4, $s6	#E=counter
		li $t1, 4
		sll $t1, $t1, 2
		sw $s4, lettersOccurrence($t1)	#in $t1 index of the letter array adds the occurrence of E
		li $s6, 0	#counter=0
		j countLettersOuterLoop	
	itIsF:
		move $s5, $s6	#F=counter
		li $t1, 5
		sll $t1, $t1, 2
		sw $s5, lettersOccurrence($t1)	#in $t1 index of the letter array adds the occurrence of F
		li $s6, 0	#counter=0
		j countLettersOuterLoop	
			
	countLettersOuterLoopExit:
		li $t0, 0	#first loop index	
		li $t1, 0	#second loop index make sure it is 0
		li $t3, 6	#array lenght
		
		#sorts the numbers in the lettersOccurrence array
		for1loop:
			slt $t4, $t0, $t3		#is it greater than length of the array	
			beqz $t4, createArrayLetters	#if $t4=0 exit
			addi $t1, $t0, -1		#j=i-1 second loop index		
		for2loop:
			slti $t4, $t1, 0		#j>=0 $t3=1
			bnez $t4, for2loopExit
			sll $t2, $t1, 2
			addi $t6, $t2, 4			
			lw $t4, lettersOccurrence($t2)
			lw $t5, lettersOccurrence($t6)			
			slt $t2, $t5, $t4
			beqz $t2, for2loopExit
			sll $t7, $t1, 2
			addi $t4, $t7, 4
			lw $t8, lettersOccurrence($t7)		#swapping
			lw $t9, lettersOccurrence($t4)
			sw $t9, lettersOccurrence($t7)
			sw $t8, lettersOccurrence($t4)
			addi $t1,$t1,-1
			j for2loop
			
			for2loopExit:
				addi $t0, $t0,1
				j for1loop	
	
	#in thispart 2nd array which contains the letters is cretaed based on their occurrence value by ascending order
	createArrayLetters:	
		li $t0, 0	
		
		arrayLoop:
			slt $t4, $t0, $t3		#is it greater than length of the array	
			beqz $t4, createHuffmanCodeArray #if it is exit
			sll $t5, $t0, 2			#$t0*4
			lw $t5, lettersOccurrence($t5)	#loads the number at $t5 index into $t5
			beq $t5, $s0, equalAsOccurrence	#controls if the occurence value is A's value
			beq $t5, $s1, equalBsOccurrence #controls if the occurence value is B's value
			beq $t5, $s2, equalCsOccurrence #controls if the occurence value is C's value
			beq $t5, $s3, equalDsOccurrence #controls if the occurence value is D's value
			beq $t5, $s4, equalEsOccurrence #controls if the occurence value is E's value
			beq $t5, $s5, equalFsOccurrence #controls if the occurence value is F's value
			
			equalAsOccurrence:
				li $t1, 'A'
				li $s0,0	#makes it zero to ensure it wont be repeated again. 
				sb $t1, letters($t0)	#add the letter A in the index $t0 of the letters array
				addi $t0, $t0, 1
				j arrayLoop				
			equalBsOccurrence:
				li $t1, 'B'
				li $s1,0	#makes it zero to ensure it wont be repeated again. 
				sb $t1, letters($t0)	#add the letter B in the index $t0 of the letters array
				addi $t0, $t0, 1
				j arrayLoop
			equalCsOccurrence:
				li $t1, 'C'
				li $s2,0	#makes it zero to ensure it wont be repeated again. 
				sb $t1, letters($t0)	#add the letter C in the index $t0 of the letters array
				addi $t0, $t0, 1
				j arrayLoop
			equalDsOccurrence:
				li $t1, 'D'
				li $s3,0	#makes it zero to ensure it wont be repeated again. 
				sb $t1, letters($t0)	#add the letter D in the index $t0 of the letters array
				addi $t0, $t0, 1
				j arrayLoop
			equalEsOccurrence:
				li $t1, 'E'
				li $s4,0	#makes it zero to ensure it wont be repeated again. 
				sb $t1, letters($t0)	#add the letter E in the index $t0 of the letters array
				addi $t0, $t0, 1
				j arrayLoop
			equalFsOccurrence:
				li $t1, 'F'
				li $s5,0	#makes it zero to ensure it wont be repeated again. 
				sb $t1, letters($t0)	#add the letter F in the index $t0 of the letters array
				addi $t0, $t0, 1
				j arrayLoop			
			
	#in this part 3rd array is created based on huffman tree logic
	createHuffmanCodeArray:
	
		  #arrays indexes 
		  li $s0, 0
		  li $s1, 4
 		  li $s2, 8
  		  li $s3, 12
  		  li $s4, 16
   		  li $s5, 20

		  #occurrence values are loaded
 		  lw $t0, lettersOccurrence($s0) #t0=num[0]
  		  lw $t1, lettersOccurrence($s1)
  		  lw $t2, lettersOccurrence($s2)
 		  lw $t3, lettersOccurrence($s3)
 		  lw $t4, lettersOccurrence($s4)
   		  lw $t5, lettersOccurrence($s5)

 		  add $t6, $t0, $t1 #lettersOccurrence[0]+lettersOccurrence[1]
 		  add $t6, $t6, $t2 #lettersOccurrence[0]+lettersOccurrence[1]+lettersOccurrence[2]
  		  add $t6, $t6, $t5 #lettersOccurrence[0]+lettersOccurrence[1]+lettersOccurrence[2]+lettersOccurrence[5]

  		  add $t7, $t3, $t4 #lettersOccurrence[3]+lettersOccurrence[4]

		#we consider 2 is 0 cuz we cannot add 0 at the begginning of an integer!
		
   		  blt $t6, $t7, Else #lettersOccurrence[0]+lettersOccurrence[1]+lettersOccurrence[2]+lettersOccurrence[5]>=lettersOccurrence[3]+lettersOccurrence[4]
  		  li $t8, 20		#20 is actually equals to 00 
  		  li $t9, 21		#21=01
  		  sw $t8, lettersHuffmanCode($s3)	#adds huffman code into array
  		  sw $t9, lettersHuffmanCode($s4)
  		  
   		  sub $t6, $t6, $t5 #lettersOccurrence[0]+lettersOccurrence[1]+lettersOccurrence[2]
   		  
  		  blt $t6, $t5, Else1  #lettersOccurrence[0]+lettersOccurrence[1]+lettersOccurrence[2]>=lettersOccurrence[5]

   		  li $t8, 10 
   		  sw $t8, lettersHuffmanCode($s5) #adds huffman code into array
   		  sub $t6, $t6, $t2 #lettersOccurrence[0]+lettersOccurrence[1]
    		  blt $t6, $t2, Else2 #lettersOccurrence[0]+lettersOccurrence[1]>=lettersOccurrence[2]

    		  li $t7, 110
  		  li $t8, 1110
  		  li $t9, 1111

  		  sw $t7, lettersHuffmanCode($s2)	#adds huffman code into array
  		  sw $t8, lettersHuffmanCode($s0)	#adds huffman code into array
  		  sw $t9, lettersHuffmanCode($s1)	#adds huffman code into array
  		  j printHuffmanCode
  		  
		Else2:
 		   	li $t7, 111
 		   	li $t8, 1100
  		  	li $t9, 1101

    			sw $t7, lettersHuffmanCode($s2)	#adds huffman code into array
    			sw $t8, lettersHuffmanCode($s0)	#adds huffman code into array
    			sw $t9, lettersHuffmanCode($s1)	#adds huffman code into array
    			
    			j printHuffmanCode
		Else1:
 			li $t8, 11
    			sw $t8, lettersHuffmanCode($s5) 

    			sub $t6, $t6, $t2#lettersOccurrence[0]+lettersOccurrence[1]>=lettersOccurrence[2]
    			blt $t6, $t2, Else3

    			li $t7, 100
    			li $t8, 1010
    			li $t9, 1011

    			sw $t7, lettersHuffmanCode($s2)	#adds huffman code into array
    			sw $t8, lettersHuffmanCode($s0)	#adds huffman code into array
    			sw $t9, lettersHuffmanCode($s1)	#adds huffman code into array
    			
    			j printHuffmanCode
		Else3:
    			li $t7, 101
    			li $t8, 1000
    			li $t9, 1001

    			sw $t7, lettersHuffmanCode($s2)	#adds huffman code into array
    			sw $t8, lettersHuffmanCode($s0)	#adds huffman code into array
    			sw $t9, lettersHuffmanCode($s1)	#adds huffman code into array
    			
    			j printHuffmanCode
    			
    			
		Else:#lettersOccurrence[0]+lettersOccurrence[1]+lettersOccurrence[2]+lettersOccurrence[5]<=lettersOccurrence[3]+lettersOccurrence[4]
			add $t6, $t0, $t1
 			add $t6, $t6, $t2
  		  	add $t6, $t6, $t5 #lettersOccurrence[0]+lettersOccurrence[1]+lettersOccurrence[2]+lettersOccurrence[5]
  		  	
    			li $t7, 10
    			li $t8, 11
    			
    			sw $t7, lettersHuffmanCode($s3)		#adds huffman code into array
  		  	sw $t8, lettersHuffmanCode($s4)		#adds huffman code into array
  		  	sub $t6, $t6, $t5 #lettersOccurrence[0]+lettersOccurrence[1]+lettersOccurrence[2]
   		  
  		  	blt $t6, $t5, Else11  #lettersOccurrence[0]+lettersOccurrence[1]+lettersOccurrence[2]>=lettersOccurrence[5]

   		 	li $t8, 20 
   		  	sw $t8, lettersHuffmanCode($s5)#binary[5]=10
   		  	sub $t6, $t6, $t2 #lettersOccurrence[0]+lettersOccurrence[1]
    		  	blt $t6, $t2, Else22 #lettersOccurrence[0]+lettersOccurrence[1]>=lettersOccurrence[2]

    		  	li $t7, 210
  		  	li $t8, 2110
  		  	li $t9, 2111

  		  	sw $t7, lettersHuffmanCode($s2)	#adds huffman code into array
  		  	sw $t8, lettersHuffmanCode($s0)	#adds huffman code into array
  		  	sw $t9, lettersHuffmanCode($s1)	#adds huffman code into array
  		  	
  		  	j printHuffmanCode
		Else22:
 		   	li $t7, 211
 		   	li $t8, 2100
  		  	li $t9, 2101

    			sw $t7, lettersHuffmanCode($s2)	#adds huffman code into array
    			sw $t8, lettersHuffmanCode($s0)	#adds huffman code into array
    			sw $t9, lettersHuffmanCode($s1)	#adds huffman code into array
    			
    			j printHuffmanCode
		Else11:
 			li $t8, 21
    			sw $t8, lettersHuffmanCode($s5) #adds huffman code into array

    			sub $t6, $t6, $t2#lettersOccurrence[0]+lettersOccurrence[1]>=lettersOccurrence[2]
    			blt $t6, $t2, Else33

    			li $t7, 200
    			li $t8, 2010
    			li $t9, 2011

    			sw $t7, lettersHuffmanCode($s2)	#adds huffman code into array
    			sw $t8, lettersHuffmanCode($s0)	#adds huffman code into array
    			sw $t9, lettersHuffmanCode($s1)	#adds huffman code into array
    			
    			j printHuffmanCode
		Else33:
    			li $t7, 201
    			li $t8, 2000
    			li $t9, 2001

    			sw $t7, lettersHuffmanCode($s2)	#adds huffman code into array
    			sw $t8, lettersHuffmanCode($s0)	#adds huffman code into array
    			sw $t9, lettersHuffmanCode($s1)	#adds huffman code into array
    			
    			j printHuffmanCode  	
   	
   	#prints the huffman code according the input given by user
   	printHuffmanCode:
   		li $v0, 4
		la $a0, huffmanMes2	#prints messgae
		syscall
		
		li $v0, 8 		#read_string
		la $a0, huffmanInput2 	#address to place string
		li $a1, 10 		#max string length, we assumed input size might be 10 at most
		syscall
		move $a2, $a0
		
	
		jal length
		
		move $a3, $v0		#cuz we are gonna use $v0 we are load its value in $a3
		
		li $s7, 6	#array length
		li $t0, 0	#first loop index
		
		
		fLoop:
			slt $t3, $t0, $a3	#$t3=0 if($t0>=$v0) /if(i>=length)
			beqz $t3, firstLoopExit	#if $t3=0 exit
			li $t1, 0	#second loop index
		
		secondLoop:
			add $t4, $t0, $a2
			slt $t3, $t1, $s7	#index should be less than array length
			beqz $t3, secondLoopExit
			lb $t4, 0($t4)		#char at $t4
			lb $t5, letters($t1)	#char at array nth index
			bne $t4, $t5, secondLoopExit1
			sll $t5, $t1, 2
			lw $t5, lettersHuffmanCode($t5)	#temporary
			li $t6, 0	#counter
			
			#cuz we assign the 0 at the beginning as 2 this loop is check if it is 2 or not. iif it is 2 than it prints it as 0
			whl:
				#finds the first digit
   				blt $t5, 10, whileExit
   				div $t5, $t5, 10
				addi $t6, $t6, 1
				j whl
				
			whileExit:
				li $t7, 2	#iis first digit is 2?
				beq $t5, $t7, whileExitElse
				sll $t5, $t1, 2
				lw $t8, lettersHuffmanCode($t5)
				
				li $v0, 1
				move $a0, $t8	#prints the huffman code
				syscall
				
				addi $t1, $t1, 1
				j secondLoop
			
			whileExitElse:	#first digit is 2
				li $t7, 0
				li $t2, 1
				li $t3, 10
				
				#this while loop for takind the nth power of 10 n is $t6
				wh:
					beq $t7, $t6, exitWH
					mul $t2, $t2, $t3
					addi $t7, $t7,1
					j wh
					
				exitWH:
					sll $t5, $t1, 2
					lw $t8, lettersHuffmanCode($t5)
					div $t8, $t2	#divide huffman code with 10 to the n
					mfhi $t9	#keep remainder in $t9
					
					li $v0, 1
					move $a0, $zero	#cuz first value was 2 it prints 0 instead 
					syscall
					
					li $v0, 1
					move $a0, $t9	#prints the remainder part
					syscall
					
					addi $t1, $t1, 1
					j secondLoop
			
		
		firstLoopExit:
			lw $ra, 0($sp)	#loads the return value
			addi $sp, $sp, 4
			jr $ra	#returns
		
		secondLoopExit:
			addi $t0, $t0,1	#increment $t0
			j fLoop
		secondLoopExit1:
			addi $t1, $t1, 1	#increment $t1
			j secondLoop	
	
#LENGTH FUNCTION	
length:
	li $t0, 0	#makes sure it is 0
	li $t1, 0	#makes sure it is 0
	loop:
		add $t1, $a0, $t0	#$a0 is our string $t1 contains the address of the character at nth element of a0
		lb $t2, 0($t1)		#$t2 contains the character at the addres of $t1
		beq $t2, $zero, exitLoop	#if end of the string than exit
		addi $t0, $t0, 1		#increment $t0
		j loop		
	exitLoop:
		subi	$t0, $t0, 1	#increment $t0
		add	$v0, $zero, $t0	#$v0 conta?ns the length of the array so we are adding $t0 to $v0
		jr	$ra	#returns
		
		

	#data segment
	.data
hello: .asciiz "Welcome to our MIPS project!\n"
Menu: .asciiz "\nMain Menu:\n1. Count Alphabetic Characters\n2. Sort Numbers\n3. Prime (N)\n4. Huffman Coding\n5. Exit\nPlease select an option:"
goodbye: .asciiz "Program ends. Bye :)"
userInput: .space 50 
Input: .asciiz "Input:"
Output: .asciiz "Output:"
spc: .asciiz " "
message: .asciiz "Please enter an integer number for prime(N):"
inputMessage: .asciiz "prime("
pr: .asciiz ") is "
huffmanMes: .asciiz "Please enter the string to construct Huffman Code:\n"
huffmanMes2: .asciiz "Please enter the string to be converted using Huffman Code:\n"
huffmanInput: .space 50
huffmanInput2: .space 6
letters: .space 6 
charOc: .asciiz "Character	Occurence\n"
tab: .asciiz       "		"
command: .asciiz "Enter the String:\n"
line: .asciiz "\n"
input: .space 100
.align 2
numbersArray: .space 200	#we assumed there could be at most 50 numbers so 50*4=200
primesArray: .space 800 	#we assumed there could be at most 50 numbers so 200*4=800
lettersOccurrence: .space 24 
lettersHuffmanCode: .space 24
array: .space 104
