<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="utf-8">
    <title>博客类别管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layuimini/lib/layui-v2.5.5/css/layui.css"
          media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layuimini/css/public.css" media="all">
</head>
<body>
<div class="layuimini-container">
    <div class="layuimini-main">
        <input type="hidden" id="currPage">
        <script type="text/html" id="toolbarDemo">
            <div class="layui-btn-container">
                <button class="layui-btn layui-btn-normal layui-btn-sm data-add-btn" lay-event="add">
                    <i class="layui-icon layui-icon-add-1"></i> 添加
                </button>
                <button class="layui-btn layui-btn-sm layui-btn-danger data-delete-btn" lay-event="delete">
                    <i class="layui-icon layui-icon-delete"></i> 删除
                </button>
            </div>
        </script>

        <table class="layui-hide" id="currentTableId" lay-filter="currentTableFilter"></table>

        <script type="text/html" id="currentTableBar">
            <a class="layui-btn layui-btn-normal layui-btn-xs data-count-edit" lay-event="edit"><i
                    class="layui-icon layui-icon-edit"></i>编辑</a>
            <a class="layui-btn layui-btn-xs layui-btn-danger data-count-delete" lay-event="delete"><i
                    class="layui-icon layui-icon-delete"></i>删除</a>
        </script>

    </div>
</div>
<script src="${pageContext.request.contextPath}/static/layuimini/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script>
    layui.use(['element', 'form', 'table'], function () {
        var $ = layui.jquery,
            element = layui.element,
            form = layui.form,
            table = layui.table;

        table.render({
            elem: '#currentTableId',
            url: '${pageContext.request.contextPath}/admin/blogType/list.do',
            toolbar: '#toolbarDemo',
            defaultToolbar: ['filter', 'exports', 'print', {
                title: '提示',
                layEvent: 'LAYTABLE_TIPS',
                icon: 'layui-icon-tips'
            }],
            cols: [[
                {type: "numbers"},
                {type: "checkbox"},
                {field: 'id', title: '编号', sort: true, align: 'center'},
                {field: 'typeName', title: '博客类别名称', align: 'center'},
                {field: 'orderNo', title: '排序序号', sort: true, align: 'center'},
                {title: '操作', minWidth: 150, toolbar: '#currentTableBar', align: "center"}
            ]],
            //数据渲染完的回调
            done: function (res, curr, count) {
                //如果是异步请求数据方式，res即为你接口返回的信息。
                //如果是直接赋值的方式，res即为：{data: [], count: 99} data为当前页数据、count为数据总长度
                console.log(res);
                //得到当前页码
                console.log(curr);
                //得到数据总量
                console.log(count);

                if (curr > 1 && res.data.length == 0) {
                    table.reload('currentTableId', {
                        page: {
                            curr: curr - 1//重新从当前页开始
                        },
                        data: '#currentTableId'
                    });
                }

                $("#currPage").val(curr);
            },
            limits: [10, 15, 20, 25, 50, 100],
            limit: 10,
            page: true,
            skin: 'line',
            even: true, //开启隔行背景

        });

        /**
         * toolbar监听事件
         */
        table.on('toolbar(currentTableFilter)', function (obj) {
            console.log(obj)
            if (obj.event === 'add') {  // 监听添加操作
                var index = layer.open({
                    title: '添加博客类别',
                    type: 1,
                    shade: 0.2,
                    maxmin: true,
                    shadeClose: true,
                    area: ['50%', '50%'],
                    content: $("#add-edit-form"),
                    success: function (layero, index) {
                        //监听提交
                        form.on('submit(saveBtn)', function (data) {
                            console.log(data);
                            console.log(data.field);
                            //console.log(typeof data.field.id);
                            $.post("${pageContext.request.contextPath}/admin/blogType/save.do", data.field,
                                function (result) {
                                    if (result.success) {
                                        layer.msg('成功保存' + '"' + data.field.typeName + '"' + '类别',
                                            {
                                                icon: 1,
                                                time: 2000
                                            });
                                        table.reload('currentTableId', {
                                            page: {
                                                curr: obj.config.page.count % 10 == 0 ? Math.ceil(obj.config.page.count / obj.config.page.limit) + 1 : Math.ceil(obj.config.page.count / obj.config.page.limit) //重新从当前页开始
                                            }
                                        });
                                    } else {
                                        layer.msg('保存失败！', {icon: 2, time: 2000});
                                    }
                                }, "json");
                            //var iframeIndex = parent.layer.getFrameIndex(window.name);
                            //parent.layer.close(iframeIndex);
                            layer.close(index);
                            return false;
                        });
                    }
                });
                $(window).on("resize", function () {
                    layer.full(index);
                });
                $("#typeId").val("");
                $("#typeName").val("");
                $("#orderNo").val("");
                //$("#currPage").val(Math.ceil(obj.config.page.count / obj.config.page.limit));
            } else if (obj.event === 'delete') {  // 监听删除操作
                var checkStatus = table.checkStatus('currentTableId'),
                    data = checkStatus.data;
                console.log(data);
                if (data.length != 0) {
                    layer.prompt({formType: 1, title: '请输入密码'},
                        function (value, index, elem) {
                            //layer.alert(value); //得到value
                            layer.close(index);
                            if (value === '123') {
                                layer.confirm("确定删除这<font color='red'>" + data.length + "</font>个类别吗?",
                                    {
                                        btn: ['确定', '取消'],
                                        icon: 3,
                                        title: '删除提示'
                                    },
                                    function (index) {
                                        var ids = '';
                                        var strIds = new Array();
                                        for (let i = 0; i < data.length; i++) {
                                            strIds.push(data[i].id);
                                        }
                                        ids = strIds.join(",");
                                        console.log(ids);
                                        $.post("${pageContext.request.contextPath}/admin/blogType/delete.do", {ids: ids},
                                            function (result) {
                                                if (result.success) {
                                                    if (result.exist) {
                                                        layer.msg(data.typeName + "等" + result.exist, {
                                                            icon: 0,
                                                            time: 2000
                                                        });
                                                    } else {
                                                        layer.msg('<font color="red">' + data.length + '</font>' + '个类别已成功删除！',
                                                            {
                                                                icon: 1,
                                                                time: 2000
                                                            });
                                                        table.reload('currentTableId', {
                                                            page: {
                                                                curr: obj.config.page.curr //重新从当前页开始
                                                            }
                                                        });
                                                    }
                                                } else {
                                                    layer.msg('数据删除失败！', {icon: 2, time: 2000});
                                                }
                                            }, "json");
                                        layer.close(index);
                                        return false;
                                    });
                            } else {
                                layer.msg('密码错误', {icon: 5, time: 2000});
                            }
                        });
                } else {
                    layer.msg("请选择要删除的类别", {icon: 0, time: 2000})
                }
                // layer.alert(JSON.stringify(data));
            }
        });

        //监听表格复选框选择
        table.on('checkbox(currentTableFilter)', function (obj) {
            console.log(obj)
        });

        table.on('tool(currentTableFilter)', function (obj) {
            console.log(obj);
            var data = obj.data;
            if (obj.event === 'edit') {
                var index = layer.open({
                    title: '编辑博客类别',
                    type: 1,
                    shade: 0.2,
                    maxmin: true,
                    shadeClose: true,
                    area: ['50%', '50%'],
                    content: $("#add-edit-form"),
                    success: function (layero, index) {
                        //监听提交
                        form.on('submit(saveBtn)', function (data) {
                            console.log(data);
                            console.log(data.field);
                            //console.log(typeof data.field.id);
                            $.post("${pageContext.request.contextPath}/admin/blogType/save.do", data.field,
                                function (result) {
                                    if (result.success) {
                                        layer.msg('成功修改为' + '"' + data.field.typeName + '"' + '类别',
                                            {
                                                icon: 1,
                                                time: 2000
                                            });
                                        table.reload('currentTableId', {
                                            page: {
                                                curr: $("#currPage").val() //重新从当前页开始
                                            }
                                        });
                                    } else {
                                        layer.msg('保存失败！', {icon: 2, time: 2000});
                                    }
                                }, "json");
                            //var iframeIndex = parent.layer.getFrameIndex(window.name);
                            //parent.layer.close(iframeIndex);
                            layer.close(index);
                            return false;
                        });
                    }
                });
                $(window).on("resize", function () {
                    layer.full(index);
                });
                $("#typeId").val(data.id);
                $("#typeName").val(data.typeName);
                $("#orderNo").val(data.orderNo);
                //$("#currPage").val(obj.config.page.curr);
                return false;
            } else if (obj.event === 'delete') {
                layer.prompt({formType: 1, title: '请输入密码'},
                    function (value, index, elem) {
                        //layer.alert(value); //得到value
                        layer.close(index);
                        if (value === '123') {
                            layer.confirm('确定删除' + '"' + obj.data.typeName + '"' + '类别么',
                                {
                                    btn: ['确定', '取消'],
                                    icon: 3,
                                    title: '删除提示'
                                },
                                function (index) {
                                    var ids = obj.data.id.toString();
                                    $.post("${pageContext.request.contextPath}/admin/blogType/delete.do", {ids: ids},
                                        function (result) {
                                            if (result.success) {
                                                if (result.exist) {
                                                    layer.msg(data.typeName + result.exist, {icon: 0, time: 2000},
                                                        function () {
                                                        });
                                                } else {
                                                    layer.msg('"' + obj.data.typeName + '"' + '类别已成功删除！', {
                                                        icon: 1,
                                                        time: 2000
                                                    });
                                                    table.reload('currentTableId', {
                                                        page: {
                                                            curr: $("#currPage").val()//重新从当前页开始
                                                        }
                                                    });
                                                }
                                            } else {
                                                layer.msg(obj.data.typeName + '类别删除失败！', {icon: 2, time: 2000});
                                            }
                                        }, "json");
                                    layer.close(index);
                                    return false;
                                });
                        } else {
                            layer.msg('密码错误', {icon: 5, time: 2000});
                        }
                    });
            }
        });
        /*element.on('tab(currentTableFilter)', function (data) {
            element.render('tab', 'currentTableFilter');
            var src = $(".layui-tab-item.layui-show").find("iframe").attr("src");
            $(".layui-tab-item.layui-show").find("iframe").attr("src", src);
        });*/
    });
</script>
</body>
<form class="layui-form layuimini-form" hidden id="add-edit-form">
    <input type="hidden" name="id" id="typeId">
    <div class="layui-form-item" style="margin-top: 50px">
        <label class="layui-form-label required">博客类别名称</label>
        <div class="layui-input-block">
            <input type="text" id="typeName" name="typeName" lay-verify="required" lay-reqtext="类别名称不能为空"
                   placeholder="请输入类别名称" value="" class="layui-input" style="width: 450px">
            <tip>填写类别名称。</tip>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label required">排序序号</label>
        <div class="layui-input-block">
            <input type="number" id="orderNo" name="orderNo" lay-verify="required" lay-reqtext="序号不能为空"
                   placeholder="请输入序号" value="" class="layui-input" style="width: 450px">
            <tip>填写类别排序序号。</tip>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit lay-filter="saveBtn" style="margin-left: 160px">确认保存
            </button>
        </div>
    </div>
</form>
</html>