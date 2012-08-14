"
" set the t register such that it runs a TM when invoked as a macro!
function! s:setTuringMachineRegister()
  " First we mark the current position, @t will always be invoked with the 
  " current position on the read write head, thus we start by marking it
  let @t = 'mh'
  " then we read the current char into the @c register and the current state into 
  " the @s register
  let @t .= '"cxP2G"sy$'
  " Now we will search for the combination of the two, if they are not found
  " the macro, and thus the turing machine will halt, otherwise we move to
  let @t .= '/=@s =@c'
  " the new state that we will now save in the @s register and the new character
  let @t .= 'f f l"syew'
  " that we will save into the @c register
  let @t .= '"cxPll"dxp'
  " now we will add LhRl to the end of the line, see it as a lookup table
  " that will be used to translate L -> h and R -> l
  let @t .= 'ALhRl'
  " now we will add the submacro x that will translate and remove the translation
  " matrix again
  let @t .= 'F=@dl"dx$xxx'
  " and store it and delete the line go back to the end of the state transition line
  let @t .= '0"xy$ddk$'
  " and execute the macro
  let @t .= '@x'
  " Now we update the state
  let @t .= '2Gc$=@s'
  " And now the character
  let @t .= '`hxi=@c'
  " And finally, after all the trouble to set the @d register up correctly we use
  " it to move the read write head to the correct position
  let @t .= '@d'
  " and tail recurse on ourself 
  let @t .= '@t'
endfunction

call s:setTuringMachineRegister()
