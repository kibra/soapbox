All messsages <br/>
% for message in messages:
    ${message.body + ' by: ' + str(message.author)} <br/>
% endfor
 <br/>
<a href="/auth/logout">Logout</a>
