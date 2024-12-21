<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>设置</title>
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
            width: 300px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .button {
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 50px;
            background-image: linear-gradient(45deg, #3abff8, #f83abf);
            color: white;
            cursor: pointer;
            font-size: 18px;
            background-size: 200% 200%;
            animation: gradientButton 6s ease infinite;
            margin: 10px; /* Uniform margin for all buttons */
        }

        .button:first-child {
            margin-bottom: 20px; /* Additional bottom margin for the Login button */
        }

        .button:last-child {
            margin-top: 20px; /* Additional top margin for the Register button */
        }

        .button:hover {
            animation: gradientButtonHover 0.5s ease forwards;
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
    </style>
</head>
<body>

<div class="login-container">
    <button class="button" onclick="location.href='info_edit.jsp'">编辑个人信息</button>
    <button class="button" onclick="location.href='../index.jsp'">退出</button>
</div>

</body>
</html>
