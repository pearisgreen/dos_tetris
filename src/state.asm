;;; This file contains the main loop and
;;; procedures for handling all the state
;;; of the game being:
;;;     choosing - the player is expected to left click the mouse on the board
;;;                to declare the piece he wants to move
;;;     selected - the player has selected a piece to move
;;;     ai       - the player has selected the destination of the piece and its the ais turn
;;;     done     - the game has concluded
;;;     end      - the game returns to main waiting for player to press any key to close the program
;;;


  include std.asm
  include boardm.asm

  public main_loop

  extrn mouse_board_pos:proc
  extrn piece_at:proc
  extrn board_move:proc

  .data

;;; the var holding the state
;;;  end (0) - choosing (1) - selected (2) - ai (3) - done (4)
game_state db 1


selected_xpos db 0
selected_ypos db 0

  .code


main_loop proc near
  entr 0

@@next_it:

  cmp byte ptr [game_state], 0
  je @@end

  cmp byte ptr [game_state], 1
  je @@next_choosing
  cmp byte ptr [game_state], 2
  je @@next_selected
  cmp byte ptr [game_state], 3
  je @@next_ai
  cmp byte ptr [game_state], 4
  je @@next_done

;;; TODO: invalid state here exit with error

@@next_choosing:
  call choosing_state
  jmp @@next_state
@@next_selected:
  call selected_state
  jmp @@next_state
@@next_ai:
  call ai_state
  jmp @@next_state
@@next_done:
  call done_state


@@next_state:
  jmp @@next_it

@@end:

  leav
  ret
  endp

done_state proc near
  entr 0

  mov byte ptr [game_state], 0

  leav
  ret
  endp


choosing_state proc near
  entr 0

  ;; ax - xpos (0-7) | bx - ypos (0-7)
  ;; dx - 1 valid | 0 invalid
  call mouse_board_pos
  cmp dx, 1
  jne @@done

  ;; check if selected piece is white
  push ax
  push bx
  board_dword_byte
  push_args<ax>
  call piece_at
  pop_args

  ;; if first bit is set piece is white
  and ax, 8
  jnc @@done

  mov byte ptr [game_state], 2

  ;; TODO: calculate possible moves

  pop bx
  pop ax
  mov byte ptr [selected_xpos], al
  mov byte ptr [selected_ypos], bl


@@done:
  leav
  ret
  endp

selected_state proc near
  entr 0

  ;; ax - xpos (0-7) | bx - ypos (0-7)
  ;; dx - 1 valid | 0 invalid
  call mouse_board_pos
  cmp dx, 1
  jne @@done

  ;; TODO: check if valid move

  board_dword_byte
  mov dx, ax

  xor ax
  mov al, byte ptr [selected_xpos]
  mov bl, byte ptr [selected_ypos]
  board_dword_byte

  mov bx, ax
  mov al, dl
  mov ah, bl

  push_args<ax>
  call board_move
  pop_args

  ;; TODO: change state to ai state
  mov byte ptr [game_state], 1

@@done:
  leav
  ret
  endp

ai_state proc near
  entr 0


  leav
  ret
  endp


  end
