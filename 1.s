# Programa creado por Javier Helguera y Alvaro Velasco
# Calcula los dias pasados entre dos fechas
# Dice en forma de texto en que cayo el dia mayor escrito
# Imprime el calendario de ese mes3
.data
dias:	.byte	0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
semana:	.asciiz "Viernes    Sabado     Domingo    Lunes      Martes     Miercoles  Jueves     Enero      Febrero    Marzo      Abril      Mayo       Junio      Julio      Agosto     Septiembre Octubre    Noviembre  Diciembre  "
temp:	.word 	0
pri_dir:.word 	0
seg_dir:.word	0
mem_todo:.word 0
entrada1: .space 100
entrada2: .space 100
temp2:	.space 100
str1:	.asciiz "Introduce la primera fecha: "
str2:	.asciiz "Introduce la segunda fecha: "
str3:	.asciiz "Entre las dos fechas hay "
str4:	.asciiz " dias"
str5:	.asciiz "Ha introducido una fecha no valida"
str6: 	.asciiz " de "
str7:	.asciiz "El calendario del "
str8:	.asciiz ", que es la fecha mayor, es: "
	.globl __start
	.text
__start:
	add $t1,$zero,0
	add $a1,$zero,20
	la $a0, str1
	li $v0,4
	syscall
	li $v0, 8
	la $a0, entrada1
	syscall
	
	la $a0, str2
	li $v0,4
	syscall
	li $v0, 8
	la $a0, entrada2
	syscall
	
	jal tomar_entrada
	
	add $t1,$t1,1
	la $a0, temp2
	lw $s0,0($a0)
	lw $s1,4($a0)
	lw $s2,8($a0)
	
	
	jal tomar_entrada
	
	la $a0, temp2
	lw $s3,0($a0)
	lw $s4,4($a0)
	lw $s5,8($a0)
	
	jal comprobacion

comienzo:		
	sub $t0, $s5, $s2	# t0 = 2aï¿½o - 1aï¿½o
	beq $t0, 0, correcto1	# correcto1 si esta en el mismo aï¿½o
	
	slti $t1, $t0, 0	# t1=0 2aï¿½o>1aï¿½o	t1=1aï¿½o>2aï¿½o
	bne $t1, 1, guardar_	# Salta a guardar si el 2aï¿½o > 1aï¿½o
	jal cambio		# Si 2aï¿½o < 1aï¿½o (hacia atras en el tiempo) invierte sus valores
	
guardar_:
	jal guardar 		# Guarda en memoria 'pri_dir' la pri_dir fecha y en 'seg_dir' la segunda fecha

primero:add $s3, $zero, 31	# s3/s5 carga 31dic del aï¿½o la fecha menor
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
				# y en los de la fecha menor carga el 1 de enero de ese aï¿½o
	lw $s3,0($a0)
	lw $s4,4($a0)
	lw $s5,8($a0)
	add $s0, $zero, 1
	add $s1, $zero, 1
	add $s2, $zero, $s5
	add $a3, $zero,$s2

correcto1:
	add $t3,$zero,2	# Si las fechas son del mismo aï¿½o $t3 = 2
correcto:jal calculo	
	
	beq $t3,0,segundo	# $t3 = 0 Si son fechas de distinto aï¿½o
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
#--------------- Aqui acaba el primer ejercicio $s7=resultado ---------------------	

	




	
imprimir:
	beq $t8,1,ej2.1
	beq $t8,2,ej2.2
	add $t8, $zero,1
	la $a0, str3
	li $v0,4
	syscall
	move $a0, $s7
	li $v0,1		# Imprime los dias (faltan los aï¿½os intermedios)
	syscall
	la $a0, str4
	li $v0,4
	syscall


#-------------- EJERCICIO 2 -------------------------
ej2.1:	add $s0,$zero,15
	add $s1,$zero,10
	add $s2,$zero,1582
	add $t8, $t8,1
	
	j comienzo
	
ej2.2:	add $t0, $zero, $s7 #Guardamos en t0 los dias que han pasado desde el 15/10/1582
	div $s7,$s7,7
	mfhi $s7
	jal dime_semana_o_mes 
	
	
	
	
	

#--------------- EJERCICIO 3 ------------------------
ej3.3:	
	# Pasamos el año a s2, que es el que comprueba en la funcion bisiesto
	# y ponemos $s7 a 0. Si es bisiesto este año, lo pondrá a 1.
	# pasamos el resultado de s7 a t4
	
	add $s2, $zero, $s5
	add $s7, $zero, $zero
	
	jal bisiesto
	
	move $t4, $s7
	
	#En t0 estan los dias que han pasado desde 15/10/1582 a la fecha mayor
	jal calendario

	li $v0,10
	syscall
	
	
calendario:
	add $t1, $zero, $zero
	sub $t0, $t0, $s3 #Vemos los dias que han pasado al principio del mes
	div $s7, $t0, 7
	mfhi $t0		# dia de la semana del primer dia del mes. (0=V, 2=D, 6=J)
	slti $t3, $t0, 2
	
	beq $t3, 0, ajuste	# $t0: L=0; D=6
	add $t0, $t0, 7
ajuste: sub $t0, $t0, 2
	sub $t0, $zero, $t0
	add $t1, $t0, 7		# $t1: Dias que faltan para acabar la semana

	sub $t0, $zero, $t0
	la $a1, dias
	add $a1, $a1, $s4
	lb $t7, 0($a1) 		# Guardamos en t7 los dias que puede tener ese mes
	bne $t7, 28, no_feb	# Si no es febrero saltamos
	add $t7, $t7, $t4	# Le sumamos un dia si este año es bisiesto, si no lo es, $t4 era 0
no_feb:	add $t2, $zero, $zero 	#t2 sera el contador dia
	add $t5, $zero, $zero 	#t5 contador semana	
	
sig0:	beq $t0, 0, sig1
	add $a0, $zero, 32 	#imprimos 2 espacios por cada dia de la semana que no ha empezado el mes
	li $v0 11
	syscall
	li $v0 11
	syscall
	li $v0 11
	syscall
	addi $t0, $t0, -1
	j sig0
		
sig1:	beq $t1, 0, sig2	#imprimos los dias que quedan de la primera semana
	add $t2, $t2, 1
	addi $t1, $t1, -1
	add $a0, $zero, $t2	
	li $v0, 1
	syscall
	slti $t6, $t2, 10
	bne $t6, 1, sig1.1
	add $a0, $zero, 32
	li $v0 11
	syscall
sig1.1:	add $a0, $zero, 32
	li $v0 11
	syscall
	j sig1
	
sig2:	add $t5, $zero, $zero	# imprimios salto de linea = semana nueva
	add $a0, $zero 10
	li $v0, 11
	syscall
sig2.1:	beq $t2, $t7, fin_cal	# Imprimimos el resto de dias del mes
	add $t2, $t2, 1
	add $a0, $zero, $t2
	li $v0, 1
	syscall
	slti $t6, $t2, 10
	bne $t6, 1, sig2.2
	add $a0, $zero, 32
	li $v0 11
	syscall
sig2.2:
	add $a0, $zero, 32
	li $v0, 11
	syscall
	add $t5 $t5 1
	beq $t5, 7, sig2
	j sig2.1

fin_cal:
	jr $ra
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
#------------------------------------------------------------
calculo:addi $sp,$sp,-4		# 1er bucle: Guarda la posicion de memoria para luego poder volver a correcto
	sw $ra,0($sp)	
	sub $t1, $s1, $s4	# 1er bucle: $t1 = diferencia del mes a diciembre
	slt $t2, $s1, $s4	# 1er bucle: $t2 = 1 si la fecha no es diciembre
	beq $t1,0, comprueba_dia# 1er bucle: Si es diciembre, se compueba el dï¿½a
	beq $t2,0,cambia_todo	# 1er bucle: Si es diciembre, cambia_todo (AQUI NO LLEGA)
	j inicio
	
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
	
bucle:	lb $t0,0($a0)		# Bucle que suma en $s7 los dï¿½as de los meses que van
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
bisiesto:div $t7,$s2,4		# $t7 = aï¿½opequeï¿½o / 4
	mfhi $t5		# $t5 = aï¿½opequeï¿½o % 4
	div $t7,$s2,100		# $t7 = aï¿½opequeï¿½o / 10
	mfhi $t6		# $t6 = aï¿½opequeï¿½o % 10
	beq $t5,0,puede		# $t5 = 0: Puede ser bisiesto
	j segunda		
puede:	bne $t6,0,si
segunda:div $t7,$s2, 400	
	mfhi $t5
	bne $t5, 0, no		# Si es divisible entre 400, es bisiesto
	slti $t9, $s1, 3	# $t9 = 1 si  no ha llegado a marzo = feb tiene un dia mas
	beq $t9, 0, no
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
bisiestoTF:div $t7,$s2,4		# $t7 = aï¿½opequeï¿½o / 4
	mfhi $t5		# $t5 = aï¿½opequeï¿½o % 4
	div $t7,$s2,100		# $t7 = aï¿½opequeï¿½o / 10
	mfhi $t6		# $t6 = aï¿½opequeï¿½o % 10
	beq $t5,0,puedeTF	# $t5 = 0: Puede ser bisiesto
	j segundaTF		
puedeTF:bne $t6,0,siTF
segundaTF:div $t7,$s2, 400	
	mfhi $t5
	bne $t5, 0, noTF		# Si es divisible entre 400, no es bisiesto
siTF:	add $s7, $s7,366		# Si es divisible entre 400, se le suma un dia
	jr $ra
noTF:	add $s7,$s7,365
	jr $ra
#----------------------------------------------
tomar_entrada:
	beq $t1,1,segunda_entrada
primera_entrada:
	la $a0, entrada1
	j seguir_entrada
segunda_entrada:
	la $a0, entrada2
seguir_entrada:
	add $t7, $zero, 0
	la $a1, temp2
	j bucle_entrada
guardar_entrada:
	sw $t7,0($a1)
	add $a1,$a1,4
	add $t7,$zero,0
bucle_entrada:
	lb $t0,0($a0)
	add $a0,$a0,1
	beq $t0,47, guardar_entrada
	beq $t0, 10, salir_entrada
	mul $t7,$t7,10
	sub $t0,$t0,48
	add $t7,$t7,$t0
	j bucle_entrada
salir_entrada:
	sw $t7,0($a1)
	jr $ra
#----------------------------------------------
comprobacion:
	slti $t9,$s0,1
	beq $t9,1,incorrecto
	slti $t9,$s3,1
	beq $t9,1,incorrecto
	slti $t9,$s1,1
	beq $t9,1,incorrecto
	slti $t9,$s4,1
	beq $t9,1,incorrecto
	slti $t9,$s1,13
	bne $t9,1,incorrecto
	slti $t9,$s4,13
	bne $t9,1,incorrecto
	
	la $a0, dias
	add $a0, $a0, $s1
	lb $t0, 0($a0)
	slt $t9,$t0,$s0
	beq $t9,1,incorrecto
	la $a0, dias
	add $a0, $a0, $s4
	lb $t0, 0($a0)
	slt $t9,$t0,$s3
	beq $t9,1,incorrecto
	jr $ra

incorrecto:
	la $a0, str5
	li $v0,4
	syscall
	li $v0,10
	syscall
#-----------------------------------------
dime_semana_o_mes:
	add $t3, $zero,0
	li $v0,11
	add $a0,$zero,10
	syscall
	la $a0, str7
	li $v0,4
	syscall
salto_semana_o_mes:
	add $t5, $zero,$s7	#$s5 es el numero de mes
	add $t5,$t5,1
	la $a1, semana
	sub $t5,$t5,1
	mul $t5,$t5,11
	add $a1,$a1,$t5
bucle_semana_o_mes:
	lb $a0,0($a1)
	beq $a0,32,salir_semana_o_mes
	li $v0,11
	syscall
	add $a1,$a1,1
	j bucle_semana_o_mes
salir_semana_o_mes:
	add $t3, $t3,1
	beq $t3,2,salir_de_ej2
	li $v0,11
	add $a0,$zero,32
	syscall
	move $a0,$s3
	li $v0,1
	syscall
	la $a0, str6
	li $v0,4
	syscall
	add $s7,$s4,6
	j salto_semana_o_mes
salir_de_ej2:
	la $a0, str6
	li $v0,4
	syscall
	move $a0,$s5
	li $v0,1
	syscall
	la $a0, str8
	li $v0,4
	syscall
	li $v0,11
	add $a0,$zero,10
	syscall
	jr $ra
#-------------------------------------------
