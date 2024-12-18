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
    <title>User Personal Page</title>
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
    </style>
</head>
<body>
<div class="modules-container">
    <div class="row-module">
        <a href="myOrders.jsp" class="module">My Orders</a>
        <a href="myWallet.jsp" class="module">My Wallet</a>
    </div>
    <a href="settings.jsp" class="module settings-module">Setting</a>
</div>
</body>
</html>