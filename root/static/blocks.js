function loadBlock(block)
{
    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200)
        {
            var newDiv = document.createElement('div');
            var divname = 'block_'.concat(block);
            newDiv.id = divname;
            newDiv.className = divname;
            document.getElementById("main").appendChild(newDiv);

            document.getElementById(divname).innerHTML=xmlhttp.responseText;
        }
    }
    xmlhttp.open("GET","/block/".concat(block),true);
    xmlhttp.send();
};
function load( action, argument )
{
    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200)
        {
            var newDiv = document.createElement('div');
            var divname = 'l_block_'.concat(action).concat(argument);
            newDiv.id = divname;
            newDiv.className = divname;
            document.getElementById(action).appendChild(newDiv);

            document.getElementById(divname).innerHTML=xmlhttp.responseText;
        }
    }
    var url="/admin/".concat(action).concat("/");
    xmlhttp.open("GET",url.concat(argument),true);
    xmlhttp.send();
};
function loadLanguages(block)
{
    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200)
        {
            var newDiv = document.createElement('div');
            var divname = 'l_block_'.concat(block);
            newDiv.id = divname;
            newDiv.className = divname;
            document.getElementById("languages").appendChild(newDiv);

            document.getElementById(divname).innerHTML=xmlhttp.responseText;
        }
    }
    xmlhttp.open("GET","/admin/languages/".concat(block),true);
    xmlhttp.send();
}
function doPreview()
{
    form=document.getElementById('blockeditor');
    old=form.action;
    form.target='_black';
    form.action='/block';
    form.submit();
    form.action=old;
    form.target='';
}
