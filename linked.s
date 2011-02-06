    extern malloc
    extern putchar
    extern puts

section .data
    size_i:             ; Used to determine the size of the structure
    struc node
        info: resd  1
        next: resd  1
    endstruc
    len: equ $ - size_i  ; Size of the data type

    nullMes:    db  'Null pointer - the list is void', 0
    addMes:     db  'Adding a new element', 0
    printMes:   db  'Printing a linked list:', 0

section .bss
    prim:   resd  1

section .text
    global main

main:
    push ebp            ; Standard procedure entry
    mov ebp, esp

    mov dword [prim], 0 ; Pointer is NULL initially - the list is void

    push dword 'a'      ; Element to add to the list
    push prim           ; Address of the first element in the list and pass it to the init function, through the stack
    call append         ; Call the init function

    push dword 'b'
    push prim
    call append

    push dword 'c'
    push prim
    call append
    
    push dword 'c'
    push prim
    call append

    push dword 'c'
    push prim
    call append

    push dword 'c'
    push prim
    call append

    push dword 'c'
    push prim
    call append

    push dword 'c'
    push prim
    call append

    push dword 'c'
    push prim
    call append

    push dword 'c'
    push prim
    call append

    mov ecx, 10000
zzzZZZ:
    push ecx            ; I don't know yet why or where ecx is changed, but if I don't save it, the loop breaks and becomes infinite
    push dword 'Z'
    push prim
    call append
    pop ecx
    loop zzzZZZ

    push dword [prim]
    call print

    mov esp, ebp        ; Restore the stack
    pop ebp
    ret

; Procedure: append
; Appends and element at the end of a linked list
; If the linked list is void, initialize the list
; Params (in order of pushing on the stack):
;           dword element - data to be added
;           dword prim    - first element in the list
; Return: none
; Modifies the value of prim if it is null

append:
    push ebp            ; Save the stack
    mov ebp, esp

    push eax            ; Save the registers
    push ebx

    push len            ; Size to get from the heap and pass the size to the malloc function
    call malloc         ; Call the malloc function - now eax has the address of the allocated memory

    mov ebx, [ebp + 12]
    mov [eax + info], ebx    ; Add the element to the node data field
    mov dword [eax + next], 0   ; Address of the next element is NULL, because it is the last element in the list

    mov ebx, [ebp + 8]  ; Retrieve the address to the first element
    cmp dword [ebx], 0
    je null_pointer

    mov ebx, [ebx]      ; This parameter was the address of the address
                        ; Now it is the address of the first element, in this case, not null
    ; If it is not NULL, find the address of the last element
next_element:
    cmp dword [ebx + next], 0
    je found_last
    mov ebx, [ebx + next]
    jmp next_element

found_last:
    push eax
    push addMes
    call puts
    add esp, 4              ; Restore the stack
    pop eax

    mov [ebx + next], eax   ; Last element is this one from the newly allocated memory block

go_out:
    pop ebx             ; Restore registers
    pop eax
    
    mov esp, ebp
    pop ebp
    ret 8               ; Return to the caller function and cleaning the stack

null_pointer:
    push eax
    push nullMes
    call puts
    add esp, 4
    pop eax
    
    mov [ebx], eax      ; Point the address of the first element to the allocated memory

    jmp go_out

; Procedure: print
; Prints the elements of a linked list
; The elements are considered ASCII characters, otherwise things might blow in your face with various degrees of terribleness
; Params (in order of pushing on the stack):
;           dword prim - address of the first element
; Return: none

print:
    push ebp
    mov ebp, esp

    push ebx
    mov ebx, [ebp + 8]  ; Address of the first element
    cmp ebx, 0
    je done

    push eax
    push printMes       ; Print message "Printing a linked list"
    call puts
    add esp, 4
    pop eax

next_char:
    push dword [ebx + info]
    call putchar
    mov ebx, [ebx + next]
    cmp ebx, 0
    jne next_char
    
    push dword 10
    call putchar

done:
    pop ebx
    mov esp, ebp
    pop ebp
    ret 4
