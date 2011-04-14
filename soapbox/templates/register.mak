<!DOCTYPE html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<style type="text/css">
  html { height: 100% }
  body { height: 100%; margin: 0px; padding: 0px }
  #map_canvas { height: 100% }
</style>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
<script type="text/javascript">
  function initialize() {
    var latlng = new google.maps.LatLng(34.4113849, -119.854860);
    var myOptions = {
      zoom: 15,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(document.getElementById("map_canvas"),
        myOptions);
    var marker = new google.maps.Marker({
        position: latlng,
        draggable: true,
        map: map
      });
  }

</script>
<link rel="stylesheet" type="text/css" href="/static/mysoapbox.css" />
<script type="text/javascript">
/* Javascript Date Selector
   by Warren Brown (03/01/2004 Radiokop South Africa)

   Script to place Month/day/year onto a web page, leap year enabled
*/

var date_arr = new Array;
var days_arr = new Array;

date_arr[0]=new Option("January",31);
date_arr[1]=new Option("February",28);
date_arr[2]=new Option("March",31);
date_arr[3]=new Option("April",30);
date_arr[4]=new Option("May",31);
date_arr[5]=new Option("June",30);
date_arr[6]=new Option("July",31);
date_arr[7]=new Option("August",30);
date_arr[8]=new Option("September",30);
date_arr[9]=new Option("October",31);
date_arr[10]=new Option("November",31);
date_arr[11]=new Option("December",30);

function fill_select(f)
{
        document.writeln("<SELECT name=\"months\" onchange=\"update_days(FRM)\">");
        for(x=0;x<12;x++)
                document.writeln("<OPTION value=\""+date_arr[x].value+"\">"+date_arr[x].text);
        document.writeln("</SELECT><SELECT name=\"days\"></SELECT>");
        selection=f.months[f.months.selectedIndex].value;
}

function update_days(f)
{
        temp=f.days.selectedIndex;
        for(x=days_arr.length;x>0;x--)
        {
                days_arr[x]=null;
                f.days.options[x]=null;
         }
        selection=parseInt(f.months[f.months.selectedIndex].value);
        ret_val = 0;
        if(f.months[f.months.selectedIndex].value == 28)
        {
                year=parseInt(f.years.options[f.years.selectedIndex].value);
                if (year % 4 != 0 || year % 100 == 0 ) ret_val=0;
                else
                        if (year % 400 == 0)  ret_val=1;
                        else
                                ret_val=1;
        }
        selection = selection + ret_val;
        for(x=1;x < selection+1;x++)

        {
                days_arr[x-1]=new Option(x);
                f.days.options[x-1]=days_arr[x-1];
        }
        if (temp == -1) f.days.options[0].selected=true;
        else
             f.days.options[temp].selected=true;
}
function year_install(f)
{
        document.writeln("<SELECT name=\"years\" onchange=\"update_days(FRM)\">")
        for(x=1900;x<2000;x++) document.writeln("<OPTION value=\""+x+"\">"+x);
        document.writeln("</SELECT>");
        update_days(f)
}
function addDob() {
    var month = document.getElementById("register_form").months[document.getElementById("register_form").months.selectedIndex].text;
    var year = document.getElementById("register_form").years.value
    var day =  document.getElementById("register_form").days.value
    var dob = year + '-' + month + '-' + day
    document.getElementById("register_form").dob.value = dob;
}
</script>
</head>

<body onload="initialize()">

<div id="main">


<div id="floatdiv">
<<div id="registerFrame">
			<h3>Registration Form</h3>
                        <form action="/auth/register" method="post" id="register_form" name="FRM" onSubmit="addDob()" target="_parent"> 
<div id="container">
<div style="position:relative;float:left;">
<p style="margin-top:4px;margin-bottom:6px;">Email:</p>
<p style="margin-top:3px;margin-bottom:6px;">Password:</p>
<p style="margin-top:3px;margin-bottom:6px;">Confirm Password:</p>
<p style="margin-top:3px;margin-bottom:6px;">I am:</p>
<p style="margin-top:3px;margin-bottom:6px;">Birthday:</p>
<p style="margin-top:3px;margin-bottom:6px;">First Name (optional):</p>
<p style="margin-top:3px;margin-bottom:6px;">Last Name (optional):</p>
<p style="margin-top:3px;margin-bottom:6px;">Location:</p>
<p style="margin-top:3px;margin-bottom:6px;font-weight:bold;">(drag marker to move)</p>
<div class="buttons">
<br>${ renderer.submit('submit', 'Submit') }
</div>
</div>
<div style="margin-left:6px;position:relative;float:left;">
<div class="field">
    ${ renderer.text('email', size=30)}
    % for error in renderer.errors_for('email'):
        ${error + ' '}
    % endfor
</div>
<div class="field">
    ${ renderer.password('password', size=30)}
    % for error in renderer.errors_for('password'):
        ${error + ' '}
    % endfor
</div>
<div class="field">
    ${ renderer.password('confirm_password', size=30)}
    % for error in renderer.errors_for('confirm_password'):
        ${error + ' '}
    % endfor
</div>
<div class="field">
    <select name="sex">
    <option value="" selected="selected">Select Sex</option>
    <option value="female">female</option>
    <option value="male">male</option>
    </select>
    % for error in renderer.errors_for('sex'):
        ${error + ' '}
    % endfor
</div>
<div class="field">
<SCRIPT>fill_select(document.FRM);year_install(document.FRM)</script>
    <input name="dob" type="hidden"/>
    % for error in renderer.errors_for('dob'):
        ${error + ' '}
    % endfor
</div>
<div class="field">
    ${ renderer.text('first_name', size=30)}
    % for error in renderer.errors_for('first_name'):
        ${error + ' '}
    % endfor
</div>

<div class="field">
    ${ renderer.text('last_name', size=30)}
    % for error in renderer.errors_for('last_name'):
        ${error + ' '}
    % endfor
    
</div>

<div id="map_canvas" style="border: 1px solid #979797; background-color: #e5e3df; 
  width: 450px; height: 275px; margin:0 4em;margin-left:0pc;float:left;"></div>


${ renderer.end() }
</div>
</div>



</div> 

</div>

</div>

</body>
</html>

