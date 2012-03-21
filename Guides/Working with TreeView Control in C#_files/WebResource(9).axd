function RadRotator(_1,_2,_3){
var _4=window[_1];
if(_4&&typeof (_4.Dispose)=="function"){
_4.Dispose();
}
this.ClientID=_1;
this.SmoothScrollDelay=10;
this.ControlElement=document.getElementById(_1+"_Div");
this.FrameContainer=document.getElementById(_1+"_FrameContainer");
if(_2){
this.FramesToShow=_2;
}else{
this.FramesToShow=1;
}
this.FrameContainer.style.top="0px";
this.FrameContainer.style.left="0px";
this.CurrentFrame=0;
var _5=this;
this.ControlElement.RadResize=this.ControlElement.RadShow=function(){
_5.FixHeight();
_5.Start();
this.style.cssText=this.style.cssText;
};
this.MouseEnterHandler=function(e){
_5.OnMouseEnter(e);
};
this.MouseLeaveHandler=function(e){
_5.OnMouseLeave(e);
};
this.MouseOverHandler=function(e){
_5.OnMouseOver(e);
};
this.MouseOutHandler=function(e){
_5.OnMouseOut(e);
};
this.OnLoadHandler=function(){
_5.Start();
};
this.AttachEvent(this.ControlElement,"mouseenter",this.MouseEnterHandler);
this.AttachEvent(this.ControlElement,"mouseleave",this.MouseLeaveHandler);
this.AttachEvent(this.ControlElement,"mouseover",this.MouseOverHandler);
this.AttachEvent(this.ControlElement,"mouseout",this.MouseOutHandler);
this.AttachEvent(window,"load",this.OnLoadHandler);
this.UnLoadHandler=function(){
_5.Dispose();
};
this.AttachEvent(window,"unload",_5.UnLoadHandler);
}
RadRotator.prototype.Dispose=function(){
this.disposed=true;
try{
this.DetachEvent(window,"unload",this.UnLoadHandler);
this.UnLoadHandler=null;
this.ClearTimeouts();
this.DetachEvent(this.ControlElement,"mouseenter",this.MouseEnterHandler);
this.MouseEnterHandler=null;
this.DetachEvent(this.ControlElement,"mouseleave",this.MouseLeaveHandler);
this.MouseLeaveHandler=null;
this.DetachEvent(this.ControlElement,"mouseover",this.MouseOverHandler);
this.MouseOverHandler=null;
this.DetachEvent(this.ControlElement,"mouseout",this.MouseOutHandler);
this.MouseOutHandler=null;
this.DetachEvent(window,"load",this.OnLoadHandler);
this.OnLoadHandler=null;
this.ControlElement=null;
this.FrameContainer=null;
}
catch(error){
}
};
RadRotator.prototype.attachEvent=function(_a,_b){
var _c=this.FunctionFromVariable(_b);
var _d=function(_e,_f){
return _c(_e,_f);
};
this[_a+"Handler"]=_d;
};
RadRotator.prototype.FunctionFromVariable=function(_10){
var _11=function(_12,_13){
};
if(typeof (_10).toString().toLowerCase()=="function"){
_11=_10;
}else{
if(typeof (_10).toString().toLowerCase()=="string"){
try{
_11=eval(_10);
}
catch(error){
}
}
}
return _11;
};
RadRotator.prototype.FireOnClientFrameChanging=function(_14){
if(this.OnClientFrameChangingHandler!=null){
var _15=this.OnClientFrameChangingHandler;
return _15(this,{});
}
};
RadRotator.prototype.FireOnClientFrameChanged=function(_16){
this.FireTickers();
var _17=this;
if(this.RotatorMode.toLowerCase()=="scroll"){
window.clearTimeout(this.scroll_timeout);
this.scroll_timeout=0;
this.scroll_timeout=window.setTimeout(function(){
_17.StartScroll();
},this.FrameTimeout);
}
if(this.RotatorMode.toLowerCase()=="slideshow"){
window.clearTimeout(this.show_timeout);
this.show_timeout=0;
this.show_timeout=window.setTimeout(function(){
_17.StartSlideShow();
},this.FrameTimeout);
}
if(this.OnClientFrameChangedHandler!=null){
var _18=this.OnClientFrameChangedHandler;
return _18(this,{});
}
};
RadRotator.prototype.Random=function(max){
return parseInt(((max*Math.random())%max));
};
RadRotator.prototype.PauseToggle=function(_1a){
if(_1a){
this.Paused=true;
}else{
this.Paused=false;
}
};
RadRotator.prototype.AttachEvent=function(_1b,_1c,_1d){
try{
if(_1b.attachEvent){
_1b.attachEvent("on"+_1c,_1d);
}else{
_1b.addEventListener(_1c,_1d,true);
}
}
catch(error){
}
};
RadRotator.prototype.DetachEvent=function(_1e,_1f,_20){
if(_1e==null||_1f==null||_20==null){
return;
}
try{
if(_1e.detachEvent){
_1e.detachEvent("on"+_1f,_20);
}else{
_1e.removeEventListener(_1f,_20,true);
}
}
catch(error){
}
};
RadRotator.prototype.OnMouseEnter=function(e){
if(!this.AutoAdvance){
return;
}
if(this.PauseOnMouseOver){
this.PauseToggle(true);
}
};
RadRotator.prototype.OnMouseLeave=function(){
if(!this.AutoAdvance){
return;
}
if(this.PauseOnMouseOver){
this.PauseToggle(false);
}
};
RadRotator.prototype.OnMouseOver=function(){
if(!this.AutoAdvance){
return;
}
if(document.all&&!window.opera){
return;
}
if(this.PauseOnMouseOver){
this.PauseToggle(true);
}
};
RadRotator.prototype.OnMouseOut=function(){
if(!this.AutoAdvance){
return;
}
if(document.all&&!window.opera){
return;
}
if(this.PauseOnMouseOver){
this.PauseToggle(false);
}
};
RadRotator.prototype.OnMouseClick=function(id){
var _23="__doPostBack('"+this.UniqueID+"','"+id+"')";
eval(_23);
return;
};
RadRotator.prototype.StartRotator=function(){
this.Frozen=false;
if(this.stopped==0){
return;
}
this.stopped=0;
this.AutoAdvance=1;
if(this.RotatorMode.toLowerCase()=="scroll"){
this.StartScroll();
}else{
this.StartSlideShow();
}
};
RadRotator.prototype.StopRotator=function(){
if(this.RotatorMode.toLowerCase()=="scroll"){
this.StopScroll();
}else{
this.StopSlideShow();
}
};
RadRotator.prototype.StopSlideShow=function(){
this.stopped=1;
this.AutoAdvance=0;
};
RadRotator.prototype.StopScroll=function(){
this.stopped=1;
this.AutoAdvance=0;
};
RadRotator.prototype.Start=function(){
if(this.disposed==true){
return;
}
if(this.ControlElement.offsetWidth==0){
return;
}
this.FixHeight();
this.FireTickers();
if(this.RotatorMode!=null&&this.RotatorMode.toLowerCase()=="scroll"){
this.InitScroll();
var _24=this;
window.clearTimeout(this.scroll_timeout);
this.scroll_timeout=window.setTimeout(function(){
_24.StartScroll();
},this.FrameTimeout);
}
if(this.RotatorMode!=null&&this.RotatorMode.toLowerCase()=="slideshow"){
var _24=this;
window.clearTimeout(this.show_timeout);
if(this.UseRandomSlide){
_24.StartSlideShow();
}else{
this.show_timeout=window.setTimeout(function(){
_24.StartSlideShow();
},this.FrameTimeout);
}
}
};
RadRotator.prototype.FireTickers=function(){
if(this.disposed==true||!this.ControlElement.parentNode){
return;
}
if(this.HasTickers){
this.ResetTickers();
var _25=this.FrameIdArray;
var _26=RadRotator.RadGetElementRect(this.ControlElement);
for(var i=0;i<this.NumberOfFrames;i++){
var _28=document.getElementById(_25[i]);
var _29=RadRotator.RadGetElementRect(_28);
if(_26.Intersects(_29)||((null!=document.readyState&&"complete"!=document.readyState))){
eval(this[_28.id+"_s"]);
}
}
}
};
RadRotator.prototype.ResetTickers=function(){
if(this.HasTickers){
for(var i=0;i<this.NumberOfTickers;i++){
if(window[this.TickerIdArray[i]].tagName){
return;
}
window[this.TickerIdArray[i]].ResetTicker();
}
}
};
RadRotator.prototype.Freeze=function(){
this.Frozen=true;
};
RadRotator.prototype.FixHeight=function(){
var _2b;
var _2c;
this.ControlElement.style.zoom="1";
if(parseInt(this.ControlElement.offsetWidth)>0){
_2b=this.ControlElement.offsetWidth;
}else{
_2b=this.ControlElement.style.width;
}
if(parseInt(this.ControlElement.offsetHeight)>0){
_2c=this.ControlElement.offsetHeight;
}else{
_2c=this.ControlElement.style.height;
}
if(this.RotatorMode.toLowerCase()=="scroll"&&(this.ScrollDirection.toLowerCase()=="left"||this.ScrollDirection.toLowerCase()=="right")){
this.FrameWidth=parseInt(_2b)/this.FramesToShow;
this.FrameHeight=parseInt(_2c);
this.FrameContainer.style.width=(this.FrameWidth*this.NumberOfFrames)+"px";
}
if(this.RotatorMode.toLowerCase()=="scroll"&&(this.ScrollDirection.toLowerCase()=="up"||this.ScrollDirection.toLowerCase()=="down")){
this.FrameWidth=parseInt(_2b);
this.FrameHeight=parseInt(_2c)/this.FramesToShow;
this.FrameContainer.style.height=(this.FrameHeight*this.NumberOfFrames)+"px";
}
if(this.RotatorMode.toLowerCase()=="slideshow"){
this.FrameWidth=parseInt(_2b);
this.FrameHeight=parseInt(_2c);
}
var _2d=this.FrameIdArray;
for(var i=0;i<this.NumberOfFrames;i++){
var _2f=document.getElementById(_2d[i]);
_2f.style.height=this.FrameHeight+"px";
_2f.style.width=this.FrameWidth+"px";
}
};
RadRotator.prototype.StartSlideShow=function(){
if(this.disposed==true){
return;
}
if(this.NumberOfFrames/this.FramesToShow<=1){
return;
}
if(this.AutoAdvance){
this.ShowNextFrame();
}
};
RadRotator.prototype.InitScroll=function(){
if(this.ScrollDirection.toLowerCase()=="down"){
this.FrameContainer.style.top=(this.NumberOfFrames-this.FramesToShow)*this.FrameHeight*(-1)+"px";
}
if(this.ScrollDirection.toLowerCase()=="right"){
this.FrameContainer.style.left=(this.NumberOfFrames-this.FramesToShow)*this.FrameWidth*(-1)+"px";
}
this.FireTickers();
};
RadRotator.prototype.StartScroll=function(){
if(this.disposed==true){
return;
}
if(this.NumberOfFrames/this.FramesToShow<=1){
return;
}
if(this.FireOnClientFrameChanging(this)==false){
return;
}
if(this.AutoAdvance){
this.ScrollShow();
}
};
RadRotator.prototype.ScrollShow=function(){
switch(this.ScrollDirection.toLowerCase()){
case "up":
this.ScrollUpNextFrame();
break;
case "down":
this.ScrollDownNextFrame();
break;
case "left":
this.ScrollLeftNextFrame();
break;
case "right":
this.ScrollRightNextFrame();
break;
}
};
RadRotator.prototype.ShowPrevFrame=function(){
if(this.RotatorMode.toLowerCase()!="slideshow"){
alert("Do not call this function when rotator is in scrolling mode!");
return;
}
this.CurrentFrame=(this.CurrentFrame-2)%this.NumberOfFrames;
if(this.CurrentFrame<-1){
this.CurrentFrame=this.NumberOfFrames-2;
}
this.ShowNextFrame();
};
RadRotator.prototype.ShowNextFrame=function(){
if(this.disposed==true){
return;
}
if(this.RotatorMode.toLowerCase()!="slideshow"){
alert("Do not call this function when rotator is in scrolling mode!");
return;
}
if(this.Paused){
var _30=this;
window.clearTimeout(this.show_timeout);
this.show_timeout=0;
this.show_timeout=window.setTimeout(function(){
_30.ShowNextFrame();
},this.FrameTimeout);
return;
}
if(this.FireOnClientFrameChanging(this)==false){
return;
}
var _31;
if(this.UseRandomSlide){
do{
_31=this.Random(this.NumberOfFrames)*this.FrameHeight*(-1);
}while(_31==parseInt(this.FrameContainer.style.top));
}else{
this.CurrentFrame=(this.CurrentFrame+1)%this.NumberOfFrames;
_31=this.CurrentFrame*this.FrameHeight*(-1);
}
if(this.UseTransition&&document.all&&!window.opera){
try{
if(this.UseRandomEffect){
this.ControlElement.style.filter=this.TransitionStrings[this.Random(17)];
}else{
this.ControlElement.style.filter=this.TransitionString;
}
this.ControlElement.filters[0].Apply();
this.ControlElement.filters[0].Play();
}
catch(e){
}
}
this.FrameContainer.style.top=_31+"px";
this.FireOnClientFrameChanged();
};
RadRotator.prototype.ScrollLeftNextFrame=function(){
if(this.disposed==true){
return;
}
if(this.RotatorMode.toLowerCase()!="scroll"){
alert("Do not call this function when rotator is in slideshow mode!");
return;
}
if(this.ScrollDirection.toLowerCase()=="up"||this.ScrollDirection.toLowerCase()=="down"){
alert("Do not call this function when rotator is in vertical scrolling mode!");
return;
}
if(this.Frozen){
return;
}
if(this.Paused){
var _32=this;
this.frame_timeout=0;
this.frame_timeout=window.setTimeout(function(){
_32.ScrollLeftNextFrame();
},this.ScrollSpeed);
return;
}
if(parseInt(this.FrameContainer.style.left)>this.FrameWidth*(-1)){
this.FrameChaning=true;
if(!this.UseSmoothScroll){
this.FrameContainer.style.left=(parseInt(this.FrameContainer.style.left)-1)+"px";
}else{
var _33=(this.FrameWidth*(-1)-parseInt(this.FrameContainer.style.left))/this.SmoothScrollDelay;
this.FrameContainer.style.left=(parseInt(this.FrameContainer.style.left)+_33-1)+"px";
}
var _32=this;
this.frame_timeout=0;
this.frame_timeout=window.setTimeout(function(){
_32.ScrollLeftNextFrame();
},this.ScrollSpeed);
}else{
var _34=this.FrameContainer.firstChild.firstChild.firstChild;
this.FrameContainer.firstChild.firstChild.removeChild(this.FrameContainer.firstChild.firstChild.firstChild);
this.FrameContainer.firstChild.firstChild.appendChild(_34);
this.FrameContainer.style.left="0px";
this.CurrentFrame=(this.CurrentFrame+1)%this.NumberOfFrames;
this.FireOnClientFrameChanged();
this.FrameChaning=false;
}
};
RadRotator.prototype.ScrollRightNextFrame=function(){
if(this.disposed==true){
return;
}
if(this.RotatorMode.toLowerCase()!="scroll"){
alert("Do not call this function when rotator is in slideshow mode!");
return;
}
if(this.ScrollDirection.toLowerCase()=="up"||this.ScrollDirection.toLowerCase()=="down"){
alert("Do not call this function when rotator is in vertical scrolling mode!");
return;
}
if(this.Frozen){
return;
}
if(this.Paused){
var _35=this;
this.frame_timeout=0;
this.frame_timeout=window.setTimeout(function(){
_35.ScrollRightNextFrame();
},this.ScrollSpeed);
return;
}
if(parseInt(this.FrameContainer.style.left)<this.FrameWidth*(this.NumberOfFrames-this.FramesToShow-1)*(-1)){
this.FrameChaning=true;
if(!this.UseSmoothScroll){
this.FrameContainer.style.left=parseInt(this.FrameContainer.style.left)+1+"px";
}else{
var _36=(((this.NumberOfFrames-this.FramesToShow)*this.FrameWidth*(-1)+this.FrameWidth)-parseInt(this.FrameContainer.style.left))/this.SmoothScrollDelay;
this.FrameContainer.style.left=parseInt(this.FrameContainer.style.left)+_36+"px";
}
var _35=this;
this.frame_timeout=0;
this.frame_timeout=window.setTimeout(function(){
_35.ScrollRightNextFrame();
},this.ScrollSpeed);
}else{
var _37=this.FrameContainer.firstChild.firstChild.lastChild;
this.FrameContainer.firstChild.firstChild.removeChild(this.FrameContainer.firstChild.firstChild.lastChild);
this.FrameContainer.firstChild.firstChild.insertBefore(_37,this.FrameContainer.firstChild.firstChild.firstChild);
this.FrameContainer.style.left=(this.NumberOfFrames-this.FramesToShow)*this.FrameWidth*(-1)+"px";
this.CurrentFrame=(this.CurrentFrame+1)%this.NumberOfFrames;
this.FireOnClientFrameChanged();
this.FrameChaning=false;
}
};
RadRotator.prototype.ScrollDownNextFrame=function(){
if(this.disposed==true){
return;
}
if(this.RotatorMode.toLowerCase()!="scroll"){
alert("Do not call this function when rotator is in slideshow mode!");
return;
}
if(this.ScrollDirection.toLowerCase()=="right"||this.ScrollDirection.toLowerCase()=="left"){
alert("Do not call this function when rotator is in horizontal scrolling mode!");
return;
}
if(this.Frozen){
return;
}
if(this.Paused){
var _38=this;
this.frame_timeout=0;
this.frame_timeout=window.setTimeout(function(){
_38.ScrollDownNextFrame();
},this.ScrollSpeed);
return;
}
if(parseInt(this.FrameContainer.style.top)<(this.NumberOfFrames-this.FramesToShow)*this.FrameHeight*(-1)+this.FrameHeight){
this.FrameChaning=true;
if(!this.UseSmoothScroll){
this.FrameContainer.style.top=parseInt(this.FrameContainer.style.top)+1+"px";
}else{
var _39=(((this.NumberOfFrames-this.FramesToShow)*this.FrameHeight*(-1)+this.FrameHeight)-parseInt(this.FrameContainer.style.top))/this.SmoothScrollDelay;
this.FrameContainer.style.top=parseInt(this.FrameContainer.style.top)+_39+"px";
}
var _38=this;
this.frame_timeout=0;
this.frame_timeout=window.setTimeout(function(){
_38.ScrollDownNextFrame();
},this.ScrollSpeed);
}else{
var _3a=this.FrameContainer.lastChild;
this.FrameContainer.removeChild(this.FrameContainer.lastChild);
this.FrameContainer.insertBefore(_3a,this.FrameContainer.firstChild);
this.FrameContainer.style.top=(this.NumberOfFrames-this.FramesToShow)*this.FrameHeight*(-1)+"px";
this.CurrentFrame=(this.CurrentFrame+1)%this.NumberOfFrames;
this.FireOnClientFrameChanged();
this.FrameChaning=false;
}
};
RadRotator.prototype.ScrollUpNextFrame=function(){
if(this.disposed==true){
return;
}
if(this.RotatorMode.toLowerCase()!="scroll"){
alert("Do not call this function when rotator is in slideshow mode!");
return;
}
if(this.ScrollDirection.toLowerCase()=="right"||this.ScrollDirection.toLowerCase()=="left"){
alert("Do not call this function when rotator is in horizontal scrolling mode!");
return;
}
if(this.Frozen){
return;
}
if(this.Paused){
var _3b=this;
this.frame_timeout=0;
this.frame_timeout=window.setTimeout(function(){
_3b.ScrollUpNextFrame();
},this.ScrollSpeed);
return;
}
if(parseInt(this.FrameContainer.style.top)>this.FrameHeight*(-1)){
this.FrameChaning=true;
if(!this.UseSmoothScroll){
this.FrameContainer.style.top=(parseInt(this.FrameContainer.style.top)-1)+"px";
}else{
var _3c=(this.FrameHeight*(-1)-parseInt(this.FrameContainer.style.top))/this.SmoothScrollDelay;
this.FrameContainer.style.top=(parseInt(this.FrameContainer.style.top)+_3c-1)+"px";
}
var _3b=this;
this.frame_timeout=0;
this.frame_timeout=window.setTimeout(function(){
_3b.ScrollUpNextFrame();
},this.ScrollSpeed);
}else{
try{
var _3d=this.FrameContainer.firstChild;
this.FrameContainer.removeChild(this.FrameContainer.firstChild);
this.FrameContainer.appendChild(_3d);
this.FrameContainer.style.top="0px";
this.CurrentFrame=(this.CurrentFrame+1)%this.NumberOfFrames;
this.FireOnClientFrameChanged();
this.FrameChaning=false;
}
catch(e){
}
}
};
function Rectangle(_3e,top,_40,_41){
this.left=(null!=_3e?_3e:0);
this.top=(null!=top?top:0);
this.width=(null!=_40?_40:0);
this.height=(null!=_41?_41:0);
this.right=_3e+_40;
this.bottom=top+_41;
}
Rectangle.prototype.Clone=function(){
return new Rectangle(this.left,this.top,this.width,this.height);
};
Rectangle.prototype.PointInRect=function(x,y){
return (this.left<=x&&x<=(this.left+this.width)&&this.top<=y&&y<=(this.top+this.height));
};
Rectangle.prototype.Intersects=function(_44){
if(null==_44){
return false;
}
if(this==_44){
return true;
}
return (_44.left<this.right&&_44.top<this.bottom&&_44.right>this.left&&_44.bottom>this.top);
};
Rectangle.prototype.Intersection=function(_45){
if(null==_45){
return false;
}
if(this==_45){
return this.Clone();
}
if(!this.Intersects(_45)){
return new Rectangle();
}
var _46=Math.max(this.left,_45.left);
var top=Math.max(this.top,_45.top);
var _48=Math.min(this.right,_45.right);
var _49=Math.min(this.bottom,_45.bottom);
return new Rectangle(_46,_48,_48-_46,_49-top);
};
RadRotator.prototype.ClearTimeouts=function(){
window.clearTimeout(this.scroll_timeout);
window.clearTimeout(this.show_timeout);
window.clearTimeout(this.frame_timeout);
};
RadRotator.RadGetElementRect=function(_4a){
if(!_4a){
_4a=this;
}
var _4b=0;
var top=0;
var _4d=_4a.offsetWidth;
var _4e=_4a.offsetHeight;
while(_4a.offsetParent){
_4b+=_4a.offsetLeft;
top+=_4a.offsetTop;
_4a=_4a.offsetParent;
}
if(_4a.x){
_4b=_4a.x;
}
if(_4a.y){
top=_4a.y;
}
return new Rectangle(_4b,top,_4d,_4e);
};

