DEFAULT_PREFIX = "+855"

jQuery ->
  phoneNumberInput = $('*[data-mobile-phone-number]')
  return if !phoneNumberInput.length
  phoneNumberInput.mobilePhoneNumber(defaultPrefix: DEFAULT_PREFIX)
  phoneNumberInput.keyup (e) ->
    if phoneNumberInput.val().length == 1 && e.keyCode != 8
      phoneNumberInput.val(DEFAULT_PREFIX + phoneNumberInput.val())
