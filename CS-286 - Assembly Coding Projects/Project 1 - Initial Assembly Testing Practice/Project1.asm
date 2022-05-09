#Kolton Klette
#Dennis Bouvier
#CS-286
#January 21st, 2020
#Project #1 - Hello CS-286

	.data
	
startMessage: .asciiz "Enter your name \n"
handlerMessage: .asciiz "Hello, "
welcomeMessage: .asciiz "Welcome to The Flat Zone!"
newLine: .asciiz "\n" #called on in order to more efficiently format print statements
inputHandle: .space 40

	.text

main:
	#Starting Message Chunk
	li $v0, 4
	la $a0, startMessage
	syscall
	
	#Input Handling Chunk
	li $v0, 8 
	la $a0, inputHandle
	li $a1, 40
	syscall
	
	#Greeting W/ Input Chunk
	li $v0, 4
	la $a0, handlerMessage
	syscall
	la $a0, inputHandle
	syscall
	
	#Welcome Message Handling Chunk
	li $v0, 4
	la $a0, welcomeMessage
	syscall
	
	#Exit Program Chunk
	li $v0, 10
	syscall
	
	
	
	
	
	
	#Program Exit Upon Completion
	li $v0, 10
	syscall
	





















