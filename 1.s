.data
dias:	.byte	0,31,28,31,30,31,30,31,31,30,31,30,31
temp:	.word 	0
	.globl __start
	.text
__start:
	add $s0,$zero, 17
	add $s1,$zero, 8
	add $s2,$zero, 2015

	add $s3,$zero, 2
	add $s4,$zero, 4
	add $s5,$zero, 2015
	
	jal calculo	
	
	move $a0, $s7
	li $v0,1
	syscall
	
	li $v0,10
	syscall
	


	
#------------------------------------------------------------
calculo:sub $t1, $s1, $s4
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
	
salir:	jr $ra
#---------------------------------------------
bisiesto:la $a0, dias
	add $t7,$t7,29
	sb $t7,2($a0)
	jr $ra
#---------------------------------------------
	
