#Kolton Klette, Thomas Siganga, Geopat Appiah-Sokye, Jacob Skeleton
#Dennis Bouvier
#CS-286
#April 15th, 2020

.data
output:	    .space 10000	
size:       .word 8 8	            # image width(row length) and image height (num rows)

space:   .asciiz " "

newLine: .asciiz "\n"

image:	.word 0xffffff00 0x00ffffff # row 0 : 3 white, 2 black, 3 white
        .word 0xffff00ff 0xff00ffff # row 1 : 2 white, 1 black, 2 white, 1 black, 2 w
        .word 0xff00ff00 0x00ff00ff # row 2 : 1 w, 1 b, 1 w, 2 b, 1 w, 1 b, 1 w 
        .word 0x00ffffff 0xffffff00 # row 3 : 1 black, 6 white, 1 black
        .word 0x00ff00ff 0xff00ff00 # row 4 : 
        .word 0xff00ff00 0x00ff00ff
        .word 0xffff00ff 0xff00ffff
        .word 0xffffff00 0x00ffffff

########Additional Information########		
	
andControl: .word 0xff000000         # used for AND statements later in the program.
	    .word 0x00ff0000
	    .word 0x0000ff00
	    .word 0x000000ff
	    
########\Additional Information########
	    	  
.text
main:
    #Address Handling
    la $s0, output	   # saves address where compressed image will be sent to
    la $s1, size           # saves size address; references width/height of input
    la $s2, image 	   # saves image address; references input data
    li $s3, 0		   # saves the previous byte in a word detected by looping structure
    la $s6, andControl	   # saves address of "AND" values used to isolate bytes
    li $s7, 4              # initial number accounts for all non-compressed words in output
    
    
    #Temporary Register Instantiation
    
    li $t1, 0              # saves the value of outerIncrement
    li $t2, 0 		   # saves the value of innerIncrement
    li $t3, 0		   # saves the address of the first word of "image"
    li $t4, 0              # saves the edited word stored in $t3 after byte-isolation
    li $t5, 0		   # saves the second and fourth bytes ("color bytes") in a given word during byte-isolation
    li $t6, 0              # saves the count of compressed words derived from "image"
    li $t7, 0		   # saves individual statements from "andControl" to isolate bytes
    li $t8, 0              # saves the count of rows in "image" that have been processed
    la $t9, newLine		   
    
    
    
    #Preliminary Set-Up Before Loops Occur
    lw $s4, ($s1)       # lines 53 - 55: $s1 = [width / 4]
    lw $s5, 4($s1)      # loads height given by "size" in register $s2
    
    li $v0, 1
    move $a0, $s4
    syscall
    
    li $v0, 4
    move $a0, $t9
    syscall
    
    li $v0, 1
    move $a0, $s5
    syscall
    
    li $v0, 4
    move $a0, $t9
    syscall
    
    li $t0, 4
   
    
    div $s4, $t0        # completes division operation as described on line 53
    mflo $s4            # saves quotient to register for use in looping construction
   
    
    
    la $t0, space
    
    
   
    
##################outerLoop##############################
            

li $t1, 0               # resets value of outerIncrement
outerLoop: 
    li $t2, 0           # resets value of innerIncrement
    
##############innerLoop################
	
        innerLoop:

            lw $t3, ($s2)
   	    lw $t7, ($s6)              # saves first statement of andControl to isolate left-most byte
   	   
            and $t4, $t3, $t7          # AND shifted word + 0xff000000 in order to isolate byte
            srl $t4, $t4, 24
            move $s3, $t5	       # Move previous value into register to check isolated byte above with it
            jal ColorCheck
            
            lw $t7, 4($s6)
            and $t5, $t3, $t7
            srl $t5, $t5, 16
            
            move $s3, $t4
            jal ColorCheck	       # Alternates routines based on if $t4 or $t5 is being compared
            
            lw $t7, 8($s6)
            and $t4, $t3, $t7       
            srl $t4, $t4, 8
            move $s3, $t5
            jal ColorCheck
            
            lw $t7, 12($s6)
            and $t5, $t3, $t7
            move $s3, $t4
            
            jal ColorCheck
            addi $s2, $s2, 4           # shifts address of image to read next word in current row of image
            
           
        innerIncrement:    
            addi $t2, $t2, 1           # innerLoop increment
            bne $t2, $s4, innerLoop    # if innerLoop increment is not equal to [width/4], loop again
            
##############/innerLoop##################

outerIncrement:
    
    jal rowReset		       # moves last value of row into $t3 and puts it in a register
    addi $t1, $t1, 1 		       # outerLoop increment
    beq $t1, $s5, end		       # if outerLoop increment is equal to height of input, jump to end label
    
    # everything is reset when a row is done except for the increments for the loops
    li $t6, 0
    li $t4, 0
    li $t5, 0
    li $t8, 0
    li $s3, 0
    li $t6, 0
    
    j outerLoop          	       # else, loop again
    
##################/outerLoop##############################

########Hexadecimal "Construction" Handling########
rowReset:
    move $s3, $t5	       	# stores last color in the row, whether it is the first or second part
    j FirstHalf		       	# Check if the first part of the compression is done or not.

ColorCheck:
    beq $t8, 0, firstByte       # if detected to be the first byte from read input, jump to label "firstByte"
    beq $t4, $t5, Counter   
    j FirstHalf
    
firstByte:
    li $t6, 1			# if bne $t4 and 0, make $t6 equal 1 telling us the first color was read in
    addi $t8, $t8, 1		# tells us the next values are not the first byte in the row
    jr $ra

FirstHalf:
    
    
    li $v0, 1
    move $a0, $t6
    syscall
    
    li $v0, 4
    move $a0, $t0
    syscall
    
    li $v0, 1
    move $a0, $s3
    syscall
    
    
    li $v0, 4
    move $a0, $t9
    syscall
    
    # reset the count based on new color(The row reset makes it 0 somewhere else)
    li $t6, 1
    jr $ra
    

    
Counter:
    addi $t6, $t6, 1	# if previous == current, then add 1 to $t6
    jr $ra

########\Hexadecimal "Construction" Handling########

end:
    la $s0, output      # resets $s0 to its original spot
    
    
    
    #Exit Program Upon Completion
    li $v0, 10
    syscall
    
   
