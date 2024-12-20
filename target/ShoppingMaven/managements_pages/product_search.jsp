<%--
  管理员的搜索界面，便于管理员删除特定的商品
--%>
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
<link rel="stylesheet" href="product_search.css">
<button id="removeButton">-</button>
<button id="backHomeButton">全部商品</button>
<!-- 搜索框 -->
<div class="search-container">
    <input type="text" id="searchInput" placeholder="请输入商品名称" />
</div>
<button id="searchButton">搜索</button>

<button id="deleteButton" disabled>删除</button>

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
    let deleteMode = false; // 控制勾选框的显示状态
    let deleteBtn = false; // 控制删除按钮的显示状态
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
        location.href = './product_management.jsp';
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
                //触发搜索按钮点击事件
                clickSearchSourceIsnotHand = true;
                document.getElementById('searchInput').value = userEnter;
                $("#searchButton").click();

            })
            .catch(error => {
                console.error('Error deleting products:', error);
                // 错误时显示提示框
                showCustomModal("删除过程中发生错误！");
            });
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
                    <div class="delete-checkbox" data-id="\${product.productId}" onclick="toggleCheckbox(\${product.productId})"></div>
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
