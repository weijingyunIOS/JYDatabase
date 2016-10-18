# JYDatabase
对FMDB的轻量级封装，帮助快速创建管理移动端数据库。让SQLite使用更加简单,记得给小星星哦。

要实现的目标：

	1.自动处理数据库升级，让使用者不用考虑数据库升级带来烦劳。
	2.封装简单常用的查询语句，让使用者只用关注特殊的SQL查询，基本查询不用重复写直接使用即可。

已支持 CocoaPods
	
	pod 'JYDataBase'
	
一、JYDatabase 的使用
![enter image description here](http://i.niupic.com/images/2016/09/18/CG4mV3.jpg)

	如图：是Demo中创建本地数据库的一个框图。
	BS1: JYDBService类 提供了所有对外的查询方法，数据库的增删查改都通过这个单例调用。
	BS2: JYPersonDB 是JYDBService 所包含的其中一个数据库，他管理着 该库所有表的创建和升级。
	BS3: JYPersonTable 是JYPersonDB库下的其中一张表，它管理了该表的所有 增删查改 操作。
	BS4: JYPersonInfo 是映射JYPersonTable表的列的对象。JYPersonTable表查询出来的数据都会转换成JYPersonInfo对象。
	注意：个人建议不要在项目中建多个数据库，建一个数据库，多张表即可。

1.1 JYPersonTable建立（数据表）
	
	数据表的建立需要继承 JYContentTable(该类实现了工作中用到的大部分SQL查询)，只要重写以下几个方法就可以快速创建一张数据表。
	
	  // 必须实现 contentClass 是该表所对应的模型类，tableName 是表的名字
	  - (void)configTableName{             
         self.contentClass = [JYPersonInfo class];
         self.tableName = @"JYPersonTable";
      }
      
	  // 必须实现 contentId 是该表的主键（也是唯一索引）比如用户的userId 必须是 contentClass 的属性
      - (NSString *)contentId{
          return @"personnumber";
      }

	  // 数据表的其他字段，必须是 contentClass 的属性，如不实现则默认取 contentClass 以“DB”结尾 的属性
      - (NSArray<NSString *> *)getContentField{
          return @[@"mutableString1",@"integer1",@"uInteger1",@"int1",@"bool1",@"double1"];
      }

	  // 表创建时对应字段的默认长度，如不写，取默认。
      - (NSDictionary*)fieldLenght{
      	  return @[@"mutableString1":@"512"];
      }
      
      // 查询是否使用NSCache缓存，默认YES。
      - (BOOL)enableCache{
          return NO;
      }
      
      注意：1.数据表映射的属性仅仅支持 NSString  NSMutableString  NSInteger NSUInteger int BOOL double float NSData 的数据类型
      其在数据表中对应的是@"BOOL",@"DOUBLE",@"FLOAT",@"INTEGER",@"INTEGER",@"INTEGER",@"VARCHAR",@"VARCHAR",@"BLOB"
      默认的数据长度是   @"1"   ,@"10"    ,@"10"   ,@"10"     ,@"10"     ,@"10"     ,@"128"    ,@"128"    ,@"256"
      
      2.NSCache的默认缓存条数是20条，可自行设置修改self.cache.countLimit = 20; 使用enableCache 将优先从缓存中取数据
      如自行实现的查询请在适当情况下使用以下三个方法来加入缓存。方法内部有 enableCache 的实现。
      - (id)getCacheContentID:(NSString *)aID;
	  - (void)saveCacheContent:(id)aContent;
	  - (void)removeCacheContentID:(NSString *)aID;
      
  1.2 JYPersonDB管理了数据库的创建和升级 需要继承JYDataBase

	关键方法：
	// 该方法会根据当前版本判断 是创建数据库表还是 数据表升级
	- (void)buildWithPath:(NSString *)aPath mode:(ArtDatabaseMode)aMode;
	
	// 返回当前数据库版本，只要数据表有修改 返回版本号请 ＋1 默认返回 1
	- (NSInteger)getCurrentDBVersion{
	    return 4;
	}
	
	// 所有数据表的创建请在该方法实现  调用固定方法 - (void)createTable:(FMDatabase *)aDB;
	- (void)createAllTable:(FMDatabase *)aDB{
	    [self.personTable createTable:aDB];
	}
	
	// 所有数据表的升级请在该方法实现  调用固定方法 - (void)insertDefaultData:(FMDatabase *)aDb;
	- (void)updateDB:(FMDatabase *)aDB{
	    [self.personTable updateDB:aDB];
	}

  1.3 JYDBService
  
  	这是一个单例，向外提供数据库的一切外部接口，具体实现大家可以看Demo。
  	
  	
 二、内部部分代码的实现讲解
 
 2.1 数据库升级的实现 - (void)updateDB:(FMDatabase *)aDB 
 
 	对于每一张表，所谓的修改无非是 添加了一个 新的字段 或减少了几个字段（这种情况很少）。
 	2.2.1 字段的对比
 		PRAGMA table_info([tableName]) 可以获取一张表的所有字段
 		再与当前需要的字段做对比即可得到要增加的字段和减少的字段
 	2.2.2 字段的添加
 		sqlite有提供对应的SQL语句实现
 		ALTER TABLE tableName ADD 字段 type(lenght)
 	2.2.3 减少字段
 		sqlite并未提供对应的SQL语句实现但可通过以下方法实现
 		a.根据原表新建一个表
 		sql = [NSString stringWithFormat:@"create table %@ as select %@%@ from %@", tempTableName,[self contentId],tableField,self.tableName];
 		b.删除原表
 		sql = [NSString stringWithFormat:@"drop table if exists %@", self.tableName];
 		c.将表改名
 		sql = [NSString stringWithFormat:@"alter table %@ rename to %@",tempTableName ,self.tableName];
 		d.为新表添加唯一索引
 		sql = [NSString stringWithFormat:@"create unique index '%@_key' on  %@(%@)", self.tableName,self.tableName,[self contentId]];
  	
 2.2 FMDB部分方法说明
 	
 	- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;
	- (void)inDatabase:(void (^)(FMDatabase *db))block;
 	以上 两个方法都是开启了事务操作的
 	- (BOOL)rollback {
    BOOL b = [self executeUpdate:@"rollback transaction"];
    
    if (b) {
        _inTransaction = NO;
    }
    
    return b;
	}
	
	- (BOOL)commit {
	    BOOL b =  [self executeUpdate:@"commit transaction"];
	    
	    if (b) {
	        _inTransaction = NO;
	    }
	    
	    return b;
	}
	
	- (BOOL)beginDeferredTransaction {
	    
	    BOOL b = [self executeUpdate:@"begin deferred transaction"];
	    if (b) {
	        _inTransaction = YES;
	    }
	    
	    return b;
	}
	
	- (BOOL)beginTransaction {
	    
	    BOOL b = [self executeUpdate:@"begin exclusive transaction"];
	    if (b) {
	        _inTransaction = YES;
	    }
	    
	    return b;
	}
	
	- (BOOL)inTransaction {
	    return _inTransaction;
	}
	在数据库的创建 升级 以及 多数据的插入，我都使用了该方法。
	
2.3 条件查询的实现
	
	关于复杂查询我提供了一个简单的方法 
	- (NSArray *)getContentByConditions:(void (^)(JYQueryConditions *make))block;
	可以看下它的使用
	NSArray*infos = [[JYDBService shared] getPersonInfoByConditions:^(JYQueryConditions *make) {
        make.field(@"personnumber").greaterThanOrEqualTo(@"12345620");
        make.field(@"bool1").equalTo(@"1");
        make.field(@"personnumber").lessTo(@"12345630");
        make.asc(@"bool1").desc(@"int1");
    }];
    其实它不过产生了如下一条查询语句：
    SELECT * FROM JYPersonTable WHERE personnumber >= 12345620 AND bool1 = 1 AND personnumber < 12345630  order by  bool1 asc , int1 desc 
    
    make.field(@"personnumber").greaterThanOrEqualTo(@"12345620"); 就代表了 personnumber >= 12345620
    
    实现实际相当简单，先用 JYQueryConditions 记录下所描描述的参数，最后再拼接出完整的sql语句。
    至于通过点语法的链式调用则参考了 Masonry 的声明方式
    - (JYQueryConditions * (^)(NSString *compare))equalTo;
    - (JYQueryConditions * (^)(NSString *field))field{
    return ^id(NSString *field) {
        NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
        dicM[kField] = field;
        [self.conditions addObject:dicM];
        return self;
    };
}
	
三、提供的查询方法
#pragma mark - 索引添加
- (void)addUniques:(NSArray<NSString *>*)indexs; // 默认添加 非唯一索引
- (void)addDB:(FMDatabase *)aDB uniques:(NSArray<NSString *>*)indexs; 
- (void)addDB:(FMDatabase *)aDB type:(EJYDataBaseIndex)aType uniques:(NSArray<NSString *>*)indexs;

#pragma mark - insert 插入
- (void)insertDB:(FMDatabase *)aDB contents:(NSArray *)aContents;
- (void)insertContent:(id)aContent;
- (void)insertContents:(NSArray *)aContents;

#pragma mark - get 查询
- (NSArray *)getContentDB:(FMDatabase *)aDB byconditions:(void (^)(JYQueryConditions *make))block;
- (NSArray *)getDB:(FMDatabase *)aDB contentByIDs:(NSArray<NSString*>*)aIDs;
- (NSArray *)getContentByConditions:(void (^)(JYQueryConditions *make))block;
- (NSArray *)getContentByIDs:(NSArray<NSString*>*)aIDs;
- (id)getContentByID:(NSString*)aID;
- (NSArray *)getAllContent;

#pragma mark - delete 删除
- (void)deleteContentDB:(FMDatabase *)aDB byconditions:(void (^)(JYQueryConditions *make))block;
- (void)deleteDB:(FMDatabase *)aDB contentByIDs:(NSArray<NSString*>*)aIDs;
- (void)deleteContentByConditions:(void (^)(JYQueryConditions *make))block;
- (void)deleteContentByID:(NSString *)aID;
- (void)deleteContentByIDs:(NSArray<NSString *>*)aIDs;
- (void)deleteAllContent;
- (void)cleanContentBefore:(NSDate*)date;

#pragma mark - getCount
- (NSInteger)getCountContentDB:(FMDatabase *)aDB byconditions:(void (^)(JYQueryConditions *make))block;
- (NSInteger)getCountByConditions:(void (^)(JYQueryConditions *make))block;
- (NSInteger)getAllCount;

	
四、工具的推荐
	
	在移动端使用SqLite，个人建议安装 火狐浏览器 的一个插件 SQLite Manager 多的就不说了。
	
五、版本记录

 tag - 1.0.6  谈下在移动端，数据库关于不同用户的区分问题

		移动端缓存有个必须要注意的问题，那就是用户区分，要不把用户A的缓存数据显示到了用户B上
	就比较尴尬了。一般来说有两种方法：
	1.在每张表添加一个字段 userId 用于用户区分。在查询时要添加userId做为查询条件，插入时也要设置当前的userId。 
	2.为每个用户创建一个数据库。
	综合比较的话：方案一：优点是，可以为数据库的每一张表定义是否区分用户，缺点是，要多维护一个字段得不尝失。故而选择方案二。
	
	方案二的使用：
		通过监听userId的改变重新绑定数据库。self.documentDirectory 使用懒加载生成与userId有关的 地址。
	  - (void)construct{
		    NSLog(@"%@",self.documentDirectory);
		    [self buildWithPath:self.documentDirectory mode:ArtDatabaseModeWrite registTable:^{
		        //注册数据表 建议外引出来，用于其它位置调用封装
		        self.personTable = (JYPersonTable *)[self registTableClass:[JYPersonTable class]];
		        self.test1Table = (JYTest1Table *)[self registTableClass:[JYTest1Table class]];
		    }];
		    
		    @weakify(self)
		    [RACObserve([ArtUserConfig shared], userId) subscribeNext:^(id x) {
		        @strongify(self)
		        self.documentDirectory = nil;
		        [self construct];
		    }];
	}
		这种使用方式本身是没有问题的，但在实际的业务使用场景可能照成一些问题，比如在使用用户数据存储时，我将用
	户数据存入用户数据库，在程序中只传递userId 在需要使用时才从 数据库中读取。这时如果退出登录，此时访问的
	数据库就不是插入的数据库，那么就取不到数据。
		如何解决上述问题，我的建议是 建立 两种数据库，一种是公用数据库(该库不区分用户)，还有一种是 独立数据
	(每个用户都建一个)。对于社交应用，缓存用户信息的表放倒 公用数据库 即可。
	
1.本版本主要修改了查询方法的使用，以及数据建立方法更为简便，不用用户写大量无用代码，具体可见JYPersonDB。

2.OC属性字段与sqlite属性字段的映射是依赖与 JYDataBaseConfig 里 NSDictionary * jy_correspondingDic()的静态方法，但是在实际使用中可能无法全部覆盖，触发断言，大家遇到后可以自己设置 corresponding 属性添加额外的映射。

3.宗旨就是让数据库的使用变的简单，后期会根据我所遇到的一些业务场景进行持续更新。
 

  	
      
      