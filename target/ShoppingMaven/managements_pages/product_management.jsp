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
        html {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(45deg, #3abff8, #f83abf);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
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

        #addButton,
        #removeButton {
            position: fixed;
            right: 20px;
            width: 70px; /* 确保两个按钮宽度一致 */
            height: 60px; /* 确保两个按钮高度一致 */
            padding: 0; /* 去除多余的内边距，保持大小一致 */
            background-color: white;
            color: black;
            border: none;
            border-radius: 10px; /* 圆形按钮 */
            cursor: pointer;
            font-size: 36px; /* 字体大小一致 */
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            transition: transform 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center; /* 居中对齐文本 */
        }

        #addButton {
            top: 20px; /* 距顶部的距离 */
        }

        #removeButton {
            top: 90px; /* 确保与加号按钮垂直间隔 */
        }

        #addButton:hover,
        #removeButton:hover {
            background-color: #f8f8f8;
            transform: scale(1.1); /* 鼠标悬浮时放大按钮 */
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

        .product-list-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start; /* 将内容从顶部开始排列 */
            min-height: 100vh; /* 确保容器至少有视口高度 */
            margin-top: 100px; /* 给商品列表留出足够的空间，防止被按钮遮挡 */
            width: 100%;
            max-width: 800px;
            margin: 0 auto;
        }

        .product-module {
            background-color: white;
            margin: 20px; /* 增加模块之间的间距 */
            padding: 30px; /* 增加模块内容的内边距 */
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            cursor: pointer;
            width: 350px; /* 增加模块的宽度 */
            max-width: 100%; /* 确保模块宽度不超过容器宽度 */
            position: relative; /* 确保小圆框相对于商品模块定位 */
        }

        .product-module h3 {
            margin: 0;
            font-size: 20px;
        }

        .product-module p {
            margin: 10px 0;
            font-size: 16px;
        }

        .product-module button {
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            background: linear-gradient(45deg, #3abff8, #f83abf); /* 与页面背景一致 */
            background-size: 400% 400%; /* 确保渐变动态 */
            animation: gradientBG 15s ease infinite; /* 与页面背景动画同步 */
            color: white; /* 保持文字颜色对比清晰 */
            transition: transform 0.2s ease; /* 增加点击时的动画效果 */
        }

        .product-module button:hover {
            transform: scale(1.1); /* 鼠标悬浮时放大按钮 */
        }

        .product-module .delete-checkbox {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 20px;
            height: 20px;
            background-color: white;
            border: 2px solid #f83abf;
            border-radius: 50%;
            cursor: pointer;
            display: none; /* 默认隐藏 */
            z-index: 10;
        }

        .product-module .delete-checkbox:hover {
            background-color: #f83abf;
        }
    </style>
</head>
<body>
<button id="addButton">+</button>
<button id="removeButton">-</button>

<div class="modal-overlay" id="modalOverlay"></div>
<div class="modal" id="confirmModal">
    <div class="message">您确定要添加商品吗？</div>
    <div class="buttons">
        <button class="confirm" onclick="closeModal(true)">确定</button>
        <button class="cancel" onclick="closeModal(false)">取消</button>
    </div>
</div>

<div class="product-list-container">
    <div id="productList"></div>
</div>

<script type="text/javascript" src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script>
    let deleteMode = false; // 控制勾选框的显示状态
    // 点击加号按钮
    document.addEventListener('DOMContentLoaded', function() {
        fetchProducts();
    });
    // 点击减号按钮切换删除模式
    document.getElementById("removeButton").onclick = function() {
        deleteMode = !deleteMode; // 切换deleteMode状态
        toggleDeleteCheckboxes(); // 更新所有商品模块的小圆框显示状态
    }
    // 显示或隐藏删除小圆框
    function toggleDeleteCheckboxes() {
        const deleteCheckboxes = document.querySelectorAll('.delete-checkbox');
        deleteCheckboxes.forEach(checkbox => {
            checkbox.style.display = deleteMode ? 'block' : 'none'; // 根据deleteMode控制显示或隐藏
        });
    }
    function fetchProducts() {
        fetch("../product_getting")
            .then(response => response.json())
            .then(data => {
                const productList = document.getElementById('productList');
                productList.innerHTML = ``; // 清空现有内容
                data.forEach(product => {
                    const productModule = document.createElement('div');
                    productModule.className = 'product-module';
                    productModule.innerHTML = `
                    <div class="delete-checkbox" onclick="location.href='./product_detail.jsp?id=\${product.productId}'"></div>
                    <h3>\${product.productName}</h3>
                    <p>库存:\${product.productAmount}</p>
                    <p>价格:￥\${product.productPrice}</p>
                    <button onclick="location.href='./product_detail.jsp?id=\${product.productId}'">查看详情</button>
                    `;
                    productList.appendChild(productModule);
                });
            })
            .catch(error => console.error('Error fetching products:', error));
    }

    var modal = document.getElementById("confirmModal");
    var overlay = document.getElementById("modalOverlay");

    document.getElementById("addButton").onclick = function() {
        modal.style.display = "block";
        overlay.style.display = "block";
    }

    function closeModal(isConfirm) {
        if (isConfirm) {
            window.location.href = './product_add.jsp';
        }
        else {
            modal.style.display = "none";
            overlay.style.display = "none";
        }
    }

    // 阻止遮罩层的点击事件冒泡到弹窗
    overlay.addEventListener('click', function(event) {
        event.stopPropagation();
    });
</script>
</body>
</html>