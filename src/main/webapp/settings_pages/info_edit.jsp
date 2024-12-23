<%@ page import="com.xxxx.bean.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
  用于更新用户信息
--%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户信息编辑</title>
</head>
<body>
<link rel="stylesheet" href="info_edit.css">
<div class="user-form-container">
    <div class="user-form-title">编辑信息</div>
    <form id="editingfrom">
        <div class="input-group">
            <label for="username">用户名:</label>
            <input type="text" id="username" name="username">
        </div>
        <div class="input-group">
            <label for="password">密码:</label>
            <input type="text" id="password" name="password">
        </div>
        <div class="button-group">
            <button type="button" id="editbtn">修改</button>
            <button type="button" id="clearbtn">注销</button>
        </div>
    </form>
</div>

<!-- 弹窗遮罩层 -->
<div id="modalOverlay" class="modal-overlay"></div>

<!-- 弹窗 -->
<div id="errorModal" class="modal">
    <div class="message" id="errorMessage"></div>
    <button class="close" onclick="closeModal()">&times;</button>  <!-- HTML 实体符号 -->
</div>

</body>
<%
    User user = (User) request.getSession().getAttribute("user");
    int userid = user.getUserid();
    String username = user.getUsername();
    String password = user.getPassword();
%>
<script type="text/javascript" src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
    var userid = "<%= userid %>";
    var username = "<%= username %>";
    var password = "<%= password %>";
    //获得上一个页面里被点击模块的信息
    window.onload = function() {
        // 将 localStorage 中的值填充到对应的 input 元素中
        if (username) {
            document.getElementById('username').value = username;
        }
        if (password) {
            document.getElementById('password').value = password;
        }
    };

    // 显示弹窗
    function showModal(message) {
        $("#errorMessage").text(message);
        $("#errorModal").show();  // 显示弹窗
        $("#modalOverlay").show();  // 显示遮罩层
    }

    // 关闭弹窗
    function closeModal() {
        $("#errorModal").hide();  // 隐藏弹窗
        $("#modalOverlay").hide();  // 隐藏遮罩层
    }

    $("#editbtn").click(function (event) {
        // 阻止表单的默认提交行为
        event.preventDefault();
        var uid = userid;
        var uname = $("#username").val();
        var upwn = $("#password").val();
        // 判断用户名是否为空
        if (isEmpty(uname)) {
            showModal("用户名不能为空！");
            return;  // 结束函数，避免继续执行提交
        }

        // 判断密码是否为空
        if (isEmpty(upwn)) {
            showModal("密码不能为空！");
            return;  // 结束函数，避免继续执行提交
        }


        // 使用 Ajax 提交表单数据到 Servlet
        $.ajax({
            url: "../user_updating", // Servlet 的 URL
            type: "POST",
            data: {
                userid: uid,
                username: uname,
                password: upwn
            },
            dataType: "json", // 指定返回数据的类型为 JSON
            success: function (response) {
                // 根据服务器返回的数据进行处理
                if (response.success) {
                    // 更新成功，弹窗显示成功消息
                    showModal(response.message);

                    // 1.5秒后重定向到上一页
                    setTimeout(function () {
                        location.href = "settings.jsp";
                    }, 1500);

                } else {
                    // 更新失败，弹窗显示错误消息
                    showModal(response.message);
                }
            },
            error: function () {
                // 网络或服务器错误
                showModal("发生了错误，请稍后再尝试！");
            }
        });
    });

    //注销用户
    $("#clearbtn").click(function (event) {
        // 阻止表单的默认提交行为
        event.preventDefault();
        var uid = userid;

        // 使用 Ajax 提交表单数据到 Servlet
        $.ajax({
            url: "../user_deleting", // Servlet 的 URL
            type: "POST",
            data: {
                userid: uid
            },
            dataType: "json", // 指定返回数据的类型为 JSON
            success: function (response) {
                // 根据服务器返回的数据进行处理
                if (response.success) {
                    // 注销成功，弹窗显示成功消息
                    showModal(response.message);

                    // 1.5秒后重定向到上一页
                    setTimeout(function () {
                        window.close();
                    }, 1500);

                } else {
                    // 注销失败，弹窗显示错误消息
                    showModal(response.message);
                }
            },
            error: function () {
                // 网络或服务器错误
                showModal("发生了错误，请稍后再尝试！");
            }
        });
    });

    // 判断字符串是否为空，空则返回 true，否则返回 false
    function isEmpty(str) {
        if (str == null || str.trim() == "") {
            return true;
        }
        return false;
    }
</script>
</html>


