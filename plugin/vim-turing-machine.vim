"
" set the t register such that it runs a TM when invoked as a macro!
"
" the TM itself is described as follows
"
" * tape -> 1st line (head position is represented by cursor position )
" * current state -> 2nd line
" * transitions from 3rd line in the form:
"      <old_state><space><old_symbol><space><new_state><space><new_symbol><space><direction>
"      all lines not starting with a state can be used as comments savely
"
"  Example:
"
"  010100 |
"  start
"  * A bit inverter start it at first column by running @t
"  start 0 start 1 R
"  start 1 start 0 R
"  start   accept * L
function! s:setTuringMachineRegister()
  let @t = ''
  " stores @s and @c
  call s:setCurrentState()
  " looks for @s and @c in transition table and halts if not found!
  call s:findTransition()
  " changes @s and @c to new values, store L or R into @d
  call s:recomputeState()
  " translate L --> h, R --> l
  call s:transformDirectionIntoMovement()
  " and now execute the transition and ...
  call s:executeTransition()
  " ... merrily loop :-O
  call s:loop()
endfunction

function! s:executeTransition()
  " prepare a temporary writer macro that overwrites the symbol --> @y
  let @t .= 'or"cp0"yy$dd'
  " prepare a temporary writer macro that overwrites the state  --> @x
  let @t .= 'ocw"sp0"xy$dd'
  " go to the state lined and execute @x
  let @t .= '2G@x'
  " go back to r/w head and execute @y and the direction movement
  let @t .= '`h@y@d'
endfunction

function! s:findTransition()
  " As we do not want to use the the expression register we use a temporary macro f
  " that we prepare at the end of the buffer
  let @t .= 'Go/^"spA "cpA0"fy$dd'
  let @t .= "3G@f"
  " Now that we have found the transition (or halted our TM) we just skip over to <new_state>
  let @t .= "ww"
endfunction

function! s:loop()
  let @t .= '@t'
endfunction

function! s:recomputeState()
  " We have found a transition and are on <new_state>
  " we store it into @s and move to <new_symbol>
  let @t .= '"syew'
  " same for @c
  let @t .= '"cyew'
  " eventually we yank direction into @d
  let @t .= '"dyw'
endfunction

function! s:setCurrentState()
  " First we mark the current position, @t will always be invoked with the 
  " current position on the read write head, thus we start by marking it
  let @t .= 'mh'
  " then we read the current char into the @c register and the current state into 
  " the @s register
  let @t .= '"cxP2G"sy$'
endfunction

function! s:transformDirectionIntoMovement()
  " we will again use the approach from findTransition to create a temporary macro
  " that will do the transfomrmation, but in addition we will write a temporary
  " translation table (ttt) LhRl on which @x will operate.
  let @t .= 'GoLhRl'
  " now a tmp line for @z, which will find @d backwards in the ttt
  let @t .= 'oF"dp0"zy$dd'
  " we deleted the tmp line for @z, thus we are on the ttt line now
  let @t .= '$@zx"dxdd'
endfunction

call s:setTuringMachineRegister()
