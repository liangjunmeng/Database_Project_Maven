<%--
  商品管理（仅限管理员）
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品管理</title>
<body>
<%-- 引用css文件，避免代码太长 --%>
<link rel="stylesheet" href="product_management.css">
<button id="addButton">+</button>
<button id="removeButton">-</button>
<button id="backHomeButton">回到首页</button>
<button id="deleteButton" disabled>删除</button>

<div class="modal-overlay" id="modalOverlay"></div>
<div class="modal" id="confirmModal">
    <div class="message">您确定要添加商品吗？</div>
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

<script type="text/javascript" src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script>
    let deleteMode = false; // 控制勾选框的显示状态
    let deleteBtn = false; // 控制删除按钮的显示状态
    let selectedProductIds = []; // 存储被选中的商品ID

    // 点击回到首页按钮
    document.getElementById("backHomeButton").onclick = function() {
        location.href = '../personal_pages/manager_personal.jsp';
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


    // 点击减号按钮切换删除模式以及勾选框的状态
    document.getElementById("removeButton").onclick = function() {
        deleteMode = !deleteMode; // 切换deleteMode状态
        deleteBtn = !deleteBtn;
        toggleDeleteCheckboxes(); // 更新所有商品模块的小圆框显示状态
    }
    // 显示或隐藏删除小圆框以及删除按钮
    function toggleDeleteCheckboxes() {
        const deleteCheckboxes = document.querySelectorAll('.delete-checkbox');
        const deleteButton = document.getElementById("deleteButton");
        deleteCheckboxes.forEach(checkbox => {
            checkbox.style.display = deleteMode ? 'block' : 'none'; // 根据deleteMode控制显示或隐藏
        });
        deleteButton.style.display = deleteBtn ? 'block' : 'none';
    }
    // 切换勾选框选中状态
    function toggleCheckbox(productId) {
        const checkbox = document.querySelector(`.delete-checkbox[data-id="\${productId}"]`);
        checkbox.classList.toggle('selected'); // 切换选中状态
        const index = selectedProductIds.indexOf(productId);
        if (index === -1) {
            selectedProductIds.push(productId); // 添加到选中列表
        } else {
            selectedProductIds.splice(index, 1); // 从选中列表移除
        }
        toggleDeleteButton(); // 根据选中的商品更新删除按钮状态
    }
    // 更新删除按钮的状态
    function toggleDeleteButton() {
        const deleteButton = document.getElementById("deleteButton");
        if (selectedProductIds.length > 0) {
            deleteButton.classList.add('active'); // 激活删除按钮
            deleteButton.disabled = false;
        } else {
            deleteButton.classList.remove('active'); // 禁用删除按钮
            deleteButton.disabled = true;
        }
    }
    // 点击删除按钮后删除选中的商品
    document.getElementById("deleteButton").onclick = function() {
        if (selectedProductIds.length > 0) {
            deleteSelectedProducts(selectedProductIds);
            deleteMode = false;
            deleteBtn = false;
            toggleDeleteCheckboxes();
        }
    }

    // 从后端删除选中的商品
    function deleteSelectedProducts(productIds) {
        fetch("../product_deleting", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ productIds: productIds })
        })
            .then(response => response.json())
            .then(data => {
                // 根据删除结果显示不同的提示框
                const resultModal = document.getElementById('resultModal');
                const resultMessage = document.getElementById('resultMessage');
                const modalOverlay = document.getElementById('modalOverlay');
                if (data.success) {
                    showCustomModal("删除成功！");
                } else {
                    showCustomModal("删除失败！");
                }

                // 刷新商品列表
                fetchProducts();
            })
            .catch(error => {
                console.error('Error deleting products:', error);
                // 错误时显示提示框
                showCustomModal("删除过程中发生错误！");
            });
    }

    var modal = document.getElementById("confirmModal");
    var overlay = document.getElementById("modalOverlay");
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
                    <div class="delete-checkbox" data-id="\${product.productId}" onclick="toggleCheckbox(\${product.productId})"></div>
                    <h3>\${product.productName}</h3>
                    <p>库存:\${product.productAmount}</p>
                    <p>价格:￥\${product.productPrice}</p>
                    <button onclick="saveToLocalStorage(\${product.productId}, '\${product.productName}', \${product.productAmount}, \${product.productPrice})">点击更新</button>
                    `;
                    productList.appendChild(productModule);
                });
            })
            .catch(error => console.error('Error fetching products:', error));
    }

    //使得点击模块后跳转到的页面能够取得被点击模块的信息
    function saveToLocalStorage(productId, productName, productAmount, productPrice) {
        localStorage.setItem('productId', productId);
        localStorage.setItem('productName', productName);
        localStorage.setItem('productAmount', productAmount);
        localStorage.setItem('productPrice', productPrice);
        location.href = './product_update.jsp';
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