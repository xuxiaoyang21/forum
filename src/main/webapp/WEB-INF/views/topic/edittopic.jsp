<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="shortcut icon" href="/static/img/edit.png">
    <title>编辑主题</title>
    <link href="/static/font-awesome-4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="/static/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/static/css/style.css">
    <link rel="stylesheet" href="/static/js/editer/styles/simditor.css">
    <link rel="stylesheet" href="/static/css/simditor-emoji.css">
</head>
<body>
<%@include file="../include/navbar.jsp"%>
<!--header-bar end-->
<div class="container">
    <c:choose>
        <c:when test="${not empty topic }">
            <div class="box">
                <div class="box-header">
                    <span class="title"><i class="fa fa-edit"></i> 编辑主题</span>
                </div>

                <form action="" id="topicForm" style="padding: 20px">
                    <input type="hidden" name="topicid" value="${topic.id}">
                    <label class="control-label">主题标题</label>
                    <input name="title" id="title" type="text" value="${topic.title}" style="width: 100%;box-sizing: border-box;height: 30px" placeholder="请输入主题标题，如果标题能够表达完整内容，则正文可以为空">
                    <label class="control-label">正文</label>
                    <textarea name="content" id="editor" >${topic.content}</textarea>

                    <select name="nodeid" id="nodeid" style="margin-top:15px;">
                        <option value="">请选择节点</option>
                        <c:forEach items="${nodeList}" var="node">
                            <option ${topic.node.id==node.id?'selected':''} value="${node.id}">${node.nodename}</option>
                        </c:forEach>
                    </select>
                </form>
                <div class="form-actions" style="text-align: right">
                    <button id="sendBtn"class="btn btn-primary">发布主题</button>
                </div>
            </div>
            <!--box end-->
        </c:when>
        <c:otherwise>
            <strong>当前主题不可编辑或已被删除</strong>
        </c:otherwise>
    </c:choose>
</div>
<!--container end-->
<script src="http://cdn.bootcss.com/jquery/1.11.2/jquery.min.js"></script>
<script src="/static/js/editer/scripts/module.min.js"></script>
<script src="/static/js/editer/scripts/hotkeys.min.js"></script>
<script src="/static/js/editer/scripts/uploader.min.js"></script>
<script src="/static/js/editer/scripts/simditor.min.js"></script>
<script src="/static/js/jquery.validate.min.js"></script>
<script src="/static/js/simditor-emoji.js"></script>
<script>
    $(function(){
        var editor = new Simditor({
            textarea: $('#editor'),
            //optional options
            toolbar: ['title','bold','italic','underline','strikethrough',
                'fontScale','color','ol' ,'ul', 'blockquote','code',
                'table', 'image','emoji'],
            emoji: {
                imagePath: '/static/img/emoji/',
                images: ['+1.png',
                    '100.png',
                    '109.png']
            },
            upload:{
                url: 'http://up-z1.qiniu.com/',
                params:{"token":"${token}"},
                fileKey:'file'
            }


        });
        $("#sendBtn").click(function () {
            $("#topicForm").submit();
        });
        $("#topicForm").validate({
            errorElement:"span",
            errorClass:"text-error",
            rules:{
                title:{
                    required:true
                },
                nodeid:{
                    required:true
                }
            },
            messages:{
                title:{
                    required:"请输入标题"
                },
                nodeid:{
                    required:"请选择节点"
                }
            },
            submitHandler:function () {
                $.ajax({
                    url:"/editTopic",
                    type:"post",
                    data:$("#topicForm").serialize(),
                    beforeSend:function(){
                        $("#sendBtn").text("发布中").attr("disabled","disabled");
                    },
                    success:function(json){
                        if(json.state == "success"){
                            window.location.href="/topicDetail?topicid="+json.data;
                        }else {
                            alert("编辑主题异常");
                        }
                    },
                    error:function(){
                        alert("服务器异常");
                    },
                    complete:function () {
                        $("#sendBtn").text("发布主题").removeAttr("disabled");
                    }
                })
            }
        });
    });
</script>

</body>
</html>
