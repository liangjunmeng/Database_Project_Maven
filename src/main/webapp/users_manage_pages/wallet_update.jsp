<%@ page import="com.xxxx.bean.User" %><%--
  更新钱包状态，包括充值（增加余额）、提现（减少余额）、
  提高优先级（查看其他钱包里有没有优先级高的钱包，有则降低其优
  先级，因为只允许一种钱包优先级为高）、注销钱包（直接删除）
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>支付方式</title>
</head>
<body>
<link rel="stylesheet" href="wallet_update.css">
<div class="product-form-container">
    <div class="product-form-title">有关支付</div>
    <form id="addingfrom">
        <div class="input-group">
            <label for="productName">方式</label>
            <input type="text" id="productName" name="productName" readonly>
        </div>
        <div class="input-group">
            <label for="productQuantity">余额（￥）</label>
            <input type="text" id="productQuantity" name="productQuantity" readonly>
        </div>
        <div class="input-group">
            <label for="productPrice">优先级</label>
            <input type="text" id="productPrice" name="productPrice" readonly>
        </div>
    </form>
</div>

<button id="backHomeButton">返回</button>
<button id="recharge">充值</button>
<button id="cashOut">提现</button>
<button id="increasePriority">提高优先级</button>
<button id="logOff">注销</button>

<!-- 弹窗遮罩层 -->
<div id="modalOverlay" class="modal-overlay"></div>

<!-- 提示弹窗 -->
<div id="errorModal" class="modal">
    <div class="message" id="errorMessage"></div>
    <button class="close" onclick="closeModal()">&times;</button>  <!-- HTML 实体符号 -->
</div>

<!-- 金额操作弹窗遮罩层 -->
<div id="buyModalOverlay" class="buy-modal-overlay"></div>

<!-- 金额操作弹窗 -->
<div id="buyModal" class="buy-modal">
    <div class="message">
        <label for="buyQuantity">金额（￥）：</label>
        <input type="text" id="buyQuantity" name="buyQuantity">
    </div>
    <span id="alertInfo"></span>
    <div class="modal-buttons">
        <button type="button" id="confirmBuy">确定</button>
        <button type="button" id="cancelBuy" onclick="closeBuyModal()">取消</button>
    </div>
</div>
</body>
<%
    User user = (User) request.getSession().getAttribute("user");
    int userid = user.getUserid();
%>
<script type="text/javascript" src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
    let moneyin = false;//判断是充值还是提现
    var lastPage;
    var span;
    var sources;
    var balance;
    var isPrior;
    var userid = "<%= userid %>";
    //进入页面后自动执行
    window.onload = function() {
        lastPage = localStorage.getItem('lastPage');
        sources = localStorage.getItem('sources');
        balance = localStorage.getItem('balance');
        isPrior = localStorage.getItem('isPrior');
        // 将 localStorage 中的值填充到对应的 div 元素中
        // 将 localStorage 中的值填充到对应的 input 元素中
        document.getElementById('productName').value = methodChinese(sources);
        document.getElementById('productQuantity').value = balance;
        if(isPrior=="1"){
            document.getElementById('productPrice').value = "高";
        }
        else{
            document.getElementById('productPrice').value = "低";
        }

    };

    // 点击返回按钮
    document.getElementById("backHomeButton").onclick = function() {
        location.href = 'my_wallets.jsp';
    }

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

    // 显示购买弹窗
    function showBuyModal() {
        $("#buyModal").show();
        $("#buyModalOverlay").show();
    }

    // 关闭购买弹窗
    function closeBuyModal() {
        $("#buyModal").hide();
        $("#buyModalOverlay").hide();
    }

    $("#recharge").click(function (event) {
        moneyin = true;
        showBuyModal();
    });
    $("#cashOut").click(function (event) {
        moneyin = false;
        showBuyModal();
    });


    $("#confirmBuy").click(function (event) {
        // 阻止表单的默认提交行为
        event.preventDefault();
        showBuyModal();
        var money = $("#buyQuantity").val();

        if(isEmpty(money)){
            span = document.getElementById('alertInfo');
            span.innerHTML = "金额不能为空！";
            span.style.color = "red";
            setTimeout(function (){
                span.innerHTML = "";
            },1500);//1500毫秒后span里的内容清空
            return;
        }
        if(money == "0"){
            span = document.getElementById('alertInfo');
            span.innerHTML = "金额不能为0！";
            span.style.color = "red";
            setTimeout(function (){
                span.innerHTML = "";
            },1500);//1500毫秒后span里的内容清空
            return;
        }
        if (!isPositiveInt(money)) {
            span = document.getElementById('alertInfo');
            span.innerHTML = "金额应为正整数！";
            span.style.color = "red";
            setTimeout(function (){
                span.innerHTML = "";
            },1500);//1500毫秒后span里的内容清空
            return;
        }
        if(!moneyin && Number(money) > Number(balance)){
            span = document.getElementById('alertInfo');
            span.innerHTML = "提现金额不能超过余额！";
            span.style.color = "red";
            setTimeout(function (){
                span.innerHTML = "";
            },1500);//1500毫秒后span里的内容清空
            return;
        }

        var uid = userid;
        var sos = sources;
        if(!moneyin) {
            var mny = Number(money) * (-1);
        }
        else{
            var mny = Number(money);
        }
        // 使用 Ajax 提交表单数据到 Servlet
        $.ajax({
            url: "../wallet_money", // Servlet 的 URL
            type: "POST",
            data: {
                userid: uid,
                sources: sos,
                money: mny
            },
            dataType: "json", // 指定返回数据的类型为 JSON
            success: function (response) {
                // 根据服务器返回的数据进行处理
                if (response.success) {
                    // 添加成功，弹窗显示成功消息
                    span = document.getElementById('alertInfo');
                    span.innerHTML = response.message;
                    span.style.color = "green";
                    var newBalance = Number(balance) + mny;
                    localStorage.setItem("balance",newBalance);
                    setTimeout(function (){
                        span.innerHTML = "";
                        location.href = 'wallet_update.jsp';
                    },1500);//1500毫秒后span里的内容清空
                } else {
                    // 添加失败，弹窗显示错误消息
                    span = document.getElementById('alertInfo');
                    span.innerHTML = response.message;
                    span.style.color = "red";
                    setTimeout(function (){
                        span.innerHTML = "";
                    },1500);//1500毫秒后span里的内容清空
                }
            },
            error: function () {
                // 网络或服务器错误
                span = document.getElementById('alertInfo');
                span.innerHTML = "发生了错误，请稍后再尝试！";
                span.style.color = "red";
                setTimeout(function (){
                    span.innerHTML = "";
                },1500);//1500毫秒后span里的内容清空
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

    // 判断字符串是否为正整数
    function isPositiveInt(str) {
        return /^[1-9]\d*$/.test(str);
    }
    //将支付方式的英文名改为中文并返回
    function methodChinese(str){
        var source = "";
        switch (str) {
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
        return source;
    }
</script>
</html>


