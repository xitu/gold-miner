> * 原文链接: [Quickly Process API Requests with Shoryuken and SQS](https://www.sitepoint.com/quickly-process-api-requests-with-shoryuken-and-sqs/)
* 原文作者: [William Kennedy](https://www.sitepoint.com/author/wkennedy/)
* 译文出自: [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者: 
* 校对者:

![](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2016/07/1468165009amazon-sqs_512-300x300.png)

Rail’s has lots of solutions for background jobs. One of these is a brilliant Gem called Sidekiq, [which we have written about before on Sitepoint](https://www.sitepoint.com/comparing-background-processing-libraries-sidekiq/).

Sidekiq is great and can solve most developer needs. It is especially useful as it takes over the heavy lifting from Rails. However, it has a few shortfalls:

*   If you are not a Pro user ($750 per year) and your process crashes, you will lose your jobs.
*   If your job load increases, you will need a more powerful version of Redis which costs more money and resources.
*   You need to host its dashboard in order to monitor what is happening with your jobs.

Another approach you may want to consider for processing queued jobs is [Shoryuken](https://github.com/phstc/shoryuken), which works in conjunction with Amazon’s SQS (Simple Queue Service). This is a basic store of messages that you can process later via Shoryuken workers. These workers then work outside of the main Rails processes. With SQS and Shoryuken, you create a queue for your workers to use and these workers cycle through the jobs until the queue is empty.

A few benefits of using Shoryuken:

*   It is built with Amazon SQS in mind, which is incredibly cheap ($0.50 per 1 million Amazon SQS Requests).
*   SQS is built to scale. You are taking advantage of Amazon’s amazing infrastructure so it’s easy to scale your workers.
*   Amazon provides a simple console to watch your queues as well as configure what happens to dead messages.
*   Amazon’s Ruby SDK is very flexible when it comes to creating queues. You can create as many as you want.

In this article, I am going to guide you through setting up Shoryuken for use with the Flickr API. You will see how Shoryuken processes jobs in the background at lighting speed.

To begin this tutorial, we are going to use the Flickr API to create a simple search bar where we can generate photos based on whatever id is entered.

1.  First up, we have to [set up a Yahoo account](https://help.yahoo.com/kb/SLN2056.html), as this is the only way we can access the Flickr API. Once we have a Yahoo account, simply visit the [Flickr Docs page](https://www.flickr.com/services/api/)
2.  Click the [Create an App](https://www.flickr.com/services/apps/create/) link on the [Flickr docs](https://www.flickr.com/services/api/) page.
3.  Apply for a non-commercial key at [Flickr.com](https://www.flickr.com/services/apps/create/noncommercial/).
4.  On the next page, you will be asked to enter some details about your project. Simply fill in the name and other bits about your project.
5.  You’ll receive a Key and Secret for your application. Write these down somewhere because we will need them for this tutorial.

Next, set up the Rails app with a single controller action. To set up a new Rails app, generate one like so from the command line:

```
rails new shoryuken_flickr

```

Next, set up the controller. A standard controller action with an `index` action is perfect:

```
rails g controller Search index

```

Add a root route that to this action in **config/routes.rb**:

```
root  'search#index'

```

On the index page, set up a simple search form:

```
<%= form_tag("/", method: "get") do %>
  <%= text_field_tag(:flickr_id) %>
  <%= submit_tag("Search") %>
<% end %>

```

We must set up a Flickr module to return photos of the user ID being submitted:

1.  First, we install the [flickr_fu](https://github.com/commonthread/flickr_fu) which makes it easy to grab the data we want.
2.  Set up the **flickr.yml** file with our relevant credentials. This file lives in the **config** folder and looks like:

    ```
    key: <%= ENV["flickr<em>key"] %>
    secret: <%= ENV["flickr</em>secret"] %>
    token_cache: "token_cache.yml

    ```

3.  Now we create a helper method to return the photos for the index page. In **app/helpers/search_helper.rb**, add the following:

    ```
    module SearchHelper
      def user_photos(user_id, photo_count = 5)
        flickr = Flickr.new(File.join(Rails.root, 'config','flickr.yml'))
        flickr.photos.search(:user_id => user_id).values_at(0..(photo_count - 1))
      end
    end

    ```

This method returns the photos based on the provided Flickr user ID. In **app/controllers/search_controller.rb**, we need to put in an action to grab that data:

```
  class SearchController < ApplicationController
    def index
      if params[:flickr_id]
        @photos = user_photos(params[:flickr_id],10).in_groups_of(2)
        @id = params[:flickr_id]
      end
    end
  end

```

Now, just create a little partial to generate the photos. In **app/views/search**, add a **photos.html.erb** file with the following:

```
  <ul>
    <% @photos.each do |photo| %>
      <li> <% photo.each do |p| %>
      <%= link_to(image_tag(p.url(:square), :title => p.title, :border => 0, :size => '375x375'), p.url_photopage) %>
      </li>
    <% end %>
  <% end %>
  </ul>

```

Flickr ids are present on user profiles in the URL. An example ID is `138578671@N04` and if you submit that value in the form, a bunch of photos are returned.

Now we have a functioning application that gets new photos from Flickr. This is awesome, but it is very slow for the user and it refreshes the whole page each time.

I think this app would be better with a bit of AJAX. First, create an **index.js.erb** view in **app/views/search** and put in some simple Javascript:

```
$('ul').remove();
$('#flickr').append("<%= j render 'photos'%>").html_safe();

```

In the controller, make sure we have a `respond_to` block for our code:

```
class SearchController < ApplicationController
  def index
    if params[:flickr_id]
      @photos = user_photos(params[:flickr_id],10).in_groups_of(2)
      @id = params[:flickr_id]
    end
    respond_to |format|
      format.html
      format.js
    end
  end
end

```

Finally, in the search form, set `remote` to `true`:

```
<br/>
  <%= form_tag("/", method: "get", :remote => true) do %>
  <%= text_field_tag(:flickr_id) %>
  <%= submit_tag("Search") %> <% end %>
<br/>

```

Okay, so it’s cool, but we still have not used Shoryuken. The process is still single threaded.

## Setting Up Shoryuken

If you don’t already have an [Amazon Web Services (AWS)](https://aws.amazon.com) account, you’ll need to set one up. Follow

1.  Click on the “My Account” dropdown menu and then click “AWS Management Console”.
2.  Sign in and then you’ll be taken to the AWS Management Console.
3.  In the top right, click on your user name in the menu bar and then click on “Security Credentials”.
4.  Now you will be taken to a page where you can get access to your AWS Access Keys (Access Key ID and Secret Access Key)
5.  Click “Create New Access Key” and take down your Access Key ID and Secret Access Key. You need these to run Shoryuken and SQS.

Once we have the AWS access keys, the next step is to install and configure the relevant gems. First, install the AWS SDK with the relevant details by adding the following to your Gemfile:

```
gem 'aws-sdk', '~> 2'

```

Then, `bundle install`.

We need to configure the AWS SDK with the relevant credentials. I usually create a file called **aws.rb** which I put in in the **config/initializers** folder

```
touch config/initializers/aws.rb

```

Add the following code to the file:

```
Aws.config.update({ 
  region:      "eu-west-1",
  credentials: Aws::Credentials.new(your_access_key, your_secret_key)
})

sqs = Aws::SQS::Client.new(
  region:      "eu-west-1",
  credentials: Aws::Credentials.new(your_access_key, your_secret_key)
)
sqs.create_queue({queue_name: 'default'})

```

Make sure to replace the credentials with your actual credentials.

If we go to the SQS console, we will see a new queue created if you restart your Rails server.

![SQS QUEUE](http://i.imgur.com/qG23zqp.png?2)

Finally, time to install the Shoryuken gem. In our Gemfile:

```
gem 'shoryuken'

```

Create the Shoryuken worker and some middleware. I just create a new directory under **apps** called **workers**:

```
mkdir app/workers
touch app/workers/flickr_worker.rb
touch app/workers/flickr_middleware.rb
touch config/shoryuken.yml

```

Configure our Flickr middleware:

```
class FlickrMiddleware
  def call(worker_instance, queue, sqs_msg, body)
    puts 'Before work'
    yield
    puts 'After work'
  end
end

```

Set up the worker:

```
class MyWorker
  include Shoryuken::Worker
  shoryuken_options queue: QUEUE_NAME, auto_delete: true, body_parser: JSON

  def perform(sqs_msg, body)
    id = body.fetch('id')
    flickr = Flickr.new({
      key:"your_key",
      secret:"your_secret",
      token_cache:"token_cache.yml"
    })
    flickr.photos.search(:user_id => id).values_at(0..(5 - 1))
  end
 end

```

As well as configuring our **config/shoryuken.yml** file to the following:

```
aws:
  access_key_id: 'AWS_KEY'
  receive_message:
    attribute_names:
    - ApproximateReceiveCount
    - SentTimestamp
  region: eu-west-1
  secret_access_key: 'AWS Secret Key'
  concurrency: 25
  delay: 0
  queues:
    - [default, 6]

```

Excellent! We nearly have everything setup and ready to go. All that’s left is to send messages to our queue. In the search controller, put in the following:

```
  class SearchController < ApplicationController
    include SearchHelper

    def index
      # 138578671@N04 submit this in the form
      if params[:flickr_id]
        FlickrWorker.perform_async("id" => params[:flickr_id])
        sleep 0.1
        @photos = Photo.find_by_user_id(params[:flickr_id]).photos
      end
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

```

Now we just submit another message. This time, you should see it appear on the SQS console. You may need to refresh the SQS console using the refresh button which is in the top right of the screen.

You should see a message in your queue but for some reason, it is not being processed. Better sort that out. Open up another terminal window and navigate to your project. When you are there, you must run the following command:

```
bundle exec shoryuken -R -C config/shoryuken.yml

```

Now you should see you worker cleaning out the queue. When you go back to your app, you will probably see an error. Remember, Shoryuken runs in the background so it cannot create instance variables for your current process. You could save the photos to a database and then poll the table when the results arrive.

```
rails g model Photo user_id:string photos:string

```

Now we just check our migrate file and make sure the correct fields are being added. Open up the migration file (in **db/migrate**) and make sure it looks like:

```
class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :user_id
      t.string :photos

      t.timestamps null: false
    end
  end
end

```

If everything looks OK, we need to migrate the database.

```
rake db:migrate

```

Make sure to serialize the array that is returned in our database. In **app/models/photos.rb**:

```
class Photo < ActiveRecord::Base
  serialize :photos
end

```

Then update our table every time the worker is run. At the bottom of the `SearchHelper#user_photos` method add a line to write the photos to the database:

```
photos = flickr.photos.search(:user_id => id).values_at(0..(5 - 1))
Photo.create(:user_id => id, :photos => [photos])

```

To see it working in action, add a delay to your search controller action to give your database a chance to update. In the real world, I suggest a more elegant solution using AJAX.

```
sleep 1.5

```

There you have it. You now know how to take advantage of some awesome libraries for processing queued tasks with Shoryuken. While this example is very contrived, I used it to demonstrate how to use Shoryuken with SQS. No doubt, you probably have at least one use case that would benefit from queued messages.
