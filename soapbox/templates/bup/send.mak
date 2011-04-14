<form action="/messages/send" method="post">
    <table style="text-align:left">
    <tr><td>
    <h3>Send a message</h3>
    </td></tr>
    <tr><th>Subject</th></tr><tr><td><input size="100" type="text" name="subject" /></td></tr>
    <tr><th>Message</th></tr><tr><td><textarea name="body" cols=80 rows=12></textarea></td></tr>
<tr><td>
    % for tag in available_tags:
        <input type="checkbox" name="public_tag" value="${available_tags.index(tag)}" />${tag['label']}<br />
    % endfor
<input type="checkbox" name="personal_tag" value="${personal_tag.keys()[0]}" />Tag as me: ${personal_tag.values()[0]['label']}<br />
</td></tr>
    <tr><td><input type="submit" value="Send" /></td></tr>
    </table>
</form>	
