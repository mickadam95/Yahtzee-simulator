#Yahtzee simulator by Adam Mick

.data

dice: .byte 0, 0, 0, 0, 0  #An array of bytes to store dice 0-4. All initlized to 0.

newline: .byte 0xA

introText: .asciiz "Welcome to Yahtzee Simulator! You have three rolls to get Yahtzee, good luck!"

rollText: .asciiz "You rolled a: "

prompt: .asciiz "How many dice would you like to roll? (1 - 5 from left to right) "

diceDisplayText: .asciiz "The dice values are: "

errorMSG: .asciiz "Error, looks like there was a problem, Please try again "

victoryText: .asciiz "YAHTZZE! YOU WIN!"

lossText: .asciiz "No yahtzze, sorry you lose"

.text
main:
	########################TURN ONE###############################
	
	li $v0, 4
	la $a0, introText #Displays game intro
	syscall
	
	li $v0, 11
	lb $a0, newline #feeds a new line
	syscall
	
	
	jal rollDice #jump to the dice rolling procedure.
	
	jal sort_Dice #sorts the array putting the largest numbers to the right
	
	jal print_dice #jump to the dice printing procedure
	
	jal sortPairs #sorts the pairs to the right of the array
	
	li $v0, 11
	lb $a0, newline #feeds a new line
	syscall
	
	jal print_dice
	
	jal yahtzze
	
	#################TURN TWO###########################
	
	li $v0, 11
	lb $a0, newline #feeds a new line
	syscall
	
	jal rollDice #jump to the dice rolling procedure.
	
	jal sort_Dice #sorts the array putting the largest numbers to the right
	
	jal print_dice #jump to the dice printing procedure
	
	jal sortPairs #sorts the pairs to the right of the array
	
	li $v0, 11
	lb $a0, newline #feeds a new line
	syscall
	
	jal print_dice
	
	jal yahtzze
	
	#####################TURN THREE##############################
	
	li $v0, 11
	lb $a0, newline #feeds a new line
	syscall
	
	
	jal rollDice #jump to the dice rolling procedure.
	
	jal sort_Dice #sorts the array putting the largest numbers to the right
	
	jal print_dice #jump to the dice printing procedure
	
	jal sortPairs #sorts the pairs to the right of the array
	
	li $v0, 11
	lb $a0, newline #feeds a new line
	syscall
	
	jal print_dice
	
	jal yahtzze
	
	######################LOSS###################################
	
	li $v0, 11
	lb $a0, newline #feeds a new line
	syscall
	
	li $v0, 4
	la $a0, lossText #displays loss text
	syscall
	
	li $v0, 10 #exit the program
	syscall
	
#The sortPairs procedure will find pairs in the sorted array of dice and then place them in the rightmost position in the array, allowing the user to roll without overwriting them.
#it does this by pushing the dice pairs onto the stack, moving every element in the array to the memory location left of it, then placing the data saved in the stack into the right most elements in that array. 
sortPairs:

	la $t6, dice
	
	lb $t0, 0($t6)
	lb $t1, 1($t6)
	lb $t2, 2($t6)		#Load the dice values from memory into registers $t0 - $t4
	lb $t3, 3($t6)
	lb $t4, 4($t6)
	
	subi $sp, $sp, 5 #subtract 5 bytes from the stack so there is space for every dice value to be stored
	
	sb $t0, 0($sp)
	sb $t1, 1($sp)
	sb $t2, 2($sp) #store all of the current dice values onto the stack
	sb $t3, 3($sp)
	sb $t4, 4($sp)
	
	
	
CHECK1:	beq $t0, $t1, P1 #branch to P1 (pair 1) if t0 and t1 are equal
CHECK2:	beq $t1, $t2, P2 #branch to P2 (pair 2) if t1 and t2 are equal
CHECK3:	beq $t2, $t3, P3 #branch to P3 (pair 3) if t2 and t3 are equal
CHECK4:	beq $t3, $t4, P4 #branch to P4 (pair 4) if t3 and t4 are equal

	addi $sp, $sp, 5 #give memory back to the stack
	
	jr $ra	#No pairs were found


#flgChk checks witch flags get set after the CHECK# procedures are called and tells it witch sortpair procedure to call for proper sorting
flgChk:
	beq $s1, 1, SORTPAIR1 #if theres a pair in P1 go to SORTPAIR1
	beq $s2, 1, SORTPAIR2 #if theres a pair in P2 go to SORTPAIR2
	beq $s3, 1, SORTPAIR3 #if theres a pair in P3 go to SORTPAIR3
	beq $s4, 1, SORTPAIR4 #if there is a pair in P4 go to SORTPAIR4

###########################The sortpair procedures are all the commands to shuffle the data around in the registers depending on witch flags are set in the P# procedure and the flgChk procedure####################	
SORTPAIR1: 
	beq $s3, 1, SORTPAIR13 #if there is a pair on 3 AND a pair on 1 then go to SORTPAIR13
	beq $s4, 1, SORTPAIR14 #if theres a pair on 1 AND a pair on 4 go to SORTPAIR14
	
	add $t0, $t3, $zero #move t3 into t0
	add $t1, $t4, $zero #move t4 into t1
	
	lb $t3, 0($sp) #load the pair into t3 and t4 from the stack
	lb $t4, 1($sp)
	
	sb $t0, 0($t6)
	sb $t1, 1($t6)
	sb $t2, 2($t6)	#store the new dice values back into the array
	sb $t3, 3($t6)
	sb $t4, 4($t6)
	
	addi $sp, $sp, 5 #give memory back to the stack
	
	jr $ra #return to main, pair sorting done
	
	
SORTPAIR14:
	add $t0, $t2, $zero #move t2 into t0
	
	lb $t2, 0($sp) #load the pair into t2 from the stack
	
	sb $t0, 0($t6)
	sb $t1, 1($t6)
	sb $t2, 2($t6)	#store the new dice values back into the array
	sb $t3, 3($t6)
	sb $t4, 4($t6)
	
	addi $sp, $sp, 5 #give memory back to the stack
	
	jr $ra #return to main, pair sorting done
	

SORTPAIR2: beq $s4, 1, SORTPAIR24 #if there is a pair on 2 AND theres a pair on 4 then go to SORTPAIR24
	
	
	add $t2, $t4, $zero #move t4 into t2
	add $t1, $t3, $zero #move t3 into t1
	
	lb $t4, 2($sp) #load t2 into t4
	lb $t3, 1($sp) #load t1 into t3
	
	sb $t0, 0($t6)
	sb $t1, 1($t6)
	sb $t2, 2($t6)	#store the new dice values back into the array
	sb $t3, 3($t6)
	sb $t4, 4($t6)
	
	addi $sp, $sp, 5 #give memory back to the stack
	
	jr $ra #return to main program sorting done

SORTPAIR13:
	beq $s4, 1, SORTPAIR134

	add $t0, $t4 $zero #move t4 (the only non-pair) into t0
	
	add $t4, $t1, $zero #move t1 into t4
	add $t1, $t2, $zero #move t2 into t1
	add $t2, $t3, $zero #move t3 into t2
	lb $t3, 0($sp) #move t0 into t3
	
	
	sb $t0, 0($t6)
	sb $t1, 1($t6)
	sb $t2, 2($t6)	#store the new dice values back into the array
	sb $t3, 3($t6)
	sb $t4, 4($t6)	
	
	addi $sp, $sp, 5 #give memory back to the stack
	
	jr $ra #jump back into the main program, sorting and storing is done.
	
SORTPAIR134:
	
	#if theres ever a pair in P1, P3, and P4 We do not need to change anything because the pairs are already sorted.
	
	addi $sp, $sp, 5 #give memory back to the stack
	
	jr $ra
	
SORTPAIR3:
	add $t2, $t4, $zero #move t4 into t2
	lb $t4, 2($sp) #move t2 into t4
	
	sb $t0, 0($t6)
	sb $t1, 1($t6)
	sb $t2, 2($t6)	#store the new dice values back into the array
	sb $t3, 3($t6)
	sb $t4, 4($t6)	
	
	addi $sp, $sp, 5 #give memory back to the stack
	
	jr $ra #jump back into the main program, sorting and storing is done.
	
	
	

SORTPAIR4:
	addi $sp, $sp, 5 #give memory back to the stack
	jr $ra #jump back to main, the pairs are already sorted
		
SORTPAIR24:	addi $sp, $sp, 5 #give memory back to the stack
	
	jr $ra #jump back into main, these pairs are already in place
	

######################The P functions set flags depending on where the game finds different pairs of numbers. Ex. (11)234 the numbers 11 would set the flag in P1##############################
P1: 	seq $s1, $t0, $t1 #flag s1 to show that the first pair was found
	beq $t2, $t3, P3 #branch to P3 (pair 3) if t2 and t3 are equal. We do not need to check t1 t2 because t1 is already being used in the first pair
	beq $t3, $t4, P4 #branch to P4 (pair 4) if t3 and t4 are equal
	
	j flgChk
	
P2:	seq $s2, $t1, $t2 #flag t7 to show the first pair was found
	beq $t3, $t4, P4 #branch to P4 (pair 4) if t3 and t4 are equal
	
	j flgChk
	
P3:	seq $s3, $t2, $t3 #flag s3 to show the second pair was found
	beq $t3, $t4, P4 #branch to P4 (pair 4) if t3 and t4 are equal
	
	j flgChk
	
P4:	seq $s4, $t3, $t4 #flag s4 to show the pair on P4 was found

	j flgChk #all pairs are found and stored, jump to a label to put them back

#the start of the rolling operation, always jump-and-link to this label.
#This will simulate a dice roll and place the value into memory under the byte array labeled "dice"
#the program will loop for the disired amount of user inputed rolls, up to 5.
rollDice:

	li $v0, 4
	la $a0, prompt #Load the message prompting the user to input the dice	
	syscall		#call to display text
	
	li $v0, 5	#system call code for reading an integer
	syscall
	
	sgt $t1, $v0, 5 #sets $t1 if $v0 is greater than 5
	beq $t1, 1, ERROR #Branch to error because user inputed more than 5 
	
	beqz $v0, ERROR #Display error if user selects to roll 0 dice
	
	add $t2, $v0, $zero #Moves the amount of dices rolled into $t2 from $v0
	
	li $v0, 11 	#systemcall for a character
	lb $a0, newline #feeds into a newline of text
	syscall
	
rolling: #a label for a loop where the "rolling" gets simulated
	
	beqz $t2, return
	li $a1, 6 #assign a1 to 6, the upperbound for a dice. (0 <= int < 6)
	li $v0, 42 #The system call value for a random number range
	syscall
	
	addi $v1, $a0, 1 #store reslut of roll (add one to all results to avoid a roll of 0)
		
	la $t3, dice #the address of the dice array into $t3
	
	subi $t4, $t2, 1 #Turn $t4 into the address of the dice offset
	
	add $t5, $t3, $t4 #$t5 is the storage address of dice + $t2 offset 
	
	sb $v1, ($t5) #store diceroll at (dice) + offset
	
	subi $t2, $t2, 1 
	
	 j rolling 
	 
return:#a return label to break back to the program
	jr $ra



#a subroutine to sort the dice array
sort_Dice:

	la $t6, dice
	
	lb $t0, 0($t6)
	lb $t1, 1($t6)
	lb $t2, 2($t6)		#Load the dice values from memory into registers $t0 - $t4
	lb $t3, 3($t6)
	lb $t4, 4($t6)
	

checks:
#runs a comparison of all the values thus sorting the array

	sgt $t7, $t0, $t1
	beq $t7, 1, swapt0t1
	
	sgt $t7, $t0, $t2
	beq $t7, 1, swapt0t2
	
	sgt $t7, $t0, $t3
	beq $t7, 1, swapt0t3
	
	sgt $t7, $t0, $t4
	beq $t7, 1, swapt0t4
	
	sgt $t7, $t1, $t2
	beq $t7, 1, swapt1t2
	
	sgt $t7, $t1, $t3
	beq $t7, 1, swapt1t3
	
	sgt $t7, $t1, $t4
	beq $t7, 1, swapt1t4
	
	sgt $t7, $t2, $t3
	beq $t7, 1, swapt2t3
	
	sgt $t7, $t2, $t4
	beq $t7, 1, swapt2t4
	
	sgt $t7, $t3, $t4
	beq $t7, 1, swapt3t4
	
	sb $t0, 0($t6)
	sb $t1, 1($t6)
	sb $t2, 2($t6)		#store the sorted dice values into the dice array
	sb $t3, 3($t6)
	sb $t4, 4($t6)
	
	
	jr $ra #return to main
	
	
	
swapt0t1: #swaps t0 & t1
	add $t8, $t0, $zero
	add $t0, $t1, $zero
	add $t1, $t8, $zero
	j checks
	
swapt0t2: #swaps t0 & t2
	add $t8, $t0, $zero
	add $t0, $t2, $zero
	add $t2, $t8, $zero
	j checks

swapt0t3: #swaps t0 & t3
	add $t8, $t0, $zero
	add $t0, $t3, $zero
	add $t3, $t8, $zero
	j checks
	
swapt0t4: #swaps t0 & t4
	add $t8, $t0, $zero
	add $t0, $t4, $zero
	add $t4, $t8, $zero
	j checks
	
swapt1t2: #swaps t1 & t2
	add $t8, $t1, $zero
	add $t1, $t2, $zero
	add $t2, $t8, $zero
	j checks
	
swapt1t3: #swaps t1 & t3
	add $t8, $t1, $zero
	add $t1, $t3, $zero
	add $t3, $t8, $zero
	j checks
	
swapt1t4: #swaps t1 & t4
	add $t8, $t1, $zero
	add $t1, $t4, $zero
	add $t4, $t8, $zero
	j checks
	
swapt2t3: #swaps t2 & t3
	add $t8, $t2, $zero
	add $t2, $t3, $zero
	add $t3, $t8, $zero
	j checks
	
swapt2t4: #swaps t2 & t4
	add $t8, $t2, $zero
	add $t2, $t4, $zero
	add $t4, $t8, $zero
	j checks
	
swapt3t4: #swaps t3 & t4
	add $t8, $t3, $zero
	add $t3, $t4, $zero
	add $t4, $t8, $zero
	j checks

#Displays the dice values when called
print_dice:
	
	la $t6, dice
	
	lb $t0, ($t6)
	lb $t1, 1($t6)
	lb $t2, 2($t6)		#Load the dice values from memory into registers $t0 - $t4
	lb $t3, 3($t6)
	lb $t4, 4($t6)
	
	li $v0, 4
	la $a0, diceDisplayText #sets the systemcall to display a string and show the dice text
	syscall
	
	add $a0, $t0, $zero #sets a0 to the current dice then displays it also sets systemcall to display an integer
	li $v0, 1
	syscall
	
	add $a0, $t1, $zero
	syscall
	
	add $a0, $t2, $zero
	syscall
	
	add $a0, $t3, $zero
	syscall
	
	add $a0, $t4, $zero
	syscall
	
	
	jr $ra
	
	
yahtzze:
	la $t6, dice
	
	lb $t0, ($t6)
	lb $t1, 1($t6)
	lb $t2, 2($t6)		#Load the dice values from memory into registers $t0 - $t4
	lb $t3, 3($t6)
	lb $t4, 4($t6)
		
	seq $t5, $t0, $t1	
		
	bnez $t5, pass1
	
	jr $ra
	
pass1:
	seq $t6, $t1, $t2
	bnez $t6, pass2
	jr $ra
pass2:
	seq $t7, $t2, $t3
	bnez $t7, pass3
	jr $ra
pass3:
	seq $t8, $t3, $t4
	bnez $t8, win
	jr $ra
win: 
	li $v0, 11
	lb $a0, newline #feeds a new line
	syscall
	
	li $v0, 4
	la $a0, victoryText #display the victory text
	syscall
	
	li $v0, 10 #stop the program
	syscall
	
	
ERROR:
	
	li $v0, 11 #systemcall for character
	lb $a0, newline #diplsays a newline
	syscall
	
	li $v0, 4 	#system call to display a string of text
	la $a0, errorMSG #addreess of error message
	syscall
	
	li $v0, 10 	#system call for program end
	syscall
