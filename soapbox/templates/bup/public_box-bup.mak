<table width=100%>
    <tr>
        <td style="border-bottom:solid" colspan="3">
            <h1 style="margin-bottom:0">SoapBox</h1>
        </td>
    </tr>
    <tr>
        <td valign=top width="180">
            <a href="/auth/register">Send a message</a></br>
            <a href="/profile/send">Public Inbox</a></br>
            <a href="/auth/register">My Inbox</a></br></br>
            <form action="/change_filter" method="post">
            % for tag in public_tags:
                <input type="checkbox" name="filter_public_tag" value="${tag['uuid']}" />${tag['label']}<br />
            % endfor
            <input type="submit" value="Send" />
            </form>
        </td>
        <td valign=top>
            <table>
                <tr>
                    <h2>Public Inbox</h2>
                        % for message in messages:
                            ${message.body + ' tags: ' + str([tag.label for tag in message.tags])} <br/>
                        % endfor
                </tr>
            </table>
        </td>
        <td width="200" align=center>
            <form action="/auth/login_post" method="post">
                <table style="text-align:left">
                <tr><td>
                <h3 style="margin-bottom:0">Sign in</h3>
                </td></tr>
                <tr><th>Email:</th><td><input type="text" name="email" /></td></tr>
                <tr><th>Password:</th><td><input type="password" name="password" /></td></tr>
                <tr><td><input type="submit" value="Login" /></td></tr>
                </table>
            </form>

Don't have an account? Click <a href="/auth/register">here</a> to register.</br></br>
<div style="text-align:center">Ads</div>
        </td>
    </tr>
</table>
