<%--
  Created by IntelliJ IDEA.
  User: Mxia
  Date: 2016/12/28
  Time: 10:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link href="/static/font-awesome-4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="/static/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/static/css/sweetalert.css">
</head>
<body>
<%@include file="../include/adminNavber.jsp"%>
<!--header-bar end-->
<div class="container-fluid" style="margin-top:20px">
    <table class="table">
        <thead>
        <tr>
            <th>名称</th>
            <th>发布人</th>
            <th>发布时间</th>
            <th>回复数量</th>
            <th>最后回复时间</th>
            <%--<th>节点</th>--%>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.items}" var="topic">
            <tr>
                <td>
                    <a href="/topicDetail?topicid=${topic.id}" target="_blank">${topic.title}</a>
                </td>
                <td>${topic.user.username}</td>
                <td>${topic.createtime}</td>
                <td>${topic.replynum}</td>
                <td>${topic.lastreplytime}</td>
                <%--<td>--%>
                     <%--<select name="nodeid" id="nodeid" style="margin-top:0px;">--%>
                        <%--<option value="">请选择节点</option>--%>
                        <%--<c:forEach items="${nodeList}" var="node">--%>
                            <%--<option ${topic.nodeid==node.id?'selected':''} class="." value="${node.id}">${node.nodename}</option>--%>
                        <%--</c:forEach>--%>
                    <%--</select>--%>
                <%--</td>--%>
                <td>
                    <a href="javascript:;" rel="${topic.id}" class="del">删除</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
        <div class="pagination pagination-mini pagination-centered">
            <ul id="pagination" style="margin-bottom:20px;font-size: 22px"></ul>
        </div>
</div>
<!--container end-->
<script src="/static/js/jquery-1.11.3.min.js"></script>
<script src="/static/js/jquery.twbsPagination.min.js"></script>
<script src="/static/js/sweetalert.min.js"></script>
<%--<script src="/static/js/user/notify.js"></script>--%>
<script>
    $(function(){
        $("#pagination").twbsPagination({
            totalPages:${page.totalPage},
            visiblePages:5,
            first:'首页',
            last:'末页',
            prev:'上一页',
            next:'下一页',
            href: '?p={{number}}&nodeid=${param.nodeid}'
        });
        $(".del").click(function(){
            var id = $(this).attr("rel");//获取当前主题的id
            swal({
                    title: "确定要删除该主题?",
                    type: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#DD6B55",
                    confirmButtonText: "确定",
                    closeOnConfirm: false },
                //回调函数
                function(){
                    $.ajax({
                        url:"/admin/topic",//跳到这个servlet做删除主题操作
                        type:"post",
                        data:{"id":id},//传递的参数
                        success:function(data){
                            if(data == 'success') {
                                swal({title:"删除成功!"},function () {
                                    window.history.go(0);
                                });
                            } else {
                                swal(data);
                            }
                        },
                        error:function(){
                            swal("服务器异常,删除失败!");
                        }
                    });
             })

        })


        $("#nodeid").change(function(){
            var nodeid = $(this).attr("value");
            var nodename = $(this).text();
            alert(nodeid);
            alert(nodename);


        })

    });
</script>
</body>
</html>
