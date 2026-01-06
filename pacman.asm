
; **********************************************************************
BUFFER	EQU	2000H		
PIN     EQU 0E0
00H
POUT    EQU 0C000H

POUT1   EQU    0A000H    ;periférico de saída de 8 bits
POUT2   EQU    0C000H    ;periférico de saída de 8 bits
POUT3   EQU    06000H    ;periférico de saída de 8 bits

; **********************************************************************

;-------------------------------------------------------
stackSize EQU 100H          ;Tamanho da pilha
pixelsMatriz  EQU 8000H     ;endereço da matriz de pixels
PLACE 2000H
pilha: TABLE stackSize
stackBase:
PLACE 2200H

ptable: STRING 01H,02H,04H,08H,10H,20H,40H,80H  ;Tabela de máscaras: cada valor isola um bit (pixel) de 0 a 7
;-------------------------------------------------------

;; Define uma tabela de variáveis para guardar as posições dos objectos do jogo
PLACE 3200H

; Coordenadas do Jogador (x, y) - Ocupam 2 bytes cada (3200H e 3202H)
linhaJogador EQU 3200H
colunaJogador EQU 3202H

linhaJogadorAnt   EQU 3232H
colunaJogadorAnt  EQU 3234H

; Coordenadas dos Objetos Tipo D (Triângulos) - Organizados em pares de 2 bytes
linhaC1 EQU  3224H
colunaC1 EQU 3226H

; Coordenadas dos Objetos Tipo Cruz - Organizados sequencialmente após os objetos D
linhaCc1 equ 3204H;3224H
colunaCc1 equ 3206H;3226H

linhaCc2 equ 3208H
colunaCc2 equ 3210H

linhaCc3 equ 3212H
colunaCc3 equ 3214H

linhaCc4 equ 3216H
colunaCc4 equ 3218H
;============Coordenadas na moldura e da caixa dos fantasmas==================
linhaMoldura equ 3220H
colunaMoldura equ 3222H

linhaCaixa equ 3228H
colunaCaixa equ 3230H
;-------------------------------------------------------


PLACE 0
main: MOV SP, stackBase         ;Inicializa o Stack Pointer com o endereco base


CALL inicializacaoP         ;Chamada da rotina 

inicicioPrincipal:
    CALL inicioLaEsqJg
    CALL inicioMolduraEsq
    CALL inicioLaEsqCaixa
    CALL desenhaOutrosObjectos
    CALL teclado

    MOV R5,BUFFER
    MOVB R4,[R5]
    MOV R5,4H
    CMP R4,R5
    JZ andaEsquerda

    MOV R5,BUFFER
    MOVB R4,[R5]
    MOV R5,6H
    CMP R4,R5
    JZ andaDireita

    MOV R5,BUFFER
    MOVB R4,[R5]
    MOV R5,1H
    CMP R4,R5
    JZ andaCima

    MOV R5,BUFFER
    MOVB R4,[R5]
    MOV R5,9H
    CMP R4,R5
    JZ andaBaixo

    MOV R5,BUFFER
    MOVB R4,[R5]
    MOV R5,0H
    CMP R4,R5
    JZ andaDiagSupE

    MOV R5,BUFFER
    MOVB R4,[R5]
    MOV R5,2H
    CMP R4,R5
    JZ adsd

    MOV R5,BUFFER
    MOVB R4,[R5]
    MOV R5,8H
    CMP R4,R5
    JZ andaDiagInfE

    MOV R5,BUFFER
    MOVB R4,[R5]
    MOV R5,0AH
    CMP R4,R5
    JZ andaDiagInfD

    JMP inicicioPrincipal
    acabou:
    JMP acabou
adsd:
    JMP andaDiagSupD

andaEsquerda:
    call limpatela
    MOV R3,linhaJogador
    MOV R4,colunaJogador
    MOV R1,[R3]
    MOV R2,[R4]
    MOV R5,linhaJogadorAnt
    MOV R6,colunaJogadorAnt
    MOV [R5],R1
    MOV [R6],R2
    CMP R2,1
    JLE inicicioPrincipal
    SUB R2,1H
    MOV [R4],R2
    JMP inicicioPrincipal

andaDireita:
    call limpatela
    MOV R3,linhaJogador
    MOV R4,colunaJogador
    MOV R1,[R3]
    MOV R2,[R4]
    MOV R5,1CH
    CMP R2,R5
    JGE inicicioPrincipal
    ADD R2,1H
    MOV [R4],R2
    JMP inicicioPrincipal

andaCima:
    call limpatela
    MOV R3,linhaJogador
    MOV R4,colunaJogador
    MOV R1,[R3]
    MOV R2,[R4]
    CMP R1,2H
    JLE inicicioPrincipal
    SUB R1,1H
    MOV [R3],R1
    JMP inicicioPrincipal

inicici:
    JMP inicicioPrincipal
inicici2:
    JMP inicicioPrincipal
inicici3:
    JMP inicicioPrincipal
inicici4:
    JMP inicicioPrincipal
inicici5:
    JMP inicicioPrincipal
inicici6:
    JMP inicicioPrincipal
inicicio:
    JMP inicicioPrincipal
inicicio1:
    JMP inicicioPrincipal

andaBaixo:
    call limpatela
    MOV R3,linhaJogador
    MOV R4,colunaJogador
    MOV R1,[R3]
    MOV R2,[R4]
    MOV R5,1DH
    CMP R1,R5                  ;Limite da movimentação do boneco
    JGE inicicioPrincipal       ;Faz o boneco parar no mesmo local quando estiver no limite
    ADD R1,1H
    MOV [R3],R1
    JMP inicicioPrincipal
andaDiagInfD:
    call limpatela
    MOV R3,linhaJogador
    MOV R4,colunaJogador
    MOV R1,[R3]
    MOV R2,[R4]
    MOV R5,1DH
    CMP R1,R5                  ;Limite da movimentação do boneco
    JGE inicicio       ;Faz o boneco parar no mesmo local quando estiver no limite
    MOV R5,1CH
    CMP R2,R5
    JGE inicicio1
    ADD R1,1H
    ADD R2,1H
    MOV [R3],R1
    MOV [R4],R2
    JMP inicicioPrincipal
andaDiagInfE:
    call limpatela
    MOV R3,linhaJogador
    MOV R4,colunaJogador
    MOV R1,[R3]
    MOV R2,[R4]
    MOV R5,1DH
    CMP R1,R5                  ;Limite da movimentação do boneco
    JGE inicici       ;Faz o boneco parar no mesmo local quando estiver no limite
    CMP R2,1
    JLE inicici2
    ADD R1,1H
    SUB R2,1H
    MOV [R3],R1
    MOV [R4],R2
    JMP inicicioPrincipal
andaDiagSupE:
    call limpatela
    MOV R3,linhaJogador
    MOV R4,colunaJogador
    MOV R1,[R3]
    MOV R2,[R4]
    CMP R2,1
    JLE inicici3
    CMP R1,2
    JLE inicici4
    SUB R1,1H
    SUB R2,1H
    MOV [R3],R1
    MOV [R4],R2
    JMP inicicioPrincipal
andaDiagSupD:
    call limpatela
    MOV R3,linhaJogador
    MOV R4,colunaJogador
    MOV R1,[R3]
    MOV R2,[R4]
    CMP R1,2
    JLE inicici5
    MOV R5,1CH
    CMP R2,R5
    JGE inicici6
    SUB R1,1H
    ADD R2,1H
    MOV [R3],R1
    MOV [R4],R2
    JMP inicicioPrincipal

limpatela:
        MOV R1, 8000H
        MOV R2, 807FH
        MOV R0,0H
    limpatudo:
        MOVB [R1],R0
        ADD R1,1H
        CMP R2,R1
        JN RETOR1
        JMP limpatudo

RETOR1:
    RET


pixel_xy: 
          ; --- Salva o estado dos registradores para não perder dados ---
          PUSH R4 
          PUSH R6 
          PUSH R7 
          PUSH R2 
          PUSH R5 
          PUSH R3

          ; --- Cálculo do endereço de memória do byte ---
          MOV R4,4           ; Cada linha tem 4 bytes
          MOV R6,8           ; Cada byte tem 8 bits
          MOV R7,R2          ; R7 recebe a coluna (X)
          MUL R4,R1          ; R4 = Linha (Y) * 4
          DIV R7,R6          ; R7 = Coluna (X) / 8
          ADD R4,R7          ; R4 = Offset total (Byte exato)
          MOV R7, pixelsMatriz
          ADD R4,R7          ; R4 = Endereço base + Offset (Endereço final), basicamente o proximo enderço a cender é calculado aqui

          ; --- Determina o limite do grupo de 8 bits (Byte) ---
          MOV R6,7H          ; Limite do 1º byte (0-7)
          CMP R2,R6
          JLE bitpixel       ; Se X <= 7, vai para o cálculo do bit
          MOV R6,0FH         ; Limite do 2º byte (8-15)
          CMP R2,R6
          JLE bitpixel
          MOV R6,17H         ; Limite do 3º byte (16-23)
          CMP R2,R6
          JLE bitpixel
          MOV R6, 1FH        ; Limite do 4º byte (24-31)

bitpixel:
        SUB R6,R2            ; Calcula o índice (0-7) do bit dentro do byte
        MOV R5,ptable        ; Endereço base da tabela de bits
        ADD R5,R6            ; Desloca até o bit correspondente
        MOVB R3,[R5]         ; R3 recebe a máscara (ex: 00001000)
        MOVB R6,[R4]         ; R6 lê o byte atual da memória de vídeo
        OR R6,R3             ; Aplica a máscara: liga o novo pixel sem apagar os outros
        MOVB [R4],R6         ; Grava o byte atualizado de volta na memória

        ; --- Restaura o estado original dos registradores ---
        POP R3 
        POP R5 
        POP R2 
        POP R7 
        POP R6 
        POP R4
        RET                  ; Retorna para quem chamou a função pixel_xy


inicioObjD:
    PU999SH R3
    PUSH R4
    PUSH R1
    PUSH R2
    PUSH R10
    PUSH R9
    MOV R10,3H
    MOV R9,1H
desenhaObjD1:
    call pixel_xy
    CMP R10,R9
    JZ inicioObjD2
    ADD R9,1H
    SUB R1,1H
    ADD R2,1H
    JMP desenhaObjD1

inicioObjD2:
    MOV R10,3H
    MOV R9,1H
    SUB R2,2H
desenhaObjD2:
    call pixel_xy
    CMP R10,R9
    JZ saidaObjD2
    ADD R9,1H
    ADD R1,1H
    ADD R2,1H
    JMP desenhaObjD2
saidaObjD2:
    JMP RETORNO
inicioCruz:
    PUSH R3
    PUSH R4
    PUSH R1
    PUSH R2
    PUSH R10
    PUSH R9
    MOV R10,3
    MOV R9,1H
desenhaCruz1:
    call pixel_xy
    CMP R10,R9
    JZ inicioCruz2
    SUB R1,1H
    ADD R9,1H
    JMP desenhaCruz1

inicioCruz2:
    MOV R10,3
    MOV R9,1H
    ADD R1,1H
    SUB R2,1H
    desenhaCruz2:
        call pixel_xy
        CMP R10,R9
        JZ saidaCruz2
        ADD R2,1H
        ADD R9,1H
        JMP desenhaCruz2
saidaCruz2:
    JMP RETORNO
;================================================================================
;ETIQUETA PARA DESENHAR E INICIALIZAR MOLDURA
;================================================================================
inicioMolduraEsq:
    PUSH R3
    PUSH R4
    PUSH R1
    PUSH R2
    PUSH R10
    PUSH R9
    MOV R3,linhaMoldura
    MOV R4,colunaMoldura
    MOV R1,[R3]
    MOV R2,[R4]
    MOV R10,1FH ;Limite
    MOV R9,1H ;Contador
    desenhaLaEsqMold:
        call pixel_xy
        CMP R10,R9
        JZ  inicioMolduraCima;inicioMolduraCima
        ADD R1,1H ;LINHA
        ADD R9,1H
        JMP desenhaLaEsqMold

    inicioMolduraCima:
        MOV R10,1FH
        MOV R9,1H
        MOV R1,0H ;LINHA
        MOV R2,0H ;COLUNA
        desenhoLaCimaMold:
            call pixel_xy
            CMP R10,R9
            JZ inicioMolduraBaixo
            ADD R2,1H ;COLUNA
            ADD R9,1H
            JMP desenhoLaCimaMold
    
    inicioMolduraBaixo:
    MOV R10,1FH
    MOV R9,1H
    MOV R1,1FH ;LINHA
    MOV R2,0H ;COLUNA
    desenhaLaBaixoMold:
       call pixel_xy
       CMP R10,R9
       JZ iniciarMolduraDireita
       ADD R2,1H ;Coluna
       ADD R9,1H
       JMP desenhaLaBaixoMold

    iniciarMolduraDireita:
    MOV R10,20H
    MOV R9,1H
    MOV R1,0H ;LINHA
    MOV R2,1FH ;COLUNA
    desenhaLadDireitoMold:
       call pixel_xy
       CMP R10,R9
       JZ RETORNO_M
       ADD R1,1H ;LINHA
       ADD R9,1H
       JMP desenhaLadDireitoMold

    RETORNO_M:
    POP R9
    POP R10
    POP R2
    POP R1
    POP R4
    POP R3
    RET
;========CAIXA==========================
inicioLaEsqCaixa:
    PUSH R3
    PUSH R4
    PUSH R1
    PUSH R2
    PUSH R10
    PUSH R9
    MOV R3,linhaCaixa
    MOV R4,colunaCaixa
    MOV R1,[R3]
    MOV R2,[R4]
    MOV R10,7H ;Limite
    MOV R9,1H ;Contador
    desenhaLaEsqCaixa:
        call pixel_xy
        CMP R10,R9
        JZ inicioCaixaCima 
        ADD R1,1H ;LINHA
        ADD R9,1H
        JMP desenhaLaEsqCaixa
inicioCaixaCima:
        MOV R10,2H
        MOV R9,1H
        MOV R1,0CH ;LINHA
        MOV R2,0DH ;COLUNA
        CALL pixel_xy
        ADD R2,1H
        desenhoLaCimaCaixa:
            call pixel_xy
            CMP R10,R9
            JZ inicioCaixaBaixo
            ADD R2,4H ;COLUNA
            ADD R9,1H
            JMP desenhoLaCimaCaixa
inicioCaixaBaixo:
    MOV R10,7H
    MOV R9,1H
    MOV R1,13H ;LINHA
    MOV R2,0DH ;COLUNA
    desenhaLaBaixoCaixa:
       call pixel_xy
       CMP R10,R9
       JZ iniciarCaixaDireita
       ADD R2,1H ;Coluna
       ADD R9,1H
       JMP desenhaLaBaixoCaixa

iniciarCaixaDireita:
    MOV R10,7H
    MOV R9,1H
    MOV R1,0CH ;LINHA
    MOV R2,13H ;COLUNA
    desenhaLadDireitoCaixa:
       call pixel_xy
       CMP R10,R9
       JZ RETORNO_C
       ADD R1,1H ;LINHA
       ADD R9,1H
       JMP desenhaLadDireitoCaixa
    
    RETORNO_C:
    POP R9
    POP R10
    POP R2
    POP R1
    POP R4
    POP R3
    RET


inicioLaEsqJg:
    PUSH R3
    PUSH R4
    PUSH R1
    PUSH R2
    PUSH R10
    PUSH R9
    MOV R3,linhaJogador
    MOV R4,colunaJogador
    MOV R1,[R3]
    MOV R2,[R4]
    MOV R10,1H
    MOV R9,1H 
    desenhaLaEsqJg:
        call pixel_xy
        CMP R10,R9
        JZ inicioLaCima
        ADD R1,2H ;LINHA
        ADD R9,1H
        JMP desenhaLaEsqJg

inicioLaCima:
    MOV R10,3H
    MOV R9,1H
    SUB R1,1H ;LINHA
    desenhoLaCima:
        call pixel_xy
        CMP R10,R9
        JZ inicioLaBaixo
        ADD R2,1H ;COLUNA
        ADD R9,1H
        JMP desenhoLaCima

inicioLaBaixo:
    MOV R10,3H
    MOV R9,1H
    SUB R2,2H ;COLUNA
    ADD R1,2H ;LINHA
    desenhaLaBaixo:
       call pixel_xy
       CMP R10,R9
       JZ RETORNO
       ADD R2,1H ;Coluna
       ADD R9,1H
       JMP desenhaLaBaixo

RETORNO:
    POP R9
    POP R10
    POP R2
    POP R1
    POP R4
    POP R3
    RET

inicializacaoP:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    MOV R1,linhaJogador     ; gurda o endereco da linha Jogador
    MOV R2,colunaJogador    ; Guarda o endereco correspondente a coluna do jogador
    MOV R3,1BH
    MOV R4,0DH
    MOV [R1],R3
    MOV [R2],R4
    MOV R1,linhaC1
    MOV R2, colunaC1
    MOV R3,0FH        ; linha 15 (centro)
    MOV R4,0FH        ; coluna 15 (centro)
    MOV [R1],R3
    MOV [R2],R4

    MOV R1,linhaCc1
    MOV R2,colunaCc1
    MOV R3,03H
    MOV R4,03H
    MOV [R1],R3
    MOV [R2],R4
    MOV R1,linhaCc2
    MOV R2,colunaCc2
    MOV R3,03H
    MOV R4,1CH
    MOV [R1],R3
    MOV [R2],R4
    MOV R1,linhaCc3
    MOV R2,colunaCc3
    MOV R3,1EH
    MOV R4,03H
    MOV [R1],R3
    MOV [R2],R4

    MOV R1,linhaCc4
    MOV R2, colunaCc4
    MOV R3,1EH
    MOV R4,1CH
    MOV [R1],R3
    MOV [R2],R4

    MOV R1, linhaMoldura
    MOV R2, colunaMoldura
    MOV R3,0H
    MOV R4,0H
    MOV [R1],R3
    MOV [R2],R4

    MOV R1, linhaCaixa
    MOV R2, colunaCaixa
    MOV R3,0CH
    MOV R4,0DH
    MOV [R1],R3
    MOV [R2],R4

    POP R4
    POP R3
    POP R2
    POP R1
    RET


desenhaOutrosObjectos:
    PUSH R3
    PUSH R4
    PUSH R1
    PUSH R2


    MOV R3,linhaC1
    MOV R4,colunaC1
    MOV R1 , [R3]
    MOV R2, [R4]
    CALL inicioObjD
    
    MOV R3,linhaCc1
    MOV R4,colunaCc1
    MOV R1,[R3]
    MOV R2,[R4]
    CALL inicioCruz

    MOV R3,linhaCc2
    MOV R4,colunaCc2
    MOV R1,[R3]
    MOV R2,[R4]
    CALL inicioCruz

    MOV R3,linhaCc3
    MOV R4,colunaCc3
    MOV R1,[R3]
    MOV R2,[R4]
    CALL inicioCruz
    MOV R3,linhaCc4
    MOV R4,colunaCc4
    MOV R1,[R3]
    MOV R2,[R4]
    CALL inicioCruz

    POP R2
    POP R1
    POP R4
    POP R3
    RET


teclado:
    PUSH R1
    PUSH R6
    PUSH R2
    PUSH R3
    PUSH R8
    PUSH R10
    PUSH R4
    inicio:
    MOV R5, BUFFER	; R5 com endere�o de mem�ria BUFFER
    MOV	R1, 1	    ; testar a linha 1
    MOV R6,PIN   
    MOV	R2, POUT	; R2 com o endere�o do perif�rico
    
    ;corpo principal do programa

    ciclo:MOVB 	[R2], R1	; escrever no porto de sa�da
        MOVB 	R3, [R6]	; ler do porto de entrada
        AND 	R3, R3		; afectar as flags (MOVs n�o afectam as flags)
        JZ 	inicializarLinha		; nenhuma tecla premida
        MOV R8,1
        CMP R8,R1
        JZ linha1
        MOV R8,2
        CMP R8,R1
        JZ linha2
        MOV R8,4
        CMP R8,R1
        JZ linha3
        MOV R8,8
        CMP R8,R1
        JZ linha4

    linha4:
        linha4C1:MOV R8,1
        CMP R8,R3
        JZ EC
        JNZ linha4C2
        linha4C2:MOV R8,2
        CMP R8,R3
        JZ ED
        JNZ linha4C3
        linha4C3:MOV R8,4
        CMP R8,R3
        JZ EE
        JNZ linha4C4
        linha4C4:MOV R8,8
        CMP R8,R3
        JZ EF
    linha3:
        linha3C1:MOV R8,1
        CMP R8,R3
        JZ Eoito
        JNZ linha3C2
        linha3C2:MOV R8,2
        CMP R8,R3
        JZ Enove
        JNZ linha3C3
        linha3C3:MOV R8,4
        CMP R8,R3
        JZ EA
        JNZ linha3C4
        linha3C4:MOV R8,8
        CMP R8,R3
        JZ EB

    linha2:
        linha2C1:MOV R8,1
        CMP R8,R3
        JZ Equatro
        JNZ linha2C2
        linha2C2:MOV R8,2
        CMP R8,R3
        JZ Ecinco
        JNZ linha2C3
        linha2C3:MOV R8,4
        CMP R8,R3
        JZ Eseis
        JNZ linha2C4
        linha2C4:MOV R8,8
        CMP R8,R3
        JZ Esete


    linha1:
        linha1C1:MOV R8,1
        CMP R8,R3
        JZ Ezero
        JNZ linha1C2
        linha1C2:MOV R8,2
        CMP R8,R3
        JZ Eum
        JNZ linha1C3
        linha1C3:MOV R8,4
        CMP R8,R3
        JZ Edois
        JNZ linha1C4
        linha1C4:MOV R8,8
        CMP R8,R3
        JZ Etres

        Ezero:MOV R10,0H
        JMP armazena
        Eum:MOV R10,1H
        JMP armazena
        Edois:MOV R10,2H
        JMP armazena
        Etres:MOV R10,3H
        JMP armazena
        Equatro:MOV R10,4H
        JMP armazena
        Ecinco:MOV R10,5H
        JMP armazena
        Eseis:MOV R10,6H
        JMP armazena
        Esete:MOV R10,7H
        JMP armazena
        Eoito:MOV R10,8H
        JMP armazena
        Enove:MOV R10,9H
        JMP armazena
        EA:MOV R10,9H
        ADD R10,1H
        JMP armazena
        EB:MOV R10,9H
        ADD R10,2H
        JMP armazena
        EC:MOV R10,9H
        ADD R10,3H
        JMP armazena
        ED:MOV R10,9H
        ADD R10,4H
        JMP armazena
        EE:MOV R10,9H
        ADD R10,5H
        JMP armazena
        EF:MOV R10,9H
        ADD R10,6H
        armazena:
        MOV	R4, R10		    ; guardar tecla premida em registo
        MOVB [R5], R4	; guarda tecla premida em mem�ria
        JMP RETOR

inicializarLinha:
    MOV R8,2
    MUL R1,R8
    MOV R8,8
    CMP R8,R1
    JN inicio
    JNN ciclo


RETOR:
    POP R4
    POP R10
    POP R8
    POP R3
    POP R2
    POP R6
    POP R1
    RET
FIM: