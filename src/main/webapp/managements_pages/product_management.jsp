<%--
  商品管理（仅限管理员）
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品管理</title>
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

        #addButton {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 25px;
            background-color: white;
            color: black;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 24px;
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }
        #addButton:hover {
            background-color: #f8f8f8;
        }

        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
        }

        .modal {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 8px;
            border: 1px solid rgba(0, 0, 0, 0.2);
            box-shadow: 0 4px 25px rgba(0, 0, 0, 0.4);
            z-index: 1000;
            max-width: 300px;
            width: 60%;
            text-align: center;
        }

        .modal button {
            padding: 10px 15px;
            margin: 5px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 48%;
        }

        .modal .confirm {
            background-image: linear-gradient(45deg, #3abff8, #f83abf);
            background-size: 400% 400%;
            animation: gradientButton 6s ease infinite;
            color: white;
            border-radius: 5px;
        }

        .modal .cancel {
            background-color: #808080;
            color: white;
            border-radius: 5px;
        }

        .modal .buttons {
            display: flex;
            justify-content: center;
            margin-top: 20px;
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
    </style>
</head>
<body>
<h1>欢迎来到商品管理页面</h1>
<button id="addButton">+</button>

<div class="modal-overlay" id="modalOverlay"></div>
<div class="modal" id="confirmModal">
    <div class="message">您确定要添加商品吗？</div>
    <div class="buttons">
        <button class="confirm" onclick="location.href='./product_add.jsp'">确定</button>
        <button class="cancel" onclick="closeModal()">取消</button>
    </div>
</div>

<script>
    var modal = document.getElementById("confirmModal");
    var overlay = document.getElementById("modalOverlay");

    document.getElementById("addButton").onclick = function() {
        modal.style.display = "block";
        overlay.style.display = "block";
    }

    function closeModal() {
        modal.style.display = "none";
        overlay.style.display = "none";
    }

    // 阻止遮罩层的点击事件冒泡到弹窗
    overlay.addEventListener('click', function(event) {
        event.stopPropagation();
    });
</script>
</body>
</html>