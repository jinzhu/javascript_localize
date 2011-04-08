module JavascriptLocalize
  module Methods

    # _ = function(str,opt){
    #   var localeString = __LocaleString[str];
    #   localeString = (localeString && localeString != '') ? localeString : str;
    #
    #   if(opt){
    #     fn = new Function("obj",
    #         "var p=[],print=function(){p.push.apply(p,arguments);};" +
    #
    #         "with(obj){p.push(\"" +
    #         localeString
    #         .replace(/[\t]/g, " ")
    #         .replace(/\"/g, '\\"')
    #         .split("{{").join("\t")
    #         .replace(/\t(.*?)}}/g, "\",function(){ try { return $1 }catch(err){ return '$1 undefined'} }.apply(this),\"")
    #         + "\");};return p.join('');");
    #
    #     return fn.call(this,opt)
    #   }else{
    #     return localeString
    #   }
    # }

    def include_localized_javascript
      return %Q{
      <script src='/javascripts/locales/#{I18n.locale}.js' type='text/javascript' charset='utf-8'></script>
      <script type='text/javascript'>
        _ = function(str,opt){
          var localeString = __LocaleString[str];
          localeString = (localeString && localeString != '') ? localeString : str;

          if(opt){
            fn = new Function("obj",
                "var p=[],print=function(){p.push.apply(p,arguments);};" +

                "with(obj){p.push(\\"" +
                localeString
                .replace(/[\\t]/g, " ")
                .replace(/\\"/g, '\\\\"')
                .split("{{").join("\\t")
                .replace(/\\t(.*?)}}/g, "\\",function(){ try { return $1 }catch(err){ return '$1 undefined'} }.apply(this),\\"")
                + "\\");};return p.join('');");

            return fn.call(this,opt)
          }else{
            return localeString
          }
        }
      </script>
      }
    end
  end

  class Railtie < ::Rails::Railtie
    initializer :include_javascript_localize do |app|
      ActionView::Base.send :include, JavascriptLocalize::Methods
    end
  end
end
