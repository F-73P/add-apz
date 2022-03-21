;v1.00

;addition of arbitrary-precision non-negative integers, sum stored in memory address of first addend 
;input: R0 = number of digits of first addend, R1 = address of least significant digit of first addend 
;R2 = number of digits of second addend, R3 = address of least significant digit of second addend

;return value: R0 = number of digits of sum (R0 or R0+1)

            AREA add_non_negative_apz_area,CODE,READONLY             
            EXPORT add_non_negative_apz

            ENTRY			
add_non_negative_apz     
            PUSH {R4,R5,R6,R7}
            CMP R0,R2
            BPL start
;;;;;;;;;;			
			MOV R7,R0 ;first addend shorter than second addend
            
            LDR R4,[R1] ;R4 = least significant digit of shorter addend
            LDR R5,[R3],#4 ;R5 = least significant digit of longer addend
            
            ADDS R4,R4,R5
            STR R4,[R1],#4 ;store sum of LSD's and increment memory address
loop_1_2    SUB R0,R0,#1
            CBZ R0,section_1_2 ;branch if no more digits in shorter addend            
    
            LDR R4,[R1] ;R4 = next digit of shorter addend 
            LDR R5,[R3],#4 ;R5 = next digit of longer addend 
            
            ADCS R4,R4,R5
            STR R4,[R1],#4                       
            B loop_1_2
            
section_1_2 SUB R0,R2,R7
            LDR R4,[R3],#4
            ADCS R4,R4,#0
            STR R4,[R1],#4
loop_2_2    SUB R0,R0,#1
            CBZ R0,section_2_2 ;branch if no more digits in longer addend
            LDR R4,[R3],#4
            ADCS R4,R4,#0
            STR R4,[R1],#4            
            B loop_2_2
            
section_2_2 BCC exit_2
            MOV R4,#1
            STR R4,[R1]
            ADD R2,R2,#1
       
exit_2      MOV R0,R2
            POP {R4,R5,R6,R7}

            BX lr
;;;;;;;;;;           
start       MOV R7,R2 ;first addend longer than or equal to second addend            
            			
			LDR R4,[R1] ;R4 = least significant digit of longer addend
            LDR R5,[R3],#4 ;R5 = least significant digit of shorter addend 
			
            ADDS R4,R4,R5
            STR R4,[R1],#4
loop_1      SUB R2,R2,#1
            CBZ R2,section_1            
    
            LDR R4,[R1] ;R4 = next digit of longer integer
            LDR R5,[R3],#4 ;R5 = next digit of shorter integer
            
            ADCS R4,R4,R5
            STR R4,[R1],#4                      
            B loop_1
            
section_1   SUB R2,R0,R7
loop_2      CBZ R2,section_2
            LDR R4,[R1]
            ADCS R4,R4,#0
            STR R4,[R1],#4
            SUB R2,R2,#1
            B loop_2
            
section_2   BCC exit
            MOV R4,#1
            STR R4,[R1]
            ADD R0,R0,#1
       
exit        POP {R4,R5,R6,R7}
            BX lr
			
            END

