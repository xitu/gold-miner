> * 原文链接: [利用 Shoryuken and SQS 快速处理 API 请求](https://www.sitepoint.com/quickly-process-api-requests-with-shoryuken-and-sqs/)
* 原文作者: [William Kennedy](https://www.sitepoint.com/author/wkennedy/)
* 译文出自: [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者: [circlelove](https://github.com/circlelove)
* 校对者: [rccoder](https://github.com/rccoder), [MAYDAY1993](https://github.com/MAYDAY1993)

# 利用 Shoryuken and SQS 快速处理 API 请求

![](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2016/07/1468165009amazon-sqs_512-300x300.png)

Rails 为后台工作提供了相当多的解决方案。其中一个就是被称为 Sidkiq 的智能 Gem， [我们之前在 Sitepoint 上提到过](https://www.sitepoint.com/comparing-background-processing-libraries-sidekiq/)。


Sidekiq 相当棒，能解决大多数开发中的问题。尤其是 Rails 繁重问题上相当有用。然而，它也有一些不足。



*   如果你不是专业版用户（每年支付750美元），而你的进程崩溃的话，将会丢失你的工作 
*   如果你的工作量增加，你需要更强大版本的 Redis ，而它耗费更多的成本和资源。
*   为了监控你工作上发生的一切，你需要把握它的控制面板。


想要解决排队任务的你需要考虑的另一种方法是 [Shoryuken](https://github.com/phstc/shoryuken) ，它和亚马逊的 SQS (Simple Queue Service)协同工作。这是一个基本消息存储，之后你可以通过 Shoryukeσn workers 进行处理。这些 workers 之后在主 Rails 进程外部工作。有了 SQS 和 Shoryuken，你可以为 workers 创建队列利用 workers 循环任务直到队列空闲。

使用 Shoryuken 有以下好处：

*   他是以 Amazon SQS 构建的，难以置信的便宜（每一百万次 Amazon SQS Requests 只要0.5美元）。
*   SQS 是用来规模化作业的。利用亚马逊这个令人惊喜的基础配置，你可以轻松地简化你的 workers 。
*   亚马逊提供了一个简单的控制台来查看队列以及配置死消息的情况。
*   亚马逊的 Ruby SDK 在创建队列的时候十分灵活。如果你愿意可以创建很多队列。

本文档中，我会带你来配置带有 Flickr API 的 Shoryuken 。你将见证 Shoryuken 如何在后台光速处理任务。

为了开始这个教程，我们将用 Flickr API 来创建一个简单的搜索框，这样就可以根据 id 输入来生成照片。

1.  首先，我们需要[设置雅虎账户](https://help.yahoo.com/kb/SLN2056.html)，因为这是我们可以访问 Flickr API 唯一的方式。配好雅虎账户之后，简单地查看一下[Flickr 文档页面](https://www.flickr.com/services/api/)。

2.  在 [Flickr 文档](https://www.flickr.com/services/api/) 页面单击[创建一个应用](https://www.flickr.com/services/apps/create/) 链接。
 
3.  在 [Flickr.com](https://www.flickr.com/services/apps/create/noncommercial/) 申请一个非商业密钥。

4.  下一个页面当中，你会被要求输入项目的具体信息，简单地填入项目名称和事项等即可。

5.  你会收到应用的密钥和密码。把他们写在某个地方，因为这个教程当中需要用到。

接下来，搭建一个单控制器行为的 Rails app 。要生成新的 Rails app，利用如下命令行生成：

```
rails new shoryuken_flickr

```

下一步，配置控制器。带有`index`行为的控制器行为是完美的：

```
rails g controller Search index

```

在**config/routes.rb** 里添加一个根路径到这个操作上：

```
root  'search#index'

```

在索引页，设置一个简单的搜索框：
```
<%= form_tag("/", method: "get") do %>
  <%= text_field_tag(:flickr_id) %>
  <%= submit_tag("Search") %>
<% end %>

```

我们必须配置 Flickr 模块来返回用户提交 id 的照片：

1.  首先，我们得安装[ flickr_fu ] (https://github.com/commonthread/flickr_fu)，这样更容易抓取我们需要的数据。
2.  利用相关凭证配置 **flickr.yml** 文件。这个文件在 **config** 文件夹里作业，看起来是这样的：

    ```
    key: <%= ENV["flickr<em>key"] %>
    secret: <%= ENV["flickr</em>secret"] %>
    token_cache: "token_cache.yml

    ```

3.  现在我们可以为目录页创建一个 helper 方法来返回照片。在 **app/helpers/search_helper.rb** 添加如下内容：

    ```
    module SearchHelper
      def user_photos(user_id, photo_count = 5)
        flickr = Flickr.new(File.join(Rails.root, 'config','flickr.yml'))
        flickr.photos.search(:user_id => user_id).values_at(0..(photo_count - 1))
      end
    end

    ```

基于提供的用户 id 这种方法可以返回照片。在 **app/controllers/search_controller.rb** ，需要一个操作来抓取数据：

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

现在，只要创建一个小的片段来生成照片。在 **app/views/search** 里通过如下代码添加一个 **photos.html.erb** 文件：

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

Flickr id 就呈现在 URL 的用户配置里。以 `138578671@N04` 这个 ID 为例，如果你在表单里提交了有效值，就会返回一系列照片。

现在我们有了一个从 Flickr 获取新照片的应用。这很棒，但是对用户来说这还很慢，而且每次搜需要刷新整个页面。


我认为加上一点 AJAX 这个应用会更完善，在 **app/views/search**  创建 **index.js.erb** 视图，并添加一些 Javascript 的内容：

```
$('ul').remove();
$('#flickr').append("<%= j render 'photos'%>").html_safe();

```

控制器当中，要保证我们对代码阻塞有  `响应 `
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

最后，每个搜索表单中，设置 `remote` 为 `ture`:
```
<br/>
  <%= form_tag("/", method: "get", :remote => true) do %>
  <%= text_field_tag(:flickr_id) %>
  <%= submit_tag("Search") %> <% end %>
<br/>

```

好，这很酷，但是我们还没有用到 Shroyuken 。进程还是单线程的。

##配置 Shoryuken

如果你还没有 [Amazon Web Services (AWS)](https://aws.amazon.com) 账户，你需要创建一个。按照：

1.  点击“我的账户”下拉菜单，然后单击“AWS 控制台”。
2.  登录之后就进入了控制台。
3.  在右上方，单击菜单栏中的用户名，然后单击“安全验证”。
4.  现在你被带到一个页面里，你可以获取访问密钥的 id 和密码。  
5.  点击“创建新的访问密钥”得到你的访问密钥 ID 和密码。你需要这些来运行 Shoryuken 和 SQS。

这样我们有了 AWS 的访问密钥，下一步就是安装和配置相关的 gem 。添加如下代码到你的 Gemfile里来安装带有相关细节的 AWS SDK 。

```
gem 'aws-sdk', '~> 2'

```


之后，`bundle install`。

我们需要利用相关证书配置 AWS SDK。完成通常创建一个叫**aws.rb** 的文件，放在 **config/initializers** 文件夹里面。

```
touch config/initializers/aws.rb

```

在文件中添加以下代码：

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

确保用你的实际证书替代原证书

如果我们查看 SQS 控制台，会发现重启 Rails 服务器之后会出现新的队列。

![SQS QUEUE](http://i.imgur.com/qG23zqp.png?2)


最后，到了安装 Shoryuken gem 的时候了。在我们的 Gemfile 里：

```
gem 'shoryuken'

```


创建 Shoryuken worker 和其他中间件。我只是创建了在 **apps**  下创建了一个新的名叫 **workers** 的目录：

```
mkdir app/workers
touch app/workers/flickr_worker.rb
touch app/workers/flickr_middleware.rb
touch config/shoryuken.yml

```


配置 Flickr 中间件：
```
class FlickrMiddleware
  def call(worker_instance, queue, sqs_msg, body)
    puts 'Before work'
    yield
    puts 'After work'
  end
end

```


配置 worker ：

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


同时也需要按如下方式配置我们的 **config/shoryuken.yml**  文件：

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


完美! 我们差不多配置好了所有的东西准备开始了。只剩下了给队列发送消息了。在搜索控制器上，写入如下代码：

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


现在我们刚刚提交了另一个消息。这时候，你应该看到它显示在 SQS 控制台上。你也许需要单击刷新 SQS 控制台，按钮在屏幕右上方。

你应该可以看到队列的一条消息，不过由于某种原因还没有被处理。最好梳理一下。打开另一个终端窗口浏览你的项目。当你进入的时候，必须运行如下命令：

```
bundle exec shoryuken -R -C config/shoryuken.yml

```


现在你应该能看到 worker 在清理队列了。当你返回 app 的时候，你或许可以看到一个报错。记住， Shoryuken 在后台运行所以无法为当前进程创建实例变量。你可以把照片保存在数据库中，得到结果之后再提交表单。

```
rails g model Photo user_id:string photos:string

```


现在我们检查一下迁移文件并确认添加了正确的字段。在 **db/migrate** 中打开迁移文件
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


如果一切都没有问题的话，我们就可以迁移数据库了。

```
rake db:migrate

```


确认序列化数据库返回的数组。在 **app/models/photos.rb** 当中：

```
class Photo < ActiveRecord::Base
  serialize :photos
end

```


之后每次 worker 工作的时候就更新一次表单。在 `SearchHelper#user_photos` 方法下方添加一行将照片写入数据库：

```
photos = flickr.photos.search(:user_id => id).values_at(0..(5 - 1))
Photo.create(:user_id => id, :photos => [photos])

```


为了查看它工作的情况，给控制器操作添加一个延迟让数据库得以更新。现实当中，我建议使用 AJAX 这个更优雅的方案。

```
sleep 1.5

```


那么你就完成了。你现在了解了如何利用一些很赞的库来处理带有 Shoryuken 的工作。尽管这个例子还不太自然，用它演示了如何使用带有 SQS 的 Shoryuken。 相信至少你学到了一个利用队列消息的案例。



