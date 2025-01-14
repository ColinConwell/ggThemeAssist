jscodeHeight <-
  'document.addEventListener("DOMContentLoaded", function(event) {
    var jsHeight = window.innerHeight;
    Shiny.setInputValue("ViewerHeight", jsHeight);
  });'

jscodeWidth <-
  'document.addEventListener("DOMContentLoaded", function(event) {
    var jsWidth = window.innerWidth;
    Shiny.setInputValue("ViewerWidth", jsWidth);
  });'

jsColourSelector <- I(
  '{
  option: function(item, escape) {
  return "<div><div style=\'width:25px; height:15px; background-color:" + item.rgb + "; float:left; vertical-align:bottom\'></div>&nbsp;" + escape(item.name) + "</div>";
  }
  }')
