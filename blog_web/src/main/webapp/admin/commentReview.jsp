<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="utf-8">
    <title>评论审核管理</title>
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
        <script type="text/html" id="toolbarDemo">
            <div class="layui-btn-container">
                <button class="layui-btn layui-btn-normal " lay-event="check">
                    <i class="layui-icon layui-icon-ok"></i> 审核通过
                </button>
                <button class="layui-btn layui-btn-danger" lay-event="uncheck">
                    <i class="layui-icon layui-icon-close"></i> 审核不通过
                </button>
            </div>
        </script>

        <table class="layui-hide" id="currentTableId" lay-filter="currentTableFilter"></table>

    </div>
</div>
<script src="${pageContext.request.contextPath}/static/layuimini/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script>
    layui.use(['form', 'table'], function () {
        var $ = layui.jquery,
            form = layui.form,
            table = layui.table;

        table.render({
            elem: '#currentTableId',
            url: '${pageContext.request.contextPath}/admin/comment/list.do?state=0',
            toolbar: '#toolbarDemo',
            even: true, //开启隔行背景
            defaultToolbar: ['filter', 'exports', 'print', {
                title: '提示',
                layEvent: 'LAYTABLE_TIPS',
                icon: 'layui-icon-tips'
            }],
            cols: [[
                {
                    type: "numbers",
                },
                {
                    type: "checkbox",
                },
                {
                    field: 'id',
                    title: '编号',
                    sort: true,
                    align: 'center',
                },
                {
                    field: 'blog',
                    //添加模板，格式化该单元格里的内容
                    <%--templet: '<div><a target="_blank" href="${pageContext.request.contextPath}/blog/articles/{{d.blog.id}}.html" class="layui-table-link">{{d.blog.title}}</a></div>',--%>
                    templet: function (d) {
                        if (d.blog == null) {
                            return "<font color='red'>该博客已被删除！</font>";
                        } else {
                            return '<div><a target="_blank" href="${pageContext.request.contextPath}/blog/articles/' + d.blog.id + '.html" class="layui-table-link">' + d.blog.title + '</a></div>';
                        }
                    },
                    title: '博客标题',
                    align: 'center',
                },
                {
                    field: 'userIp',
                    title: '用户IP',
                    align: 'center',
                },
                {
                    field: 'content',
                    title: '评论内容',
                    align: 'center',
                },
                {
                    field: 'commentDate',
                    title: '评论日期',
                    sort: true,
                    align: 'center',
                },
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
            },
            limits: [10, 15, 20, 25, 50, 100],
            limit: 10,
            page: true,
            skin: 'line'
        });

        /**
         * toolbar监听事件
         */
        table.on('toolbar(currentTableFilter)', function (obj) {
            console.log(obj);
            console.log("obj...=" + obj.config.page.curr);
            var state = '';
            if (obj.event === 'check') {  // 监听
                state = 1;
            } else if (obj.event === 'uncheck') {
                state = 2;
            }
            var checkStatus = table.checkStatus('currentTableId')
                , data = checkStatus.data;
            console.log("data=" + data);
            if (data.length != 0) {
                layer.confirm("您确定要审核这<font color=red>" + data.length + "</font>条评论吗？",
                    {btn: ['确定', '取消'], icon: 3, title: '审核提示'},
                    function (index) {
                        var ids = '';
                        var strIds = new Array();
                        for (let i = 0; i < data.length; i++) {
                            strIds.push(data[i].id);
                        }
                        ids = strIds.join(",");
                        console.log("ids=" + ids);
                        $.post("${pageContext.request.contextPath}/admin/comment/review.do",
                            {
                                ids: ids,
                                state: parseInt(state)    //审核状态  1 通过，2 不通过
                            },
                            function (result) {
                                if (result.success) {
                                    layer.msg("提交成功！", {icon: 1, time: 2000});
                                    table.reload('currentTableId', {
                                        page: {
                                            curr: obj.config.page.curr //重新从当前页开始
                                        }
                                    });
                                } else {
                                    layer.msg("提交失败！", {icon: 2, time: 2000});
                                }
                            }, "json");
                        layer.close(index);
                        return false;
                    });
            } else {
                layer.msg("请选择要审核的评论", {icon: 0, time: 2000})
            }
            //窗口重置
            /*$(window).on("resize", function () {
                layer.full(index);
            });*/
        });

        //监听表格复选框选择
        table.on('checkbox(currentTableFilter)', function (obj) {
            console.log(obj)
        });
    });
</script>

</body>
</html>