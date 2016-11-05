.data
dias:	.byte	0,31,28,31,30,31,30,31,31,30,31,30,31
temp:	.word 	0
primera:.word 	0
seg_dir:.word	0
	.globl __start
	.text
__start:
	add $s0,$zero, 3	# Primera fecha
	add $s1,$zero,3
	add $s2,$zero, 2000	

	add $s3,$zero, 4	# Segunda fecha
	add $s4,$zero, 2
	add $s5,$zero, 2001
	
	sub $t0, $s5, $s2	# t0 = 2año - 1año
	beq $t0, 0, correcto1	# correcto1 si esta en el mismo año
	slti $t1, $t0, 0	# t1=0 2año>1año	t1=1año>2año
	bne $t1, 1, guardar_	# Salta a guardar si el 2año > 1año
	jal cambio		# Si 2año < 1año (hacia atras en el tiempo) invierte sus valores
	
guardar_:jal guardar 		# Guarda en memoria 'primera' la primera fecha y en 'seg_dir' la segunda fecha

primero:add $s3, $zero, 31	# s3/s5 carga 31dic del año la fecha menor
	add $s4, $zero, 12
	add $s5, $zero, $s2
	add $t3,$zero,0		# Establece $t3=0
	j correcto		# salta a correcto, que ira con jal a calculo
	
segundo:move $t4,$s7		#$t4= dias de $s7
	add $t4,$t4,1		#$t4= dias de $s7 + 1
	la $a0, seg_dir		# Carga los valores de la segunda fecha como fecha mayor
				# y en los de la fecha menor carga el 1 de enero de ese año
	lw $s3,0($a0)
	lw $s4,4($a0)
	lw $s5,8($a0)
	add $s0, $zero, 1
	add $s1, $zero, 1
	add $s2, $zero, $s5


correcto1:add $t3,$zero,2	# Si las fechas son del mismo año $t3 = 2
correcto:jal calculo	
	
	beq $t3,0,segundo	# $t3 = 0 Si son fechas de distinto año
	add $s7,$s7,$t4		# (dias de la fecha menor a diciembre) + (dias de enero a la fecha mayor)
	move $a0, $s7
	li $v0,1		# Imprime los dias (faltan los años intermedios)
	syscall
	
	li $v0,10
	syscall
	


	
#------------------------------------------------------------
calculo:addi $sp,$sp,-4		# 1er bucle: Guarda la posicion de memoria para luego poder volver a correcto
	sw $ra,0($sp)	
	sub $t1, $s1, $s4	# 1er bucle: $t1 = diferencia del mes a diciembre
	slt $t2, $s1, $s4	# 1er bucle: $t2 = 1 si la fecha no es diciembre
	beq $t1,0, comprueba_dia# 1er bucle: Si es diciembre, se compueba el día
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
	
bucle:	lb $t0,0($a0)		# Bucle que suma en $s7 los días de los meses que van
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
bisiesto:div $t7,$s2,4		# $t7 = añopequeño / 4
	mfhi $t5		# $t5 = añopequeño % 4
	div $t7,$s2,10		# $t7 = añopequeño / 10
	mfhi $t6		# $t6 = añopequeño % 10
	beq $t5,0,puede		# $t5 = 0: Puede ser bisiesto
	j segunda		
puede:	bne $t6,0,si
segunda:div $t7,$s2, 400	
	mfhi $t5
	bne $t5, 0, no		# Si es divisible entre 400, no es bisiesto
	
	
	#######################################################
	# Esto funciona: bisiesto la fecha menor pero ya ha pasado el 29F
	# Esto Falla(da un día de mas): bisiesto la fecha MAYOR, pero aun no ha llegado el 29F
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
guardar:la $a0, primera
	sw $s0,0($a0)
	sw $s1,4($a0)
	sw $s2,8($a0)
	la $a0, seg_dir
	sw $s3,0($a0)
	sw $s4,4($a0)
	sw $s5,8($a0)
	jr $ra
