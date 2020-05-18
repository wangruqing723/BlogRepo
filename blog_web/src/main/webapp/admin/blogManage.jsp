<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="utf-8">
    <title>博客信息管理</title>
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
        <fieldset class="table-search-fieldset">
            <legend>搜索信息</legend>
            <div style="margin: 10px 10px 10px 10px">
                <form class="layui-form layui-form-pane" action="">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">博客标题</label>
                            <div class="layui-input-inline">
                                <input type="text" name="blogTitle" autocomplete="off"
                                       class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">博客类别</label>
                            <div class="layui-input-inline">
                                <input type="text" name="typeName" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <button type="submit" class="layui-btn layui-btn-primary" lay-submit
                                    lay-filter="data-search-btn"><i class="layui-icon"></i> 搜 索
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>
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
    layui.use(['element', 'form', 'table', 'layer'], function () {
        var $ = layui.jquery,
            element = layui.element,
            layer = layui.layer,
            form = layui.form,
            table = layui.table;

        table.render({
            elem: '#currentTableId',
            url: '${pageContext.request.contextPath}/admin/blog/list.do',
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
                {
                    field: 'title',
                    title: '博客标题',
                    align: 'center',
                    templet: '<div><a target="_blank" href="${pageContext.request.contextPath}/blog/articles/{{d.id}}.html"><font color="#02AAED">{{d.title}}</font></a></div>'
                },
                {field: 'releaseDate', title: '发布日期', sort: true, align: 'center'},
                {
                    field: 'blogType',
                    title: '博客类别',
                    align: 'center',
                    templet: '<div>{{d.blogType.typeName}}</div>'
                },
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
            //数据格式解析的回调函数，用于将返回的任意数据格式解析成 table 组件规定的数据格式
            parseData: function (res) { //res 即为原始返回的数据
                return {
                    'code': res.code, //解析接口状态
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
         *  监听搜索
         */
        form.on('submit(data-search-btn)', function (data) {
            console.log(data);
            console.log(data.field.blogTitle);
            console.log(data.field.typeName);
            table.reload('currentTableId', {
                where: {
                    title: data.field.blogTitle,
                    //typeName: data.field.typeName
                },
                page: {
                    curr: 1
                },
                data: '#currentTableId'
            });
        });

        /**
         * toolbar监听事件
         */
        table.on('toolbar(currentTableFilter)', function (obj) {
            console.log(obj);
            if (obj.event === 'add') {  // 监听添加操作
                var index = layer.open({
                    title: '添加博客文章',
                    type: 2,
                    shade: 0.2,
                    maxmin: true,
                    area: ['100%', '100%'],
                    content: '/admin/writeBlog.jsp'
                });
                $(window).on("resize", function () {
                    layer.full(index);
                });
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
                                layer.confirm("确定删除这<font color='red'>" + data.length + "</font>个博客吗?",
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
                                        var index_load = layer.load();
                                        $.post("${pageContext.request.contextPath}/admin/blog/delete.do", {ids: ids},
                                            function (result) {
                                                if (result.success) {
                                                    layer.msg('<font color="red">' + data.length + '</font>' + '个博客已成功删除！',
                                                        {
                                                            icon: 1,
                                                            time: 2000
                                                        });
                                                    table.reload('currentTableId', {
                                                        page: {
                                                            curr: obj.config.page.curr //重新从当前页开始
                                                        }
                                                    });
                                                } else {
                                                    layer.msg('数据删除失败！', {icon: 2, time: 2000});
                                                }
                                                layer.close(index_load);
                                            }, "json");
                                        layer.close(index);
                                    });
                            } else {
                                layer.msg('密码错误', {icon: 5, time: 2000});
                            }
                        });
                } else {
                    layer.msg("请选择要删除的博客文章", {icon: 0, time: 2000})
                }
                // layer.alert(JSON.stringify(data));
                return false;
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
                    title: '编辑博客文章',
                    type: 2,
                    shade: 0.2,
                    maxmin: true,
                    area: ['100%', '100%'],
                    content: '/admin/writeBlog.jsp',
                    success: function (layero, index) {
                        //成功回调,传递参数给弹窗
                        var body = layer.getChildFrame('body', index);
                        //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
                        var iframeWin = window[layero.find('iframe')[0]['name']];
                        //console.log(body.html()); //得到iframe页的body内容
                        body.find('#blogId').val(data.id);
                        body.find('#title').val(data.title);
                        body.find('#blogTypeId').val(data.blogType.id);
                        body.find('#editorData').val(data.content);
                        body.find('#keyWord').val(data.keyWord);
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
                            layer.confirm('确定删除' + '"' + data.title + '"' + '博客么',
                                {
                                    btn: ['确定', '取消'],
                                    icon: 3,
                                    title: '删除提示'
                                },
                                function (index) {
                                    var index_load = layer.load();
                                    var ids = data.id.toString();
                                    $.post("${pageContext.request.contextPath}/admin/blog/delete.do", {ids: ids},
                                        function (result) {
                                            if (result.success) {
                                                layer.msg('"' + data.title + '"' + '博客已成功删除！', {icon: 1, time: 2000});
                                                table.reload('currentTableId', {
                                                    page: {
                                                        curr: $("#currPage").val()//重新从当前页开始
                                                    }
                                                });
                                            } else {
                                                layer.msg(data.title + '博客删除失败！', {icon: 2, time: 2000});
                                            }
                                            layer.close(index_load);
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
    });
</script>
</body>
</html>