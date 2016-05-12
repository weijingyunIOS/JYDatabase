# JYDatabase
对FMDB的轻量级封装，帮助快速创建管理移动端数据库。让SQLite使用更加简单

要实现的目标：

	1.自动处理数据库升级，让使用者不用考虑数据库升级带来烦劳。
	2.封装简单常用的查询语句，让使用者只用关注特殊的SQL查询，基本查询不用重复写直接使用即可。

一、JYDatabase 的使用
![enter image description here](http://imgdata.hoop8.com/1605/2283412352730.jpg)

	如图：是Demo中创建本地数据库的一个框图。
	BS1: JYDBService类 提供了所有对外的查询方法，数据库的增删查改都通过这个单利调用。
	BS2: JYPersonDB 是JYDBService 所包含的其中一个数据库，他管理着 该库所有表的创建和升级。
	BS3: JYPersonTable 是JYPersonDB库下的其中一张表，它管理了该表的所有 增删查改 操作。
	BS4: JYPersonInfo 是映射JYPersonTable表的列的对象。JYPersonTable表查询出来的数据都会转换成JYPersonInfo对象。
	
	
	