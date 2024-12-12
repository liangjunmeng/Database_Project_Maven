<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Page</title>
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
            animation: gradientButton 3s ease infinite;
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
        #overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5); /* 半透明黑色背景 */
            display: none; /* 初始隐藏 */
            z-index: 999; /* 层级高于弹窗 */
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
            z-index: 1000;
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

<!-- 遮罩层 -->
<div id="overlay"></div>

<div class="login-container">
    <div class="login-title">Register</div>
    <form action="/register" method="post" id="signform">
        <div class="input-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required>
        </div>
        <div class="input-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>
        </div>
        <button type="submit" id="signbtn">Sign Up</button>
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
            return;  // 结束函数，避免继续执行提交
        }

        // 判断密码是否为空
        if (isEmpty(upwd)) {
            showModal("Please enter a password.");
            return;  // 结束函数，避免继续执行提交
        }

        $("#signform").submit();
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
