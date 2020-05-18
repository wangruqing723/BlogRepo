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
    <title>刷新系统缓存</title>
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
    layui.use(['form', 'miniTab'], function () {
        var $ = layui.jquery,
            layer = layui.layer,
            miniTab = layui.miniTab;

        layer.ready(function () {
            $.post("${pageContext.request.contextPath}/admin/system/refreshSystem.do", {},
                function (result) {
                    if (result.success) {
                        layer.msg("成功刷新系统缓存", {icon: 1, time: 1000},
                            function () {
                                miniTab.deleteCurrentByIframe();
                            });
                    } else {
                        layer.msg("刷新系统缓存失败！", {icon: 2, time: 2000},
                            function () {
                                miniTab.deleteCurrentByIframe();
                            });
                    }
                }, "json");
        });

    });
</script>
</body>
</html>
