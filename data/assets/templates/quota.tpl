<html>
  <head>
  <style>
  body {
    font-family: sans-serif;
  }
  #progressbar {
    background-color: #f0f0f0;
    border-radius: 0px;
    padding: 0px;
    width:50%;
  }  
  #progressbar > div {
    background-color: #ff9c9c;
    width: {{percent}}%;
    height: 20px;
    border-radius: 0px;
  }
  </style>
  </head>
  <body>
    <p>Hallo {{username}},<br><br>
    Ihr Postfach ist zu {{percent}}% gefüllt, bitte erwägen Sie das Löschen alter Nachrichten, um weiterhin neue E-Mails zu erhalten.<br> 
    <div id="progressbar">
      <div></div>
    </div>
    </p>
  </body>
</html>
