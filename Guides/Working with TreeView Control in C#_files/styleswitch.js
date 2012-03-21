function setPreSelectedImg()
{var selectedtitle=getCookie("mysheet")
setImage(selectedtitle)}
function getCookie(Name){var re=new RegExp(Name+"=[^;]+","i");if(document.cookie.match(re))
return document.cookie.match(re)[0].split("=")[1]
return null}
function setCookie(name,value,days){days=90;var expireDate=new Date()
var expstring=(typeof days!="undefined")?expireDate.setDate(expireDate.getDate()+parseInt(days)):expireDate.setDate(expireDate.getDate()-5)
document.cookie=name+"="+value+"; expires="+expireDate.toGMTString()+"; path=/";}
function deleteCookie(name){setCookie(name,"moot")}
function setStylesheet(title)
{var i,cacheobj
for(i=0;(cacheobj=document.getElementsByTagName("link")[i]);i++)
{if(cacheobj.getAttribute("rel").indexOf("style")!=-1&&cacheobj.getAttribute("title"))
{cacheobj.disabled=true
if(cacheobj.getAttribute("title")==title)
cacheobj.disabled=false}}}
function setImage(title)
{if(title!=null)
{var Img=document.getElementById(title)
Img.src="/App_Themes/CSharp/Images/ThemeIcons/"+title+"2.gif";}}
function chooseStyle(styletitle,days)
{if(document.getElementById)
{var selectedtitle=getCookie("mysheet")
if(selectedtitle!=null)
{var SelectedImg=document.getElementById(selectedtitle)
SelectedImg.src="/App_Themes/CSharp/Images/ThemeIcons/"+selectedtitle+".gif";}
setImage(styletitle)
setStylesheet(styletitle)
setCookie("mysheet",styletitle,days)}}
var selectedtitle=getCookie("mysheet")
if(document.getElementById&&selectedtitle!=null)
setStylesheet(selectedtitle)