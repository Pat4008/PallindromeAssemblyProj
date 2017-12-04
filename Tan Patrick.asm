;Tan, Patrick Spencer, S18

%include "io.inc"
section .data
msg1 db "Enter the String: ",0
msg2 db "Pallindrome: ",0
msg3 db "Word: ",0
msg4 db "Character: ",0
msg5 db "Bit-1: ",0
msg6 db "Error: invalid terminator, please try again", 0
msg7 db "Error, maximum character reached!", 0
msg8 db "Error, null input!", 0
msg9 db "Do you want to continue? (1=yes, 0=no)", 0
msg10 db "Program ended",0

N dd 0
i dd 0
S dd 0
T dd 0
T2 dd 0
TEMP times 50 db 0

section .text
global CMAIN
CMAIN:
    
    ;reset and initialize
    XOR EAX, EAX
    XOR EBX, EBX
    XOR ECX, ECX
    XOR EDX, EDX
    XOR ESI, ESI
    XOR EDI, EDI
    MOV BYTE [N], 0
    MOV BYTE [i], 0
    MOV BYTE [S], 0
    MOV BYTE [T], 0
    MOV BYTE [T2], 0

    mov ebp, esp; for correct debugging
    PRINT_STRING msg1
    GET_STRING TEMP, 50
    LEA EBX, [TEMP]   
    DEC BYTE [T] ;Dec T to ignore terminator in char count, T = -1
    NEWLINE
    
CheckNull:    
    MOV EAX, [TEMP] 
    CMP EAX, 0x00 ;checks if null input
    JE IsNull
         
COUNT:
    MOV EAX, 0    
    MOV AL, [EBX]   ;Move one character from EBX to AL
    
    CMP EAX, 0x20
    JE Space 
    
    INC BYTE [N]   ;N = amt of characters in the string
    Ignoredn:
    INC EBX
    INC BYTE [T]  ;T = amt of chars + space
    INC BYTE [T2]
    
    CMP EAX, 0x21  ;Checks if terminator is !
    JE IsExa
    
    CMP EAX, 0x2E  ;Checks if terminator is .
    JE IsPeriod
    
    CMP EAX,0    ;If not empty, loop
    JNE COUNT  
    
    PRINT_STRING msg6  ;if no terminator
    JE END2    
     
REVERSE:   
    CMP BYTE [ESI], 0
    JE PALLINDROME
    
    INC ESI
    JMP REVERSE

PALLINDROME:
    DEC ESI
    DEC ESI
    LEA EDI, [T2]
    PRINT_STRING msg2
    
    PALLY:
        CMP BYTE [EDI], 0
        JE STOP

        DEC ESI
        DEC BYTE [EDI]
        PRINT_CHAR [ESI]
        JMP PALLY
    
PRINTNORMAL:
    
    CMP EDI, 0
    JE STOP
    
    CMP EDI, 0x2E
    JE STOP
    
    PRINT_CHAR [ESI]
    INC ESI
    DEC EDI
    JMP PRINTNORMAL
    
STOP:       
    NEWLINE
    INC BYTE [S]  ;default one word
    PRINT_STRING msg3  ;print amt of words
    PRINT_UDEC 4, [S]
    NEWLINE
    DEC BYTE[N]
    PRINT_STRING msg4   ;print character count
    PRINT_UDEC 4, [N]
    JMP END

END:
    JMP BITCOUNT
    PRINTBIT:
             PRINT_STRING msg5
             PRINT_UDEC 4, BX 
             
             END2:            
                 NEWLINE
                 PRINT_STRING msg9
                 GET_STRING TEMP, 50
             
                 CMP byte [TEMP], "1"
                 JE AGAIN
                 
                    END3:
                      NEWLINE
                      PRINT_STRING msg10
                      xor eax, eax
                      ret
    
AGAIN:
    NEWLINE
    NEWLINE
    NEWLINE
    JMP CMAIN


IsNull:
    PRINT_STRING msg8
    JMP END2
    
IsMax:
    PRINT_STRING msg7
    JMP END2

IsExa:  
            CharCount1:
            MOV ECX, 42
            MOV EDX, N  
            CMP [EDX], ECX
            JGE IsMax 
    LEA ESI, [TEMP] 
    JMP REVERSE
  
IsPeriod:
            CharCount2:
            MOV ECX, 42
            MOV EDX, N  
            CMP [EDX], ECX
            JGE IsMax 
            
    PRINT_STRING msg2
    MOV EDI, [N]  ;put amt of characters of N to loop print characters in the upcoming codes
    DEC EDI       ;to not print period later
    LEA ESI, [TEMP]
    JMP PRINTNORMAL

Space:
    INC BYTE [S]
    INC BYTE [N]
    JMP Ignoredn

BITCOUNT:
    LEA EDX, [TEMP]
    NEWLINE
    XOR BX, BX              ;clear the insides of BX 
    DEC EDX
    DEC EDX
    BITCOUNTLOOP:
     CMP byte [T], 0
     JLE DEDUCTBIT
    
     MOV CX, 0           ;SET i=0 for loops
     INC EDX
     INC EDX
     MOV AX, [EDX] ;gives 2 val to AX from original string
     DEC BYTE [T]
     DEC BYTE [T]
     
    
    SCAN2CHAR:
        CMP CX, 16 ;scans til 16th bit of AX
        JE BITCOUNTLOOP

        BT AX, CX  ;put to carry flag
        ADC BX,0   ;add carry flag to bx
        INC CX     ;increase CX for the loop
        JMP SCAN2CHAR
        
RemoveTERMINATOR:
    CMP BYTE AH, "!"
    JE DEDUCTEXAMBIT
 
    CMP BYTE AH, "."
    JE DEDUCTPERIODBIT
    
    DEDUCTEXAMBIT:
        SUB BX, 2 
        JMP PRINTBIT
    DEDUCTPERIODBIT:
        SUB BX, 4
        JMP PRINTBIT

DEDUCTBIT:
     CMP byte [T], 255   ;odd amt of characters
     JE RemoveTERMINATOR
     JMP PRINTBIT