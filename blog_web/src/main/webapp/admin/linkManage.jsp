<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="utf-8">
    <title>友情链接管理</title>
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

        <table class="layui-table" lay-filter="currentTableFilter" id="currentTableId"></table>

        <script type="text/html" id="currentTableBar">
            <a class="layui-btn layui-btn-normal layui-btn-xs data-count-edit" lay-event="edit">
                <i class="layui-icon layui-icon-edit"></i>编辑</a>
            <a class="layui-btn layui-btn-xs layui-btn-danger data-count-delete" lay-event="delete">
                <i class="layui-icon layui-icon-delete"></i>删除</a>
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
            url: '${pageContext.request.contextPath}/admin/link/list.do',
            toolbar: '#toolbarDemo',
            defaultToolbar: ['filter', 'exports', 'print', {
                title: '提示',
                layEvent: 'LAYTABLE_TIPS',
                icon: 'layui-icon-tips'
            }],
            cols: [[
                {type: 'numbers'},
                {type: 'checkbox'},
                {title: '编号', field: 'id', sort: true, align: 'center'},
                {title: '友情链接名称', field: 'linkName', align: 'center'},
                {
                    title: '友情链接地址',
                    field: 'linkUrl',
                    align: 'center',
                    templet: '<div><a target="_blank" href="{{d.linkUrl}}" class="layui-table-link">{{d.linkUrl}}</a></div>'
                },
                {title: '排序序号', field: 'orderNo', sort: true, align: 'center'},
                {title: '操作', toolbar: '#currentTableBar', minWidth: 150, align: 'center'}
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
            //数据格式解析的回调函数，用于将返回的任意数据格式解析成 table 组件规定的数据格式
            parseData: function (res) { //res 即为原始返回的数据
                return {
                    'code': res.state, //解析接口状态
                    'count': res.total, //解析数据长度
                    'data': res.rows //解析数据列表
                };
            },
            //用于对分页请求的参数：page、limit重新设定名称
            request: {
                pageName: 'page', //页码的参数名称，默认：page
                limitName: 'rows' //每页数据量的参数名，默认：limit
            },
            //response 用来重新设定返回的数据格式
            //response: {
            //statusName: 'state', //规定数据状态的字段名称，默认：code
            //statusCode: 200, //规定成功的状态码，默认：0
            //msgName: 'hint', //规定状态信息的字段名称，默认：msg
            //countName: 'total', //规定数据总数的字段名称，默认：count
            //dataName: 'rows' //规定数据列表的字段名称，默认：data
            //}
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
            $("#linkId").val("");
            $("#linkName").val("");
            $("#linkUrl").val("");
            $("#orderNo").val("");
            console.log(obj);
            if (obj.event === 'add') {  // 监听添加操作
                var index = layer.open({
                    title: '添加友情链接',
                    type: 1,
                    shade: 0.2,
                    maxmin: true,
                    shadeClose: true,
                    area: ['50%', '55%'],
                    content: $("#add-edit-form"),
                    success: function (layero, index) {
                        //监听提交
                        form.on('submit(saveBtn)', function (data) {
                            console.log(data);
                            console.log(data.field);
                            //console.log(typeof data.field.id);
                            $.post("${pageContext.request.contextPath}/admin/link/save.do", data.field,
                                function (result) {
                                    if (result.success) {
                                        layer.msg('成功保存' + '"' + data.field.linkName + '"' + '友情链接',
                                            {
                                                icon: 1,
                                                time: 2000
                                            });
                                        table.reload('currentTableId', {
                                            page: {
                                                curr: obj.config.page.curr /*obj.config.page.count % 10 == 0 ? Math.ceil(obj.config.page.count / obj.config.page.limit) + 1 : Math.ceil(obj.config.page.count / obj.config.page.limit)*/ //重新从当前页开始
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
                                layer.confirm("确定删除这<font color='red'>" + data.length + "</font>个友情链接吗?",
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
                                        $.post("${pageContext.request.contextPath}/admin/link/delete.do", {ids: ids},
                                            function (result) {
                                                if (result.success) {
                                                    if (result.exist) {
                                                        layer.msg(result.exist, {icon: 0, time: 2000});
                                                    } else {
                                                        layer.msg('<font color="red">' + data.length + '</font>' + '个友情链接已成功删除！',
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
                    layer.msg("请选择要删除的友情链接", {icon: 0, time: 2000})
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
            $("#linkId").val(data.id);
            $("#linkName").val(data.linkName);
            $("#linkUrl").val(data.linkUrl);
            $("#orderNo").val(data.orderNo);
            if (obj.event === 'edit') {
                var index = layer.open({
                    title: '编辑友情链接',
                    type: 1,
                    shade: 0.2,
                    maxmin: true,
                    shadeClose: true,
                    area: ['50%', '55%'],
                    content: $("#add-edit-form"),
                    success: function (layero, index) {
                        //监听提交
                        form.on('submit(saveBtn)', function (data) {
                            console.log(data);
                            console.log(data.field);
                            //console.log(typeof data.field.id);
                            $.post("${pageContext.request.contextPath}/admin/link/save.do", data.field,
                                function (result) {
                                    if (result.success) {
                                        layer.msg('成功修改了编号:' + '"' + data.field.id + '"', {icon: 1, time: 2000});
                                        table.reload('currentTableId', {
                                            page: {
                                                curr: $("#currPage").val()
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
                return false;
            } else if (obj.event === 'delete') {
                layer.prompt({formType: 1, title: '请输入密码'},
                    function (value, index, elem) {
                        //layer.alert(value); //得到value
                        layer.close(index);
                        if (value === '123') {
                            layer.confirm('确定删除' + '"' + obj.data.linkName + '"' + '友情链接么',
                                {
                                    btn: ['确定', '取消'],
                                    icon: 3,
                                    title: '删除提示'
                                },
                                function (index) {
                                    var ids = obj.data.id.toString();
                                    $.post("${pageContext.request.contextPath}/admin/link/delete.do", {ids: ids},
                                        function (result) {
                                            if (result.success) {
                                                if (result.exist) {
                                                    layer.msg(result.exist, {icon: 0, time: 2000},
                                                        function () {
                                                        });
                                                } else {
                                                    layer.msg('"' + obj.data.linkName + '"' + '友情链接已成功删除！', {
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
                                                layer.msg(obj.data.linkName + '类型删除失败！', {icon: 2, time: 2000});
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
    <input type="hidden" name="id" id="linkId">
    <div class="layui-form-item" style="margin-top: 25px">
        <label class="layui-form-label required">友情链接名称</label>
        <div class="layui-input-block">
            <input type="text" id="linkName" name="linkName" lay-verify="required" lay-reqtext="友情链接名称不能为空"
                   placeholder="请输入友情链接名称" value="" class="layui-input" style="width: 450px">
            <tip>填写友情链接名称。</tip>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label required">友情链接地址</label>
        <div class="layui-input-block">
            <input type="text" id="linkUrl" name="linkUrl" lay-verify="required|url" lay-reqtext="友情链接地址不能为空"
                   placeholder="请输入友情链接地址" value="" class="layui-input" style="width: 450px">
            <tip>填写友情链接地址。</tip>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label required">排序序号</label>
        <div class="layui-input-block">
            <input type="number" id="orderNo" name="orderNo" lay-verify="required|number" lay-reqtext="序号不能为空"
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