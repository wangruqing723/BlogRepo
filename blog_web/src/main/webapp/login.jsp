<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Java个人博客系统后台登录页面</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layuimini/lib/layui-v2.5.5/css/layui.css"
          media="all">
    <script src="${pageContext.request.contextPath}/static/bootstrap3/js/jquery-1.11.2.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/layuimini/lib/layui-v2.5.5/layui.js"
            charset="utf-8"></script>
    <!--[if lt IE 9]>
    <script src="https://cdn.staticfile.org/html5shiv/r29/html5.min.js"></script>
    <script src="https://cdn.staticfile.org/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <style>
        #code {
            font-family: Arial, 宋体;
            font-style: italic;
            color: green;
            outline: none;
            border: 0;
            background-color: transparent;
            padding: 5px 8px;
            letter-spacing: 3px;
            font-weight: bolder;
            font-size: 18px;
        }

        body {
            background-image: url("${pageContext.request.contextPath}/static/layuimini/images/bg.jpg");
            height: 100%;
            width: 100%;
        }

        #container {
            height: 100%;
            width: 100%;
        }

        input:-webkit-autofill {
            -webkit-box-shadow: inset 0 0 0 1000px #fff;
            background-color: transparent;
        }

        .admin-login-background {
            width: 300px;
            height: 300px;
            position: absolute;
            left: 50%;
            top: 47%;
            margin-left: -150px;
            margin-top: -100px;
        }

        .admin-header {
            text-align: center;
            margin-bottom: 20px;
            color: #ffffff;
            font-weight: bold;
            font-size: 40px
        }

        .admin-input {
            border-top-style: none;
            border-right-style: solid;
            border-bottom-style: solid;
            border-left-style: solid;
            height: 50px;
            width: 300px;
            padding-bottom: 0px;
        }

        .admin-input::-webkit-input-placeholder {
            color: #a78369
        }

        .layui-icon-username {
            color: #a78369 !important;
        }

        .layui-icon-username:hover {
            color: #9dadce !important;
        }

        .layui-icon-password {
            color: #a78369 !important;
        }

        .layui-icon-password:hover {
            color: #9dadce !important;
        }

        .admin-input-username {
            border-top-style: solid;
            border-radius: 10px 10px 0 0;
        }

        .admin-input-verify {
            border-radius: 0 0 10px 10px;
        }

        .admin-button {
            margin-top: 20px;
            font-weight: bold;
            font-size: 18px;
            width: 300px;
            height: 50px;
            border-radius: 5px;
            background-color: #a78369;
            border: 1px solid #d8b29f
        }

        .admin-icon {
            margin-left: 260px;
            margin-top: 10px;
            font-size: 30px;
        }

        i {
            position: absolute;
        }

        .admin-captcha {
            position: absolute;
            margin-left: 205px;
            margin-top: -40px;
        }

        .tou {
            background: url("${pageContext.request.contextPath}/static/images/tou.png") no-repeat;
            width: 97px;
            height: 92px;
            position: absolute;
            top: -85px;
            left: 96px;
        }

        .left_hand {
            background: url("${pageContext.request.contextPath}/static/images/left_hand.png") no-repeat;
            width: 32px;
            height: 37px;
            position: absolute;
            top: -38px;
            left: 106px;
        }

        .right_hand {
            background: url("${pageContext.request.contextPath}/static/images/right_hand.png") no-repeat;
            width: 32px;
            height: 37px;
            position: absolute;
            top: -38px;
            right: 116px;
        }

        .initial_left_hand {
            background: url("${pageContext.request.contextPath}/static/images/hand.png") no-repeat;
            width: 30px;
            height: 20px;
            position: absolute;
            top: -12px;
            left: 50px;
        }

        .initial_right_hand {
            background: url("${pageContext.request.contextPath}/static/images/hand.png") no-repeat;
            width: 30px;
            height: 20px;
            position: absolute;
            top: -12px;
            right: 60px;
        }

        .left_handing {
            background: url("${pageContext.request.contextPath}/static/images/left-handing.png") no-repeat;
            width: 30px;
            height: 20px;
            position: absolute;
            top: -24px;
            left: 139px;
        }

        .right_handinging {
            background: url("${pageContext.request.contextPath}/static/images/right_handing.png") no-repeat;
            width: 30px;
            height: 20px;
            position: absolute;
            top: -21px;
            left: 210px;
        }
    </style>

    <script type="text/javascript">
        var code; //在全局定义验证码
        function createCode() {
            code = "";
            var codeLength = 4;//验证码的长度
            var checkCode = document.getElementById("code");
            var random = new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'A', 'B', 'C', 'D', 'E', 'F', 'G',
                'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y',
                'Z');//随机数
            for (var i = 0; i < codeLength; i++) {//循环操作
                var index = Math.floor(Math.random() * 36);//取得随机数的索引（0~35）
                code += random[index];//根据索引取得随机数加到code上
            }
            checkCode.value = code;//把code值赋给验证码
        }

        /*$("#password-show").click(function () {
           $("#password").prop('type','text');
        });*/

        $(function () {
            createCode();
            //得到焦点
            $("#password").focus(function () {
                $("#left_hand").animate({
                    left: "106",
                    top: " -38"
                }, {
                    step: function () {
                        if (parseInt($("#left_hand").css("left")) > 100) {
                            $("#left_hand").attr("class", "left_hand");
                        }
                    }
                }, 2000);
                $("#right_hand").animate({
                    right: "116",
                    top: "-38px"
                }, {
                    step: function () {
                        if (parseInt($("#right_hand").css("right")) > 102) {
                            $("#right_hand").attr("class", "right_hand");
                        }
                    }
                }, 2000);
            });
            //失去焦点
            $("#password").blur(function () {
                $("#left_hand").attr("class", "initial_left_hand");
                $("#left_hand").attr("style", "left:50px;top:-12px;");
                $("#right_hand").attr("class", "initial_right_hand");
                $("#right_hand").attr("style", "right:60px;top:-12px");
            });
        });

        layui.use(['form'], function () {
            var form = layui.form,
                layer = layui.layer;

            // 登录过期的时候，跳出ifram框架

            /*if (top.location != self.location) top.location = self.location;*/
            // 进行登录操作
            form.on('submit(login)', function (data) {
                data = data.field;
                if ($.trim(data.captcha) == "") {
                    layer.msg('验证码不能为空', {time: 2000});
                    return false;
                }
                if (data.captcha.toUpperCase() != code) {
                    layer.msg('验证码错误', {time: 1000},
                        function () {
                            createCode();
                        });
                    return false;
                }
                if ($.trim(data.userName) == "") {
                    layer.msg('用户名不能为空', {time: 2000});
                    return false;
                }
                if ($.trim(data.password) == "") {
                    layer.msg('密码不能为空', {time: 2000});
                    return false;
                }
                $("#login-form").submit();
                return false;
            });
        });
    </script>
</head>
<body>
<div id="container">
    <div></div>
    <div class="admin-login-background">
        <DIV class="tou">
        </DIV>
        <DIV class="initial_left_hand" id="left_hand">
        </DIV>
        <DIV class="initial_right_hand" id="right_hand">
        </DIV>
        <form id="login-form" action="${pageContext.request.contextPath}/login.do" method="post" class="layui-form">

            <div>
                <i class="layui-icon layui-icon-username admin-icon"></i>
                <input type="text" name="userName" id="userName" placeholder="请输入用户名" autocomplete="off"
                       class="layui-input admin-input admin-input-username" value="${blogger.userName }">
            </div>
            <div>
                <i class="layui-icon layui-icon-password admin-icon" id="password-show"></i>
                <input type="password" name="password" id="password" placeholder="请输入密码" autocomplete="off"
                       class="layui-input admin-input" value="">
            </div>
            <div>
                <input type="text" name="captcha" maxlength="4" placeholder="请输入验证码" autocomplete="off"
                       class="layui-input admin-input admin-input-verify" value="">
                <input class="admin-captcha" type="button" id="code" onclick="createCode()"
                       style="width:90px;height:30px;" title='点击更换验证码'/>
            </div>
            <div>
                <span>
                    <font color="red">${sessionScope.SPRING_SECURITY_LAST_EXCEPTION.message}</font>
                </span>
            </div>
            <button class="layui-btn admin-button" lay-submit lay-filter="login">登 录</button>
        </form>
        <div style="text-align:center;padding-top: 30px">
            <a href="${pageContext.request.contextPath}/index.html">Java个人博客系统首页</a><br>
        </div>
    </div>
</div>
</body>
</html>