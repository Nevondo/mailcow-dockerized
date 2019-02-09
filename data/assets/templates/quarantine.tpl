<html>
  <head>
  <style>
  body {
    font-family: Helvetica, Arial, Sans-Serif;
  }
  table {
    border-collapse: collapse;
    width: 100%;
    margin-bottom: 20px;
  }
  th, td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid #ddd;
    vertical-align: top;
  }
  th {
    background-color: #56B04C;
    color: white;
  }
  tr:nth-child(even){background-color: #f2f2f2}

  </style>
  </head>
  <body>
    <p>Hallo,<br>
    {% if counter == 1 %}
    es wurde 1 neue E-Mail in Ihre persönliche Quarantäne verschoben:<br>
    {% else %}
    es wurden {{counter}} neue E-Mails in Ihre persönliche Quarantäne verschoben:<br>
    {% endif %}
    <table>
    <tr><th>Betreff</th><th>Absender</th><th>Wertung</th><th>Empfangen</th>{% if quarantine_acl == 1 %}<th>Aktionen</th>{% endif %}</tr>
    {% for line in meta %}
    <tr>
    <td>{{ line.subject|e }}</td>
    <td>{{ line.sender|e }}</td>
    <td>{{ line.score }}</td>
    <td>{{ line.created }}</td>
    {% if quarantine_acl == 1 %}
    <td><a href="https://{{ hostname }}/qhandler/release/{{ line.qhash }}">Freigeben</a> | <a href="https://{{ hostname }}/qhandler/delete/{{ line.qhash }}">Löschen</a></td>
    {% endif %}
    </tr>
    {% endfor %}
    </table>
    </p>
  </body>
</html>
