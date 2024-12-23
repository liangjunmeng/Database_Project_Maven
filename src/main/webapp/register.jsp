<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册页面</title>
</head>
<body>
<link rel="stylesheet" href="register.css">
<!-- 遮罩层 -->
<div id="overlay"></div>

<div class="login-container">
    <div class="login-title">Register</div>
    <form id="signform">
        <div class="input-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username">
        </div>
        <div class="input-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password">
        </div>
        <button type="button" id="signbtn">Sign Up</button>
        <div class="register">
            Already have an account? <a href="login.jsp" class="registerReal">Back to login</a>
        </div>
    </form>
</div>

<!-- 弹窗 -->
<div id="errorModal" class="modal">
    <div class="message" id="errorMessage"></div>
    <button class="close" onclick="closeModal()">&times;</button>  <!-- HTML 实体符号 -->
</div>

<script type="text/javascript" src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
    // 显示弹窗
    function showModal(message) {
        $("#errorMessage").text(message);
        $("#errorModal").show();  // 显示弹窗
        $("#overlay").show();  // 显示遮罩层
    }

    // 关闭弹窗
    function closeModal() {
        $("#errorModal").hide();  // 隐藏弹窗
        $("#overlay").hide();  // 隐藏遮罩层
    }

    $("#signbtn").click(function (event) {
        // 阻止表单提交
        event.preventDefault();  // 阻止表单的默认提交行为
        var uname = $("#username").val();
        var upwd = $("#password").val();

        // 判断用户名是否为空
        if (isEmpty(uname)) {
            showModal("Username can't be empty");
            setTimeout(function () {
                closeModal();
            }, 1500);
            return;  // 结束函数，避免继续执行提交
        }

        // 判断密码是否为空
        if (isEmpty(upwd)) {
            showModal("Please enter a password.");
            setTimeout(function () {
                closeModal();
            }, 1500);
            return;  // 结束函数，避免继续执行提交
        }

        // 使用 Ajax 提交表单数据到 Servlet
        $.ajax({
            url: "register", // Servlet 的 URL
            type: "POST",
            data: {
                username: uname,
                password: upwd
            },
            dataType: "json", // 指定返回数据的类型为 JSON
            success: function (response) {
                // 根据服务器返回的数据进行处理
                if (response.success) {
                    // 注册成功，弹窗显示成功消息
                    showModal(response.message);
                    //判断是否为管理员
                    if(!response.isManager) {
                        // 1.5秒后重定向到首页
                        setTimeout(function () {
                            //关闭弹窗并清除输入框里的内容
                            closeModal();
                            //判断用户是否已经通过注册方式登录了,若有则跳转到登陆页面
                            if (localStorage.getItem("doesLogin") == "yes"){
                                window.location.href = "login.jsp";
                                return;
                            }
                            document.getElementById('username').value = "";
                            document.getElementById('password').value = "";
                            localStorage.setItem("doesLogin","yes");
                            //同一标签页中打开，这里不再采用
                            //window.location.href = "homepages/home.jsp";
                            //重新打开一个标签页，方便之后的退出操作
                            window.open("homepages/home.jsp", "_blank");
                        }, 1500);
                    }
                    else{
                        setTimeout(function () {
                            closeModal();
                            if (localStorage.getItem("doesLogin") == "yes"){
                                window.location.href = "login.jsp";
                                return;
                            }
                            document.getElementById('username').value = "";
                            document.getElementById('password').value = "";
                            localStorage.setItem("doesLogin","yes");
                            window.open("personal_pages/manager_personal.jsp", "_blank");
                        }, 1500);
                    }
                } else {
                    // 注册失败，弹窗显示错误消息
                    showModal(response.message);
                    setTimeout(function () {
                        closeModal();
                    }, 1500);
                }
            },
            error: function () {
                // 网络或服务器错误
                showModal("An error occurred. Please try again.");
                setTimeout(function () {
                    closeModal();
                }, 1500);
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

</body>
</html>
