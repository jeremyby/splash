validate_email = (email) ->
  re = /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i
  
  return re.test(email)

mark_error = (el) ->
  el.addClass('error')

reset_field = (el) ->
  el.removeClass('error')

check_email = (f) ->
  if !validate_email(f.val())
    mark_error(f)
    return false
  else
    reset_field(f) 
    return true
    
input_change_checker = ->
  input_on_change($('#email'))

  setTimeout(input_change_checker, 30)

input_on_change = (array) ->
  array.each(->
    if $(this).val()
      $(this).next().hide()
    else
      $(this).next().show()
    )


$(document).ready ->
  input_change_checker()
  
  $('.line input:submit').click (e) ->
    e.preventDefault() unless check_email($('#email'))
  
  $('#email').focus ->
    reset_field($(this))
    $(this).next().addClass('light')
    
  $('#label').click ->
    $('#email').focus()
    
  $('#email').blur (e) ->
    $(this).next().removeClass('light')