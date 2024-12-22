<%--
  用户首页
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品管理</title>
<body>
<%-- 引用css文件，避免代码太长 --%>
<link rel="stylesheet" href="home.css">
<button id="myButton">我的</button>
<button id="searchButton">搜索</button>

<!-- 弹窗遮罩层 -->
<div id="customModalOverlay" class="custom-modal-overlay"></div>

<!-- 弹窗 -->
<div id="customErrorModal" class="custom-modal">
    <div class="custom-message" id="customErrorMessage"></div>
    <button class="custom-close" onclick="closeCustomModal()">&times;</button>
</div>


<div class="product-list-container">
    <div id="productList"></div>
</div>

<script type="text/javascript" src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script>

    let selectedProductIds = []; // 存储被选中的商品ID

    // 点击搜索按钮，来到搜索页面
    document.getElementById("searchButton").onclick = function() {
        location.href = 'product_search.jsp';
    }

    // 显示弹窗
    function showCustomModal(message) {
        $("#customErrorMessage").text(message);  // 设置错误信息
        $("#customErrorModal").show();  // 显示弹窗
        $("#customModalOverlay").show();  // 显示遮罩层
    }

    // 关闭弹窗
    function closeCustomModal() {
        $("#customErrorModal").hide();  // 隐藏弹窗
        $("#customModalOverlay").hide();  // 隐藏遮罩层
    }


    // 进入页面即可自动执行，刷新并显示出所有商品
    document.addEventListener('DOMContentLoaded', function() {
        fetchProducts();
    });
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
                    <h3>\${product.productName}</h3>
                    <p>库存:\${product.productAmount}</p>
                    <p>价格:￥\${product.productPrice}</p>
                    <button onclick="saveToLocalStorage(\${product.productId}, '\${product.productName}', \${product.productAmount}, \${product.productPrice})">查看详情</button>
                    `;
                    productList.appendChild(productModule);
                });
            })
            .catch(error => console.error('Error fetching products:', error));
    }

    //使得点击模块后跳转到的页面能够取得被点击模块的信息
    function saveToLocalStorage(productId, productName, productAmount, productPrice) {
        localStorage.setItem('lastPage', "product_management");
        localStorage.setItem('productId', productId);
        localStorage.setItem('productName', productName);
        localStorage.setItem('productAmount', productAmount);
        localStorage.setItem('productPrice', productPrice);
        location.href = 'product_buy.jsp';
    }

    // 点击加号按钮
    document.getElementById("myButton").onclick = function() {
        window.location.href = "../personal_pages/user_personal.jsp";
    }


</script>
</body>
</html>
