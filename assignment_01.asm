	# IFRN
	# Exercicio 01 de estrutura de dados - implementar transformacao e calculo, infixiada para pos-fixada
	# Funcoes: ***
	# Aluno: Mannuel Victor Di Pace Maroja Limeira
	# Matricula: 20121014040067
	.data
	
pilha: 		.space 128	# pilha de operadores
pilha_final:	.space 128	# pilha final para calculo
expressao:	.space 128	# Espaco para entrada do calculo
menu:		.asciiz "\nEscolha uma opcao abaixo:\n1 - Calcular\n0 - sair\n"
menu_receber:	.asciiz "\nDigite o calculo abaixo: \n"
end_line:	.ascii "\n"
comparar:	.ascii "()+-*/"

	.text
	# $s0 = endereco inicial da pilha de operadores
	# $s1 = endereco inicial da pilha de calculos
	# $s3 = endereco inicial da lista de comparadores
	# $s4 = agulha da pilha de operadores
	# $s5 = agulha da pilha de calculos
	# $s6 = contador pilha de calculos
	# $s7 = contador pilha de operandos
	# $t0 = opcao de funcao
	# $t2 = livre para testes
	# $t3 = livre para testes
	# $t4 =
	# $t5 = iterador da string de entrada do usuario
	# $t6 = salvar byte do string de entrada do usuario
main:

inicializador:	la $s0, pilha		# $s0 = endereco da pilha de operadores
		la $s1, pilha_final	# $s1 = endereco da pilha de calculos
		la $s3, comparar	# $s3 = endereco da lista de comparadores
		la $s4, pilha		# $s0 = agulha da pilha de operadores
		la $s5, pilha_final	# $s1 = agulha da pilha de calculos
		li $s6, 0		# Zera contador de pilha final
		li $s7, 0		# Zera contador de pilha de operandos
		
menu_inicio:	li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, menu		# Carregar endereco de menu no $a0
		syscall			# Chamada
		
		li $v0, 5 		# Carregar interger do usuario para $v0
		syscall 		# Chamada
		move $t0, $v0		# Move o inteiro opcao do usuario para $t0
		
		#testa entrada
		beqz $t0, saida		# Opcao 0 , saida
		beq $t0, 1, receber	# Opcao 1 , Calcular
		j menu_inicio		# Nenhuma opcao encontrada, volta para o inicio do menu

########################## Receber Calculo ###########################

receber:	li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, menu_receber	# Carregar endereco de menu_receber no $a0
		syscall			# Chamada

		li $v0, 8		# Comando ler string
    		la $a0, expressao	# Salva o endereco do buffer
		li $a1, 64		# Tamanho do buffer
    		syscall
    		
    		#li $v0, 4		# Chamada de sistema para imprimir string = 4
		#la $a0, expressao	# Carregar endereco de expressao no $a0
		#syscall 		# Chamada
		
		la $t5, expressao	# Endereco do string de entrada do usuario
loop_byte:	#iterar caracteres
		lb $t6, ($t5)		# carrega byte do string em $t6
		lb $t0, end_line	# Carrega byte: \n
		beq $t6, $t0, calcular	# Checar final da string, limpa pilha e calcula
		j tratar_byte		# Nao chegou ao final, tratar byte carregado em $t6
ret_tratar:	#retorna do tratamento do byte
		add $t5, $t5, 1		# Adicionar proximo caracter no gatilho
		j loop_byte		# LOOP
		
		j saida
		
########################### Tratar byte ################################
tratar_byte:
		# if "("
		lb $t2, 0($s3)			# Carrega "(" da lista de comparadores
		beq $t2, $t6, push_operador	# Se sim, push.
		
		# if ")"
		lb $t2, 1($s3)			# Carrega ")" da lista de operadores
		beq $t2, $t6, push_operador_p	# Se sim, push
		
		# if "+"
		lb $t2, 2($s3)			# Carrega "+" da lista de operadores
		beq $t2, $t6, push_operador_n1	# Se sim, push
		
		# if "-"
		lb $t2, 3($s3)			# Carrega "-" da lista de operadores
		beq $t2, $t6, push_operador_n1	# Se sim, push
		
		# if "*"
		lb $t2, 4($s3)			# Carrega "*" da lista de operadores
		beq $t2, $t6, push_operador_n2	# Se sim, push
		
		# if "/"
		lb $t2, 5($s3)			# Carrega "/" da lista de operadores
		beq $t2, $t6, push_operador_n2	# Se sim, push
		
		# se nenhum acima, temos um numero
		j push_numero

################################ PUSH_COMPUTACAO_TODOS ################################
push_operador:
		sw $t6, ($s4)		# Adiciona o byte tratado na agulha da pilha de operadores
		addi $s4, $s4, 4 	# Ja incremeta $s4 para uma proxima entrada na pilha operadores
		addi $s7, $s7, 1	# +1 pilha de operandos
		
		j ret_tratar		# Retorna ao fluxo do tratamento de byte

push_operador_p:
		lb $t2, 0($s3)		# Carrega "(" da lista de comparadores
		lb $t3, -4($s4)		# Carrega ultimo operador da lista
		bne $t2, $t3, pop_push	# Se o operando for "(", ativar push_pop
		#else = retira o "(" da jogada sem adicionar nada a pilha de calculo
		addi $s4, $s4, -4	# Posicao real da cabeca de pilha
		addi $s7, $s7, -1	# Decrementa o contador da pilha de operadores
		j ret_tratar
		
pop_push:
		addi $s4, $s4, -4	# Posicao real da cabeca de pilha
		addi $s7, $s7, -1	# Decrementa o contador da pilha de operadores
		lw $t0, ($s4)		# Carrega o valor em $t0
		
		sw $t0, ($s5)		# Adiciona o byte tratado na agulha da pilha de calculo
		addi $s5, $s5, 4 	# Ja incremeta $s5 para uma proxima entrada na pilha calculo
		addi $s6, $s6, 1	# Contador de pilha calculo ++
		
		j push_operador_p
		
push_operador_n1:
		j tratar_n1
post_j_n1:	
		sw $t6, ($s4)		# Adiciona o byte tratado na agulha da pilha de operadores
		addi $s4, $s4, 4 	# Ja incremeta $s4 para uma proxima entrada na pilha operadores
		addi $s7, $s7, 1	# +1 no contador de pilha de operadores
		
		j ret_tratar		# Retorna ao fluxo do tratamento de byte
		
tratar_n1:
		beqz $s7, post_j_n1	# pilha vazia, ativar push
		
		# Se pilha nao vazia, testar ultimo operador para nivel 1
		lb $t2, 2($s3)		# Carrega "+" da lista de comparadores
		lb $t3, -4($s4)		# Carrega ultimo operador da lista
		beq $t2, $t3, post_j_n1	# Se o operando for "+", ativar push
		
		lb $t2, 3($s3)		# Carrega "-" da lista de comparadores
		lb $t3, -4($s4)		# Carrega ultimo operador da lista
		beq $t2, $t3, post_j_n1	# Se sim, ativar push
		
		# Testar parenteses
		lb $t2, 0($s3)		# Carrega "(" da lista de comparadores
		lb $t3, -4($s4)		# Carrega ultimo operador da lista
		beq $t2, $t3, post_j_n1	# Se sim, ativar push
		
		# Nivel 2 encontrado, pop niveis 2
		j pop_niveis2
		j post_j_n1

push_operador_n2:
		sw $t6, ($s4)		# Adiciona o byte tratado na agulha da pilha de operadores
		addi $s4, $s4, 4 	# Ja incremeta $s4 para uma proxima entrada na pilha operadores
		addi $s7, $s7, 1	# +1 pilha de operandos
		
		j ret_tratar		# Retorna ao fluxo do tratamento de byte

push_numero:
		sw $t6, ($s5)		# Adiciona o byte tratado na agulha da pilha de calculo
		addi $s5, $s5, 4 	# Ja incremeta $s5 para uma proxima entrada na pilha calculo
		addi $s6, $s6, 1	# Contador de pilha calculo ++
		
		j ret_tratar		# Retorna ao fluxo do tratamento de byte

pop_niveis2:
		lb $t2, 4($s3)		# Carrega "*" da lista de comparadores
		lb $t3, -4($s4)		# Carrega ultimo operador da lista
		beq $t2, $t3, pop_push_n2	# Se sim, ativar pop_push
		
		lb $t2, 5($s3)		# Carrega "/" da lista de comparadores
		lb $t3, -4($s4)		# Carrega ultimo operador da lista
		beq $t2, $t3, pop_push_n2	# Se sim, ativar pop_push
		
		j tratar_n1

pop_push_n2:
		addi $s4, $s4, -4	# Posicao real da cabeca de pilha
		addi $s7, $s7, -1	# Decrementa o contador da pilha de operadores
		lw $t0, ($s4)		# Carrega o valor em $t0
		
		sw $t0, ($s5)		# Adiciona o byte tratado na agulha da pilha de calculo
		addi $s5, $s5, 4 	# Ja incremeta $s5 para uma proxima entrada na pilha calculo
		addi $s6, $s6, 1	# Contador de pilha calculo ++
		
		j tratar_n1

########################### Imprimir ################################
limpar_pilha:
		addi $s4, $s4, -4	# Posicao real da cabeca de pilha
		addi $s7, $s7, -1	# Decrementa o contador da pilha de operadores
		lw $t6, ($s4)		# Carrega o valor em $t6
		sw $t6, ($s5)		# Adiciona o byte tratado na agulha da pilha de calculo
		addi $s5, $s5, 4 	# Ja incremeta $s5 para uma proxima entrada na pilha calculo
		addi $s6, $s6, 1	# Contador de pilha calculo ++

calcular:
		bnez $s7, limpar_pilha	# Se pilha de operadores nao vazio, limpar
		la $s5, pilha_final	# Zera agulha da pilha final
		
print:		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, ($s5)		# Carregar endereco de menu_receber no $a0
		syscall			# Chamada
		addi $s6, $s6, -1	# Decrementa contador da pilha final
		beqz $s6, saida		# Se terminou a pilha, saida
		addi $s5, $s5, 4	# proximo numero
		j print
		
		j saida

################################ SAIDA ################################
		
saida:		li $v0, 10		# command to exit
		syscall
