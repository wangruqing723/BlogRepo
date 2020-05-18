<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>写博客页面</title>
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
        .layui-form-select {
            margin-left: 50px;
            width: 800px;
            z-index: 1000;
        }

        .layui-tab {
            overflow: visible; /*防止下拉框显示不出来*/
        }
    </style>
</head>
<body style="background-color: white">
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>发布博客</legend>
</fieldset>
<form class="layui-form layui-form-pane" action="">
    <input type="hidden" id="blogId" name="id">
    <div class="layui-form-item">
        <label class="layui-form-label" style="background-color: #F2F2F2;border: 0px">博客标题： </label>
        <div class="layui-input-block">
            <input type="text" lay-verify="required" autocomplete="off" placeholder="请输入博客标题"
                   lay-reqtext="请填写博客标题" class="layui-input" style="margin-left: 50px;width: 800px"
                   id="title" name="title">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="background-color: #F2F2F2;border: 0px">所属类别： </label>
        <div class="layui-input-block">
            <select lay-verify="required" id="blogTypeId" name="blogTypeId" lay-filter="blogTypeSelect"
                    lay-reqtext="请选择博客类型">
                <option value="">请选择博客类别</option>
                <c:forEach var="blogType" items="${blogTypeCountList }">
                    <option value="${blogType.id }">${blogType.typeName }</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="layui-form-item ">
        <label class="layui-form-label" style="background-color: #F2F2F2;border: 0px">博客内容： </label>
        <div class="layui-input-block">
            <input type="hidden" id="editorData">
            <script id="editor" type="text/plain" style="width:92%;height:500px;margin-left: 50px"></script>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label" style="background-color: #F2F2F2;border: 0px">关键字： </label>
            <div class="layui-input-inline">
                <input type="tel" id="keyWord" name="keyWord" class="layui-input"
                       style="margin-left: 50px;width: 500px">
            </div>
            <div class="layui-form-mid layui-word-aux" style="margin-left: 360px">多个关键字中间用空格隔开</div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit lay-filter="saveBtn" style="margin: 20px 20px 20px 200px;">
                <i class="layui-icon layui-icon-release"></i>发布博客
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

    //实例化编辑器
    //建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
    var ue = UE.getEditor('editor');

    layui.use(['form', 'jquery', 'layer', 'miniTab'], function () {
        var form = layui.form,
            $ = layui.jquery,
            layer = layui.layer,
            miniTab = layui.miniTab;

        ue.setContent($("#editorData").val());

        console.log($("#editorData").val());
        console.log($("#blogTypeId").val());
        form.render();
        //各种基于事件的操作，下面会有进一步介绍
        //form.render('组件名','lay-filter名')

        $("#resetBtn").on('click', function () {
            ue.setContent("");
        });

        form.on('submit(saveBtn)', function (data) {
            console.log(data.elem); //被执行事件的元素DOM对象，一般为button对象
            console.log(data.form); //被执行提交的form对象，一般在存在form标签时才会返回
            console.log(data.field); //当前容器的全部表单字段，名值对形式：{name: value}
            console.log(data.field.editorValue); //当前容器的全部表单字段，名值对形式：{name: value}
            console.log(ue.getContentTxt()); //当前容器的全部表单字段，名值对形式：{name: value}
            console.log(ue.getContentTxt().substr(0, 155)); //当前容器的全部表单字段，名值对形式：{name: value}

            if ($.trim(data.field.editorValue) != "") {
                layer.confirm('确定发布' + '"' + data.field.title + '"' + '这篇文章吗？',
                    {
                        btn: ['确定', '取消'],
                        title: '发布博客',
                        icon: 3
                    },
                    function (index) {
                        var indexLoad = layer.load();
                        $.post("${pageContext.request.contextPath}/admin/blog/save.do",
                            {
                                'id': data.field.id,
                                'title': data.field.title,
                                'blogType.id': data.field.blogTypeId,
                                'content': data.field.editorValue,
                                'contentNoTag': ue.getContentTxt(),
                                'summary': ue.getContentTxt().substr(0, 155),
                                'keyWord': data.field.keyWord
                            }, function (result) {
                                if (result.success) {
                                    //layer.msg("博客发布成功！", {icon: 6, time: 1000},
                                    //function (index) {
                                    layer.close(indexLoad);
                                    var index = layer.confirm('"' + data.field.title + '"' + "博客发布成功,继续发布博客么?", {
                                        btn: ['继续', '不发布'], icon: 3,
                                        btn1: function () {
                                            $("#blogId").val("");
                                            $("#title").val("");
                                            $("#blogTypeId").val("");
                                            ue.setContent("");
                                            $("#keyWord").val("");
                                            console.log('继续发布');
                                            // window.location.reload();
                                            form.render();
                                            layer.close(index);
                                        },
                                        btn2: function () {
                                            miniTab.deleteCurrentByIframe();
                                            var index = parent.layer.getFrameIndex(window.name);
                                            parent.layui.table.reload('currentTableId');//重载父页表格，参数为表格ID
                                            parent.layer.close(index);

                                        }
                                    });
                                    //});
                                } else {
                                    layer.msg("博客发布失败！", {icon: 5, time: 2000});
                                    return false;
                                }
                            }, "json");
                        layer.close(index);
                    });
            } else {
                layer.msg("请输入博客内容", {icon: 0, time: 2000});
                return false;
            }
            return false;//阻止表单跳转。如果需要表单跳转，去掉这段即可。
        });

    });

</script>
</body>
</html>