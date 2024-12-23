<%--
  用户的个人页面，包括三个可点击模块：个人订单、钱包和设置，
  个人订单负责编辑已购买的商品相关的订单；
  钱包负责给各种购买方式，如微信支付等，充值（增）或者提现（减）；
  设置则用于编辑账号信息，如用户名（暂且可不管，因为涉及重名）和密码，以及退出当前帐号
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户个人页面</title>
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

        .modules-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .module {
            width: 200px;
            height: 120px;
            margin: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            color: #333;
            text-decoration: none;
            font-size: 20px;
            transition: transform 0.3s ease, background-color 0.3s ease;
        }

        .module:hover {
            transform: scale(1.1);
            background-color: rgba(255, 255, 255, 1);
        }

        .row-module {
            display: flex;
            width: 100%;
            justify-content: space-around;
        }

        /* 使设置模块位于中间下方 */
        .settings-module {
            margin-top: 20px;
        }

        #backHomeButton {
            position: fixed;
            left: 20px;
            width: 120px;
            height: 60px;
            padding: 0;
            background-color: white;
            color: black;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 18px;
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            transition: transform 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center; /* 居中对齐文本 */
        }

        #backHomeButton {
            top: 20px; /* 确保与加号按钮同一行 */
        }

        #backHomeButton:hover {
            background-color: #f8f8f8;
            transform: scale(1.1); /* 鼠标悬浮时放大按钮 */
        }
    </style>
</head>
<body>
<div class="modules-container">
    <div class="row-module">
        <a href="../users_manage_pages/my_orders.jsp" class="module">我的订单</a>
        <a href="../users_manage_pages/my_wallets.jsp" class="module">我的钱包</a>
    </div>
    <a href="../settings_pages/settings.jsp" class="module settings-module">设置</a>
</div>
<button id="backHomeButton">回到首页</button>
</body>
<script type="text/javascript" src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script>
    // 点击回到首页按钮
    document.getElementById("backHomeButton").onclick = function() {
        location.href = '../homepages/home.jsp';
    }
    window.onbeforeunload = function() {
        // 在标签页关闭之前清空 localStorage
        localStorage.clear();
    };
</script>
</html>