exports.new = (req, res)->
  errorMessage = req.flash('error')
  usernameClass = null
  passwordClass = null

  if String(errorMessage).match /missing.credentials/i
    usernameClass = passwordClass = "warning"

  usernameClass = "error" if String(errorMessage).match /username/i
  passwordClass = "error" if String(errorMessage).match /password/i

  res.render 'login', {
    message: errorMessage
    usernameClass: usernameClass
    passwordClass: passwordClass
  }


exports.create = (req, res)->
  