.data
dias:	.byte	0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
temp:	.word 	0
pri_dir:.word 	0
seg_dir:.word	0
mem_todo:.word 0
entrada1: .byte 0
entrada2: .byte 0

str1:	.asciiz "Introduce la primera fecha (dd/mm/aaaa): "
str2:	.asciiz "Introduce la segunda fecha (dd/mm/aaaa): "
	.globl __start
	.text
__start:
	#la $a0, str1
	#li $v0,4
	#syscall
	#li $v0, 8
	#la $a0, entrada1
	#syscall
	
	#la $a0, str2
#	li $v0,4
#	syscall
#	li $v0, 8
#	la $a0, entrada2
#	syscall
	
#	jal tomar_entrada
	







	add $s0,$zero, 12	# Primera fecha
	add $s1,$zero,10
	add $s2,$zero,1600
	

	add $s3,$zero, 13	# Segunda fecha
	add $s4,$zero, 10
	add $s5,$zero,2001
	
	
	
	sub $t0, $s5, $s2	# t0 = 2a�o - 1a�o
	beq $t0, 0, correcto1	# correcto1 si esta en el mismo a�o
	
	slti $t1, $t0, 0	# t1=0 2a�o>1a�o	t1=1a�o>2a�o
	bne $t1, 1, guardar_	# Salta a guardar si el 2a�o > 1a�o
	jal cambio		# Si 2a�o < 1a�o (hacia atras en el tiempo) invierte sus valores
	
guardar_:
	jal guardar 		# Guarda en memoria 'pri_dir' la pri_dir fecha y en 'seg_dir' la segunda fecha

primero:add $s3, $zero, 31	# s3/s5 carga 31dic del a�o la fecha menor
	add $s4, $zero, 12
	add $s5, $zero, $s2
	add $t3,$zero,0		# Establece $t3=0
	#la $a1, mem_todo 
	#sw $s2,0($a1)
	add $a2, $zero,$s2
	
	j correcto		# salta a correcto, que ira con jal a calculo
	
	
segundo:move $t4,$s7		#$t4= dias de $s7
	add $t4,$t4,1		#$t4= dias de $s7 + 1
	la $a0, seg_dir		# Carga los valores de la segunda fecha como fecha mayor
				# y en los de la fecha menor carga el 1 de enero de ese a�o
	lw $s3,0($a0)
	lw $s4,4($a0)
	lw $s5,8($a0)
	add $s0, $zero, 1
	add $s1, $zero, 1
	add $s2, $zero, $s5
	add $a3, $zero,$s2

correcto1:
	add $t3,$zero,2	# Si las fechas son del mismo a�o $t3 = 2
correcto:jal calculo	
	
	beq $t3,0,segundo	# $t3 = 0 Si son fechas de distinto a�o
	add $s7,$s7,$t4		# (dias de la fecha menor a diciembre) + (dias de enero a la fecha mayor)
	
intermedio:
	sub $t0,$a3,$a2
	beq $t0, 0, imprimir
	beq $t0, 1, imprimir
	sub $t0,$t0,1
	add $t3, $zero, 0
	move $s2, $a2
bucle_imprimir:
	add $s2,$s2,1
	add $t3,$t3,1
	jal bisiestoTF
	bne $t3,$t0,bucle_imprimir
	

	
imprimir:move $a0, $s7
	li $v0,1		# Imprime los dias (faltan los a�os intermedios)
	syscall
	
	li $v0,10
	syscall
	


	
#------------------------------------------------------------
calculo:addi $sp,$sp,-4		# 1er bucle: Guarda la posicion de memoria para luego poder volver a correcto
	sw $ra,0($sp)	
	sub $t1, $s1, $s4	# 1er bucle: $t1 = diferencia del mes a diciembre
	slt $t2, $s1, $s4	# 1er bucle: $t2 = 1 si la fecha no es diciembre
	beq $t1,0, comprueba_dia# 1er bucle: Si es diciembre, se compueba el d�a
	beq $t2,0,cambia_todo	# 1er bucle: Si es diciembre, cambia_todo (AQUI NO LLEGA)
	
comprueba_dia:			
	slt $t1, $s0, $s3	# 1er bucle: $t1 = 1 si el dia es menor que 31
	beq $t1, 1, inicio	# 1er bucle: Si es menor que 31, va a inicio
	move $t1, $s0		# 1er bucle: Si es 31, se cambian de posicion.
	move $s0, $s3		# $s0 = 31	$s3 = dia de la fecha
	move $s3, $t1
	j inicio		# Se salta a inicio

cambia_todo:
	la $a0, temp
	sw $s0,0($a0)
	sw $s1,4($a0)
	move $s0,$s3
	move $s1, $s4
	lw $s3,0($a0)
	lw $s4,4($a0)
	
inicio:	la $a0,dias		# $a0 = vector de los dias del mes
	add $a0,$a0,$s1		# $a0 = direccion del mes
	add $s7,$zero,0		# inicializa $s7 = 0
	move $s6,$s1		# $s6 = mes de la fecha
	add $s6, $s6,-1		# $s6 = mes de la fecha - 1
	
bucle:	lb $t0,0($a0)		# Bucle que suma en $s7 los d�as de los meses que van
				# desde [fecha, diciembre)
	add $s7,$s7,$t0
	add $a0,$a0,1
	add $s6,$s6,1
	bne $s6,$s4,bucle
	
	sub $s7,$s7,$s0		# Le resta a $s7 31 dias
	la $a0, dias
	add $a0, $a0, $s4	# $a0 = direccion de dias del mes de la fecha
	lb $t0, 0($a0)		# $t0 = dias del mes de la fecha
	sub $t0, $t0,$s3	# $t0 = dias totales del mes de la fecha - dia de la fecha
	sub $s7, $s7, $t0	# $s7 = dias de la fecha + [mes siguiente fecha, Noviembre] - 31
	
salir:	jal bisiesto
	lw $ra,0($sp)
	add $sp,$sp,4
	jr $ra
#---------------------------------------------
bisiesto:div $t7,$s2,4		# $t7 = a�opeque�o / 4
	mfhi $t5		# $t5 = a�opeque�o % 4
	div $t7,$s2,100		# $t7 = a�opeque�o / 10
	mfhi $t6		# $t6 = a�opeque�o % 10
	beq $t5,0,puede		# $t5 = 0: Puede ser bisiesto
	j segunda		
puede:	bne $t6,0,si
segunda:div $t7,$s2, 400	
	mfhi $t5
	bne $t5, 0, no		# Si es divisible entre 400, es bisiesto
	
	
	#######################################################
	# Esto funciona: bisiesto la fecha menor pero ya ha pasado el 29F
	# Esto Falla(da un d�a de mas): bisiesto la fecha MAYOR, pero aun no ha llegado el 29F
	slti $t9, $s1, 3	# $t9 = 1 si  no ha llegado a marzo = feb tiene un dia mas
	beq $t9, 0, no
	#######################################################
si:	add $s7, $s7,1		# Si es divisible entre 400, se le suma un dia
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
guardar:la $a0, pri_dir
	sw $s0,0($a0)
	sw $s1,4($a0)
	sw $s2,8($a0)
	la $a0, seg_dir
	sw $s3,0($a0)
	sw $s4,4($a0)
	sw $s5,8($a0)
	jr $ra
#---------------------------------------------
guardar_anio:
	la $a0, mem_todo
	sw $s2,0($a0)
	sw $s5,4($a0)
	jr $ra
#---------------------------------------------
bisiestoTF:div $t7,$s2,4		# $t7 = a�opeque�o / 4
	mfhi $t5		# $t5 = a�opeque�o % 4
	div $t7,$s2,100		# $t7 = a�opeque�o / 10
	mfhi $t6		# $t6 = a�opeque�o % 10
	beq $t5,0,puedeTF	# $t5 = 0: Puede ser bisiesto
	j segundaTF		
puedeTF:bne $t6,0,siTF
segundaTF:div $t7,$s2, 400	
	mfhi $t5
	bne $t5, 0, noTF		# Si es divisible entre 400, no es bisiesto
	
	
	#######################################################
	# Esto funciona: bisiesto la fecha menor pero ya ha pasado el 29F
	# Esto Falla(da un d�a de mas): bisiesto la fecha MAYOR, pero aun no ha llegado el 29F
	#slti $t9, $s1, 3	# $t9 = 1 si  no ha llegado a marzo = feb tiene un dia mas
	#beq $t9, 0, noTF
	#######################################################
siTF:	add $s7, $s7,366		# Si es divisible entre 400, se le suma un dia
	jr $ra
noTF:	add $s7,$s7,365
	jr $ra
#----------------------------------------------
#tomar_entrada:
#	la $a0, entrada1
#	add $t7, $zero, 0
#	add $t1, $t1, 0
#	la $a1, temp
#guardar_entrada:
#	sw $t7,0($a1)
#	add $a1,$a1,1
#	add $t7,$zero,0
#bucle_entrada:
#	lb $t0,0($a0)
#	add $a0,$a0,1
#	beq $t0,47, guardar_entrada
#	beq $t0, 10, salir_entrada
#	mul $t7,$t7,10
#	add $t7,$t7,$t0
#	j no
	

	
	 
