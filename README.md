# Database_Project_Maven
通过maven创建javaweb项目，包括添加了maven-archetype-webapp，以及配置了tomcat（点击Edit Configuration部署tomcat，再点击Deployment里的加号进行部署）
项目思路：
（代办）

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
