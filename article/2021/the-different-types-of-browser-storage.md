> * 原文地址：[The Different Types of Browser Storage](https://medium.com/better-programming/the-different-types-of-browser-storage-82b918cb3cf8)
> * 原文作者：[Albin Issac](https://medium.com/@techforum)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/the-different-types-of-browser-storage.md](https://github.com/xitu/gold-miner/blob/master/article/2021/the-different-types-of-browser-storage.md)
> * 译者：
> * 校对者：

# The Different Types of Browser Storage

![[@kundeleknabiegunie](http://twitter.com/kundeleknabiegunie) unsplash.com](https://cdn-images-1.medium.com/max/2000/0*6UmrGOz0O2pvmwHT)

Modern web browsers offer different options for storing website data on users’ browsers, allowing this data to be retrieved based on the need. This enables website owners to persist the data for long-term storage, save website content or documents for offline use, store user preferences, apply states, and more.

In this tutorial, let’s discuss the different types of browser storage available for storing website data on a user’s browser.

#### Uses cases for browser storage

* Personalizing site preferences
* Persisting site activities
* Storing the login state
* Saving data and assets locally so a site will be quicker to download or usable without a network connection
* Saving web application–generated documents locally for use offline
* Improving website performance
* Reducing requests to back-end servers

#### Types of browser storage

* Cookies
* Local storage
* Session storage
* IndexedDB
* Web SQL
* Cache storage

## Cookies

This is the legacy approach for storing data on the client machine — this was the only option pre-HTML5 web storage.

Cookies store client-side data to enable a personalized experience for the website’s visitors. Cookies are created on the server and are sent to the client on response, and the data is exchanged with the server on every request. The servers can use cookie data to send personalized content to users.

The cookies can be also created, updated, or read through JavaScript: `document.cookie`. The `HTTPOnly` cookie flag can be used to restrict the cookie access in JavaScript to mitigate some of the security issues — e.g., cross-site scripting (the cookies are only available for servers to access).

#### Cookie attributes

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

// Multiple attributes are also possible, for example:
Set-Cookie: <cookie-name>=<cookie-value>; Domain=<domain-value>; Secure; HttpOnly
```

There are two types of cookies: session cookies and persistent cookies.

**Session cookies**

Session cookies don’t specify the `Expires` or `Max-Age` attributes and are removed when the browser is closed.

**Persistent cookies**

Persistent cookies specify the `Expires` or `Max-Age` attributes. The cookies won’t be expired on closing the browser but will expire at a specific date (`Expires`) or length of time (`Max-Age`).

The cookies set on one domain are accessible to other subdomains based on the domain setting in the cookie header.

```
Set-Cookie: test=test-value; Domain=example.com - the cookie is available for example.com and sub domains
```

#### Restriction for the cookies

* Can only store 4 KB of data — this limit will vary a little based on the browser implementation
* The number of cookies allowed on a domain is restricted based on the browser implementation (e.g., 20)
* The total number of cookies across domains is restricted (e.g., 300 ). The oldest cookie is removed once the limit has been reached in order to store the new cookie. The number is based on the browser implementation.
* Cookie data is sent to the server on every request. This will consume the additional bandwidth and impact the performance.
* Sharing data with third parties is allowed (e.g., third-party cookies)

Cookies lead to multiple security issues, so it’s now recommended to use modern storage APIs wherever possible.

## Web Storage API

Web Storage API allows web applications to store data locally within the user browsers. The APIs are enabled as part of the HTML5 standards.

Compared to cookies, the storage limit is larger — e.g., at least 5 MB (the actual size is based on the browser implementation). The information is client-side only and not shared to the server. The server won’t have any access to modify the data.E

The data can’t be shared between domains, including subdomains. Each origin (protocol and domain combination) will have unique storage — all of the API operations are performed in the origin-specific storage.

Web Storage API provides two different objects for storing data on the users’ browsers: `sessionStorage` and `localStorage`.

#### localStorage

The `localStorage` object stores the data with no expiration date. The data won’t be deleted when the browser is closed and will be available in the next day, week, or year — until deleted by the website or by the user.

#### sessionStorage

The `sessionStorage` object is equal to the `localStorage` object except it stores the data for only one session. The data is deleted when the user closes the specific browser tab.

The Web Storage API stores the data as key/value pairs. All of the data is stored as a string, while all of the data added into the storage implicitly is converted into a string. It explicitly converts the data to the required type on retrieval. The `JSON.parse()` and `JSON.stringify()` methods can be used for serialization and deserialization of object data from/to storage.

```HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>Browser Storage Demos - Web Storage API </title>	
		
		<script type = "text/javascript">
		
			//Check for browser support
			if (typeof(Storage) !== "undefined") {
   
				 function addToStorage()
				 {
				     //add data to the local storage by either one of the below option
				     localStorage.setItem("testlocal", "test Local Data");
				     //localStorage.testlocal= "test Local Data";
				   
				      //add data to the session storage by either one of the below option
				      sessionStorage.setItem("testsession", "test Session Data");
				      //sessionStorage.testsession=  "test Session Data";
				   
                                      //Add JSON object to the storage
				      var testObject = { 'test1': 1, 'test2': 2, 'test3': 3 };
				      localStorage.setItem('testObject', JSON.stringify(testObject));
				 }
 
				 function removeFromStorage()
				 {
				      //Remove item from local storage
				      localStorage.removeItem("testlocal");
				  
                                      //Clear the storage
				      //localStorage.clear();
  
				      //Remove item from session storage
				      sessionStorage.removeItem("testsession");
				      //sessionStorage.clear();
				 }
 
				 function readDataFromStrage()
				 {
  
				      //Read data from local storage
				      document.getElementById("data").innerHTML= "Local Storage Data.."+localStorage.getItem("testlocal")+"<br />";
				 
                                      //read data from session storage
				      document.getElementById("data").innerHTML+="Session Storage Data.."+sessionStorage.getItem("testsession")+"<br />";
				  
                                      //Reterive JSON data from storage
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

The Web Storage API calls are synchronous, so they may impact the UI rendering. Use the Web Storage API for storing and retrieving a minimal amount of data. The Web Storage API is very easy to use for storing and retrieving data on users’ browsers — all of the the modern browsers support the Web Storage API.

---

## IndexedDB Storage

IndexedDB is a JavaScript-based object-oriented database. IndexedDB lets you store and retrieve objects that are indexed with a key (a primary key — e.g., a SSN). Any objects supported by the structured-clone algorithm (e.g., videos, images) can be stored. IndexedDB is much more complex to use than the Web Storage API.

IndexedDB is a way for you to persistently store a large amount of data inside of a user’s browser. IndexedDB lets you create web applications with advanced abilities regardless of network availability. These applications can work both online and offline. IndexedDB is useful for applications that store a large amount of data and applications that don’t need persistent internet connectivity to work.

The IndexDB API is asynchronous, and it doesn’t block the UI rendering. This API uses indexes to enable high-performance searches of the data.

Create a database schema and objects, open a connection to your database, and then retrieve and update data within a series of transactions. The IndexDB allows the storage of significant amounts of structured data. This size is based on the browser implementation.

The database is private to an origin, so any other site can’t access another website that IndexedDB stores.

```HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>Browser Storage Demos - IndexDB API </title>		
		
		
		<script type = "text/javascript">
		
			//Check for browser support
			if (window.indexedDB) {		    
			
				//Sample data
				const customerData = [{ ssn: "444-44-4444", name: "test1", age: 35, email: "test1@company.com" },
									  { ssn: "555-55-5555", name: "test2", age: 32, email: "test2@home.org" }];
				const dbName = "testDB";
				var db;
				//open the db, the db is created if not exist already
				//Specify DB name and version, update the version number if the DB structure need to be modified
				var request = indexedDB.open(dbName, 2);

				//Error Handler
				request.onerror = function(event) {
					console.log("error: ");
				};
				
				//Success Handler
				request.onsuccess = function(event) {
					db = request.result;
					console.log("success: "+ db);
				};

				//Handler invoked on successful opening of database
				//Upgrade the existing DB object if the version is different or create the objects
				request.onupgradeneeded = function(event) {
					var db = event.target.result;

					// autoIncrement: true
					//Create Object store with primary key
					var objectStore = db.createObjectStore("customers", { keyPath: "ssn" });
					
					//Define the required Indexes
					objectStore.createIndex("name", "name", { unique: false });
					objectStore.createIndex("email", "email", { unique: true });
					
					//Add data to the object
					customerData.forEach(function(customer) {
							objectStore.add(customer);
					});
					
				};
				
				function add() {
				
					//Retrieve the transaction for specific object, specify the mode - readonly, readwrite and versionchange
					var transaction = db.transaction(["customers"], "readwrite");
					
					// Handler Invoked when all the data is added to the database.
					transaction.oncomplete = function(event) {
						console.log("Add Completed!");
					};

					//Error Handler
					transaction.onerror = function(event) {
						
					};
					
					const customerDataNew = [{ ssn: "777-77-7777", name: "Test3", age: 32, email: "test3@home.org" }];
					
					//Add new customer data to the store
					var objectStore = transaction.objectStore("customers");
					customerDataNew.forEach(function(customer) {
						var request = objectStore.add(customer);
						request.onsuccess = function(event) {
							console.log("Data Added..."+event.target.result);
						};
					});
				}
				
				
				//Delete data from the store through primary key and delete method
				function deleteData()
				{
					var request = db.transaction(["customers"], "readwrite")
									.objectStore("customers")
									.delete("777-77-7777");
					request.onsuccess = function(event) {
					console.log("Record Deleted!");
					};
				}
				
				//Read data from the store through primary key and get method
				function read()
				{
					var transaction = db.transaction(["customers"]);
					var objectStore = transaction.objectStore("customers");
					var request = objectStore.get("444-44-4444");
					request.onerror = function(event) {
						// Handle errors!
					};
					request.onsuccess = function(event) {
						document.getElementById("data").innerHTML = "Name for SSN 444-44-4444 is " + request.result.name;
					};
				}


				//Read all data from the store through cursor
				function readAll()
				{
				
					var objectStore = db.transaction("customers").objectStore("customers");
					
					console.log(db.transaction("customers"));
					console.log(objectStore);
					document.getElementById("data").innerHTML="";

					objectStore.openCursor().onsuccess = function(event) {
					var cursor = event.target.result;
						
						//Iterate Cursor
                                              if (cursor) {
							document.getElementById("data").innerHTML+="SSN: " + cursor.key + " Name: " + cursor.value.name +" Age: " + cursor.value.age+"<br />";
							cursor.continue();
						}
						else {
							console.log("No more entries!");
						}
					};
				}
				
				//Update existing data through primary key and put method
				function update()
				{

					var objectStore = db.transaction(["customers"], "readwrite").objectStore("customers");
					var request = objectStore.get("444-44-4444");
					request.onerror = function(event) {
					  
					};
					request.onsuccess = function(event) {
					 
                                         //Get the current data					 
					 var data = event.target.result;

					  // update the value
					  data.age = 42;

					  // Put the updated object to store.
					  var requestUpdate = objectStore.put(data);
					   requestUpdate.onerror = function(event) {
						 // error
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

## Web SQL Database

> “Web SQL Database is a web page API for storing data in databases that can be queried using SQL variant.” — [Wikipedia](https://en.wikipedia.org/wiki/Web_SQL_Database)

The specification is based around SQLite. Web SQL Database isn’t supported by all browsers — this standard is now deprecated by W3C, and IndexDB should be an alternative

Still, this can be used in supported browsers like Safari, Chrome, Opera, and Edge.

```HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>Browser Storage Demos - Web SQL API </title>	
		
		<script type = "text/javascript">
		
			//Check for browser support
			if (window.openDatabase) {
			  
				var db;
				 
				function createDBAndTable()
				{
					//Open database, create if not exists - db name, version, description and required storage
					db = window.openDatabase('test_db', '1.0', 'Test DB', 1024*1024)
					//transaction
					db.transaction(function (tx) {
						//Delete the existing table
						tx.executeSql('DROP TABLE IF EXISTS CUSTOMERS');				
						//Create the new table with required fields, define the primary key
						tx.executeSql('CREATE TABLE IF NOT EXISTS CUSTOMERS(SSN TEXT PRIMARY KEY , NAME TEXT,AGE INTEGER ,EMAIL TEXT)', [], function(tx, result) {
							console.log(result);
							console.log('Table created Successfully!');

						}, errorHandler);
					});
				}
				
				function insertData()
				{
					db.transaction(function (tx) { 										
						 //Insert data to the table, dynamic variables can be used
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
					//Read data from table and iterate through rows object
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
						 //Update existing data
						 tx.executeSql('UPDATE CUSTOMERS SET AGE=? WHERE SSN=?',[45,"444-44-4444"], function(tx,result) {					 
							console.log("Record Updated Successfully" +result);    
						},errorHandler);				
						
					});

				}

				function deleteData()
				{
					db.transaction(function (tx) { 										
						 //Delete data through primary key
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

> “CacheStorage is a storage mechanism in browsers for storing and retrieving network requests and responses. It stores a pair of Request and Response objects, the Request as the key and Response as the value.”
>
> — [Chidume Nnamdi](undefined) via [Bits and Pieces](https://blog.bitsrc.io/introduction-to-the-cache-storage-a-new-browser-cache-pwa-api-a5d7426a2456)

The CacheStorage API can be used within a Windows context (DOM context) and also with the Service Worker API to enable offline access. In this tutorial, we’re talking more about the DOM context.

CacheStorage was created to enable websites to store network requests and responses, but it can also be used as a storage utility. For example, we can store custom data, like user preferences, into the cache, and they can be retrieved when required. The `put` method can be used to store the custom response objects to the cache storage.

The CacheStorage API allows us to fetch and cache the data from crossorigin websites. The CacheStorage API is asynchronous and won’t block the UI rendering. The CacheStorage option is the latest addition to browser storage, and some browsers still don’t support it.

```HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>Browser Storage Demos - Cache Storage API </title>	
		
		<script type = "text/javascript">
		
				//Check for browser support
				if('caches' in window) {
				
					function add()
					{
						//Open the cache store, create if not exists
						caches.open('data_cache').then((cache) => {
							
							//Fetch data.json from origin server and add the response to the cache store 
							//Cross origin response caching is allowed - specify complete Request URL
							// Request object as the key
							cache.add(new Request('/data.json'));

							var data={foo: "bar"};					
							
							//Add additional header option to the response object before caching
							const jsonResponse = new Response(JSON.stringify(data), {
								  headers: {
									'content-type': 'application/json'
								  }
							});

							//Add Custom JSON data to the cache store
							cache.put('/custom.json', jsonResponse);				

						}).catch((err) => {
							console.log(err);
						});
					}	

					//Add multiple URL's into the cache - browser fetches the responses from origin
					function addAll()
					{
						caches.open('data_cache').then((cache) => {				
							const urls = ['/data1.json', '/data2.json','/data3.json'];
							cache.addAll(urls);	
						}).catch((err) => {
							console.log(err);
						});
					}				
					
					
					//Check Cache Store Status
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
					
					//Delete Cache Store
					function deleteCache()
					{		
							caches.delete('data_cache').then((bool) => {			
							document.getElementById("data").innerHTML = "Cache data_cache is deleted";
						}).catch((err) => {
						})		
					}
					
					//Delete specific object from cache store through cache key(request URL or object)
					function deleteCacheObject()
					{		
							caches.open('data_cache').then((cache) => {
							
							cache.delete('custom.json');							

						}).catch((err) => {
							console.log(err);
						});	
					}
					
					//Get all cache keys from cache store
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
					
					//Get Cache data from cache store
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

Refer to the following video for more details on different storage options.

Refer to [Browser Storage Demo](https://github.com/techforum-repo/youttubedata/tree/master/browser-storage-demos) for the storage demo (the demo is built on Node.js with Express.js.

There are multiple options for storing data on a user’s browser — select the option based on your use case.

Use the CacheStorage API to store the data for offline access.

IndexedDB is the better choice for storing a large amount of applications or user-generated data.

Cookies still can be used to store the minimal data the server requires to identify the state.

The local storage and session storage can be used to store a minimal amount of data. Local storage and session storage APIs are synchronous, so they’ll impact the UI rendering. But it’s easy to enable the API into the project.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
