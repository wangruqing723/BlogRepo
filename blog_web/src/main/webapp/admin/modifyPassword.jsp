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
    <title>修改密码</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layuimini/lib/layui-v2.5.5/css/layui.css"
          media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layuimini/css/public.css" media="all">
    <style>
        .layui-form-item .layui-input-company {
            width: auto;
            padding-right: 10px;
            line-height: 38px;
        }
    </style>
</head>
<body>
<div class="layuimini-container" hidden id="modifyPassword">
    <div class="layuimini-main">

        <div class="layui-form layuimini-form">
            <div class="layui-form-item">
                <label class="layui-form-label required">新的密码</label>
                <div class="layui-input-block">
                    <input type="password" name="newPassword" lay-verify="required" lay-reqtext="新的密码不能为空"
                           placeholder="请输入新的密码" value="" class="layui-input" style="width: 450px">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label required">确认新密码</label>
                <div class="layui-input-block">
                    <input type="password" name="again_newPassword" lay-verify="required" lay-reqtext="新的密码不能为空"
                           placeholder="请输入新的密码" value="" class="layui-input" style="width: 450px">
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn layui-btn-normal" lay-submit lay-filter="saveBtn"
                            style="margin-left: 138px">确认修改
                    </button>
                    <br/>
                    <tip style="margin-left: 63px">密码修改成功会跳到登录界面,请保存需要保存的数据</tip>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/layuimini/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/static/layuimini/js/lay-config.js?v=1.0.4" charset="utf-8"></script>
<script>
    layui.use(['form', 'miniTab'], function () {
        var $ = layui.jquery,
            form = layui.form,
            layer = layui.layer,
            miniTab = layui.miniTab;

        var index = layer.open({
            title: '修改密码',
            type: 1,
            shade: 0.2,
            maxmin: true,
            area: ['50%', '50%'],
            content: $("#modifyPassword"),
            cancel: function (layero, index) {//只有当点击confirm框的确定时，该层才会关闭
                layer.confirm('确定退出修改密码吗?', {btn: ['确定', '取消'], icon: 3},
                    function () {
                        layer.msg('用户退出修改密码！', {icon: 2, time: 1000}, function () {
                            miniTab.deleteCurrentByIframe();
                        });
                    });
                layer.close(index);
                return false;
            }
        });

        //监听提交
        form.on('submit(saveBtn)', function (data) {
            console.log(data);
            if (data.field.again_newPassword === data.field.newPassword) {
                $.post("${pageContext.request.contextPath}/admin/blogger/modifyPassword.do", data.field,
                    function (result) {
                        if (result.success) {
                            layer.msg("密码修改成功,请重新登录!", {icon: 1, time: 1000},
                                function () {
                                    //打开新窗口
                                    window.open('${pageContext.request.contextPath}/logout.do', '_parent');
                                });
                        } else {
                            layer.msg('密码修改失败！', {icon: 2, time: 2000}, function () {
                                miniTab.deleteCurrentByIframe();
                            });
                        }
                    }, "json");
            } else {
                layer.msg("两次输入密码不一致", {icon: 5, time: 2000});
            }
            return false;
        });

    });
</script>
</body>
</html>
