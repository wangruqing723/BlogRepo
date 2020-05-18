<%--
  Created by IntelliJ IDEA.
  User: WY
  Date: 2020/4/26
  Time: 13:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>退出后台系统</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layuimini/lib/layui-v2.5.5/css/layui.css"
          media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layuimini/css/public.css" media="all">
</head>
<body>
<script src="${pageContext.request.contextPath}/static/layuimini/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/static/layuimini/js/lay-config.js?v=1.0.4" charset="utf-8"></script>
<script>
    layui.use(['jquery', 'layer', 'miniTab'], function () {
        var $ = layui.jquery,
            layer = layui.layer,
            miniTab = layui.miniTab;

        layer.ready(function () {
            layer.confirm("确定退出后台系统吗?", {
                    btn: ['确定', '取消'], icon: 3, title: '退出提示',
                    btn2: function () {
                        layer.msg("用户取消退出", {icon: 6, time: 1000},
                            function () {
                                miniTab.deleteCurrentByIframe();
                            });
                    }
                },
                function () {
                    layer.msg("退出成功", {icon: 1, time: 800},
                        function () {
                            window.open('${pageContext.request.contextPath}/logout.do', '_parent');
                        });
                    //打开新窗口
                });
        });

    });
</script>
</body>
</html>
