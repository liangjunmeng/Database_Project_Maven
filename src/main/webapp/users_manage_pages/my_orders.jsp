<%--
  订单页面（仅限用户）
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的订单</title>
</head>
<body>
<h1>欢迎来到我的订单页面</h1>
</body>
<script>
    window.onbeforeunload = function() {
        // 在标签页关闭之前清空 localStorage
        localStorage.clear();
    };
</script>
</html>
