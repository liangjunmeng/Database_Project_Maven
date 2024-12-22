<%--
  用户的搜索界面，便于用户购买特定的商品
--%>
<%--
  商品搜索（仅限用户）
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品搜索</title>
<body>
<%-- 引用css文件，避免代码太长 --%>
<link rel="stylesheet" href="product_search.css">
<button id="backHomeButton">全部商品</button>
<!-- 搜索框 -->
<div class="search-container">
    <input type="text" id="searchInput" placeholder="请输入商品名称" />
</div>
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
    /*
    判断点击搜索按钮是来自用户还是删除函数deleteSelectedProducts，
    因为如果删除了一个商品后无商品了，系统默认再搜索，会弹出无商品警告，
    而用户明明没有按下搜索
     */
    let clickSearchSourceIsnotHand = false;

    let selectedProductIds = []; // 存储被选中的商品ID
    //用于存储用户点击搜索后搜索框里的值
    var userEnter = "";
    window.onload = function() {
        var managerInputFromStorage = localStorage.getItem('managerInput');
        var lastPage = localStorage.getItem('lastPage');
        if (managerInputFromStorage != null && lastPage == "product_update") {
            localStorage.setItem('lastPage', "product_search");
            userEnter = managerInputFromStorage;
            clickSearchSourceIsnotHand = true;
            document.getElementById('searchInput').value = userEnter;
            $("#searchButton").click();
        }
    }
    // 点击全部商品按钮
    document.getElementById("backHomeButton").onclick = function() {
        location.href = 'home.jsp';
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

   $("#searchButton").click(function (event) {
        // 阻止表单的默认提交行为
        event.preventDefault();
        var managerInput = $("#searchInput").val();
        // 判断用户名是否为空
        if (isEmpty(managerInput)) {
            if(!clickSearchSourceIsnotHand) {
                showCustomModal("请勿输入空名称！");
            }
            else{
                clickSearchSourceIsnotHand = false;
            }
            return;  // 结束函数，避免继续执行提交
        }
        if(!clickSearchSourceIsnotHand) {
            userEnter = managerInput;
        }
        // 发送POST请求，将managerInput传给后端
        fetch("../product_getting", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",  // 设置请求头为JSON格式
            },
            body: JSON.stringify({ managerInput: managerInput })  // 将managerInput作为JSON数据发送
        })
            .then(response => response.json())
            .then(data => {
                const productList = document.getElementById('productList');
                productList.innerHTML = ``; // 清空现有内容
                if (data.length === 0) {
                    if(!clickSearchSourceIsnotHand) {
                        // data为空时弹出搜索结果不存在提示
                        showCustomModal("无符合条件的商品！");
                    }
                    else{
                        //把状态改回false，防止下次用户搜索无结果不会弹出提示框
                        clickSearchSourceIsnotHand = false;
                    }
                }
                else {
                    data.forEach(product => {
                        const productModule = document.createElement('div');
                        productModule.className = 'product-module';
                        productModule.innerHTML = `
                        <h3>\${product.productName}</h3>
                        <p>库存:\${product.productAmount}</p>
                        <p>价格:￥\${product.productPrice}</p>
                        <button onclick="saveToLocalStorage(\${product.productId}, '\${product.productName}', \${product.productAmount}, \${product.productPrice})">点击更新</button>
                        `;
                        productList.appendChild(productModule);
                    });
                }
            })
            .catch(error => console.error('Error fetching products:', error));
    });
    //使得点击模块后跳转到的页面能够取得被点击模块的信息
    function saveToLocalStorage(productId, productName, productAmount, productPrice) {
        localStorage.setItem('lastPage', "product_search");
        localStorage.setItem('managerInput',userEnter);
        localStorage.setItem('productId', productId);
        localStorage.setItem('productName', productName);
        localStorage.setItem('productAmount', productAmount);
        localStorage.setItem('productPrice', productPrice);
        location.href = './product_update.jsp';
    }

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
