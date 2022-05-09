#Kolton Klette, Thomas Singanga, Jacob, Geopat Appiah-Sokye
#Dennis Bouvier
#CS 286
#Februrary 19th, 2020

############
# 
# file: proj02.asm
# desc: this is example image data used in testing for the first
#       programming assignment in CS286.002 Spring 2020
# 
############

.data

size:	.word 8 8	# image width(row length) and image height (num rows)
image:	.word 0xffffff00 0x00ffffff # row 0 : 3 white, 2 black, 3 white
	.word 0xffff00ff 0xff00ffff # row 1 : 2 white, 1 black, 2 white, 1 black, 2 w
	.word 0xff00ff00 0x00ff00ff # row 2 : 1 w, 1 b, 1 w, 2 b, 1 w, 1 b, 1 w 
	.word 0x00ff0000 0x000000ff # row 3 : 1 black, 6 white, 1 black
	.word 0x00ff00ff 0xff00ff00 # row 4 : 
	.word 0xff00ff00 0x00ff00ff
	.word 0xffff00ff 0xff00ffff
	.word 0xffffff00 0x00ffffff
#Each ".word" expressions holds *two* values to be saved to registers; 16 ".word" expressions total

output:	.space 10000 

.text
main: 
    la $t0, size
    lw $s0, ($t0) # s0 = width / 4
    li $t1, 4
    div $s0, $t1
    mflo $s0
    lw $s1, 4($t0)# s1 = height
    la $s3, image    # s3 image address /move to main?
    
outerLoop: 
    la $s3, image    # s3 = image address / move to main?

    addi $s2, $s2, 1 # s2 = outerLoop increment / increments

    li $s4, 0         # resets nested loops increment
    
    lw $t0, ($s3)
    li $s4, 0
    li $s6, 0
    srl $s7, $t0, 24

    ##############innerLoop##################
        innerLoop:
            beq $s4, $s0, exit
            li $t9, 24                # sets shift amount
            addi $s4, $s4, 1         # s4 innerLoop increment
            srlv $t1, $t0, $t9        # t1 = current pixel
            addi $t9, $t9, -8        # updates shift amount
            
            loop:
                addi $s6, $s6, 1        # increments current count
                srlv $t1, $t0, $t9	
                addi $t9, $t9, -8
                beq $t9, $zero, innerLoop
                beq $t1, $s7, loop
                sb $s6, 3($s5)
                sb $s7, 2($s5)
                li $v0, 1
                move $a0, $s6
                syscall
                li $s6, 0
                move $s7, $t1

            loop2:
                addi $s6, $s6, 1        # increments current count
                srlv $t1, $t0, $t9
                addi $t9, $t9, -8
                beq $t9, $zero, innerLoop
                beq $t1, $s7, loop2
                sb $s6, 1($s5)
                sb $s7, ($s5)
                li $s6, 0
                move $s7, $t1
                addi $s5, $s5, 4
                
                
    ##############innerLoop##################
    exit:
    beq $s2, $s1, end # if s2 is equal to s1 jump to end label

    j outerLoop          # else loop again
##################outerLoop##############################