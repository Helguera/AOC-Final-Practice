.data
dias:	.byte	0,31,28,31,30,31,30,31,31,30,31,30,31
temp:	.word 	0
primera:.word 	0
seg_dir:.word	0
	.globl __start
	.text
__start:
	add $s0,$zero, 2
	add $s1,$zero, 2
	add $s2,$zero, 2000

	add $s3,$zero, 5
	add $s4,$zero, 2
	add $s5,$zero, 2001
	
	sub $t0, $s5, $s2
	beq $t0, 0, correcto1
	slti $t1, $t0, 0
	bne $t1, 1, guardar_
	jal cambio
guardar_:jal guardar 
primero:add $s3, $zero, 31
	add $s4, $zero, 12
	add $s5, $zero, $s2
	add $t3,$zero,0
	j correcto
	
segundo:move $t4,$s7
	add $t4,$t4,1
	la $a0, seg_dir
	lw $s3,0($a0)
	lw $s4,4($a0)
	lw $s5,8($a0)
	add $s0, $zero, 1
	add $s1, $zero, 1
	add $s2, $zero, $s5


correcto1:add $t3,$zero,2
correcto:jal calculo	
	
	beq $t3,0,segundo
	add $s7,$s7,$t4
	move $a0, $s7
	li $v0,1
	syscall
	
	li $v0,10
	syscall
	


	
#------------------------------------------------------------
calculo:addi $sp,$sp,-4
	sw $ra,0($sp)	
	sub $t1, $s1, $s4
	slt $t2, $s1, $s4
	beq $t1,0, comprueba_dia
	beq $t2,0,cambia_todo
	
comprueba_dia:
	slt $t1, $s0, $s3
	beq $t1, 1, inicio
	move $t1, $s0
	move $s0, $s3
	move $s3, $t1
	j inicio

cambia_todo:
	la $a0, temp
	sw $s0,0($a0)
	sw $s1,4($a0)
	move $s0,$s3
	move $s1, $s4
	lw $s3,0($a0)
	lw $s4,4($a0)
	
inicio:	la $a0,dias
	add $a0,$a0,$s1
	add $s7,$zero,0
	move $s6,$s1
	add $s6, $s6,-1
	
bucle:	lb $t0,0($a0)
	add $s7,$s7,$t0
	add $a0,$a0,1
	add $s6,$s6,1
	bne $s6,$s4,bucle
	
	sub $s7,$s7,$s0
	la $a0, dias
	add $a0, $a0, $s4
	lb $t0, 0($a0)
	sub $t0, $t0,$s3
	sub $s7, $s7, $t0
	
salir:	jal bisiesto
	lw $ra,0($sp)
	add $sp,$sp,4
	jr $ra
#---------------------------------------------
bisiesto:div $t7,$s2,4
	mfhi $t5
	div $t7,$s2,10
	mfhi $t6
	beq $t5,0,puede
	j segunda
puede:	bne $t6,0,si
segunda:div $t7,$s2, 400
	mfhi $t5
	bne $t5, 0, no
	
si:	add $s7, $s7,1
no:	jr $ra
#---------------------------------------------
cambio:	la $a0, temp
	sw $s0,0($a0)
	sw $s1,4($a0)
	sw $s2,8($a0)
	move $s0,$s3
	move $s1, $s4
	move $s2, $s5
	lw $s3,0($a0)
	lw $s4,4($a0)
	lw $s5,8($a0)
	jr $ra
#---------------------------------------------
guardar:la $a0, primera
	sw $s0,0($a0)
	sw $s1,4($a0)
	sw $s2,8($a0)
	la $a0, seg_dir
	sw $s3,0($a0)
	sw $s4,4($a0)
	sw $s5,8($a0)
	jr $ra