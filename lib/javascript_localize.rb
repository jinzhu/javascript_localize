module JavascriptLocalize
  def include_localized_javascript
    "<script src='/javascripts/locales/#{I18n.locale}.js' type='text/javascript' charset='utf-8'></script>
    <script type='text/javascript'>
       _ = function(str){
         var localeString = __LocaleString[str];
         return (localeString && localeString != '') ? localeString : str;
       }
     </script>"
  end
end
