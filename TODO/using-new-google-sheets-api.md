>* 原文链接 : [Using the new Google Sheets API](http://wescpy.blogspot.hk/2016/06/using-new-google-sheets-api.html)
* 原文作者 : [WESLEY CHUN](http://google.com/+WesleyChun)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:



## Introduction

In this post, we're going to demonstrate how to use the latest generation [Google Sheets API](http://developers.google.com/sheets). [Launched](http://googleappsdeveloper.blogspot.com/2016/06/auto-generating-google-forms.html) at Google I/O 2016 (full talk [here](http://youtu.be/Gk-xpjgUwx4)), the Sheets API v4 can do much more than previous versions, bringing it to near-parity with what you can do with the Google Sheets UI (user interface) on desktop and mobile. Below, I'll walk you through a Python script that reads the rows of a relational database representing customer orders for a toy company and pushes them into a Google Sheet. Other API calls we'll make: one to create new Google Sheets with and another that reads the rows from a Sheet.  

[Earlier posts](http://goo.gl/57Gufk) demonstrated the structure and "how-to" use Google APIs in general, so more recent posts, including this one, focus on solutions and use of specific APIs. Once you review the earlier material, you're ready to start with authorization scopes then see how to use the API itself.  

## Google Sheets API authorization & scopes

Previous versions of the Google Sheets API (formerly called the [Google Spreadsheets API](http://developers.google.com/google-apps/spreadsheets)), were part of a group of "[GData APIs](http://developers.google.com/gdata/docs/directory)" that implemented the [Google Data (GData) protocol](http://developers.google.com/gdata), an older, less-secure, REST-inspired technology for reading, writing, and modifying information on the web. The new API version falls under the more modern set of [Google APIs](http://developers.google.com/api-client-library/python/apis) requiring [OAuth2](http://oauth.net/) authorization and whose use is made easier with the [Google APIs Client Libraries](http://developers.google.com/discovery/libraries).  

The current API version features [a pair of authorization scopes](https://developers.google.com/sheets/guides/authorizing#OAuth2Authorizing): read-only and read-write. As usual, we always recommend you use the most restrictive scope possible that allows your app to do its work. You'll request fewer permissions from your users (which makes them happier), and it also makes your app more secure, possibly preventing modifying, destroying, or corrupting data, or perhaps inadvertently going over quotas. Since we're creating a Google Sheet and writing data into it, we _must_ use the read-write scope:  

*   `'https://www.googleapis.com/auth/spreadsheets'` — Read/write access to Sheets and Sheet properties

## Using the Google Sheets API

Let's look at some code that reads rows from a SQLite database and creates a Google Sheet with that data. Since we covered the authorization boilerplate fully in earlier [posts](http://goo.gl/cdm3kZ) and [videos](http://goo.gl/KMfbeK), we're going straight to creating a Sheets service endpoint. The API string to use is `'sheets'` and the version string to use is `'v4'` as we call the `apiclient.discovey.build()` function:  

`SHEETS = discovery.build('sheets', 'v4', http=creds.authorize(Http()))`  

With the SHEETS service endpoint in hand, the first thing to do is to create a brand new Google Sheet. Before we use it, one thing to know about the Sheets API is that most calls require a JSON payload representing the data & operations you wish to perform, and you'll see this as you become more familiar with it. For creating new Sheets, it's pretty simple, you don't have to provide anything, in which case you'd pass in an empty (`dict` as the) <span>body</span>, but a better bare minimum would be a name for the Sheet, so that's what `data` is for:  

`data = {'properties': {'title': 'Toy orders [%s]' % time.ctime()}}`  

Notice that a Sheet's "title" is part of its "properties," and we also happen to add the timestamp as part of its name. With the payload complete, we call the API with the command to create a new Sheet [[`spreadsheets().create()`](http://developers.google.com/sheets/reference/rest/v4/spreadsheets/create)], passing in <span>data</span> in the (eventual) request <span>body</span>:  

`res = SHEETS.spreadsheets().create(body=data).execute()`  

Alternatively, you can use the [Google Drive API](http://developers.google.com/drive) ([v2](http://wescpy.blogspot.com/2015/12/google-drive-uploading-downloading.html) or [v3](http://wescpy.blogspot.com/2015/12/migrating-to-new-google-drive-api-v3.html)) to create a Sheet but would also need to pass in the Google Sheets (file) [MIME type](http://developers.google.com/drive/v3/web/mime-types):  

    data = {
        'name': 'Toy orders [%s]' % time.ctime(),
        'mimeType': 'application/vnd.google-apps.spreadsheet',
    }
    res = DRIVE.files().create(body=data).execute() # insert() for v2

The general rule-of-thumb is that if you're only working with Sheets, you can do all the operations with _its_ API, but if creating files other than Sheets or performing other Drive file or folder operations, you may want to stick with the Drive API. You can also use both or any other Google APIs for more complex applications. We'll stick with just the Sheets API for now. After creating the Sheet, grab and display some useful information to the user:  

    SHEET_ID = res['spreadsheetId']
    print('Created "%s"' % res['properties']['title'])

You may be wondering: Why do I need to create a Sheet and _then_ make a separate API call to add data to it? Why can't I do this all when creating the Sheet? The answer (to this likely FAQ) is you _can_, but you would need to construct and pass in a JSON payload representing the entire Sheet—meaning all cells and their formatting—a much larger and more complex data structure than just an array of rows. (Don't believe me? Try it yourself!) This is why we have all of the[spreadsheets().values()](http://developers.google.com/sheets/reference/rest/v4/spreadsheets.values) methods... to simplify uploading or downloading of only values to or from a Sheet.  

Now let's turn our attention to the simple [SQLite](http://sqlite.org) database file ([db.sqlite](https://github.com/googlecodelabs/sheets-api/blob/master/start/db.sqlite)) available from [the Google Sheets Node.js codelab](http://g.co/codelabs/sheets). The next block of code just connects to the database with the standard library [sqlite3](http://docs.python.org/library/sqlite3) package, grabs all the rows, adds a header row, and filters the last two (timestamp) columns:  

    FIELDS = ('ID', 'Customer Name', 'Product Code', 'Units Ordered',
            'Unit Price', 'Status', 'Created at', 'Updated at')
    cxn = sqlite3.connect('db.sqlite')
    cur = cxn.cursor()
    rows = cur.execute('SELECT * FROM orders').fetchall()
    cxn.close()
    rows.insert(0, FIELDS)
    data = {'values': [row[:6] for row in rows]}

When you have a payload (array of row data) you want to stick into a Sheet, you simply pass in those values to [spreadsheets().values().update()](http://developers.google.com/sheets/reference/rest/v4/spreadsheets.values/update) like we do here:  

    SHEETS.spreadsheets().values().update(spreadsheetId=SHEET_ID,
        range='A1', body=data, valueInputOption='RAW').execute()

The call requires a Sheet's ID and command body as expected, but there are two other fields: the full (or, as in our case, the "upper left" corner of the) range of cells to write to (in [A1 notation](https://developers.google.com/sheets/guides/concepts#a1_notation)), and <span>[valueInputOption](https://developers.google.com/sheets/reference/rest/v4/ValueInputOption)</span> indicates how the data should be interpreted, writing the raw values ("RAW") or interpreting them as if a user were entering them into the UI ("USER_ENTERED"), possibly converting strings & numbers based on the cell formatting.  

Reading rows out of a Sheet is even easier, the [spreadsheets().values().get()](http://developers.google.com/sheets/reference/rest/v4/spreadsheets.values/get) call needing only an ID and a range of cells to read:  

    print('Wrote data to Sheet:')
    rows = SHEETS.spreadsheets().values().get(spreadsheetId=SHEET_ID,
        range='Sheet1').execute().get('values', [])
    for row in rows:
        print(row)

The API call returns a <span>dict</span> which has a 'values' key if data is available, otherwise we default to an empty list so the `<b>for</b>` loop doesn't fail.  

If you run the code (entire script below) and grant it permission to manage your Google Sheets (via the OAuth2 prompt that pops up in the browser), the output you get should look like this:  

    $ python3 sheets-toys.py # or python (2.x)
    Created "Toy orders [Thu May 26 18:58:17 2016]" with this data:
    ['ID', 'Customer Name', 'Product Code', 'Units Ordered', 'Unit Price', 'Status']
    ['1', "Alice's Antiques", 'FOO-100', '25', '12.5', 'DELIVERED']
    ['2', "Bob's Brewery", 'FOO-200', '60', '18.75', 'SHIPPED']
    ['3', "Carol's Car Wash", 'FOO-100', '100', '9.25', 'SHIPPED']
    ['4', "David's Dog Grooming", 'FOO-250', '15', '29.95', 'PENDING']
    ['5', "Elizabeth's Eatery", 'FOO-100', '35', '10.95', 'PENDING']

## Conclusion

Below is the entire script for your convenience which runs on both Python 2 **and** Python 3 (unmodified!):  

    '''sheets-toys.py -- Google Sheets API demo
        created Jun 2016 by +Wesley Chun/@wescpy
    '''
    from __future__ import print_function
    import argparse
    import sqlite3
    import time

    from apiclient import discovery
    from httplib2 import Http
    from oauth2client import file, client, tools

    SCOPES = 'https://www.googleapis.com/auth/spreadsheets'
    store = file.Storage('storage.json')
    creds = store.get()
    if not creds or creds.invalid:
        flags = argparse.ArgumentParser(parents=[tools.argparser]).parse_args()
        flow = client.flow_from_clientsecrets('client_id.json', SCOPES)
        creds = tools.run_flow(flow, store, flags)

    SHEETS = discovery.build('sheets', 'v4', http=creds.authorize(Http()))
    data = {'properties': {'title': 'Toy orders [%s]' % time.ctime()}}
    res = SHEETS.spreadsheets().create(body=data).execute()
    SHEET_ID = res['spreadsheetId']
    print('Created "%s"' % res['properties']['title'])

    FIELDS = ('ID', 'Customer Name', 'Product Code', 'Units Ordered',
            'Unit Price', 'Status', 'Created at', 'Updated at')
    cxn = sqlite3.connect('db.sqlite')
    cur = cxn.cursor()
    rows = cur.execute('SELECT * FROM orders').fetchall()
    cxn.close()
    rows.insert(0, FIELDS)
    data = {'values': [row[:6] for row in rows]}

    SHEETS.spreadsheets().values().update(spreadsheetId=SHEET_ID,
        range='A1', body=data, valueInputOption='RAW').execute()
    print('Wrote data to Sheet:')
    rows = SHEETS.spreadsheets().values().get(spreadsheetId=SHEET_ID,
        range='Sheet1').execute().get('values', [])
    for row in rows:
        print(row)

You can now customize this code for your own needs, for a mobile frontend, devops script, or a server-side backend, perhaps accessing other Google APIs. If this example is too complex, check the [Python quickstart in the docs](http://developers.google.com/sheets/quickstart/python) that way simpler, only reading data out of an existing Sheet. If you know JavaScript and are ready for something more serious, try [the Node.js codelab](http://g.co/codelabs/sheets) where we got the SQLite database from. That's it... hope you find these code samples useful in helping you get started with the latest Sheets API!  

**EXTRA CREDIT**: Feel free to experiment and try cell formatting or other API features. Challenge yourself as there's a lot more to Sheets than just reading and writing values! </div>

