" ((((h
"
" set the t register such as it runs a TM 
" when invoked as a macro!
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
  let @t .= '"cxPl'
  " and the direction that we will save in the @d register 
  " but we want to store a 'l' for 'R' and a 'h' for 'L'
  " first we store the 'h' into the @d register
  let @t .= 'ah"dx'
  " and now we look for an R and store a 'l' if we find one
  " for that we prepare a test register @x by writing it's content into this
  " line first and then deleting it into @x
  let @t .= 'AfRal"dx'
  " note the double escape above, we need the <Escape> be escaped when we yank
  " it into @x, which we are doing now, N.B the dff will leave the last x, which
  " we add to @X with x
  let @t .= '"xdFf"Xx' 
  " and now we run @x after moving to the left of 'L' or 'R'
  let @t .= 'h@x'
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
