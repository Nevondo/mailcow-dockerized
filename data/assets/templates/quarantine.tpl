<html>
  <head>
  <meta name="x-apple-disable-message-reformatting" />
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
  td.fixed {
    white-space: nowrap;
  }
  th {
    background-color: #56B04C;
    color: white;
  }
  tr:nth-child(even) {
    background-color: #f2f2f2;
  }
  /* mobile devices */
  @media all and (max-width: 480px) {
    .mob {
    display: none;
    }    
  }
  </style>
  </head>
  <body>
    <p>Hallo {{username}},<br>
    {% if counter == 1 %}
    es wurde 1 neue E-Mail in Ihre persönliche Quarantäne verschoben:<br>
    {% else %}
    es wurden {{counter}} neue E-Mails in Ihre persönliche Quarantäne verschoben:<br>
    {% endif %}
    <table>
    <tr><th>Betreff</th><th>Absender</th><th class="mob">Wertung</th><th class="mob">Aktion</th><th class="mob">Empfangen am</th>{% if quarantine_acl == 1 %}<th>Aktionen</th>{% endif %}</tr>
    {% for line in meta|reverse %}
    <tr>
    <td>{{ line.subject|e }}</td>
    <td>{{ line.sender|e }}</td>
    <td class="mob">{{ line.score }}</td>
    {% if line.action == "reject" %}
      <td class="mob">Abgelehnt</td>
    {% else %}
      <td class="mob">In den Spamordner verschoben</td>
    {% endif %}
    <td class="mob">{{ line.created }}</td>
    {% if quarantine_acl == 1 %}
      {% if line.action == "reject" %}
        <td class="fixed"><a href="https://{{ hostname }}/qhandler/release/{{ line.qhash }}">Freigeben</a> | <a href="https://{{ hostname }}/qhandler/delete/{{ line.qhash }}">Löschen</a></td>
      {% else %}
        <td class="fixed"><a href="https://{{ hostname }}/qhandler/release/{{ line.qhash }}">Kopie zusenden</a> | <a href="https://{{ hostname }}/qhandler/delete/{{ line.qhash }}">Löschen</a></td>
      {% endif %}
    {% endif %}
    </tr>
    {% endfor %}
    </table>
    </p>
  </body>
</html>
