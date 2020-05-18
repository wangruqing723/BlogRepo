<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         errorPage="../foreground/system/404.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="utf-8">
    <title>首页</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layuimini/lib/layui-v2.5.5/css/layui.css"
          media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layuimini/css/layuimini.css?v=2.0.4"
          media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layuimini/css/themes/default.css"
          media="all">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/layuimini/lib/font-awesome-4.7.0/css/font-awesome.min.css"
          media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layuimini/css/public.css" media="all">
</head>
<style>
    .layui-top-box {
        padding: 40px 20px 20px 20px;
        color: #fff
    }

    .panel {
        margin-bottom: 17px;
        background-color: #fff;
        border: 1px solid transparent;
        border-radius: 3px;
        -webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, .05);
        box-shadow: 0 1px 1px rgba(0, 0, 0, .05)
    }

    .panel-body {
        padding: 15px
    }

    .panel-title {
        margin-top: 0;
        margin-bottom: 0;
        font-size: 14px;
        color: inherit
    }

    .label {
        display: inline;
        padding: .2em .6em .3em;
        font-size: 75%;
        font-weight: 700;
        line-height: 1;
        color: #fff;
        text-align: center;
        white-space: nowrap;
        vertical-align: baseline;
        border-radius: .25em;
        margin-top: .3em;
    }

    .layui-red {
        color: red
    }

    .main_btn > p {
        height: 40px;
    }

    .home {
        cursor: pointer;
        color: white;
    }
</style>
<body>
<div class="layuimini-container" style="height: 630px;">
    <div style="margin-top: 180px;">
        <h1 align="center" style="font-size: 50px;">欢迎使用</h1>
    </div>
    <div class="layuimini-main layui-top-box" align="center">
        <div class="layui-row layui-col-space10">

            <div class="layui-col-md4">
                <div class="col-xs-6 col-md-4">
                    <div class="panel layui-bg-blue">
                        <div class="layui-anim panel-body">
                            <div class="panel-title">
                                <a href="javascript:;" data-title="写博客"
                                   layuimini-content-href="${pageContext.request.contextPath}/admin/writeBlog.jsp">
                                    <span class="home">写博客</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="layui-col-md4">
                <div class="col-xs-6 col-md-4">
                    <div class="layui-anim panel layui-bg-green">
                        <div class="panel-body">
                            <div class="panel-title">
                                <a href="javascript:;" data-title="评论审核"
                                   layuimini-content-href="${pageContext.request.contextPath}/admin/commentReview.jsp">
                                    <span class="home">评论审核</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="layui-col-md4">
                <div class="col-xs-6 col-md-4">
                    <div class="layui-anim panel layui-bg-orange">
                        <div class="panel-body">
                            <div class="panel-title">
                                <a href="javascript:;" data-title="友情链接"
                                   layuimini-content-href="${pageContext.request.contextPath}/admin/linkManage.jsp">
                                    <span class="home">友情链接</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/layuimini/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/static/layuimini/js/lay-config.js?v=2.0.0" charset="utf-8"></script>
<script>
    layui.use(['form', 'miniTab'], function () {
        var form = layui.form,
            layer = layui.layer,
            miniTab = layui.miniTab;

        miniTab.listen();

    });
</script>
</body>
</html>