<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            background: linear-gradient(45deg, #3abff8, #f83abf);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        @keyframes gradientBG {
            0% {
                background-position: 0% 50%;
            }
            50% {
                background-position: 100% 50%;
            }
            100% {
                background-position: 0% 50%;
            }
        }

        .login-container {
            background-color: rgba(255, 255, 255, 0.8);
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            width: 350px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .login-title {
            font-size: 30px;
            color: #333;
            margin-bottom: 20px;
        }

        .input-group {
            margin-bottom: 20px;
            width: 100%;
            text-align: left;
        }

        .input-group label {
            display: block;
            margin-bottom: 8px;
            color: #666;
            font-size: 16px;
        }

        .input-group input {
            width: 100%;
            padding: 15px;
            border: 2px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 16px;
        }

        .login-container button {
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 5px;
            background-image: linear-gradient(45deg, #3abff8, #f83abf);
            color: white;
            cursor: pointer;
            font-size: 18px;
            background-size: 200% 200%;
            animation: gradientButton 6s ease infinite;
        }

        .login-container button:hover {
            animation: gradientButtonHover 0.5s ease forwards;
        }

        .register {
            font-size: 16px;
            text-align: center;
            margin-top: 20px;
            color: #337ab7;
            cursor: pointer;
        }

        .registerReal {
            font-size: 16px;
            text-align: center;
            margin-top: 20px;
            color: #337ab7;
            cursor: pointer;
            text-decoration: underline;
        }

        @keyframes gradientButton {
            0% {
                background-position: 0% 50%;
            }
            50% {
                background-position: 100% 50%;
            }
            100% {
                background-position: 0% 50%;
            }
        }

        @keyframes gradientButtonHover {
            0% {
                background-position: 0% 50%;
            }
            100% {
                background-position: 100% 50%;
            }
        }

        /* 弹窗遮罩层 */
        .modal-overlay {
            display: none;  /* 初始不显示 */
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);  /* 半透明背景 */
            z-index: 999;  /* 遮罩层置于内容上方 */
        }

        /* 弹窗样式 */
        .modal {
            display: none;  /* 初始不显示 */
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 8px;
            border: 1px solid rgba(0, 0, 0, 0.2);  /* 边缘 */
            box-shadow: 0 4px 25px rgba(0, 0, 0, 0.4);
            z-index: 1000;  /* 弹窗置于遮罩层上方 */
            max-width: 250px; /* 弹窗最大宽度 */
            width: 60%; /* 宽度为80% */
        }

        .modal .message {
            color: #111;
            font-size: 16px;
            text-align: center;
        }

        .modal .close {
            background: transparent;
            color: #333;
            font-size: 28px;
            border: none;
            position: absolute;
            top: 5px;
            right: 10px;
            cursor: pointer;
        }

        .modal .close:hover {
            color: red;
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-title">Login</div>
    <form id="loginform">
        <div class="input-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username">
        </div>
        <div class="input-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password">
        </div>
        <button type="button" id="loginbtn">Login In</button>
        <div class="register">
            Don't have an account? <a href="register.jsp" class="registerReal">Click here</a>
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
<script type="text/javascript" src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
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

    $("#loginbtn").click(function (event) {
        // 阻止表单的默认提交行为
        event.preventDefault();
        var uname = $("#username").val();
        var upwd = $("#password").val();

        // 判断用户名是否为空
        if (isEmpty(uname)) {
            showModal("Username is required.");
            return;  // 结束函数，避免继续执行提交
        }

        // 判断密码是否为空
        if (isEmpty(upwd)) {
            showModal("Password is required.");
            return;  // 结束函数，避免继续执行提交
        }
        /*
        该方法是传统表单提交方式，这里不再采用，取而代之用Ajax提交和JSON响应，更灵活方便
        $("#loginform").submit();
        */
        // 使用 Ajax 提交表单数据到 Servlet
        $.ajax({
            url: "login", // Servlet 的 URL
            type: "POST",
            data: {
                username: uname,
                password: upwd
            },
            dataType: "json", // 指定返回数据的类型为 JSON
            success: function (response) {
                // 根据服务器返回的数据进行处理
                if (response.success) {
                    // 登录成功，弹窗显示成功消息
                    showModal(response.message);
                    //判断是否为管理员
                    if(!response.isManager) {
                        // 1.5秒后重定向到首页
                        setTimeout(function () {
                            window.location.href = "homepages/home.jsp";
                        }, 1500);
                    }
                    else{
                        setTimeout(function () {
                            window.location.href = "personal_pages/manager_personal.jsp";
                        }, 1500);
                    }
                } else {
                    // 登录失败，弹窗显示错误消息
                    showModal(response.message);
                }
            },
            error: function () {
                // 网络或服务器错误
                showModal("An error occurred. Please try again.");
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
