.model small
.stack 100h
.data
  INVENTORY_SIZE equ 40
  ; inventory on id, name, quantity, price, priority level
  inventory dw 0,1,2,3,4,5,6,7,8,9
            db "Sunglasses",  "Rings     ", "Socks     ", "Heels     ", "Sneakers  ", "Necklace  ", "Bracelets ", "Pants     ", "Tshirts   ", "Lipbalm   "
            dw 13, 20, 18, 7, 5, 13, 9, 3, 10, 12, 4, 7, 3, 1, 2, 7, 5, 2, 7, 9, 1, 0, 1, 1, 2, 0, 1, 2, 0, 1, '$'
  
  inventory_id_offset dw 0
  inventory_name_offset dw 20
  inventory_quantity_offset dw 120
  inventory_price_offset dw 140
  sales dw 12,15,30,24,22,99,61,47,89,10,'$' ; quantity sold & total price
  item_price dw 2, 5, 7, 12, 6, 15, 11, 12, 17, 19, '$'
  total_sales dw 0
  
  ; syntax formatting
  crlf db 13,10,'$'
  sline db 13,10, '----------------------------------------------' ,'$'
  dline db 13,10, '==============================================' ,'$'
  dotted db '**********************************************','$'

  ; main menu
  menu db 13, '----------<CAREN BEAUTY BAR>----------',13,10, '------------------MAIN MENU-----------------', 13, 10, 10 ,'1. View Inventory',13,10,'2. Restock Item',13,10,'3. Sell Items',13,10, '4. Sort Items',13,10,'5. Sales Report',13,10,'0. Exit the Program',13,10,'$'
  invalid_input db 13,10,'Invalid input. Please try again.',13,10,'$'
  
  ; CRUD labels
  ; view inventory  
  inventory_header db 13,10, '----------<CAREN BEAUTY BAR>----------',13,10, '----------------<INVENTORY>-----------------',13,10,'ID',9,'Name',9,9, 'Quantity',9, 'Price',13,10,'$'
  inventory_label db '==============================================', 13, 10, 'Items that needs to be restock are displayed as YELLOW!', 13, 10, '==============================================', 13, 10, '1. Back to Main Menu', 13, 10,  '2. Restock Items', 13, 10, '3. Sell Items', 13, 10 , 13, 10,'Enter your choice: $'
  
  stock_amount dw ?
  stock_id dw ?

  ; add items
  restock_label db '==============================================', 13, 10,9,9, 32,32,'RESTOCK ITEM', 13, 10, '==============================================', 13, 10, 'Select an item ID to restock: $'
  restock_amount_label db 13, 10, 'Enter the amount to restock (between 1-9): $'
  restock_success db 13, 10, 'Item has been restocked successfully!', 13, 10, '$'
  ; sell items 
  sell_item_id_label db '==============================================', 13, 10,9,9, 32,32,'SELL ITEM', 13, 10, '==============================================', 13, 10,  'Enter the item ID to sell: $'
  sell_item_amount_label db 13, 10, 'Enter the amount to sell (between 1-9): $'
  sell_item_success db 13, 10, 'Item has been sold successfully!', 13, 10, '$'
  sell_item_fail db 13, 10, 'Item cannot be sold, not enough quantity!', 13, 10, '$'

  ;categorize inventory
  sort_inventory_label db 13, '==============================================', 13, 10,9,'SORT INVENTORY BY STOCK COUNT', 13, 10, '==============================================', 13, 10, '1. Back to Main Menu', 13, 10, '2. In Stock', 13, 10, '3. Low/Out Of Stock', 13, 10, 13, 10, 'Enter your choice: $'
  low_stock_label db 13, 10, 'Items are Low On Stock!', 13, 10, '$'
  no_stock_label db 13, 10, 'Items are Out Of Stock!', 13, 10, '$'
  on_stock_label db 13, 10, 'Items are In Stock!', 13, 10, '$'
  
  ;sales made
  sales_header db 13,10, '-----------------------<CAREN BEAUTY BAR>--------------------',13,10, '----------------------------<SALES REPORT>-------------------------',13,10,'ID',9,'Name',9,9, 'Quantity Sold',9, 'Price/unit', 9, 'Total Earned',13,10,'$'
  sales_label db '=================================================================', 13, 10, 9,9,32,32,9,'SALES OF THE DAY', 13, 10, '=================================================================', 13, 10, '1. Back to Main Menu', 13, 10, '0. Exit the Program', 13, 10 , 13, 10,'Enter your choice: $'

  user_choice db 13, 10, 'Enter your choice: $'
  user_quit db 13, 10, 'Thanks for using the program. See you again.','$'

.code
main proc
  mov ax, @data ; set data segment
  mov ds, ax ; set data segment register
  
  
  call draw_menu                      ;Display the menu
  
  ;Prompt user to enter choice
  mov ah, 01h                          ; read character  
  int 21h
  
                                            
  cmp al, '1'                           ;Check user input
  je view_inventory_interface
  
  cmp al, '2'
  je restock_inventory_interface
  
  cmp al, '3'
  je sales_inventory_interface

  cmp al, '4'
  je sort_inventory_interface
  
  cmp al, '5'
  je sales_report_interface
  
  cmp al, '0'
  je exit_program_interface

  jmp main

; ************* INTERFACE FUNCTIONS **********

  view_inventory_interface:
    call clear_screen
    call view_inventory
    call user_navigate
    ret
  restock_inventory_interface:
    call clear_screen
    call view_inventory
    call restock_inventory
    ret
  sales_inventory_interface:
    call clear_screen
    call view_inventory
    call sales_inventory
    ret
  sort_inventory_interface:
    call sort_inventory
    call user_navigate
    ret
  sales_report_interface:
    call sales_report
    call sales_navigate
    ret
  exit_program_interface:
    call clear_screen
    call exit_program
    ret


; *********** SUBROUTINE FUNCTION ************

user_navigate:
                                    ; Code to navigate user
  lea dx, inventory_label
  mov ah, 09h
  int 21h

  mov ah, 01h ; read character
  int 21h

  cmp al, '0'
  je exit_program_interface

  cmp al, '1'
  je main

  cmp al, '2'
  je restock_inventory_interface
  
  cmp al, '3'
  je sales_inventory_interface
  
  jmp main
  ret
sales_navigate:
  lea dx, sales_label
  mov ah, 09h
  int 21h

  mov ah, 01h ; read character
  int 21h

  cmp al, '0'
  je exit_program_interface
  
  jmp main
  ret
print_int:  
                           ; convert the word to a string and print it
  push bx 
  mov bx, 10 
  xor cx, cx 
  convert_loop:
    xor dx, dx 
    div bx 
    add dl, '0' 
    push dx 
    inc cx 
    cmp ax, 0 
    jne convert_loop 
  print_loop2:
    pop dx 
    mov ah, 02 
    int 21h 
    dec cx 
    cmp cx, 0 
    jne print_loop2 
    pop bx 
    ret

check_int:
                       ; check if the inventory is less than or equal to 5
  mov bx, ax
  cmp bx, 5
  jle print_yellow_color
  ret

print_string:
                        ; Print a string of characters
  push ax 
  push bx
  push cx
  mov bx, dx 
  mov cx, 10 
  print_loop:
    mov dl, [bx] 
    int 21h 
    inc bx 
    loop print_loop      ; repeat until 10 characters are printed
  print_done:
  pop cx 
  pop bx
  pop ax
  ret

print_yellow_color:
                         ; Print a string of characters
  
  push ax 
  push bx
  push cx
  mov bx, dx 
  mov cx, 10 
  print_loop3:
    mov dl, [bx] 
    mov ah, 0Eh
    mov al, dl 
    mov bl, 04h           ; set background color to black with blink
    or bl, 80h
    int 10h
    inc bx 
    loop print_loop3      ; repeat until 10 characters are printed
  print_done3:
  pop cx 
  pop bx
  pop ax
  ret


                         ;************** CRUD FUNCTIONS **************

draw_menu:
                         
  call clear_screen
  lea dx, menu
  mov ah, 09h
  int 21h
  
  lea dx, user_choice
  mov ah, 09h
  int 21h
  ret

view_inventory:
 
  mov dx, offset inventory_header
  mov ah, 09
  int 21h
  
  mov bp, 0
  lea si, inventory

  loop_start:
    mov ax, [si] 
    cmp ax, 10 
    ja done 
    call print_int 

    call print_tab

    mov dx, offset inventory + 20 
    add dx, bp 
    call print_string 
    mov ax, [si + 120] 
    call check_int               ; check if stock is less than or equal to 5

    call print_tab
    
    mov ax, [si + 120] 
    call print_int

    call print_double_tab
    
    mov ax, [si + 140]
    call print_int
    call print_newline

    add bp, 10
    add si, 2 
    jmp loop_start 
  done:
  ret

restock_inventory:               ;code for restocking inventory

  lea dx, restock_label
  mov ah, 09h
  int 21h 

  mov ah, 01
  int 21h

  sub al, 30h 
  add al, al
  sub ax, 136
  mov stock_id, ax 

  lea dx, restock_amount_label
  mov ah, 09h 
  int 21h

  mov ah, 01
  int 21h
  sub al, 30h
  sub ax, 256
  mov cx, ax

  lea si, inventory
  add si, stock_id
  add cx, [si]
  mov word ptr [si], cx 
  
  call clear_screen
  call print_newline
  call print_asterisk
  lea dx, restock_success
  mov ah, 09h 
  int 21h 
  call print_asterisk
  call print_newline
  call view_inventory
  call user_navigate
  ret

sales_inventory:                       ;code to show all the sales in the system
 
  lea dx, sell_item_id_label
  mov ah, 09h
  int 21h 

  mov ah, 01
  int 21h

  sub al, 30h 
  add al, al 
  sub ax, 136 
  mov stock_id, ax 

  lea dx, sell_item_amount_label
  mov ah, 09h 
  int 21h

  mov ah, 01
  int 21h
  sub al, 30h
  sub ax, 256
  mov cx, ax

  lea si, inventory
  add si, stock_id
  mov bx, [si] 
  sub bx, cx
  cmp bx, 0
  js reset_quantity

  mov word ptr [si], bx
  jmp sold_quantity

  reset_quantity: 
    mov bx, [si]
    mov word ptr [si], bx
    call clear_screen
    call print_newline
    call print_asterisk
    lea dx, sell_item_fail
    mov ah, 09h 
    int 21h 
    call print_asterisk
    call print_newline
    call view_inventory
    call user_navigate
    ret 
  
  sold_quantity:
    call sales_done
    call clear_screen
    call print_newline
    call print_asterisk
    lea dx, sell_item_success
    mov ah, 09h 
    int 21h 
    call print_asterisk
    call print_newline
    call view_inventory
    call user_navigate
    ret
  sales_done: 
    mov ax, stock_id 
    sub ax, 120 
    mov stock_id, ax
    lea si, sales 
    add si, stock_id
    mov ax, [si]
    add cx, ax 
    mov word ptr [si], cx
    ret
  ret

sort_inventory:                        ;code to sort inventory in thr system

  call clear_screen
  lea dx, sort_inventory_label
  mov ah, 09h 
  int 21h 
  
  mov ah, 01h 
  int 21h 
   
  cmp al, '2'
  je in_stock_prompt
  
  cmp al, '3' 
  je low_in_stock_prompt 
  
  cmp al, '1'
  call main

  ret

in_stock_prompt:
  call clear_screen
  mov dx, offset inventory_header
  mov ah, 09
  int 21h
  
  mov bp, 0
  lea si, inventory

  loop_start2:
    mov ax, [si] 
    cmp ax, 10 
    ja end2

    mov ax, [si + 120] 
    cmp ax, 6 
    jl done2 

    mov ax, [si]
    call print_int 

    call print_tab

    mov dx, offset inventory + 20 
    add dx, bp 
    call print_string 
    mov ax, [si + 120] 
    call check_int 

    call print_tab
    
    mov ax, [si + 120] 
    call print_int

    call print_double_tab
    
    mov ax, [si + 140]
    call print_int
    call print_newline

    add bp, 10
    add si, 2 
    jmp loop_start2 
  done2:
    add bp, 10
    add si, 2
    jmp loop_start2
    ret 
  end2:
    ret
  ret

low_in_stock_prompt:          ;code to show items low in stock
  call clear_screen
  mov dx, offset inventory_header
  mov ah, 09
  int 21h
  
  mov bp, 0
  lea si, inventory

  loop_start3:
    mov ax, [si] 
    cmp ax, 10 
    ja end3

    mov ax, [si + 120] 
    cmp ax, 5 
    jg done3

    mov ax, [si]
    call print_int 

    call print_tab

    mov dx, offset inventory + 20 
    add dx, bp 
    call print_string 
    mov ax, [si + 120] 
    call check_int 

    call print_tab
    
    mov ax, [si + 120] 
    call print_int

    call print_double_tab
    
    mov ax, [si + 140]
    call print_int
    call print_newline

    add bp, 10
    add si, 2 
    jmp loop_start3 
  done3:
    add bp, 10
    add si, 2
    jmp loop_start3
    ret 
  end3:
    ret
  ret 

sales_report:
  call clear_screen
                                    ; Code to generate sales reports
  mov dx, offset sales_header
  mov ah, 09
  int 21h

  mov bp, 0
  lea si, inventory
  mov bx, offset sales 
  mov di, offset item_price 

  loop_start5:
    mov ax, [si] 
    cmp ax, 10 
    ja done5 
    call print_int 

    call print_tab

    mov dx, offset inventory + 20 
    add dx, bp 
    call print_string 

    call print_tab

    mov ax, [bx]
    call print_int

    call print_double_tab
  
    mov ax, [si + 140]
    call print_int
  
    call print_double_tab

    mov cx, [bx]
    mov ax, [di]
    mul cx
    call print_int
  
    call print_newline

    add bp, 10
    add si, 2 
    add bx, 2 
    add di, 2
    jmp loop_start5 
  done5:
    
  ret


; ************* HELPER FUNCTIONS ***************

exit_program:
                          ; Code to exit program
  call draw_line

  lea dx, user_quit
  mov ah, 09h
  int 21h 
  
  call draw_line

  mov ah, 4ch
  int 21h

clear_screen:
                          ; Function to clear the screen
  mov ah, 06h
  mov al, 0
  mov bh, 07h
  mov cx, 0
  mov dx, 184Fh
  int 10h
  ret

draw_line:
                           ; Function to draw a line
  lea dx, sline
  mov ah, 09h
  int 21h
  ret

print_tab:
  mov dl, 09
  mov ah, 02
  int 21h
  ret

print_double_tab:
  mov dl, 09
  mov ah, 02
  int 21h

  mov dl, 09
  mov ah, 02
  int 21h
  ret

print_newline:
  mov dl, 0ah
  mov ah, 02
  int 21h
  ret
print_asterisk:
  lea dx, dotted
  mov ah, 09h 
  int 21h 
  ret

main endp
end main
