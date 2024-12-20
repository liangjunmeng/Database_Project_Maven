<%--
  用于更新商品
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>添加商品</title>
</head>
<body>
<link rel="stylesheet" href="product_add_or_update.css">
<div class="product-form-container">
    <div class="product-form-title">商品更新</div>
    <form id="addingfrom">
        <div class="input-group">
            <label for="productName">商品名:</label>
            <input type="text" id="productName" name="productName">
        </div>
        <div class="input-group">
            <label for="productQuantity">商品数量:</label>
            <input type="number" id="productQuantity" name="productQuantity">
        </div>
        <div class="input-group">
            <label for="productPrice">商品单价:</label>
            <input type="number" id="productPrice" name="productPrice">
        </div>
        <button type="button" id="addbtn">更新</button>
    </form>
</div>

<!-- 弹窗遮罩层 -->
<div id="modalOverlay" class="modal-overlay"></div>

<!-- 弹窗 -->
<div id="errorModal" class="modal">
    <div class="message" id="errorMessage"></div>
    <button class="close" onclick="closeModal()">&times;</button>  <!-- HTML 实体符号 -->
</div>

</body>
<script type="text/javascript" src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
    //获得上一个页面里被点击模块的信息
    window.onload = function() {
        const productId = localStorage.getItem('productId');
        const productName = localStorage.getItem('productName');
        const productAmount = localStorage.getItem('productAmount');
        const productPrice = localStorage.getItem('productPrice');
        // 将 localStorage 中的值填充到对应的 input 元素中
        if (productName) {
            document.getElementById('productName').value = productName;
        }
        if (productAmount) {
            document.getElementById('productQuantity').value = productAmount;
        }
        if (productPrice) {
            document.getElementById('productPrice').value = productPrice;
        }
    };

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

    $("#addbtn").click(function (event) {
        // 阻止表单的默认提交行为
        event.preventDefault();
        var pid = $("#productId").val();
        var pname = $("#productName").val();
        var pamount = $("#productQuantity").val();
        var pprice = $("#productPrice").val();
        // 判断用户名是否为空
        if (isEmpty(pname)) {
            showModal("商品名不能为空");
            return;  // 结束函数，避免继续执行提交
        }

        // 判断密码是否为空
        if (isEmpty(pamount)) {
            showModal("商品数量不能为空");
            return;  // 结束函数，避免继续执行提交
        }

        // 判断密码是否为空
        if (isEmpty(pprice)) {
            showModal("商品单价不为空");
            return;  // 结束函数，避免继续执行提交
        }

        // 使用 Ajax 提交表单数据到 Servlet
        $.ajax({
            url: "../product_updating", // Servlet 的 URL
            type: "POST",
            data: {
                productId: pid,
                productName: pname,
                productAmount: pamount,
                productPrice: pprice
            },
            dataType: "json", // 指定返回数据的类型为 JSON
            success: function (response) {
                // 根据服务器返回的数据进行处理
                if (response.success) {
                    // 添加成功，弹窗显示成功消息
                    showModal(response.message);

                    // 1.5秒后重定向到首页
                    setTimeout(function () {
                        window.location.href = "product_management.jsp";
                    }, 1500);
                } else {
                    // 添加失败，弹窗显示错误消息
                    showModal(response.message);
                }
            },
            error: function () {
                // 网络或服务器错误
                showModal("发生了错误，请稍后再尝试！");
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
</script>
</html>

