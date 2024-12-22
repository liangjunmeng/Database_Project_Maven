<%@ page import="com.xxxx.bean.User" %><%--
  钱包页面（仅限用户）
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品管理</title>
<body>
<%-- 引用css文件，避免代码太长 --%>
<link rel="stylesheet" href="my_wallets.css">
<button id="addButton">添加支付方式</button>
<button id="backHomeButton">返回</button>
<div class="modal-overlay" id="modalOverlay"></div>
<div class="modal" id="confirmModal">
    <div class="message">
        支付方式
        <select id="paymentMethod" class="payment-select">
            <option value="Wechat">微信</option>
            <option value="Alipay">支付宝</option>
            <option value="Localbank">银行卡</option>
            <option value="Applepay">苹果</option>
        </select>
    </div>
    <div class="buttons">
        <button class="confirm" onclick="closeModal(true)">确定</button>
        <button class="cancel" onclick="closeModal(false)">取消</button>
    </div>
</div>

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
<%
    User user = (User) request.getSession().getAttribute("user");
    int userid = user.getUserid();
%>
<script type="text/javascript" src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script>
    var uid = "<%= userid %>";
    // 点击返回按钮
    document.getElementById("backHomeButton").onclick = function() {
        location.href = '../personal_pages/user_personal.jsp';
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

    var modal = document.getElementById("confirmModal");
    var overlay = document.getElementById("modalOverlay");
    // 进入页面即可自动执行，刷新并显示出所有商品
    document.addEventListener('DOMContentLoaded', function() {
        fetchWallets();
    });
    function fetchWallets() {
        fetch("../wallet_getting", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",  // 设置请求头为JSON格式
            },
            body: JSON.stringify({ userid: uid })  // 将managerInput作为JSON数据发送
        })
            .then(response => response.json())
            .then(data => {
                const productList = document.getElementById('productList');
                productList.innerHTML = ``; // 清空现有内容
                data.forEach(wallet => {
                    const productModule = document.createElement('div');
                    var prior = "";
                    if(wallet.isPrior){
                        prior = "高";
                    }
                    else{
                        prior = "低";
                    }
                    var source = "";
                    switch (wallet.sources) {
                        case "Alipay":
                            source = "支付宝";
                            break;
                        case "Wechat":
                            source = "微信";
                            break;
                        case "Applepay":
                            source = "苹果支付";
                            break;
                        case "Localbank":
                            source = "银行卡";
                            break;
                    }
                    productModule.className = 'product-module';
                    productModule.innerHTML = `
                    <h3>\${source}</h3>
                    <p>余额:￥\${wallet.balance}</p>
                    <p>优先级：\${prior}</p>
                    <button onclick="saveToLocalStorage(\${wallet.userid}, '\${wallet.sources}', \${wallet.balance}, \${wallet.isPrior})">查看详情</button>
                    `;
                    productList.appendChild(productModule);
                });
            })
            .catch(error => console.error('Error fetching wallets:', error));
    }

    //使得点击模块后跳转到的页面能够取得被点击模块的信息
    function saveToLocalStorage(userid, sources, balance, isPrior) {
        localStorage.setItem('lastPage', "wallets");
        localStorage.setItem('userid', userid);
        localStorage.setItem('sources', sources);
        localStorage.setItem('balance', balance);
        localStorage.setItem('isPrior', isPrior);
        location.href = './wallet_update.jsp';
    }

    // 点击加号按钮
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
