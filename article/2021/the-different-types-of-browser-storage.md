> * 原文地址：[The Different Types of Browser Storage](https://medium.com/better-programming/the-different-types-of-browser-storage-82b918cb3cf8)
> * 原文作者：[Albin Issac](https://medium.com/@techforum)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/the-different-types-of-browser-storage.md](https://github.com/xitu/gold-miner/blob/master/article/2021/the-different-types-of-browser-storage.md)
> * 译者：[flashhu](https://github.com/flashhu)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)，[k8scat](https://github.com/k8scat)

# 不同类型的浏览器存储

![[@kundeleknabiegunie](http://twitter.com/kundeleknabiegunie) unsplash.com](https://cdn-images-1.medium.com/max/2000/0*6UmrGOz0O2pvmwHT)

现代浏览器为如何在用户浏览器中存储网站数据提供了多样的选择，允许按需查询这些数据。这使得网站所有者能长期保留数据，保存网页内容或文档供离线使用，存储用户偏好，应用状态等。

在本教程中，我们将讨论可以在用户浏览器上存储网站数据的不同类型的浏览器存储。

#### 浏览器存储的使用场景

* 个性化网站偏好
* 持久化站点活动
* 存储登录状态
* 本地保存数据和资源以便快速下载或离线使用
* 本地保存 Web 应用生成的文档供离线使用
* 提升网站性能
* 减少对后端服务器的请求

#### 浏览器存储的类型

* Cookies
* 本地存储（localStorage）
* 会话存储（sessionStorage）
* IndexedDB
* Web SQL
* 缓存存储（CacheStorage）

## Cookies

它是在客户端存储数据的传统方法，因为在 HTML5 出现前，这是浏览器存储的唯一选择。

Cookie 保存客户端的数据，为网站访问者提供个性化的体验。Cookie 在服务端生成，随响应发到客户端，每次请求都会与服务器交换数据。服务器可以根据 cookie 中的数据向用户发送个性化的内容。

Cookie 可以通过 JavaScript 中的 `document.cookie` 被创建，更新或读取。`HTTPOnly` cookie 标志可在 JavaScript 中被用于限制 cookie 访问，从而减少一些安全隐患，如被跨站脚本读取（这类 cookie 仅供服务器端访问）。

#### Cookie 属性

```
Set-Cookie: <cookie-name>=<cookie-value>
Set-Cookie: <cookie-name>=<cookie-value>; Expires=<date>
Set-Cookie: <cookie-name>=<cookie-value>; Max-Age=<non-zero-digit>
Set-Cookie: <cookie-name>=<cookie-value>; Domain=<domain-value>
Set-Cookie: <cookie-name>=<cookie-value>; Path=<path-value>
Set-Cookie: <cookie-name>=<cookie-value>; Secure
Set-Cookie: <cookie-name>=<cookie-value>; HttpOnly

Set-Cookie: <cookie-name>=<cookie-value>; SameSite=Strict
Set-Cookie: <cookie-name>=<cookie-value>; SameSite=Lax
Set-Cookie: <cookie-name>=<cookie-value>; SameSite=None; Secure

// 也可以同时提供多个属性，例如：
Set-Cookie: <cookie-name>=<cookie-value>; Domain=<domain-value>; Secure; HttpOnly
```

Cookie 可分为两类：会话期 cookie 和持久性 cookie。

**会话期 cookie**

会话期 cookie 不需要指定 `Expires` 或 `Max-Age` 属性，在浏览器关闭时会被移除。

**持久性 cookie**

持久性 cookie 指定 `Expires` 或 `Max-Age` 属性。Cookie 不会在浏览器关闭时过期，但是会在特定的日期（`Expires`）或时间长度（`Max-Age`）过期。

通过在 cookie 头部中设置 `domain` 选项，某个域中的 cookie 可以访问其他子域。

```
Set-Cookie: test=test-value; Domain=example.com - cookie 可用于 example.com 及子域
```

#### Cookie 的局限性

* 只能存储 4 KB 的数据，具体限制取决于浏览器
* 一个域下的 cookie 数量有限制，具体取决于浏览器（如 20 个）
* 跨域 cookie 的总数有限制，具体取决于浏览器（如 300 个）。一旦达到限制数量，为存储新的 cookie，最老的 cookie 将被移除。
* Cookie 数据在每次请求时都被会发到服务器。这将消耗额外的带宽并影响性能。
* 可能被第三方读取数据（如第三方 cookie）

Cookie 会导致多种安全问题，因此现在建议尽可能使用现代化存储 API。

## Web Storage API

Web Storage API 允许 Web 应用在用户浏览器中本地存储数据。 这个 API 已作为 HTML5 标准的一部分。

相比 cookie，这类存储的限制更多 —— 比如, 至少 5 MB（实际大小取决于浏览器）。这些信息只在客户端，不会和服务器共享。服务器没有任何访问权限来修改数据。

数据不能在域之间共享，包括子域。每个源（协议或域的组合）都将有唯一的存储空间 —— 所有 API 操作都在源对应的存储空间中执行。

为了在用户浏览器中存储数据，Web Storage API 提供了两个不同的对象：`sessionStorage` 和 `localStorage`。

#### localStorage

`localStorage` 对象存储没有过期日期的数据。这些数据在浏览器关闭时不会被删除，而且在之后的几天、几周、几年内均可用直到被网站或用户删除。

#### sessionStorage

`sessionStorage` 对象除只存储一个对话的数据外，与 `localStorage` 对象一致。 当用户关闭特定的浏览器标签页时，对应的数据会被删除。

Web Storage API 以键/值对形式存储数据。所有数据都存储为字符串，所有被添加到存储空间中的数据会被隐式转换为字符串类型。在查询数据时，它将类型显式转换为所需类型。`JSON.parse()` 和 `JSON.stringify()` 方法可用于序列化和反序列化对象数据。

```HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>Browser Storage Demos - Web Storage API </title>	
		
		<script type = "text/javascript">
		
			// 检查浏览器支持情况
			if (typeof(Storage) !== "undefined") {
   
				 function addToStorage()
				 {
				     // 通过以下任一形式将数据添加至本地存储
				     localStorage.setItem("testlocal", "test Local Data");
				     //localStorage.testlocal= "test Local Data";
				   
				      // 通过以下任一形式将数据添加至会话存储
				      sessionStorage.setItem("testsession", "test Session Data");
				      //sessionStorage.testsession=  "test Session Data";
				   
                                      // 添加 JSON 对象到存储
				      var testObject = { 'test1': 1, 'test2': 2, 'test3': 3 };
				      localStorage.setItem('testObject', JSON.stringify(testObject));
				 }
 
				 function removeFromStorage()
				 {
				      // 从本地存储中移除某键/值对
				      localStorage.removeItem("testlocal");
				  
                                      // 清空存储
				      //localStorage.clear();
  
				      // 从会话存储中删除某键/值对
				      sessionStorage.removeItem("testsession");
				      //sessionStorage.clear();
				 }
 
				 function readDataFromStrage()
				 {
  
				      // 从本地存储中读取数据
				      document.getElementById("data").innerHTML= "Local Storage Data.."+localStorage.getItem("testlocal")+"<br />";
				 
                                      // 从会话存储中读取数据
				      document.getElementById("data").innerHTML+="Session Storage Data.."+sessionStorage.getItem("testsession")+"<br />";
				  
                                      // 从存储中获取 JSON 数据
				      var retrievedObject = localStorage.getItem('testObject');
				      document.getElementById("data").innerHTML+="JSON Data From Storage: "+JSON.stringify(retrievedObject);
				 }
			} else {
			 console.log("No Web Storage support..");  
			}
		</script>			
	</head>
	<body>
		Welcome to Browser Storage Demos - Web Storage API	<br/> 

		<p id="data"></p>
                <button onclick = "readDataFromStrage()">Read</button>
                <button onclick = "addToStorage()">Add data </button>
                <button onclick = "removeFromStorage()">Delete data </button>
	</body>
</html> 
```

Web Storage API 的调用是同步的，因此它们可能会影响 UI 渲染。也因为如此，我们仅应该使用 Web Storage API 存储和查询少量数据。在用户浏览器上使用 Web Storage API 存储及查询数据是便捷的 —— 所有现代浏览器都支持 Web Storage API。

---

## IndexedDB 存储

IndexedDB 是一个基于 JavaScript 的面向对象数据库。IndexedDB 允许你存储和查询键（主键，如 SSN）索引的对象。任何结构化克隆算法支持的对象（如：视频、图片）都可以被存储。IndexedDB 的使用比 Web Storage API 复杂得多。

IndexedDB 是一种在用户浏览器中持久化存储大量数据的方法。IndexedDB 允许你创建具有不用关心网络可用性这一高级功能的 Web 应用。这些应用在线、离线都可以工作。IndexedDB 对需要存储大量数据的应用及工作时不要求网络持续连通的应用而言非常有用。

IndexedDB API 是异步的，不会阻塞 UI 渲染。这个 API 使用索引以支持对数据的高性能搜索。

创建数据库模式及对象，打开数据库连接，然后在一系列事务中查询和更新数据。IndexedDB 允许存储大量结构化数据。具体大小取决于浏览器。

数据库对源（域/协议/端口）是私有的，因此任何网站不能访问其他网站的 IndexedDB 存储。

```HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>Browser Storage Demos - IndexDB API </title>		
		
		
		<script type = "text/javascript">
		
			// 检查浏览器支持情况
			if (window.indexedDB) {		    
			
				// 示例数据
				const customerData = [{ ssn: "444-44-4444", name: "test1", age: 35, email: "test1@company.com" },
									  { ssn: "555-55-5555", name: "test2", age: 32, email: "test2@home.org" }];
				const dbName = "testDB";
				var db;
				// 打开数据库，如果数据库不存在，则创建数据库
				// 指定数据库名称和版本，如果需要修改数据库结构，则更新版本号
				var request = indexedDB.open(dbName, 2);

				// 错误处理程序
				request.onerror = function(event) {
					console.log("error: ");
				};
				
				// 成功处理程序
				request.onsuccess = function(event) {
					db = request.result;
					console.log("success: "+ db);
				};

				// 成功打开数据库时调用处理程序
				// 如果版本不同，则更新已有数据库对象或创建对象
				request.onupgradeneeded = function(event) {
					var db = event.target.result;

					// 设置键生成器（autoIncrement: true），默认不开启
					// 使用主键创建 object store
					var objectStore = db.createObjectStore("customers", { keyPath: "ssn" });
					
					// 定义需要的索引
					objectStore.createIndex("name", "name", { unique: false });
					objectStore.createIndex("email", "email", { unique: true });
					
					// 向对象添加数据
					customerData.forEach(function(customer) {
							objectStore.add(customer);
					});
					
				};
				
				function add() {
				
					// 查询特定对象的事务，指定模式 - 只读，读写和版本变更
					var transaction = db.transaction(["customers"], "readwrite");
					
					// 当所有数据添加到数据库时调用处理程序
					transaction.oncomplete = function(event) {
						console.log("Add Completed!");
					};

					// 错误处理程序
					transaction.onerror = function(event) {
						
					};
					
					const customerDataNew = [{ ssn: "777-77-7777", name: "Test3", age: 32, email: "test3@home.org" }];
					
					// 添加新的客户数据到 store 中
					var objectStore = transaction.objectStore("customers");
					customerDataNew.forEach(function(customer) {
						var request = objectStore.add(customer);
						request.onsuccess = function(event) {
							console.log("Data Added..."+event.target.result);
						};
					});
				}
				
				
				// 通过主键和 delete 方法从 store 中删除数据
				function deleteData()
				{
					var request = db.transaction(["customers"], "readwrite")
									.objectStore("customers")
									.delete("777-77-7777");
					request.onsuccess = function(event) {
					console.log("Record Deleted!");
					};
				}
				
				// 通过主键和 get 方法从 store 中读取数据
				function read()
				{
					var transaction = db.transaction(["customers"]);
					var objectStore = transaction.objectStore("customers");
					var request = objectStore.get("444-44-4444");
					request.onerror = function(event) {
						// 处理错误!
					};
					request.onsuccess = function(event) {
						document.getElementById("data").innerHTML = "Name for SSN 444-44-4444 is " + request.result.name;
					};
				}


				// 通过游标从 store 中读取所有数据
				function readAll()
				{
				
					var objectStore = db.transaction("customers").objectStore("customers");
					
					console.log(db.transaction("customers"));
					console.log(objectStore);
					document.getElementById("data").innerHTML="";

					objectStore.openCursor().onsuccess = function(event) {
					var cursor = event.target.result;
						
						// 迭代游标
                        if (cursor) {
							document.getElementById("data").innerHTML+="SSN: " + cursor.key + " Name: " + cursor.value.name +" Age: " + cursor.value.age+"<br />";
							cursor.continue();
						}
						else {
							console.log("No more entries!");
						}
					};
				}
				
				// 通过主键和 put 方法更新已有数据
				function update()
				{

					var objectStore = db.transaction(["customers"], "readwrite").objectStore("customers");
					var request = objectStore.get("444-44-4444");
					request.onerror = function(event) {
					  
					};
					request.onsuccess = function(event) {
					 
                                         // 获取当前数据				 
					 var data = event.target.result;

					  // 更新值
					  data.age = 42;

					  // 存储更新后的对象
					  var requestUpdate = objectStore.put(data);
					   requestUpdate.onerror = function(event) {
						 // 错误
					   };
					   requestUpdate.onsuccess = function(event) {
						 console.log("Success - the data is updated!");
					   };
					};	
				}				

			
			} else {
				console.log("No IndexDB support..");		
			}	
			
		</script>
		
		
	</head>
	<body>
		Welcome to Browser Storage Demos - IndexDB API	<br/>
		
		<p id="data"></p>
                <button onclick = "read()">Read </button>
                <button onclick = "readAll()">Read all </button>
                <button onclick = "add()">Add data </button>
                <button onclick = "deleteData()">Delete data </button>
		<button onclick = "update()">Update data </button>
	
	</body>
</html>
```

## Web SQL 数据库

> “Web SQL 数据库是一个用于将数据存储在数据库中的 Web API，这些数据库可以使用 SQL 的变体进行查询。” —— [维基百科](https://en.wikipedia.org/wiki/Web_SQL_Database)

该规范基于 SQLite。Web SQL 数据库未被所有浏览器支持 —— 该标准已被 W3C 否决，IndexedDB 应该会成为替代品。

尽管如此，它仍可以在支持的浏览器中使用，如 Safari，Chrome，Opera 及 Edge。

```HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>Browser Storage Demos - Web SQL API </title>	
		
		<script type = "text/javascript">
		
			// 检查浏览器支持情况
			if (window.openDatabase) {
			  
				var db;
				 
				function createDBAndTable()
				{
					// 打开数据库，如果不存在，则创建数据库 - 数据库名称，版本，描述和所需存储空间
					db = window.openDatabase('test_db', '1.0', 'Test DB', 1024*1024)
					// 事务
					db.transaction(function (tx) {
						// 删除已有的表
						tx.executeSql('DROP TABLE IF EXISTS CUSTOMERS');				
						// 包含必填字段创建新表，定义主键
						tx.executeSql('CREATE TABLE IF NOT EXISTS CUSTOMERS(SSN TEXT PRIMARY KEY , NAME TEXT,AGE INTEGER ,EMAIL TEXT)', [], function(tx, result) {
							console.log(result);
							console.log('Table created Successfully!');

						}, errorHandler);
					});
				}
				
				function insertData()
				{
					db.transaction(function (tx) { 										
						 // 在表中插入数据，可使用动态变量
						 tx.executeSql('INSERT INTO CUSTOMERS(SSN, NAME,AGE,EMAIL) VALUES (?,?,?,?)',["444-44-4444","Bill",35,"bill@company.com"], function(tx,result) {					 
							console.log("Record Inserted Successfully "+result.insertId );    
						},errorHandler);
							
						 tx.executeSql('INSERT INTO CUSTOMERS(SSN, NAME,AGE,EMAIL) VALUES (?,?,?,?)',["555-55-5555","Test1",32,"test1@company.com"], function(tx,result) {
						 
							console.log("Record Inserted Successfully "+result.insertId);
		
						},errorHandler);
					});

				}
				
				function readDataFromDB()
				{
					
					db.readTransaction(function (tx) { 			
					// 从表中读取数据并遍历行对象
					tx.executeSql('SELECT * FROM CUSTOMERS', [], function (tx, results) { 
						var len = results.rows.length, i; 
						document.getElementById("data").innerHTML="";
						for (i = 0; i < len; i++) { 
						 document.getElementById("data").innerHTML+=" SSN: " +results.rows.item(i).SSN+ " Name: "+results.rows.item(i).NAME+" Age: "+results.rows.item(i).AGE+"<br />"; 
						} 
				  
						},errorHandler);
					});

				}	

				function updateData()
				{
					db.transaction(function (tx) { 										
						 // 更新已有数据
						 tx.executeSql('UPDATE CUSTOMERS SET AGE=? WHERE SSN=?',[45,"444-44-4444"], function(tx,result) {					 
							console.log("Record Updated Successfully" +result);    
						},errorHandler);				
						
					});

				}

				function deleteData()
				{
					db.transaction(function (tx) { 										
						 // 通过主键删除数据
						 tx.executeSql('DELETE FROM CUSTOMERS WHERE SSN=?',["444-44-4444"], function(tx,result) {					 
							console.log("Record Deleted Successfully" +result);    
						},errorHandler);					
						
					});

				}	

				function errorHandler(transaction, error) {
					console.log('Oops. Error was '+error.message+' (Code '+error.code+')');			
					return false;
				}			

				
			} else {
				console.log("No Web SQL API support..");		
			}	
		</script>			
	</head>
	<body>
		Welcome to Browser Storage Demos - Web SQL API	<br/> 

		<p id="data"></p>
                <button onclick = "createDBAndTable()">Create DB/Table</button>
                <button onclick = "insertData()">Insert data </button>
                <button onclick = "readDataFromDB()">Read data </button>
		<button onclick = "updateData()">Update data </button>
		<button onclick = "deleteData()">Delete data </button>
	</body>
</html>
```

## CacheStorage

> “CacheStorage 是一种浏览器中的存储机制，用于存储和查询网络请求和响应。它存储一对 Request 和 Response 对象，Request 作为键，Response 作为值。”
>
> —— [Chidume Nnamdi](undefined) 的 [Bits and Pieces](https://blog.bitsrc.io/introduction-to-the-cache-storage-a-new-browser-cache-pwa-api-a5d7426a2456) 专栏

CacheStorage API 可以在 Window 上下文（DOM 上下文）中使用，也可以和 Service Worker API 一起使用以实现离线访问。在本教程中，我们将更多地讨论 DOM 上下文。

CacheStorage 用于在网站中存储网络请求和响应，也可以作为存储工具。例如，我们可以存储个性化数据（如用户偏好）在缓存中，按需查询这些数据。`put` 方法可用于将个性化响应对象存储在缓存存储中。

CacheStorage API 允许我们从跨域网站获取和缓存数据。CacheStorage API 是异步的，不会阻塞 UI 渲染。CacheStorage 选项是最新加入浏览器存储的，有些浏览器仍未支持。

```HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>Browser Storage Demos - Cache Storage API </title>	
		
		<script type = "text/javascript">
		
				// 检查浏览器支持情况
				if('caches' in window) {
				
					function add()
					{
						// 打开缓存存储，如果不存在，则新建
						caches.open('data_cache').then((cache) => {
							
							// 从源服务器获取 data.json，添加响应到缓存存储中
							// 允许跨域响应缓存 —— 指定完整的请求 URL
							// Request 对象作为键
							cache.add(new Request('/data.json'));

							var data={foo: "bar"};					
							
							// 在缓存前将其他头选项加入响应对象
							const jsonResponse = new Response(JSON.stringify(data), {
								  headers: {
									'content-type': 'application/json'
								  }
							});

							// 将自定义 JSON 数据加入缓存存储
							cache.put('/custom.json', jsonResponse);				

						}).catch((err) => {
							console.log(err);
						});
					}	

					// 将多个 URL 加入缓存 —— 浏览器从源获取数据
					function addAll()
					{
						caches.open('data_cache').then((cache) => {				
							const urls = ['/data1.json', '/data2.json','/data3.json'];
							cache.addAll(urls);	
						}).catch((err) => {
							console.log(err);
						});
					}				
					
					
					// 检查缓存存储状态
					function checkCacheStatus()
					{
						caches.has('data_cache').then((bool) => {
						
						 document.getElementById("data").innerHTML = "Cache data_cache is available: " + bool+"<br />";

						}).catch((err) => {
						}) 
						
						caches.has('teat_cache').then((bool) => {
						
						 document.getElementById("data").innerHTML += "Cache test_cache is available: " + bool;

						}).catch((err) => {
						}) 
					
					}
					
					// 删除缓存存储
					function deleteCache()
					{		
							caches.delete('data_cache').then((bool) => {			
							document.getElementById("data").innerHTML = "Cache data_cache is deleted";
						}).catch((err) => {
						})		
					}
					
					// 通过缓存键（请求 URL 或对象）从缓存中删除指定对象
					function deleteCacheObject()
					{		
							caches.open('data_cache').then((cache) => {
							
							cache.delete('custom.json');							

						}).catch((err) => {
							console.log(err);
						});	
					}
					
					// 从缓存存储中获取所有缓存键
					function getAllKeys()
					{		
							caches.open('data_cache').then((cache) => {
							
							document.getElementById("data").innerHTML = "";
							cache.keys().then(function(keys) {				
								keys.forEach(function(key) {
										document.getElementById("data").innerHTML += key.url+"<br />";	
								});					
							});
										

						}).catch((err) => {
							console.log(err);
						});	
					}
					
					// 从缓存存储中获取缓存数据
					function getCacheData()
					{	
						caches.open('data_cache').then((cache) => {
						document.getElementById("data").innerHTML = "";			
								cache.match('custom.json').then((response)=> {
								response.json().then(data => {
									document.getElementById("data").innerHTML = JSON.stringify(data);
								});
									
								})							

						}).catch((err) => {
							console.log(err);
						});	
					}				
				
			} else {
					console.log("No Cache Storage API support..");		
			}		

		</script>			
	</head>
	<body>
		Welcome to Browser Storage Demos - Cache Storage API	<br/> 

		<p id="data"></p>
                <button onclick = "add()">Add to Cache </button> 
		<button onclick = "addAll()">Add All</button> 
		<button onclick = "checkCacheStatus()">Cache Status </button>
		<button onclick = "deleteCache()">Delete Cache </button> 
		<button onclick = "deleteCacheObject()">Delete Cache Object</button> 	
		<button onclick = "getAllKeys()">Get All Keys</button>
		<button onclick = "getCacheData()">Get Cache Data</button> 	 		
	</body>
</html>
```



相关演示参见[浏览器存储演示](https://github.com/techforum-repo/youttubedata/tree/master/browser-storage-demos)（这个演示是在 Node.js 上使用 Express.js 构建的）。

在用户浏览器上存储数据有多样的选择 —— 根据你的使用场景进行选择。

你可以选择使用 CacheStorage API 存储供离线访问的数据，而在存储大量应用或用户生成的数据的情况下，IndexedDB 是更好的选择。当然，Cookie 仍可以用于存储用于服务器识别的小型数据。

本地存储（localStorage）和会话存储（sessionStorage）则可用于存储少量数据。本地存储和会话存储的 API 是同步的，因此它们会影响 UI 渲染。但与此同时，它们这两个 API 易于在项目中使用。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
