	# IFRN
	# Exercicio Estrutura de dados - impelementacao de lista ligada
	# Funcoes: Inserir, buscar, Size.
	# Aluno: Mannuel Victor Di Pace Maroja Limeira
	# Matricula: 20121014040067
	.data
	
list: 		.space 1000
menu:		.asciiz "\nEcolha uma opcao abaixo:\n1 - INSERIR | 2 - DELETAR | 3 - SIZE\n0 - sair\n"
menu_inserir:	.asciiz "\nDigite o valor para ser adicionado na lista:\n"
menu_deletar:	.asciiz "\nDigite o valor para ser retirado da lista:\n"
pre_size:	.asciiz "\nNumeros de elementos na fila: "
fila_vazia_msg:	.asciiz "\nA fila esta vazia. "
nao_encontrado:	.asciiz "\nValor nao encontrado. "
nulo:		.ascii "n"

	.text
	# $s0 = Contagem de elementos
	# $s1 = endereco inicial da fila
	# $s2 = endereco de adicao de proximo elemento
	# $s3 = Endereco do primeiro elemento da fila
	# $s4 = Ultimo elemento da fila
	# $s5 = Contagem de vazamentos
main:

inicializador:	
		li $s0, 0		# $s0 = # de elementos (size)
		la $s1, list		# $s1 = endereco da fila
		la $s2, list		# $s2 = endereco de adicao de proximo elemento
		li $s3, 0		# $s3 = primeiro elemento da fila
		li $s4, 0		# $s4 = ultimo elemento da fila
		li $s5, 0		# $s5 = Contagem de vazamentos
		
menu_inicio:	

		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, menu		# Carregar endereco de menu no $a0
		syscall 		# Chamada
		
		li $v0, 5 		# Carregar interger do usuario para $v0
		syscall 		# Chamada
		move $t0, $v0		# Move o inteiro opcao do usuario para $t0
		
		#testa entrada
		beqz $t0, saida		# Opcao 0 , saida
		beq $t0, 1, inserir	# Opcao 1 , INSERIR
		beq $t0, 2, deletar	# Opcao 2 , DELETAR
		beq $t0, 3, size	# Opcao 2 , SIZE
		j menu_inicio		# Nenhuma opcao encontrada, volta para o inicio do menu

###############################################################################################
# INSERIR
###############################################################################################
inserir:
### MENU
		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, menu_inserir	# Carregar endereco de menu_ins no $a0
		syscall 		# Chamada

		li $v0, 5		# Chamada de sistema para ler inteiro = 5
		syscall			# Chamada
		move $t2, $v0		# Coloca o numero em $t2
### MENU

		beqz $s3, adicionar_p_elemento	# Testar se fila eh virgem, se sim adicionar primeiro elemento
		bnez $s5, adicionar_vazamento	# Testa se existe vazamento na estrutura, se sim adicionar no vazamento
		j adicionar_comum		# Se fila inicializada, e nao possui vazamentos, adicionar comum
		
adicionar_p_elemento:
		la $s3, ($s1)	# Set o endereco de $s1 em $s3 como primeiro elemento
		la $t1, ($s2)	# Set $t1 para ser o endereco do elemento manipulado nesta funcao
		la $s4, ($s2)	# Set $s4 para o ultimo elemento da fila
		
		sw $t2, ($t1)	# Aloca a entrada do usuario ($t2) no endereco do elemento manipulado
		sw $zero, 4($t1)	# Aloca o zero no espaco de endereco do proximo elemento
		addi $s2, $s2, 8 	# Ja incremeta $s2 para uma proxima entrada do usuario
		addi $s0, $s0, 1 	# Conta mais um elemento na fila
		
		j menu_inicio	# Retorna para o menu inicial

adicionar_vazamento:
		jal encontrar_vazamento	# Funcao para encontrar vazamento, adiciona endereco em $t3
		
		sw $t3, 4($s4)	# Carrega endereco no ultimo elemento
		la $s4, ($t3)	# Atualiza o endereco do ultimo elemento
		
		sw $t2, ($t3)	# Aloca a entrada do usuario ($t2) no endereco do elemento manipulado
		sw $zero, 4($t3)	# Aloca o zero no espaco de endereco do proximo elemento
		
		addi $s5, $s5, -1	# Decrementa contagem de vazamento
		addi $s0, $s0, 1 	# Conta mais um elemento na fila
		
		j menu_inicio	# Retorna para o menu inicial
		
		
encontrar_vazamento:
		la $t1, ($s1)	# Iniciar busca no inicio da memoria
loop_vazamento:
		lw $t4, ($t1)	# Carrega o valor de $t1 em $t4
		la $t5, nulo	# Carrega o endereco do nulo
		lb $t6, ($t5)	# Carrega o valor efetivo de nulo
		beq $t4, $t6, retorno_vazamento	# Se o valor for nulo, retorna o endereco
		addi $t1, $t1, 8	# Buscar o proximo bloco de memoria
		j loop_vazamento	# Loop de busca de vazamento
		
retorno_vazamento:
		la $t3, ($t1)	# Carrega em $t3 o endereco do vazamento
		jr $ra		# Retorna da funcao

adicionar_comum:
		la $t1, ($s2)	# Set $t1 para ser o endereco do elemento manipulado nesta funcao
		
		sw $t2, ($t1)	# Aloca a entrada do usuario ($t2) no endereco do elemento manipulado
		sw $zero, 4($t1)	# Aloca o zero no espaco de endereco do proximo elemento
		addi $s2, $s2, 8 	# Ja incremeta $s2 para uma proxima entrada do usuario
		addi $s0, $s0, 1 	# Conta mais um elemento na fila
		
		sw $t1, 4($s4)	# Set o endereco da ultima entrada para a estrutura atual
		la $s4, ($t1)	# Set $s4 para o ultimo elemento da fila
		
		j menu_inicio	# Retorna para o menu inicial

###############################################################################################
# DELETAR
###############################################################################################
deletar:
		beq $s0, $zero, vazia	# Testa se esta vazia
### MENU
		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, menu_deletar	# Carregar endereco de menu_ins no $a0
		syscall 		# Chamada

		li $v0, 5		# Chamada de sistema para ler inteiro = 5
		syscall			# Chamada
		move $t2, $v0		# Coloca o numero em $t2
### MENU

		j search_n_destroy	# Funcao para achar endereço do elemento a ser retirado
		
search_n_destroy:
		la $t1, ($s3)		# Carrega o endereco do primeiro elemento em $t1

loop_s_n_d:		
		lw $t3, ($t1)		# Carrega o valor do elemento atual em $t3
		beq $t3, $t2, destroy	# Testa se encontrou o elemento
		la $t5, 4($t1)		# Carrega o endereco do proximo do atual em $t5 para testes
		lw $t5, ($t5)		# Carrega o valor de $t5
		beq $t5, $zero, not_found	# Nao encontrou o elemento
		
		la $t4, ($t1)		# Salva o endereco do ultimo elemento pesquisado
		la $t5, 4($t1)		# Carrega o endereco do proximo do atual em $t5 para uso
		move $t1, $t5		# Endereco do proximo, ja estava em $t5
		j loop_s_n_d		# Loop do search and destroy
		
destroy:
		la $t5, 4($t1)		# Carrega o endereco do proximo do atual em $t5 para testes
		lw $t5, ($t5)		# Carrega o valor de $t5
		beq $t1, $s3, destroy_first	# Se for o primeiro elemento, tratar destruicao
		beqz $t5, destroy_last	# Tratar destruicao de ultimo elemento
		lw $t5, 4($t1)		# Carrega o enedereco do proximo elemento do atual
		sw $t5, 4($t4)		# Linka o elemento anterior ao proximo, isolando o elemento a ser destruido
		la $t6, nulo		# Carrega o endereco do nulo
		lb $t7, ($t6)		# Carrega o valor efetivo de nulo
		sw $t7, ($t1)		# Limpeza de obejto, utilizando nulo
		sw $t7, 4($t1)		# Limpeza de objeto, utilizando nulo
		
		addi $s5, $s5, 1	# Incremento de vazamento
		addi $s0, $s0, -1 	# Retira um elemento da contagem na fila
		
		beqz $s0, inicializador	# Se numero de elemento igual a zero, limpar fila e registradores
		j menu_inicio
destroy_last:
		la $s4, ($t4)		# Update do endereco do ultimo elemento
		sw $zero, 4($s4)	# Zera o link do novo ultimo elemento
		
		la $t6, nulo		# Carrega o endereco do nulo
		lb $t7, ($t6)		# Carrega o valor efetivo de nulo
		sw $t7, ($t1)		# Limpeza de obejto, utilizando nulo
		sw $t7, 4($t1)		# Limpeza de objeto, utilizando nulo
		
		addi $s5, $s5, 1	# Incremento de vazamento
		addi $s0, $s0, -1 	# Retira um elemento da contagem na fila
		
		beqz $s0, inicializador	# Se numero de elemento igual a zero, limpar fila e registradores
		j menu_inicio
		
destroy_first:
		bne $s0, 1, destroy_first_elem	# Se o primeiro elemento nao for o unico, vai para situacao de tratamento
		# Se o elemento for o primeiro e for o unico elemento na lista, reseta toda a lista
		la $t6, nulo		# Carrega o endereco do nulo
		lb $t7, ($t6)		# Carrega o valor efetivo de nulo
		sw $t7, ($t1)		# Limpeza de obejto, utilizando nulo
		sw $t7, 4($t1)		# Limpeza de objeto, utilizando nulo
		
		addi $s5, $s5, 1	# Incremento de vazamento
		addi $s0, $s0, -1 	# Retira um elemento da contagem na fila
		
		beqz $s0, inicializador	# Se numero de elemento igual a zero, limpar fila e registradores
		j menu_inicio

destroy_first_elem:
		la $s3, 4($s3)		# Update do endereco do primeiro elemento para o proximo
		
		la $t6, nulo		# Carrega o endereco do nulo
		lb $t7, ($t6)		# Carrega o valor efetivo de nulo
		sw $t7, ($t1)		# Limpeza de obejto, utilizando nulo
		sw $t7, 4($t1)		# Limpeza de objeto, utilizando nulo
		
		addi $s5, $s5, 1	# Incremento de vazamento
		addi $s0, $s0, -1 	# Retira um elemento da contagem na fila
		
		beqz $s0, inicializador	# Se numero de elemento igual a zero, limpar fila e registradores
		j menu_inicio
		
not_found:
		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, nao_encontrado	# Carregar endereco de menu_ins no $a0
		syscall 		# Chamada
		
		beqz $s0, inicializador	# Se numero de elemento igual a zero, limpar fila e registradores
		j menu_inicio
###############################################################################################
# SIZE
###############################################################################################
size:		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, pre_size	# Carregar endereco de pre_size no $a0
		syscall 		# Chamada
		
		li $v0, 1		# Chamada de sistema para imprimir inteiro = 1
		la $a0, ($s0)		# Carregar endereco da contagem de elementos ($t3) no $a0
		syscall 		# Chamada
		
		j menu_inicio		# Vai para o inicio do menu
###############################################################################################
# VAZIA
###############################################################################################
vazia:
		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, fila_vazia_msg	# Carregar endereco de fila_vazia no $a0
		syscall 		# Chamada
		
		j menu_inicio		# Retorna para o menu inicial
###############################################################################################
# SAIDA
###############################################################################################		
saida:		li $v0, 10		# command to exit
		syscall
