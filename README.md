# traitify-client-auth

Use this code in the client to create an assessment. 

    <html>
    <head>
    <title>Here</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script>
      // This gets the query parameters out of the url bar
      (function($) {
      $.QueryString = (function(a) {
      if (a == "") return {};
      var b = {};
      for (var i = 0; i < a.length; ++i){
      var p=a[i].split('=');
      if (p.length != 2) continue;
      b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
      }
      return b;
      })(window.location.search.substr(1).split('&'))
      })(jQuery);
    </script>
    </head>
    <body>
    <!-- this is the url that makes the get request for the temporary token -->
    <a href="http://localhost:8080/temp_key?public_key=qiohnq1emjqmiebinnli9lskfv">Get Token</a>
    <script>
      // This makes the post to get the assessment id
      if($.QueryString["temp_key"]){
         $.ajax({
            url: "http://localhost:8080/assessments?temp_key="+$.QueryString["temp_key"],
            type: "POST",
            crossDomain: true,
            success: function (response) {
                console.log(response.id)
            },
            error: function (xhr, status) {
                alert("error");
            }
        });
      }
    </script>
    </body>
    </html>
