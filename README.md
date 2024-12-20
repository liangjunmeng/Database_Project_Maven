# Database_Project_Maven
通过maven创建javaweb项目，包括添加了maven-archetype-webapp，以及配置了tomcat（点击Edit Configuration部署tomcat，再点击Deployment里的加号进行部署）
项目思路：
账号分为管理员账号（userid为1）和用户账号（userid不为1），管理员和用户登录后进入的首页不同，管理员的首页可以对商品进行增删改查而用户不可以。

代码思路：
①
前端使用Ajax提交方式提交至Servlet处理请求和响应（Json响应），后端处理完后返回响应至前端，实现消息结果提示和页面跳转。
②
后端的业务逻辑主要有service负责，让controller层的servlet接收到的请求可以通过调用service类中的方法实现业务逻辑处理。
③
数据库的映射主要通过mapper.xml文件和mapper接口类的方法一一对应实现，而后通过mybatis配置文件连接数据库、使用配置映射器完成映射。从而使得可以通过调用java中的类实现对数据库的操作。

各层说明：
bean层：实体层，又被称为entity层
controller层：控制层，用于对前端的请求和响应进行处理
mapper层：映射层，又被成为dao层、持久层
service层：业务逻辑层
test层：测试层，用于测试和调试项目
util层：工具层，放置各种通用类和方法
resources：配置层，主要用于各种配置，如数据库连接、映射等的配置
webapp：前端层，放置各种与前端代码相关的文件，如html、jsp、js等



注意事项：
1.service层在对数据库的更新（修改、删除和插入）操作后要及时将事务提交（session.commit()），否则数据库数据无法更新，更有伸着会导致项目和ssms崩溃！
2.注意拼写问题，如html中input里的value不要写成values，后端@Param不要写成@param
3.关于里面的路径说明：
“./login”表示上级目录加上/login，如/maven/web/register.jsp里如果写了
跳转到“./login”,那就代表跳转到“/maven/web/login”;
”../login“表示上上级目录加上/login，如“/maven/login”，以此类推...
如果只是单纯地写上“login”，等同于“./login”
4.有关javascript：
①
productModule.innerHTML = `
<h3>Name:\${product.productName}</h3>
<p>Amount:\${product.productAmount}</p>
<p>Price:\${product.productPrice}</p>
<button onclick="location.href='./product_detail.jsp?id=\${product.productId}'">查看详情</button>
`;
其中的“${product.productName}”前面需要添加”\“转义符号，否则显示出来的都是空白。
理由：
在 JavaScript 中，模板字符串（template literals）允许你使用反引号 ` 来包围字符串，
并在字符串中使用 ${...} 语法来嵌入变量或表达式的值。如果你需要在模板字符串中包含一个实际
的美元符号 $，你需要对它进行转义，因为美元符号在模板字符串中有特殊的意义（它标志着变量或表
达式的开始）。
②
<script type="text/javascript" src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script> 
这行代码的作用是从外部链接加载jQuery库。如果删除了这行代码，那么页面上将不会加载jQuery库，
而脚本中使用了$（jQuery的别名）来执行操作，没有jQuery库的支持，这些操作将无法执行，因此脚
本无法正常工作。

具体来说，以下是一些依赖于jQuery的代码段：

$("#errorMessage").text(message);：这是jQuery用来设置元素文本内容的方法。
$("#errorModal").show();：这是jQuery用来显示元素的方法。
$("#loginbtn").click(function (event) {...});：这是jQuery用来绑定点击事件的方法。
$.ajax({...});：这是jQuery提供的Ajax方法，用于发送异步HTTP请求。
如果没有加载jQuery库，那么$这个符号将不会指向jQuery对象，而是保持为undefined，导致所有
使用$的代码都会抛出错误，因为它们试图调用undefined的方法或属性。

因此，为了使这段代码正常工作，你需要确保jQuery库被正确加载。如果你不想使用外部链接，你也可
以将jQuery库文件下载到你的服务器，并使用相对路径或绝对路径来引用它。
