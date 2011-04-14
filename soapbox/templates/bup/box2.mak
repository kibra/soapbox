<table width=100%>
    <tr>
        <td style="border-bottom: solid" colspan="3", valign=top>
            <h1 style="margin-bottom:-18">SoapBox</h1><div style="float:right">${user.email} | <a href="/box/myaccount">My Account</a> | <a href="/box/logout">Sign out</a></div>
        </td>
    </tr>
    <tr>
        <td width="180" valign=top>
            <a href="/box/send">Send a message</a></br>
            <a href="/box/send">Public Inbox</a></br>
            <a href="/box/send">My Inbox</a></br></br> 
        </td>
        <td valign=top>
            <table>
                <tr>
                    <h2>My Inbox</h2>
                    % for message in messages:
                        ${message.body + ' tags: ' + str([tag.label for tag in message.tags])} <br/>
                    % endfor
                </tr>
            </table>
        </td>
        <td width="200" align=center, valign=top>
            Ads
        </td>
    </tr>
</table>
