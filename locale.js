_ = function(str){
  var localeString = __LocaleString[str];
  return (localeString && localeString != '') ? localeString : str;
}

// __LocaleString = {
//   'example' : 'example'
// }
//  _('example')
