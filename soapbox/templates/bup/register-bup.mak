<table width=100%>
    <tr>
        <td style="border-bottom:solid" colspan="3">
            <h1 style="margin-bottom:0">SoapBox</h1>
        </td>
    </tr>
    <tr>
        <td valign=top width="180">
            <a href="/auth/register">Send a message</a></br>
            <a href="/box/send">Public Inbox</a></br>
            <a href="/auth/register">My Inbox</a></br></br>
            </form>
        </td>
        <td valign=top>
            <table>
                <tr>
                    <h2>Register</h2>
                        ${ renderer.begin('/auth/register') }
<div class="field"><tr>Email:</tr>
    ${ renderer.text('email', size=30)}
    % for error in renderer.errors_for('email'):
        ${error + ' '}
    % endfor
</div>
<div class="field"><tr>Password:</tr>
    ${ renderer.password('password', size=30)}
    % for error in renderer.errors_for('password'):
        ${error + ' '}
    % endfor
</div>
<div class="field"><tr>I am:</tr>
    <select name="sex">
    <option value="" selected="selected">Select Sex</option>
    <option value="female">female</option>
    <option value="male">male</option>
    </select>
    % for error in renderer.errors_for('sex'):
        ${error + ' '}
    % endfor
</div>
<div class="field"><tr>Birthday:</tr>
    <input name="dob" size="30" type="text" /> 
    % for error in renderer.errors_for('dob'):
        ${error + ' '}
    % endfor
</div>
<div class="field"><tr>First Name:</tr>
    ${ renderer.text('first_name', size=30)}
    % for error in renderer.errors_for('first_name'):
        ${error + ' '}
    % endfor
</div>
<div class="field"><tr>Last Name:</tr>
    ${ renderer.text('last_name', size=30)}
    % for error in renderer.errors_for('last_name'):
        ${error + ' '}
    % endfor
</div>
<div class="buttons">
    ${ renderer.submit('submit', 'Submit') }
</div>
${ renderer.end() }
                </tr>
            </table>
        </td>
        <td width="200" align=center, valign=top>
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
        </td>
    </tr>
</table>
