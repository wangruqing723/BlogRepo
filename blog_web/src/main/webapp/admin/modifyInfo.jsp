<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content=content="text/html; charset=UTF-8">
    <title>修改个人信息</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layuimini/lib/layui-v2.5.5/css/layui.css"
          media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layuimini/css/public.css" media="all">

    <script type="text/javascript" charset="GBK"
            src="${pageContext.request.contextPath}/static/ueditor/ueditor.config.js"></script>
    <script type="text/javascript" charset="GBK"
            src="${pageContext.request.contextPath}/static/ueditor/ueditor.all.min.js"></script>
    <!--建议手动加载语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
    <!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
    <script type="text/javascript" charset="UTF-8" <%-- 因为下面这个文件默认是gbk编码,被我改成了UTF-8,所以这里指定UTF-8 --%>
            src="${pageContext.request.contextPath}/static/ueditor/lang/zh-cn/zh-cn.js"></script>

    <style>
        /*#imageFile {
            display: inline-block;
            height: 38px;
            width: 50px;
            line-height: 38px;
            padding: 0 18px;
            background-color: #009688;
            color: #fff;
            white-space: nowrap;
            text-align: center;
            font-size: 14px;
            border: none;
            border-radius: 2px;
            cursor: pointer;
        }*/
    </style>
</head>
<body style="background-color: white">
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>修改个人信息</legend>
</fieldset>
<form class="layui-form layui-form-pane" enctype="multipart/form-data" id='submitForm'
      action="${pageContext.request.contextPath}/admin/blogger/save.do" method="post">
    <input type="hidden" id="id" name="id" value="${applicationScope.blogger.id}"/>
    <div class="layui-form-item">
        <label class="layui-form-label" style="background-color: #F2F2F2;border: 0px">用户名： </label>
        <div class="layui-input-block">
            <input type="text" lay-verify="required" autocomplete="off" placeholder="请输入用户名"
                   lay-reqtext="请填写用户名" class="layui-input" style="margin-left: 50px;width: 800px"
                   id="userName" name="userName" value="${applicationScope.blogger.userName}">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="background-color: #F2F2F2;border: 0px">昵称： </label>
        <div class="layui-input-block">
            <input type="text" lay-verify="required" autocomplete="off" placeholder="请输入昵称"
                   lay-reqtext="请填写昵称" class="layui-input" style="margin-left: 50px;width: 800px"
                   id="nickName" name="nickName" value="${applicationScope.blogger.nickName}">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="background-color: #F2F2F2;border: 0px">个性签名： </label>
        <div class="layui-input-block">
            <input type="text" lay-verify="required" autocomplete="off" placeholder="请输入个性签名"
                   lay-reqtext="请填写个性签名" class="layui-input" style="margin-left: 50px;width: 800px"
                   id="sign" name="sign" value="${applicationScope.blogger.sign}">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="background-color: #F2F2F2;border: 0px">个人头像： </label>
        <div class="layui-input-block">
            <%--<button type="button" class="layui-btn" id="uploadBtn" name="imageFile" style="margin-left: 50px;">
                <i class="layui-icon">&#xe67c;</i>上传图片
            </button>--%>
            <input type="file" id="imageFile" name="file" value="" style="margin-left: 50px">
        </div>
    </div>
    <div class="layui-form-item ">
        <label class="layui-form-label" style="background-color: #F2F2F2;border: 0px">个人简介： </label>
        <div class="layui-input-block">
            <script id="proFile" type="text/plain" style="width:92%;height:500px;margin-left: 50px"></script>
            <xmp hidden id="proFileValue" name="proFile">${applicationScope.blogger.editorValue}</xmp>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit lay-filter="saveBtn" style="margin: 20px 20px 20px 200px;">
                <i class="layui-icon layui-icon-release"></i>提交修改
            </button>
            <button type="reset" class="layui-btn layui-btn-primary" id="resetBtn" style="margin:20px 20px 20px 50px;">
                <i class="layui-icon layui-icon-refresh"></i>重置
            </button>
        </div>
    </div>
</form>

<script src="${pageContext.request.contextPath}/static/layuimini/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/static/layuimini/js/lay-config.js?v=1.0.4" charset="utf-8"></script>
<script type="text/javascript">
    <%--console.log(${applicationScope.blogger.userName});--%>
    <%--console.log(${applicationScope.blogTypeCountList[0].typeName});--%>
    <%--console.log(${applicationScope.blogCountList[0].title});--%>
    <%--console.log(${applicationScope.linkList[0].linkName});--%>
    //实例化编辑器
    //建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
    var ue = UE.getEditor('proFile');

    layui.use(['form', 'upload', 'jquery', 'layer', 'miniTab'], function () {
        var form = layui.form,
            $ = layui.jquery,
            layer = layui.layer,
            upload = layui.upload,
            miniTab = layui.miniTab;
        //console.log(ue);
        //执行实例
        /*var uploadInst = upload.render({
            elem: '#uploadBtn',  //绑定元素
            url: '/static/userImages/', //上传接口
            done: function (res) {
                //上传完毕回调
            }
            , error: function () {
                //请求异常回调
            }
        });*/
        //console.log($("#proFileValue").html())
        ue.setContent($("#proFileValue").html());

        form.render();
        //各种基于事件的操作，下面会有进一步介绍
        //form.render('组件名','lay-filter名')

        $("#resetBtn").on('click', function () {
            ue.setContent($("#proFileValue").html());
        });

        form.on('submit(saveBtn)', function (data) {
            console.log(data);
            console.log(data.elem); //被执行事件的元素DOM对象，一般为button对象
            console.log(data.form); //被执行提交的form对象，一般在存在form标签时才会返回
            console.log(data.field); //当前容器的全部表单字段，名值对形式：{name: value}
            console.log(data.field.editorValue); //当前容器的全部表单字段，名值对形式：{name: value}
            console.log(ue.getContentTxt()); //当前容器的全部表单字段，名值对形式：{name: value}

            if ($.trim(data.field.editorValue) != "") {
                layer.confirm('确定提交修改的个人信息吗？', {btn: ['确定', '取消'], title: '提交修改信息', icon: 3},
                    function (index) {
                        $("#proFileValue").html(ue.getContent());
                        /*layer.msg('修改成功', function () {
                            miniTab.deleteCurrentByIframe();
                        });*/
                        $("#submitForm").submit();
                        layer.close(index);
                    });
            } else {
                layer.msg("请输入个人简介", {icon: 0, time: 2000});
            }
            return false;//阻止表单跳转。如果需要表单跳转，去掉这段即可。
        });

    });

</script>
</body>
</html>