var RadTreeView_KeyboardHooked=false;
var RadTreeView_Active=null;
var RadTreeView_DragActive=null;
var RadTreeView_MouseMoveHooked=false;
var RadTreeView_MouseUpHooked=false;
var RadTreeView_MouseY=0;
var RadTreeViewGlobalFirstParam=null;
var RadTreeViewGlobalSecondParam=null;
var RadTreeViewGlobalThirdParam=null;
var RadTreeViewGlobalFourthParam=null;
var contextMenuToBeHidden=null;
var safariKeyDownFlag=true;
if(typeof (window.RadControlsNamespace)=="undefined"){
window.RadControlsNamespace=new Object();
}
RadControlsNamespace.AppendStyleSheet=function(_1,_2,_3){
if(!_3){
return;
}
if(!_1){
document.write("<"+"link"+" rel='stylesheet' type='text/css' href='"+_3+"' />");
}else{
var _4=document.createElement("LINK");
_4.rel="stylesheet";
_4.type="text/css";
_4.href=_3;
document.getElementById(_2+"StyleSheetHolder").appendChild(_4);
}
};
function RadTreeNode(){
this.Parent=null;
this.TreeView=null;
this.Nodes=new Array();
this.ID=null;
this.ClientID=null;
this.SignImage=null;
this.SignImageExpanded=null;
this.Image=0;
this.ImageExpanded=0;
this.Action=null;
this.Index=0;
this.Level=0;
this.Text=null;
this.Value=null;
this.Category=null;
this.NodeCss=null;
this.NodeCssOver=null;
this.NodeCssSelect=null;
this.ContextMenuName=null;
this.Enabled=true;
this.Expanded=false;
this.Checked=false;
this.Selected=false;
this.DragEnabled=1;
this.DropEnabled=1;
this.EditEnabled=1;
this.ExpandOnServer=0;
this.IsClientNode=0;
this.Attributes=new Array();
this.IsFetchingData=false;
this.CachedText="";
}
RadTreeNode.prototype.ScrollIntoView=function(){
var _5=this.TextElement();
var _6=document.getElementById(this.TreeView.Container);
_6.scrollTop=_5.offsetTop;
};
RadTreeNode.prototype.Next=function(){
var _7=(this.Parent!=null)?this.Parent.Nodes:this.TreeView.Nodes;
return (this.Index>=_7.length)?null:_7[this.Index+1];
};
RadTreeNode.prototype.Prev=function(){
var _8=(this.Parent!=null)?this.Parent.Nodes:this.TreeView.Nodes;
return (this.Index<=0)?null:_8[this.Index-1];
};
RadTreeNode.prototype.NextVisible=function(){
if(this.Expanded&&this.Nodes.length>0){
return this.Nodes[0];
}
if(this.Next()!=null){
return this.Next();
}
var _9=this;
while(_9.Parent!=null){
if(_9.Parent.Next()!=null){
return _9.Parent.Next();
}
_9=_9.Parent;
}
return null;
};
RadTreeNode.prototype.LastVisibleChild=function(_a){
var _b=_a.Nodes;
var _c=_b.length;
var _d=_b[_c-1];
var _e=_d;
if(_d.Expanded&&_d.Nodes.length>0){
_e=this.LastVisibleChild(_d);
}
return _e;
};
RadTreeNode.prototype.PrevVisible=function(){
var _f=this.Prev();
if(_f!=null){
if(_f.Expanded&&_f.Nodes.length>0){
return this.LastVisibleChild(_f);
}
return this.Prev();
}
if(this.Parent!=null){
return this.Parent;
}
return null;
};
RadTreeNode.prototype.Toggle=function(){
if(this.Enabled){
if(this.TreeView.FireEvent(this.TreeView.BeforeClientToggle,this)==false){
return;
}
(this.Expanded)?this.Collapse():this.Expand();
if(this.ExpandOnServer!=2){
this.TreeView.FireEvent(this.TreeView.AfterClientToggle,this);
}
}
};
RadTreeNode.prototype.CollapseNonParentNodes=function(){
for(var i=0;i<this.TreeView.AllNodes.length;i++){
if(this.TreeView.AllNodes[i].Expanded&&!this.IsParent(this.TreeView.AllNodes[i])){
this.TreeView.AllNodes[i].CollapseNoEffect();
}
}
};
RadTreeNode.prototype.EncodeURI=function(s){
try{
return encodeURIComponent(s);
}
catch(e){
return escape(s);
}
};
RadTreeNode.prototype.RaiseNoTreeViewOnServer=function(){
throw new Error("No RadTreeView instance has been created on the server.\n"+"Make sure that you have the control instance created.\n"+"Please review this article for additional information.");
};
RadTreeNode.prototype.GetTheElement=function(){
var _12=this.TextElement();
while(_12&&_12.tagName.toLowerCase()!="div"){
_12=_12.parentNode;
}
return _12;
};
RadTreeNode.prototype.FetchDataOnDemand=function(){
if(this.Checked==1){
this.Checked=true;
}
var url=this.TreeView.LoadOnDemandUrl+"&rtnClientID="+this.ClientID+"&rtnLevel="+this.Level+"&rtnID="+this.ID+"&rtnParentPosition="+this.GetParentPositions()+"&rtnText="+this.EncodeURI(this.Text)+"&rtnValue="+this.EncodeURI(this.Value)+"&rtnCategory="+this.EncodeURI(this.Category)+"&rtnChecked="+this.Checked;
var _14;
if(typeof (XMLHttpRequest)!="undefined"){
_14=new XMLHttpRequest();
}else{
_14=new ActiveXObject("Microsoft.XMLHTTP");
}
url=url+"&timeStamp="+encodeURIComponent((new Date()).getTime());
_14.open("GET",url,true);
_14.setRequestHeader("Content-Type","application/json; charset=utf-8");
var _15=this;
_14.onreadystatechange=function(){
if(_14.readyState!=4){
return;
}
var _16=_14.responseText;
if(_14.status==500){
alert("RadTreeView: Server error in the NodeExpand event handler, press ok to view the result.");
document.body.innerHTML=_16;
return;
}
var _17=_16.indexOf(",");
var _18=parseInt(_16.substring(0,_17));
var _19=_16.substring(_17+1,_18+_17+1);
var _1a=_16.substring(_18+_17+1);
_15.LoadNodesOnDemand(_19,_14.status,url);
_15.ImageOn();
_15.SignOn();
_15.Expanded=true;
_15.ExpandOnServer=0;
var _1b=_15.GetTheElement();
var _1c=_1b.parentNode;
switch(_15.TreeView.LoadingMessagePosition){
case 0:
case 1:
if(_15.TextElement().parentNode.tagName=="A"){
_15.TextElement().parentNode.firstChild.innerHTML=_15.CachedText;
_1c=_1b;
}else{
_1c=_15.TextElement().parentNode;
if(_15.TextElement().innerText){
_15.TextElement().innerHTML=_15.CachedText;
}else{
_15.TextElement().innerHTML=_15.CachedText;
}
}
break;
case 2:
_1b.removeChild(document.getElementById(_15.ClientID+"Loading"));
_1c=_1b;
break;
case 3:
_1c=_1b;
}
if(_15.Nodes.length>0){
rtvInsertHTML(_1c,_1a);
var _1d=_1c.getElementsByTagName("IMG");
for(var i=0;i<_1d.length;i++){
RadTreeView.AlignImage(_1d[i]);
}
var _1f=_1c.getElementsByTagName("INPUT");
for(var i=0;i<_1f.length;i++){
RadTreeView.AlignImage(_1f[i]);
}
}
_15.IsFetchingData=false;
_15.TreeView.FireEvent(_15.TreeView.AfterClientToggle,_15);
};
_14.send(null);
};
RadTreeNode.prototype.Expand=function(){
if(this.ExpandOnServer){
if(!this.TreeView.FireEvent(this.TreeView.BeforeClientToggle,this)){
return;
}
if(this.ExpandOnServer==1){
this.TreeView.PostBack("NodeExpand",this.ClientID);
return;
}
if(this.ExpandOnServer==2){
if(!this.IsFetchingData){
this.IsFetchingData=true;
this.CachedText=this.TextElement().innerHTML;
switch(this.TreeView.LoadingMessagePosition){
case 0:
this.TextElement().innerHTML="<span class="+this.TreeView.LoadingMessageCssClass+">"+this.TreeView.LoadingMessage+"</span> "+this.TextElement().innerHTML;
break;
case 1:
this.TextElement().innerHTML=this.TextElement().innerHTML+" "+"<span class="+this.TreeView.LoadingMessageCssClass+">"+this.TreeView.LoadingMessage+"</span> ";
break;
case 2:
rtvInsertHTML(this.TextElement().parentNode,"<div id="+this.ClientID+"Loading "+" class="+this.TreeView.LoadingMessageCssClass+">"+this.TreeView.LoadingMessage+"</div>");
break;
}
var _20=this;
window.setTimeout(function(){
_20.FetchDataOnDemand();
},20);
return;
}
}
}
if(!this.Nodes.length){
return;
}
if(this.TreeView.SingleExpandPath){
this.CollapseNonParentNodes();
}
var _21=document.getElementById("G"+this.ClientID);
if(this.TreeView.ExpandDelay>0){
_21.style.overflow="hidden";
_21.style.height="1px";
_21.style.display="block";
_21.firstChild.style.position="relative";
window.setTimeout("rtvNodeExpand(1,'"+_21.id+"',"+this.TreeView.ExpandDelay+");",20);
}else{
_21.style.display="block";
}
this.ImageOn();
this.SignOn();
this.Expanded=true;
if(!this.IsClientNode){
this.TreeView.UpdateExpandedState();
}
};
RadTreeNode.prototype.GetParentPositions=function(){
var _22=this;
var _23="";
while(_22!=null){
if(_22.Next()!=null){
_23=_23+"1";
}else{
_23=_23+"0";
}
_22=_22.Parent;
}
return _23;
};
RadTreeNode.prototype.Collapse=function(){
if(this.Nodes.length>0){
if(this.ExpandOnServer==1&&this.TreeView.NodeCollapseWired){
this.TreeView.PostBack("NodeCollapse",this.ClientID);
return;
}
if(this.TreeView.ExpandDelay>0){
var _24=document.getElementById("G"+this.ClientID);
if(_24.scrollHeight!="undefined"){
_24.style.overflow="hidden";
_24.style.display="block";
_24.firstChild.style.position="relative";
window.setTimeout("rtvNodeCollapse("+_24.scrollHeight+",'"+_24.id+"',"+this.TreeView.ExpandDelay+" );",20);
}else{
this.CollapseNoEffect();
}
}else{
this.CollapseNoEffect();
}
this.ImageOff();
this.SignOff();
this.Expanded=false;
this.TreeView.UpdateExpandedState();
}
};
RadTreeNode.prototype.CollapseNoEffect=function(){
if(this.Nodes.length>0){
var _25=document.getElementById("G"+this.ClientID);
_25.style.display="none";
this.ImageOff();
this.SignOff();
this.Expanded=false;
this.TreeView.UpdateExpandedState();
}
};
RadTreeNode.prototype.Highlight=function(e){
if(!this.Enabled){
return;
}
if(e){
if(this.TreeView.MultipleSelect&&(e.ctrlKey||e.shiftKey)){
if(this.Selected){
this.TextElement().className=this.NodeCss;
this.Selected=false;
if(this.TreeView.SelectedNode==this){
this.TreeView.SelectedNode=null;
}
this.TreeView.UpdateSelectedState();
return;
}
}else{
this.TreeView.UnSelectAllNodes();
}
}
this.TextElement().className=this.NodeCssSelect;
this.TreeView.SelectNode(this);
this.TreeView.FireEvent(this.TreeView.AfterClientHighlight,this);
};
RadTreeNode.prototype.ExecuteAction=function(e){
if(this.IsClientNode){
return;
}
if(this.TextElement().tagName=="A"){
this.TextElement().click();
}else{
if(this.Action){
this.TreeView.PostBack("NodeClick",this.ClientID);
}
}
if(e){
(document.all)?e.returnValue=false:e.preventDefault();
}
};
RadTreeNode.prototype.Select=function(e){
if(this.TreeView.FireEvent(this.TreeView.BeforeClientClick,this,e)==false){
e.returnValue=false;
if(e.preventDefault){
e.preventDefault();
}
return;
}
if(this.Enabled){
this.Highlight(e);
this.TreeView.LastHighlighted=this;
this.ExecuteAction();
}else{
(document.all)?e.returnValue=false:e.preventDefault();
}
this.TreeView.FireEvent(this.TreeView.AfterClientClick,this,e);
};
RadTreeNode.prototype.UnSelect=function(){
if(this.TextElement().parentNode&&this.TextElement().parentNode.tagName=="A"){
this.TextElement().parentNode.className=this.NodeCss;
}
this.TextElement().className=this.NodeCss;
this.Selected=false;
};
RadTreeNode.prototype.Disable=function(){
this.TextElement().className=this.TreeView.NodeCssDisable;
this.Enabled=false;
this.Selected=false;
if(this.CheckElement()!=null){
this.CheckElement().disabled=true;
}
};
RadTreeNode.prototype.Enable=function(){
this.TextElement().className=this.NodeCss;
this.Enabled=true;
if(this.CheckElement()!=null){
this.CheckElement().disabled=false;
}
};
RadTreeNode.prototype.Hover=function(e){
var _2a=(e.srcElement)?e.srcElement:e.target;
if(this.TreeView.IsRootNodeTag(_2a)){
this.TreeView.SetBorderOnDrag(this,_2a,e);
return;
}
if(this.Enabled){
if(this.TreeView.FireEvent(this.TreeView.BeforeClientHighlight,this)==false){
return;
}
this.TreeView.LastHighlighted=this;
if(RadTreeView_DragActive!=null&&RadTreeView_DragActive.DragClone!=null&&(!this.Expanded)&&this.ExpandOnServer!=1){
var _2b=this;
window.setTimeout(function(){
_2b.ExpandOnDrag();
},1000);
}
if(!this.Selected){
this.TextElement().className=this.NodeCssOver;
if(this.Image){
this.ImageElement().style.cursor="hand";
}
}
this.TreeView.FireEvent(this.TreeView.AfterClientHighlight,this);
}
};
RadTreeNode.prototype.UnHover=function(e){
var _2d=(e.srcElement)?e.srcElement:e.target;
if(this.TreeView.IsRootNodeTag(_2d)){
this.TreeView.ClearBorderOnDrag(_2d);
return;
}
if(this.Enabled){
this.TreeView.LastHighlighted=null;
if(!this.Selected){
this.TextElement().className=this.NodeCss;
if(this.Image){
this.ImageElement().style.cursor="default";
}
}
this.TreeView.FireEvent(this.TreeView.AfterClientMouseOut,this);
}
};
RadTreeNode.prototype.ExpandOnDrag=function(){
if(RadTreeView_DragActive!=null&&RadTreeView_DragActive.DragClone!=null&&(!this.Expanded)){
if(RadTreeView_Active.LastHighlighted==this){
this.Expand();
}
}
};
RadTreeNode.prototype.CheckBoxClick=function(e){
if(this.Enabled){
if(this.TreeView.FireEvent(this.TreeView.BeforeClientCheck,this,e)==false){
(this.Checked)?this.Check():this.UnCheck();
return;
}
(this.Checked)?this.UnCheck():this.Check();
if(this.TreeView.AutoPostBackOnCheck){
this.TreeView.PostBack("NodeCheck",this.ClientID);
this.TreeView.FireEvent(this.TreeView.AfterClientCheck,this);
return;
}
this.TreeView.FireEvent(this.TreeView.AfterClientCheck,this);
}
};
RadTreeNode.prototype.Check=function(){
if(this.CheckElement()!=null){
this.CheckElement().checked=true;
this.Checked=true;
this.TreeView.UpdateCheckedState();
}
};
RadTreeNode.prototype.UnCheck=function(){
if(this.CheckElement()!=null){
this.CheckElement().checked=false;
this.Checked=false;
this.TreeView.UpdateCheckedState();
}
};
RadTreeNode.prototype.IsSet=function(a){
return (a!=null&&a!="");
};
RadTreeNode.prototype.ImageOn=function(){
var _30=document.getElementById(this.ClientID+"i");
if(this.ImageExpanded!=0){
_30.src=this.ImageExpanded;
}
};
RadTreeNode.prototype.ImageOff=function(){
var _31=document.getElementById(this.ClientID+"i");
if(this.Image!=0){
_31.src=this.Image;
}
};
RadTreeNode.prototype.SignOn=function(){
var _32=document.getElementById(this.ClientID+"c");
if(this.IsSet(this.SignImageExpanded)){
_32.src=this.SignImageExpanded;
}
};
RadTreeNode.prototype.SignOff=function(){
var _33=document.getElementById(this.ClientID+"c");
if(this.IsSet(this.SignImage)){
_33.src=this.SignImage;
}
};
RadTreeNode.prototype.TextElement=function(){
var _34=document.getElementById(this.ClientID);
var _35=_34.getElementsByTagName("span")[0];
if(_35==null){
_35=_34.getElementsByTagName("a")[0];
}
return _35;
};
RadTreeNode.prototype.ImageElement=function(){
return document.getElementById(this.ClientID+"i");
};
RadTreeNode.prototype.CheckElement=function(){
return document.getElementById(this.ClientID).getElementsByTagName("input")[0];
};
RadTreeNode.prototype.IsParent=function(_36){
var _37=this.Parent;
while(_37!=null){
if(_36==_37){
return true;
}
_37=_37.Parent;
}
return false;
};
RadTreeNode.prototype.StartEdit=function(){
if(this.EditEnabled){
var _38=this.Text;
this.TreeView.EditMode=true;
var _39=this.TextElement().parentNode;
this.TreeView.EditTextElement=this.TextElement().cloneNode(true);
this.TextElement().parentNode.removeChild(this.TextElement());
var _3a=this;
var _3b=document.createElement("input");
_3b.setAttribute("type","text");
_3b.setAttribute("size",this.Text.length+3);
_3b.setAttribute("value",_38);
_3b.className=this.TreeView.NodeCssEdit;
var _3c=this;
_3b.onblur=function(){
_3c.EndEdit();
};
_3b.onchange=function(){
_3c.EndEdit();
};
_3b.onkeypress=function(e){
_3c.AnalyzeEditKeypress(e);
};
_3b.onsubmit=function(){
return false;
};
_39.appendChild(_3b);
this.TreeView.EditInputElement=_3b;
_3b.focus();
_3b.onselectstart=function(e){
if(!e){
e=window.event;
}
if(e.stopPropagation){
e.stopPropagation();
}else{
e.cancelBubble=true;
}
};
var _3f=0;
var _40=this.Text.length;
if(_3b.createTextRange){
var _41=_3b.createTextRange();
_41.moveStart("character",_3f);
_41.moveEnd("character",_40);
_41.select();
}else{
_3b.setSelectionRange(_3f,_40);
}
}
};
RadTreeNode.prototype.EndEdit=function(){
this.TreeView.EditInputElement.onblur=null;
this.TreeView.EditInputElement.onchange=null;
var _42=this.TreeView.EditInputElement.parentNode;
this.TreeView.EditInputElement.parentNode.removeChild(this.TreeView.EditInputElement);
_42.appendChild(this.TreeView.EditTextElement);
if(this.TreeView.FireEvent(this.TreeView.AfterClientEdit,this,this.Text,this.TreeView.EditInputElement.value)!=false){
if(this.Text!=this.TreeView.EditInputElement.value){
var _43=this.ClientID+":"+this.TreeView.EscapeParameter(this.TreeView.EditInputElement.value);
this.TreeView.PostBack("NodeEdit",_43);
return;
}
}
this.TreeView.EditMode=false;
this.TreeView.EditInputElement=null;
this.TreeView.EditTextElement=null;
};
RadTreeNode.prototype.AnalyzeEditKeypress=function(e){
if(document.all){
e=event;
}
if(e.keyCode==13){
(document.all)?e.returnValue=false:e.preventDefault();
if(typeof (e.cancelBubble)!="undefined"){
e.cancelBubble=true;
}
this.EndEdit();
return false;
}
if(e.keyCode==27){
this.TreeView.EditInputElement.value=this.TreeView.EditTextElement.innerHTML;
this.EndEdit();
}
return true;
};
RadTreeNode.prototype.LoadNodesOnDemand=function(s,_46,url){
if(_46==404){
var _48="CallBack URL not found: \n\r\n\r"+url+"\n\r\n\rAre you using URL Rewriter? Please, try setting the AjaxUrl property to match the correct URL you need";
alert(_48);
this.TreeView.FireEvent(this.TreeView.AfterClientCallBackError,this.TreeView);
}else{
try{
eval(s);
var _49=window[this.ClientID+"ClientData"];
for(var i=0;i<_49.length;i++){
var _4b=_49[i][0];
var _4c=_4b.substring(0,_4b.lastIndexOf("_t"));
var _4d=this.TreeView.FindNode(_4c);
if(_4d){
this.TreeView.LoadNode(_49[i],null,_4d);
}else{
_49[i][17]=0;
this.TreeView.LoadNode(_49[i],null,this);
}
}
}
catch(e){
this.TreeView.FireEvent(this.TreeView.AfterClientCallBackError,this.TreeView);
}
}
};
function RadTreeView(_4e){
if(window.tlrkTreeViews==null){
window.tlrkTreeViews=new Array();
}
if(window.tlrkTreeViews[_4e]!=null){
var _4f=window.tlrkTreeViews[_4e];
_4f.Dispose();
}
tlrkTreeViews[_4e]=this;
this.Nodes=new Array();
this.AllNodes=new Array();
this.ClientID=null;
this.SelectedNode=null;
this.DragMode=false;
this.DragSource=null;
this.DragClone=null;
this.LastHighlighted=null;
this.MouseInside=false;
this.HtmlElementID="";
this.EditMode=false;
this.EditTextElement=null;
this.EditInputElement=null;
this.BeforeClientClick=null;
this.BeforeClientHighlight=null;
this.AfterClientHighlight=null;
this.AfterClientMouseOut=null;
this.BeforeClientDrop=null;
this.AfterClientDrop=null;
this.BeforeClientToggle=null;
this.AfterClientToggle=null;
this.BeforeClientContextClick=null;
this.BeforeClientContextMenu=null;
this.AfterClientContextClick=null;
this.BeforeClientCheck=null;
this.AfterClientCheck=null;
this.AfterClientMove=null;
this.AfterClientFocus=null;
this.BeforeClientDrag=null;
this.AfterClientEdit=null;
this.AfterClientClick=null;
this.BeforeClientDoubleClick=null;
this.AfterClientCallBackError=null;
this.DragAndDropBetweenNodes=false;
this.AutoPostBackOnCheck=false;
this.CausesValidation=true;
this.ContextMenuVisible=false;
this.ContextMenuName=null;
this.ContextMenuNode=null;
this.SingleExpandPath=false;
this.ExpandDelay=2;
this.TabIndex=0;
this.AllowNodeEditing=false;
this.LoadOnDemandUrl=null;
this.LoadingMessage="(loading ...)";
this.LoadingMessagePosition=0;
this.LoadingMessageCssClass="LoadingMessage";
this.NodeCollapseWired=false;
this.RightToLeft=false;
this.LastBorderElementSet=null;
this.LastDragPosition="on";
this.LastDragNode=null;
this.IsBuilt=false;
}
RadTreeView.AlignImage=function(_50){
_50.align="absmiddle";
_50.style.display="inline";
if(!document.all||window.opera){
if(_50.nextSibling&&_50.nextSibling.tagName=="SPAN"){
_50.nextSibling.style.verticalAlign="middle";
}
if(_50.nextSibling&&_50.nextSibling.tagName=="INPUT"){
_50.nextSibling.style.verticalAlign="middle";
}
}
};
RadTreeView.prototype.OnInit=function(){
var _51=new Array();
this.PreloadImages(_51);
GlobalTreeViewImageList=_51;
var _52=document.getElementById(this.Container).getElementsByTagName("IMG");
for(var i=0;i<_52.length;i++){
var _54=_52[i].className;
if(_51[_54]&&_54!=null&&_54!=""){
_52[i].src=_51[_54];
RadTreeView.AlignImage(_52[i]);
}
}
this.LoadTree(_51);
var _55=document.getElementById(this.Container).getElementsByTagName("INPUT");
for(var i=0;i<_55.length;i++){
RadTreeView.AlignImage(_55[i]);
}
var _56=this;
this.OnKeyDownMozilla=function(e){
_56.KeyDownMozilla(e);
};
if(document.addEventListener&&(!RadTreeView_KeyboardHooked)){
RadTreeView_KeyboardHooked=true;
this.AttachEvent(document,"keydown",this.OnKeyDownMozilla);
}
if((!RadTreeView_MouseMoveHooked)&&(this.DragAndDrop)){
RadTreeView_MouseMoveHooked=true;
this.AttachEvent(document,"mousemove",rtvMouseMove);
}
if(!RadTreeView_MouseUpHooked){
RadTreeView_MouseUpHooked=true;
this.AttachEvent(document,"mouseup",rtvMouseUp);
}
this.AttachAllEvents();
this.IsBuilt=true;
};
RadTreeView.prototype.AttachAllEvents=function(){
var _58=this;
var _59=document.getElementById(this.Container);
this.OnFocus=function(e){
rtvDispatcher(_58.ClientID,"focus",e);
};
this.OnMouseOver=function(e){
rtvDispatcher(_58.ClientID,"mover",e);
};
this.OnMouseOut=function(e){
rtvDispatcher(_58.ClientID,"mout",e);
};
this.OnContextMenu=function(e){
rtvDispatcher(_58.ClientID,"context",e);
};
this.OnScroll=function(e){
_58.Scroll();
};
this.OnClick=function(e){
rtvDispatcher(_58.ClientID,"mclick",e);
};
this.OnDblClick=function(e){
rtvDispatcher(_58.ClientID,"mdclick",e);
};
this.OnKeyDown=function(e){
rtvDispatcher(_58.ClientID,"keydown",e);
};
this.OnSelectStart=function(e){
return false;
};
this.OnDragStart=function(e){
return false;
};
this.OnMouseDown=function(e){
rtvDispatcher(_58.ClientID,"mdown",e);
};
this.OnUnload=function(e){
_58.Dispose();
};
this.AttachEvent(_59,"focus",this.OnFocus);
this.AttachEvent(_59,"mouseover",this.OnMouseOver);
this.AttachEvent(_59,"mouseout",this.OnMouseOut);
this.AttachEvent(_59,"contextmenu",this.OnContextMenu);
this.AttachEvent(_59,"scroll",this.OnScroll);
this.AttachEvent(_59,"click",this.OnClick);
this.AttachEvent(_59,"dblclick",this.OnDblClick);
this.AttachEvent(_59,"keydown",this.OnKeyDown);
this.AttachEvent(_59,"selectstart",this.OnSelectStart);
this.AttachEvent(_59,"dragstart",this.OnDragStart);
if(this.DragAndDrop){
this.AttachEvent(_59,"mousedown",this.OnMouseDown);
}
this.AttachEvent(window,"unload",this.OnUnload);
this.RootElement=_59;
};
RadTreeView.prototype.Dispose=function(){
if(this.disposed){
return;
}
this.disposed=true;
this.DetachEvent(this.RootElement,"focus",this.OnFocus);
this.DetachEvent(this.RootElement,"mouseover",this.OnMouseOver);
this.DetachEvent(this.RootElement,"mouseout",this.OnMouseOut);
this.DetachEvent(this.RootElement,"contextmenu",this.OnContextMenu);
this.DetachEvent(this.RootElement,"scroll",this.OnScroll);
this.DetachEvent(this.RootElement,"click",this.OnClick);
this.DetachEvent(this.RootElement,"dblclick",this.OnDblClick);
this.DetachEvent(this.RootElement,"keydown",this.OnKeyDown);
this.DetachEvent(this.RootElement,"selectstart",this.OnSelectStart);
this.DetachEvent(this.RootElement,"dragstart",this.OnDragStart);
if(this.DragAndDrop){
this.DetachEvent(this.RootElement,"mousedown",this.OnMouseDown);
}
this.DetachEvent(window,"unload",this.OnUnload);
this.RootElement=null;
};
RadTreeView.prototype.PreloadImages=function(_66){
var _67=window[this.ClientID+"ImageData"];
for(var i=0;i<_67.length;i++){
_66[i]=_67[i];
}
};
RadTreeView.prototype.FindNode=function(_69){
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].ClientID==_69){
return this.AllNodes[i];
}
}
return null;
};
RadTreeView.prototype.FindNodeByText=function(_6b){
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].Text==_6b){
return this.AllNodes[i];
}
}
return null;
};
RadTreeView.prototype.FindNodeByValue=function(_6d){
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].Value==_6d){
return this.AllNodes[i];
}
}
return null;
};
RadTreeView.prototype.FindNodeByAttribute=function(_6f,_70){
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].Attributes[_6f]==_70){
return this.AllNodes[i];
}
}
return null;
};
RadTreeView.prototype.IsChildOf=function(_72,_73){
if(_73==_72){
return false;
}
while(_73&&(_73!=document.body)){
if(_73==_72){
return true;
}
try{
_73=_73.parentNode;
}
catch(e){
return false;
}
}
return false;
};
RadTreeView.prototype.GetTarget=function(e){
if(!e){
return null;
}
return e.target||e.srcElement;
};
RadTreeView.prototype.LoadTree=function(_75){
var cd=window[this.ClientID+"ClientData"];
for(var i=0;i<cd.length;i++){
this.LoadNode(cd[i],_75);
}
};
RadTreeView.prototype.LoadNode=function(cd,_79,_7a){
var _7b=new RadTreeNode();
_7b.ClientID=cd[0];
_7b.TreeView=this;
var _7c=cd[17];
if(_7c>0){
_7b.Parent=this.AllNodes[_7c-1];
}
if(_7a!=null){
_7b.Parent=_7a;
}
_7b.NodeCss=this.NodeCss;
_7b.NodeCssOver=this.NodeCssOver;
_7b.NodeCssSelect=this.NodeCssSelect;
_7b.Text=cd[1];
_7b.Value=cd[2];
_7b.Category=cd[3];
if(_79!=null){
_7b.SignImage=_79[cd[4]];
_7b.SignImageExpanded=_79[cd[5]];
}else{
_7b.SignImage=GlobalTreeViewImageList[cd[4]];
_7b.SignImageExpanded=GlobalTreeViewImageList[cd[5]];
}
if(cd[6]>0){
_7b.Image=_79[cd[6]];
}
if(cd[7]>0){
_7b.ImageExpanded=_79[cd[7]];
}
_7b.Selected=cd[8];
if(_7b.Selected){
this.SelectedNode=_7b;
}
_7b.Checked=cd[9];
_7b.Enabled=cd[10];
_7b.Expanded=cd[11];
_7b.Action=cd[12];
if(this.IsSet(cd[13])){
_7b.NodeCss=cd[13];
}
if(this.IsSet(cd[14])){
_7b.ContextMenuName=cd[14];
}
this.AllNodes[this.AllNodes.length]=_7b;
if(_7b.Parent!=null){
_7b.Parent.Nodes[_7b.Parent.Nodes.length]=_7b;
}else{
this.Nodes[this.Nodes.length]=_7b;
}
_7b.Index=cd[16];
_7b.DragEnabled=cd[18];
_7b.DropEnabled=cd[19];
_7b.ExpandOnServer=cd[20];
if(this.IsSet(cd[21])){
_7b.NodeCssOver=cd[21];
}
if(this.IsSet(cd[22])){
_7b.NodeCssSelect=cd[22];
}
_7b.Level=cd[23];
_7b.ID=cd[24];
_7b.IsClientNode=cd[25];
_7b.EditEnabled=cd[26];
_7b.Attributes=cd[27];
};
RadTreeView.prototype.Toggle=function(_7d){
this.FindNode(_7d).Toggle();
};
RadTreeView.prototype.Select=function(_7e,e){
this.FindNode(_7e).Select(e);
};
RadTreeView.prototype.Hover=function(_80,e){
var _80=this.FindNode(_80);
if(_80){
_80.Hover(e);
}
};
RadTreeView.prototype.UnHover=function(_82,e){
var _82=this.FindNode(_82);
if(_82){
_82.UnHover(e);
}
};
RadTreeView.prototype.CheckBoxClick=function(_84,e){
this.FindNode(_84).CheckBoxClick(e);
};
RadTreeView.prototype.Highlight=function(_86,e){
this.FindNode(_86).Highlight(e);
};
RadTreeView.prototype.SelectNode=function(_88){
this.SelectedNode=_88;
_88.Selected=true;
this.UpdateSelectedState();
};
RadTreeView.prototype.GetSelectedNodes=function(){
var _89=new Array();
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].Selected){
_89[_89.length]=this.AllNodes[i];
}
}
return _89;
};
RadTreeView.prototype.UnSelectAllNodes=function(_8b){
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].Selected&&this.AllNodes[i].Enabled){
this.AllNodes[i].UnSelect();
}
}
};
RadTreeView.prototype.KeyDownMozilla=function(e){
var _8e=RadTreeView_Active;
if(_8e){
var _8f=_8e.GetTarget(e);
if(_8f.tagName.toUpperCase()=="BODY"||_8f.tagName.toUpperCase()=="HTML"||_8e.IsChildOf(_8f,_8e.RootElement)||_8f==_8e.RootElement){
if(!_8e.IsBuilt){
return;
}
var _90=_8e.SelectedNode;
if(_90!=null){
if(_8e.EditMode){
return;
}
if(e.keyCode==107||e.keyCode==109||e.keyCode==37||e.keyCode==39){
_90.Toggle();
(document.all)?e.returnValue=false:e.preventDefault();
}
if(e.keyCode==40&&_90.NextVisible()!=null){
_90.NextVisible().KeepInView();
_90.NextVisible().Highlight(e);
(document.all)?e.returnValue=false:e.preventDefault();
}
if(e.keyCode==38&&_90.PrevVisible()!=null){
_90.PrevVisible().KeepInView();
_90.PrevVisible().Highlight(e);
(document.all)?e.returnValue=false:e.preventDefault();
}
if(e.keyCode==13){
if(_8e.FireEvent(_8e.BeforeClientClick,_90,e)==false){
return;
}
_90.ExecuteAction();
_8e.FireEvent(_8e.AfterClientClick,_90,e);
}
if(e.keyCode==32){
_90.CheckBoxClick();
}
if(e.keyCode==113&&_8e.AllowNodeEditing){
_90.StartEdit();
}
}else{
if(e.keyCode==38||e.keyCode==40||e.keyCode==13||e.keyCode==32){
_8e.Nodes[0].Highlight();
_8e.Nodes[0].ScrollIntoView();
(document.all)?e.returnValue=false:e.preventDefault();
}
}
}
}
};
RadTreeNode.prototype.GetOffsetTop=function(){
var _91=this.TextElement().parentNode.offsetTop;
if(this.TextElement().parentNode.parentNode.currentStyle&&this.TextElement().parentNode.parentNode.currentStyle.hasLayout){
var _92=this.Parent;
if(_92){
var _93=_92.GetOffsetTop();
_91+=_93;
_92=_92.Parent;
var _94=this.TextElement().parentNode.offsetHeight;
_91+=_94;
}
}
return _91;
};
RadTreeNode.prototype.KeepInView=function(){
var _95=this.TextElement();
var _96=document.getElementById(this.TreeView.Container);
var _97=this.GetOffsetTop();
if(_97<_96.scrollTop){
_96.scrollTop=_97;
}
var _98=this.TextElement().parentNode.offsetHeight;
if(_97+_98>(_96.clientHeight+_96.scrollTop)){
_96.scrollTop+=((_97+_98)-(_96.clientHeight+_96.scrollTop));
}
};
RadTreeView.prototype.KeyDown=function(e){
if(this.EditMode){
return;
}
var _9a=this.SelectedNode;
if(_9a!=null){
if(e.keyCode==107||e.keyCode==109||e.keyCode==37||e.keyCode==39){
_9a.Toggle();
}
if(e.keyCode==40&&_9a.NextVisible()!=null){
(document.all)?e.returnValue=false:e.preventDefault();
_9a.NextVisible().Highlight(e);
_9a.NextVisible().KeepInView();
}
if(e.keyCode==38&&_9a.PrevVisible()!=null){
(document.all)?e.returnValue=false:e.preventDefault();
_9a.PrevVisible().Highlight(e);
_9a.PrevVisible().KeepInView();
}
if(e.keyCode==13){
if(this.FireEvent(this.BeforeClientClick,this.SelectedNode,e)==false){
return;
}
_9a.ExecuteAction(e);
this.FireEvent(this.AfterClientClick,this.SelectedNode,e);
}
if(e.keyCode==32){
_9a.CheckBoxClick();
(document.all)?e.returnValue=false:e.preventDefault();
}
if(e.keyCode==113&&this.AllowNodeEditing){
_9a.StartEdit();
}
}else{
if(e.keyCode==38||e.keyCode==40||e.keyCode==13||e.keyCode==32){
this.Nodes[0].Highlight();
this.Nodes[0].KeepInView();
(document.all)?e.returnValue=false:e.preventDefault();
}
}
};
RadTreeView.prototype.UpdateState=function(){
this.UpdateExpandedState();
this.UpdateCheckedState();
this.UpdateSelectedState();
};
RadTreeView.prototype.UpdateExpandedState=function(){
var _9b="";
for(var i=0;i<this.AllNodes.length;i++){
var _9d=(this.AllNodes[i].Expanded)?"1":"0";
_9b+=_9d;
}
document.getElementById(this.ClientID+"_expanded").value=_9b;
};
RadTreeView.prototype.UpdateCheckedState=function(){
var _9e="";
for(var i=0;i<this.AllNodes.length;i++){
var _a0=(this.AllNodes[i].Checked)?"1":"0";
_9e+=_a0;
}
document.getElementById(this.ClientID+"_checked").value=_9e;
};
RadTreeView.prototype.UpdateSelectedState=function(){
var _a1="";
for(var i=0;i<this.AllNodes.length;i++){
var _a3=(this.AllNodes[i].Selected)?"1":"0";
_a1+=_a3;
}
document.getElementById(this.ClientID+"_selected").value=_a1;
};
RadTreeView.prototype.Scroll=function(){
for(var key in tlrkTreeViews){
if((typeof (tlrkTreeViews[key])!="function")&&tlrkTreeViews[key].ContextMenuVisible){
contextMenuToBeHidden=tlrkTreeViews[key];
window.setTimeout(function(){
if(contextMenuToBeHidden){
contextMenuToBeHidden.HideContextMenu();
}
},10);
}
}
document.getElementById(this.ClientID+"_scroll").value=document.getElementById(this.Container).scrollTop;
};
RadTreeView.prototype.ContextMenuClick=function(e,p1,p2,p3){
instance=this;
window.setTimeout(function(){
instance.HideContextMenu();
},10);
if(this.FireEvent(this.BeforeClientContextClick,this.ContextMenuNode,p1,p3)==false){
return;
}
if(p2){
var _a9=this.ContextMenuNode.ClientID+":"+this.EscapeParameter(p1)+":"+this.EscapeParameter(p3);
this.PostBack("ContextMenuClick",_a9);
}
};
RadTreeView.prototype.ContextMenu=function(e,_ab){
var src=(e.srcElement)?e.srcElement:e.target;
var _ad=this.FindNode(_ab);
if(_ad!=null&&this.BeforeClientContextMenu!=null){
var _ae=this.SelectedNode;
if(this.FireEvent(this.BeforeClientContextMenu,_ad,e,_ae)==false){
return;
}
this.Highlight(_ab,e,_ae);
}
if(_ad!=null&&_ad.ContextMenuName!=null&&_ad.Enabled){
if(!this.ContextMenuVisible){
this.ContextMenuNode=_ad;
if(!_ad.Selected){
this.Highlight(_ab,e);
}
this.ShowContextMenu(_ad.ContextMenuName,e);
document.all?e.returnValue=false:e.preventDefault();
}
}
};
RadTreeView.prototype.ShowContextMenu=function(_af,e){
if(!document.readyState||document.readyState=="complete"){
var _b1="rtvcm"+this.ClientID+_af;
var _b2=document.getElementById(_b1);
if(_b2){
var _b3=_b2.cloneNode(true);
_b3.id=_b1+"_clone";
document.body.appendChild(_b3);
_b3=document.getElementById(_b1+"_clone");
_b3.style.left=this.CalculateXPos(e)+"px";
_b3.style.top=this.CalculateYPos(e)+"px";
_b3.style.position="absolute";
_b3.style.display="block";
this.ContextMenuVisible=true;
this.ContextMenuName=_af;
document.all?e.returnValue=false:e.preventDefault();
}
}
};
RadTreeView.prototype.CalculateYPos=function(e){
if(document.compatMode&&document.compatMode=="CSS1Compat"){
return (e.clientY+document.documentElement.scrollTop);
}
return (e.clientY+document.body.scrollTop);
};
RadTreeView.prototype.CalculateXPos=function(e){
if(navigator.appName=="Microsoft Internet Explorer"&&this.RightToLeft){
return (e.clientX-(document.documentElement.scrollWidth-document.documentElement.clientWidth-document.documentElement.scrollLeft));
}
if(document.compatMode&&document.compatMode=="CSS1Compat"){
return (e.clientX+document.documentElement.scrollLeft);
}
return (e.clientX+document.body.scrollLeft);
};
RadTreeView.prototype.HideContextMenu=function(){
if(!document.readyState||document.readyState=="complete"){
var _b6=document.getElementById("rtvcm"+this.ClientID+this.ContextMenuName+"_clone");
if(_b6){
document.body.removeChild(_b6);
}
this.ContextMenuVisible=false;
}
};
RadTreeView.prototype.MouseClickDispatcher=function(e){
var src=(e.srcElement)?e.srcElement:e.target;
var _b9=rtvGetNodeID(e);
if(_b9!=null&&src.tagName!="DIV"){
var _ba=this.FindNode(_b9);
if(_ba.Selected){
if(this.AllowNodeEditing){
_ba.StartEdit();
return;
}else{
this.Select(_b9,e);
}
}else{
this.Select(_b9,e);
}
}
if(src.tagName=="IMG"){
var _bb=src.className;
if(this.IsSet(_bb)&&this.IsToggleImage(_bb)){
this.Toggle(src.parentNode.id);
}
}
if(src.tagName=="INPUT"&&rtvInsideNode(src)){
this.CheckBoxClick(src.parentNode.id,e);
}
};
RadTreeView.prototype.IsToggleImage=function(n){
return (n==1||n==2||n==5||n==6||n==7||n==8||n==10||n==11);
};
RadTreeView.prototype.DoubleClickDispatcher=function(e,_be){
var _bf=this.FindNode(_be);
if(this.FireEvent(this.BeforeClientDoubleClick,_bf)==false){
return;
}
this.Toggle(_be);
};
RadTreeView.prototype.MouseOverDispatcher=function(e,_c1){
this.Hover(_c1,e);
};
RadTreeView.prototype.MouseOutDispatcher=function(e,_c3){
this.UnHover(_c3,e);
this.LastDragNode=null;
this.LastHighlighted=null;
};
RadTreeView.prototype.DetermineDirection=function(){
var _c4=document.getElementById(this.Container);
while(_c4){
if(_c4.dir){
this.RightToLeft=(_c4.dir.toLowerCase()=="rtl");
return;
}
_c4=_c4.parentNode;
}
this.RightToLeft=false;
};
RadTreeView.prototype.MouseDown=function(e){
if(this.LastHighlighted!=null&&this.DragAndDrop){
if(this.FireEvent(this.BeforeClientDrag,this.LastHighlighted)==false){
return;
}
if(!this.LastHighlighted.DragEnabled){
return;
}
if(e.button==2){
return;
}
this.DragSource=this.LastHighlighted;
this.DragClone=document.createElement("div");
document.body.appendChild(this.DragClone);
RadTreeView_DragActive=this;
var res="";
if(this.MultipleSelect&&(this.SelectedNodesCount()>1)){
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].Selected){
if(this.AllNodes[i].Image){
var img=this.AllNodes[i].ImageElement();
var _c9=img.cloneNode(true);
this.DragClone.appendChild(_c9);
}
var _ca=this.AllNodes[i].TextElement().cloneNode(true);
_ca.className=this.AllNodes[i].NodeCss;
_ca.style.color="gray";
this.DragClone.appendChild(_ca);
this.DragClone.appendChild(document.createElement("BR"));
}
res=res+"text";
}
}
if(res==""){
if(this.LastHighlighted.Image){
var img=this.LastHighlighted.ImageElement();
var _c9=img.cloneNode(true);
this.DragClone.appendChild(_c9);
}
var _ca=this.LastHighlighted.TextElement().cloneNode(true);
_ca.className=this.LastHighlighted.NodeCss;
_ca.style.color="gray";
this.DragClone.appendChild(_ca);
}
this.DragClone.style.position="absolute";
this.DragClone.style.display="none";
if(e.preventDefault){
e.preventDefault();
}
}
};
RadTreeView.prototype.SelectedNodesCount=function(){
var _cb=0;
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].Selected){
_cb++;
}
}
return _cb;
};
RadTreeView.prototype.FireEvent=function(_cd,a,b,c,d){
if(!_cd){
return true;
}
RadTreeViewGlobalFirstParam=a;
RadTreeViewGlobalSecondParam=b;
RadTreeViewGlobalThirdParam=c;
RadTreeViewGlobalFourthParam=d;
var s=_cd+"(RadTreeViewGlobalFirstParam, RadTreeViewGlobalSecondParam, RadTreeViewGlobalThirdParam, RadTreeViewGlobalFourthParam);";
return eval(s);
};
RadTreeView.prototype.Focus=function(e){
this.FireEvent(this.AfterClientFocus,this);
};
RadTreeView.prototype.IsSet=function(a){
return (a!=null&&a!="");
};
RadTreeView.prototype.GetX=function(obj){
var pos=this.GetElementPosition(obj);
return pos.x;
};
RadTreeView.prototype.GetY=function(obj){
var pos=this.GetElementPosition(obj);
return pos.y;
};
RadTreeView.prototype.GetElementPosition=function(el){
var _da=null;
var pos={x:0,y:0};
var box;
if(el.getBoundingClientRect){
box=el.getBoundingClientRect();
var _dd=document.documentElement.scrollTop||document.body.scrollTop;
var _de=document.documentElement.scrollLeft||document.body.scrollLeft;
pos.x=box.left+_de-2;
pos.y=box.top+_dd-2;
return pos;
}else{
if(document.getBoxObjectFor){
try{
box=document.getBoxObjectFor(el);
pos.x=box.x-2;
pos.y=box.y-2;
}
catch(e){
}
}else{
pos.x=el.offsetLeft;
pos.y=el.offsetTop;
_da=el.offsetParent;
if(_da!=el){
while(_da){
pos.x+=_da.offsetLeft;
pos.y+=_da.offsetTop;
_da=_da.offsetParent;
}
}
}
}
if(window.opera){
_da=el.offsetParent;
while(_da&&_da.tagName.toLowerCase()!="body"&&_da.tagName.toLowerCase()!="html"){
pos.x-=_da.scrollLeft;
pos.y-=_da.scrollTop;
_da=_da.offsetParent;
}
}else{
_da=el.parentNode;
while(_da&&_da.tagName.toLowerCase()!="body"&&_da.tagName.toLowerCase()!="html"){
pos.x-=_da.scrollLeft;
pos.y-=_da.scrollTop;
_da=_da.parentNode;
}
}
return pos;
};
RadTreeView.prototype.PostBack=function(_df,_e0){
var _e1=_df+"#"+_e0;
if(this.PostBackOptionsClientString){
var _e2=this.PostBackOptionsClientString.replace(/@@arguments@@/g,_e1);
if(typeof (WebForm_PostBackOptions)!="undefined"||_e2.indexOf("_doPostBack")>-1||_e2.indexOf("AsyncRequest")>-1||_e2.indexOf("AsyncRequest")>-1||_e2.indexOf("AjaxNS")>-1){
eval(_e2);
}
}else{
if(this.CausesValidation){
if(!(typeof (Page_ClientValidate)!="function"||Page_ClientValidate())){
return;
}
}
var _e3=this.PostBackFunction.replace(/@@arguments@@/g,_e1);
eval(_e3);
}
};
RadTreeView.prototype.EscapeParameter=function(_e4){
var _e5=_e4.replace(/'/g,"&squote");
_e5=_e5.replace(/#/g,"&ssharp");
_e5=_e5.replace(/:/g,"&scolon");
_e5=_e5.replace(/\\/g,"\\\\");
return _e5;
};
RadTreeView.prototype.IsRootNodeTag=function(_e6){
if(_e6&&_e6.tagName=="DIV"&&_e6.id.indexOf(this.ID)>-1){
return true;
}
return false;
};
RadTreeView.prototype.SetBorderOnDrag=function(_e7,_e8,e){
if(this.DragAndDropBetweenNodes&&this.IsDragActive()){
this.LastDragNode=_e7;
var _ea=this.CalculateYPos(e);
var _eb=this.GetY(_e8);
if(_ea<_eb+_e7.TextElement().offsetHeight){
_e8.style.borderTop="1px dotted black";
this.LastDragPosition="above";
}else{
_e8.style.borderBottom="1px dotted black";
this.LastDragPosition="below";
}
this.LastBorderElementSet=_e8;
}
};
RadTreeView.prototype.ClearBorderOnDrag=function(_ec){
if(_ec&&this.DragAndDropBetweenNodes&&this.IsDragActive()){
_ec.style.borderTop="0px none black";
_ec.style.borderBottom="0px none black";
this.LastDragPosition="over";
}
};
RadTreeView.prototype.AttachEvent=function(_ed,_ee,_ef){
if(_ed.attachEvent){
_ed.attachEvent("on"+_ee,_ef);
}else{
if(_ed.addEventListener){
_ed.addEventListener(_ee,_ef,false);
}
}
};
RadTreeView.prototype.DetachEvent=function(_f0,_f1,_f2){
if(_f0.detachEvent){
_f0.detachEvent("on"+_f1,_f2);
}else{
if(_f0.removeEventListener){
_f0.removeEventListener(_f1,_f2,false);
}
}
};
RadTreeView.prototype.IsDragActive=function(){
for(var key in tlrkTreeViews){
if((typeof (tlrkTreeViews[key])!="function")&&tlrkTreeViews[key].DragClone!=null){
return true;
}
}
return false;
};
RadTreeView.prototype.GetScrollBarWidth=function(){
try{
if(typeof (this.scrollbarWidth)=="undefined"){
var _f4,_f5=0;
var _f6=document.createElement("div");
_f6.style.position="absolute";
_f6.style.top="-1000px";
_f6.style.left="-1000px";
_f6.style.width="100px";
_f6.style.overflow="auto";
var _f7=document.createElement("div");
_f7.style.width="1000px";
_f6.appendChild(_f7);
document.body.appendChild(_f6);
_f4=_f6.offsetWidth;
_f5=_f6.clientWidth;
document.body.removeChild(document.body.lastChild);
this.scrollbarWidth=_f4-_f5;
if(this.scrollbarWidth<=0||_f5==0){
this.scrollbarWidth=16;
}
}
return this.scrollbarWidth;
}
catch(error){
return false;
}
};
function rtvIsAnyContextMenuVisible(){
for(var key in tlrkTreeViews){
if((typeof (tlrkTreeViews[key])!="function")&&tlrkTreeViews[key].ContextMenuVisible){
return true;
}
}
return false;
}
function rtvAdjustScroll(){
if(RadTreeView_DragActive==null||RadTreeView_DragActive.DragClone==null||RadTreeView_Active==null){
return;
}
var _f9=RadTreeView_Active;
var _fa=document.getElementById(RadTreeView_Active.Container);
if(_fa){
var _fb,_fc;
_fb=_f9.GetY(_fa);
_fc=_fb+_fa.offsetHeight;
if((RadTreeView_MouseY-_fb)<50&&_fa.scrollTop>0){
_fa.scrollTop=_fa.scrollTop-10;
_f9.Scroll();
RadTreeView_ScrollTimeout=window.setTimeout(function(){
rtvAdjustScroll();
},100);
}else{
if((_fc-RadTreeView_MouseY)<50&&_fa.scrollTop<(_fa.scrollHeight-_fa.offsetHeight+16)){
_fa.scrollTop=_fa.scrollTop+10;
_f9.Scroll();
RadTreeView_ScrollTimeout=window.setTimeout(function(){
rtvAdjustScroll();
},100);
}
}
}
}
function rtvMouseUp(e){
if(RadTreeView_Active==null){
return;
}
if(e&&!e.ctrlKey){
for(var key in tlrkTreeViews){
if((typeof (tlrkTreeViews[key])!="function")&&tlrkTreeViews[key].ContextMenuVisible){
contextMenuToBeHidden=tlrkTreeViews[key];
window.setTimeout(function(){
if(contextMenuToBeHidden){
contextMenuToBeHidden.HideContextMenu();
}
},10);
return;
}
}
}
if(RadTreeView_DragActive==null||RadTreeView_DragActive.DragClone==null){
return;
}
(document.all)?e.returnValue=false:e.preventDefault();
var _ff=RadTreeView_DragActive.DragSource;
var _100=RadTreeView_Active.LastHighlighted;
var _101=RadTreeView_Active;
var _102="over";
var _103;
if(_101.LastBorderElementSet){
_102=_101.LastDragPosition;
_103=_101.LastDragNode;
_101.ClearBorderOnDrag(_101.LastBorderElementSet);
}
if(_103){
_100=_103;
}
document.body.removeChild(RadTreeView_DragActive.DragClone);
RadTreeView_DragActive.DragClone=null;
if(_100!=null&&_100.DropEnabled==false){
return;
}
if(_ff==_100){
return;
}
if(RadTreeView_DragActive.FireEvent(RadTreeView_DragActive.BeforeClientDrop,_ff,_100,e,_102)==false){
return;
}
if(_ff.IsClientNode||((_100!=null)&&_100.IsClientNode)){
return;
}
var _104=RadTreeView_DragActive.ClientID+"#"+_ff.ClientID+"#";
var _105="";
if(_100==null){
_105="null"+"#"+RadTreeView_DragActive.HtmlElementID;
}else{
_105=_101.ClientID+"#"+_100.ClientID+"#"+_102;
}
if(_100==null&&RadTreeView_DragActive.HtmlElementID==""){
return;
}
var _106=_104+_105;
RadTreeView_DragActive.PostBack("NodeDrop",_106);
RadTreeView_DragActive.FireEvent(RadTreeView_DragActive.AfterClientDrop,_ff,_100,e);
RadTreeView_DragActive=null;
}
function rtvMouseMove(e){
if(rtvIsAnyContextMenuVisible()){
return;
}
if(RadTreeView_DragActive!=null&&RadTreeView_DragActive.DragClone!=null){
var newX,newY;
RadTreeView_DragActive.DetermineDirection();
if(!RadTreeView_DragActive.RightToLeft){
newX=RadTreeView_DragActive.CalculateXPos(e)+8;
newY=RadTreeView_DragActive.CalculateYPos(e)+4;
}else{
newX=RadTreeView_DragActive.CalculateXPos(e)-RadTreeView_DragActive.DragClone.clientWidth-8;
if((document.body.dir.toLowerCase()=="rtl"||document.dir.toLowerCase()=="rtl")&&document.all&&!window.opera){
newX-=RadTreeView_DragActive.GetScrollBarWidth();
}
newY=RadTreeView_DragActive.CalculateYPos(e)+4;
}
RadTreeView_MouseY=newY;
rtvAdjustScroll();
RadTreeView_DragActive.DragClone.style.zIndex=999;
RadTreeView_DragActive.DragClone.style.top=newY+"px";
RadTreeView_DragActive.DragClone.style.left=newX+"px";
RadTreeView_DragActive.DragClone.style.display="block";
RadTreeView_DragActive.FireEvent(RadTreeView_DragActive.AfterClientMove,e);
}
}
function rtvNodeExpand(a,id,_10c){
var _10d=document.getElementById(id);
var _10e=_10d.scrollHeight;
var step=(_10e-a)/_10c;
var _110=a+step;
if(_110>_10e-1){
_10d.style.height="";
_10d.firstChild.style.position="";
}else{
_10d.style.height=_110+"px";
window.setTimeout("rtvNodeExpand("+_110+","+"'"+id+"',"+_10c+");",5);
}
}
function rtvNodeCollapse(a,id,_113){
var _114=document.getElementById(id);
var _115=_114.scrollHeight;
var step=(_115-Math.abs(_115-a))/_113;
var _117=a-step;
if(_117<=3){
_114.style.height="";
_114.style.display="none";
_114.firstChild.style.position="";
}else{
_114.style.height=_117+"px";
window.setTimeout("rtvNodeCollapse("+_117+","+"'"+id+"',"+_113+" );",5);
}
}
function rtvGetNodeID(e){
if(RadTreeView_Active==null){
return;
}
var _119=(e.srcElement)?e.srcElement:e.target;
if(_119.nodeType==3){
_119=_119.parentNode;
}
if(_119.tagName=="IMG"&&_119.nextSibling){
var _11a=_119.className;
if(_11a){
_11a=parseInt(_11a);
if(_11a>12){
_119=_119.nextSibling;
}
}
}
if(_119.id==RadTreeView_Active.ID){
return null;
}
if(_119.id.indexOf(RadTreeView_Active.ID)>-1&&_119.tagName=="DIV"){
return _119.id;
}
while(_119!=null){
if((_119.tagName=="SPAN"||_119.tagName=="A")&&rtvInsideNode(_119)){
return _119.parentNode.id;
}
_119=_119.parentNode;
}
return null;
}
function rtvInsideNode(_11b){
if(_11b.parentNode&&_11b.parentNode.tagName=="DIV"&&_11b.parentNode.id.indexOf(RadTreeView_Active.ID)>-1){
return _11b.parentNode.id;
}
}
function rtvDispatcher(t,w,e,p1,p2,p3){
if(!e){
e=window.event;
}
if(tlrkTreeViews){
var _122=rtvGetNodeID(e);
var _123=tlrkTreeViews[t];
if(!_123.IsBuilt){
return;
}
if(rtvIsAnyContextMenuVisible()&&w!="mclick"&&w!="cclick"){
return;
}
if(_123.EditMode){
return;
}
RadTreeView_Active=_123;
var _124=window.netscape&&!window.opera;
var _125=(navigator.userAgent.toLowerCase().indexOf("safari")!=-1);
switch(w){
case "mover":
if(_122!=null){
_123.MouseOverDispatcher(e,_122);
}
break;
case "mout":
if(_122!=null){
_123.MouseOutDispatcher(e,_122);
}
break;
case "mclick":
_123.MouseClickDispatcher(e);
break;
case "mdclick":
if(_122!=null){
_123.DoubleClickDispatcher(e,_122);
}
break;
case "mdown":
_123.MouseDown(e);
break;
case "mup":
_123.MouseUp(e);
break;
case "context":
if(_122!=null){
_123.ContextMenu(e,_122);
return false;
}
break;
case "cclick":
_123.ContextMenuClick(e,p1,p2,p3);
break;
case "focus":
_123.Focus(e);
case "keydown":
if(!_124&&!_125){
_123.KeyDown(e);
}
}
}
}
function rtvAppendStyleSheet(_126,_127){
var _128=(navigator.appName=="Microsoft Internet Explorer")&&((navigator.userAgent.toLowerCase().indexOf("mac")!=-1)||(navigator.appVersion.toLowerCase().indexOf("mac")!=-1));
var _129=(navigator.userAgent.toLowerCase().indexOf("safari")!=-1);
if(_128||_129){
document.write("<"+"link"+" rel='stylesheet' type='text/css' href='"+_127+"'>");
}else{
var _12a=document.createElement("LINK");
_12a.rel="stylesheet";
_12a.type="text/css";
_12a.href=_127;
document.getElementById(_126+"StyleSheetHolder").appendChild(_12a);
}
}
function rtvInsertHTML(_12b,html){
if(_12b.tagName=="A"){
_12b=_12b.parentNode;
}
if(document.all){
_12b.insertAdjacentHTML("beforeEnd",html);
}else{
var r=_12b.ownerDocument.createRange();
r.setStartBefore(_12b);
var _12e=r.createContextualFragment(html);
_12b.appendChild(_12e);
}
}

