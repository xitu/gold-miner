> * 原文地址：[Build a Simple Mailing Service with Django](https://medium.com/python-in-plain-english/simple-mailer-with-django-2a7e2ad34b34)
> * 原文作者：[Juli Colombo](https://medium.com/@julietanataliacolombo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/simple-mailer-with-django.md](https://github.com/xitu/gold-miner/blob/master/TODO1/simple-mailer-with-django.md)
> * 译者：[shixi-li](https://github.com/shixi-li)
> * 校对者：[lsvih](https://github.com/lsvih)

# 使用 Django 构建一个简单的邮件服务

![](https://cdn-images-1.medium.com/max/3840/1*vXc5t2OrAan1o9viF-MkBQ.png)

当我们创建一个 web 应用时，经常会有发送邮件的需要。无论是用户注册，还是用户忘记密码，又或者是用户下单后进行付款确认，都需要发送不同的邮件。所以发送邮件的需求实际上是非常重要的，而且如果不在一开始就构建结构清晰的邮件服务，到后面可能会是一团糟。 

这篇文章不仅会教你如何定义一个能轻松切换发送平台的电子邮件服务，并且还可以对实际的邮件内容进行定制。

本文中使用 [Django](https://www.djangoproject.com/) 来做出示例，但我希望你可以将其中主要的思路应用到其他你可能正在使用的语言或者框架中。

让我们开始吧！

## 基本的邮件发送

假设我们希望在用户注册到我们的 web 应用后向他发送邮件。我们可以参照 [Django 文档](https://docs.djangoproject.com/en/3.0/topics/email/)，向验证通过并创建成功的用户发送邮件。具体实现如下：

```Python
import logging

from rest_framework.views import APIView
from django.http import JsonResponse
from django.core.mail import send_mail

from users.models import User

logger = logging.getLogger('django')


class RegisterView(APIView):

    def post(self, request):
        # Run validations
        if not request.data:
            return JsonResponse({'errors': 'User data must be provided'}, status=400)
        if User.objects.filter(email=request.data['email']).exists():
            return JsonResponse({'errors': 'Email already in use'}, status=400)
        try:
            # Create new user
            user = User.objects.create_user(email=request.data['email'].lower())
            user.set_password(request.data['password'])
            user.save()
            
            # Send welcome email
            send_mail(
                subject='Welcome!',
                message='Hey there! Welcome to our platform.',
                html_message='<p><strong>Het there!</strong> Welcome to our platform.</p>'
                from_email='from@example.com',
                recipient_list=[user.email],
                fail_silently=False,
            )
            
            return JsonResponse({'status': 'ok'})
        except Exception as e:
            logger.error('Error at %s', 'register view', exc_info=e)
            return JsonResponse({'errors': 'Wrong data provided'}, status=400)
```

当然正如文档中所说的那样，你也必须提前设定好一些重要的配置项，比如 EMAIL_HOST 和 EMAIL_PORT。

很好！现在我们已经发送了欢迎邮件！

## 创建一个 mailer 类

正如我之前所说，在我们的应用中不同的模块可能都需要发送邮件，所以最好有一个电子邮件服务或者 mailer 类来处理所有的邮件请求。这样子会让改动和迭代邮件的需求变得更简单，因为我们不再需要每次都去翻遍全部代码。

```Python
import logging

from django.conf import settings
from django.core.mail import send_mail

from users.models import User

logger = logging.getLogger('django')


class BaseMailer():
    def __init__(self, to_email, subject, message, html_message):
        self.to_email = to_email
        self.subject = subject
        self.message = message
        self.html_message = html_message

    def send_email(self):
        send_mail(
            subject=self.subject,
            message=self.message,
            html_message=self.html_message,
            from_email='from@example.com',
            recipient_list=[self.to_email],
            fail_silently=False,
        )
```

让我们来看看经过这次改变后，注册服务的视图层是什么样子：


```Python
import logging

from rest_framework.views import APIView
from django.http import JsonResponse
from django.core.mail import send_mail

from users.models import User
from users.mailers import BasicMailer

logger = logging.getLogger('django')


class RegisterView(APIView):

    def post(self, request):
        # Run validations
        if not request.data:
            return JsonResponse({'errors': 'User data must be provided'}, status=400)
        if User.objects.filter(email=request.data['email']).exists():
            return JsonResponse({'errors': 'Email already in use'}, status=400)
        try:
            # Create new user
            user = User.objects.create_user(email=request.data['email'].lower())
            user.set_password(request.data['password'])
            user.save()
            
            # Send welcome email
            BasicMailer(to_email=user.email, 
                        subject='Welcome!', 
                        message='Hey there! Welcome to our platform.', 
                        html_message='<p><strong>Het there!</strong> Welcome to our platform.</p>').send_email()
            
            return JsonResponse({'status': 'ok'})
        except Exception as e:
            logger.error('Error at %s', 'register view', exc_info=e)
            return JsonResponse({'errors': 'Wrong data provided'}, status=400)
```

## mailer 子类

现在我们已经把所有的“邮件代码”移动到一个单独的地方，可以把它利用起来啦！这时候就能继续创建特定的 mailer 类，并让它们知道每次被调用时该发送什么内容。现在让我们创建一个 mailer 类用来在每次用户注册时进行调用，另一个 mailer 类用来发送订单的确认信息。

```Python
import logging

from django.conf import settings
from django.core.mail import send_mail

from users.models import User

logger = logging.getLogger('django')


class BaseMailer():
    def __init__(self, to_email, subject, message, html_message):
        self.to_email = to_email
        self.subject = subject
        self.message = message
        self.html_message = html_message

    def send_email(self):
        send_mail(
            subject=self.subject,
            message=self.message,
            html_message=self.html_message,
            from_email='from@example.com',
            recipient_list=[self.to_email],
            fail_silently=False,
        )
        
        
class RegisterMailer(BaseMailer):
    def __init__(self, to_email):
        super().__init__(to_email,  
                         subject='Welcome!', 
                         message='Hey there! Welcome to our platform.', 
                         html_message='<p><strong>Het there!</strong> Welcome to our platform.</p>')
        

class NewOrderMailer(BaseMailer):
    def __init__(self, to_email):
        super().__init__(to_email,  
                         subject='New Order', 
                         message='You have just created a new order', 
                         html_message='<p>You have just created a new order.</p>')
```

这表明在不同的场景下集成邮件服务是非常简单的。你只需要构造一个基础的 mail 类来进行实现，然后在子类中设置具体内容。

因为不用实现所有邮件相关的代码，所以现在我们注册服务的视图层看起来更加简明：

```Python
import logging

from rest_framework.views import APIView
from django.http import JsonResponse
from django.core.mail import send_mail

from users.models import User
from users.mailers import RegisterMailer

logger = logging.getLogger('django')


class RegisterView(APIView):

    def post(self, request):
        # Run validations
        if not request.data:
            return JsonResponse({'errors': 'User data must be provided'}, status=400)
        if User.objects.filter(email=request.data['email']).exists():
            return JsonResponse({'errors': 'Email already in use'}, status=400)
        try:
            # Create new user
            user = User.objects.create_user(email=request.data['email'].lower())
            user.set_password(request.data['password'])
            user.save()
            
            # Send welcome email
            RegisterMailer(to_email=user.email).send_email()
            
            return JsonResponse({'status': 'ok'})
        except Exception as e:
            logger.error('Error at %s', 'register view', exc_info=e)
            return JsonResponse({'errors': 'Wrong data provided'}, status=400)
```

## 使用 Sendgrid

假设我们必须使用正式的 [python 库](https://github.com/sendgrid/sendgrid-python) 将我们的邮件服务后端迁移 [Sendgrid](https://sendgrid.com/) （一个用于交易和营销邮件的客户通信平台）。我们将不能再使用 Django 的 **send_email** 方法，而且我们还不得不使用新库的语法。嗯，但我们还是很幸运地！因为我们已经将所有与邮件管理相关的代码都放到了一个单独的地方，所以我们可以很轻松的做出这次改动 😉

```Python
import logging

from django.conf import settings
from sendgrid import SendGridAPIClient, Email, Personalization
from sendgrid.helpers.mail import Mail

from users.models import User

logger = logging.getLogger('django')


class BaseMailer():
    def __init__(self, email, subject, template_id):
        self.mail = Mail()
        self.subject = subject
        self.template_id = template_id

    def create_email(self):
        self.mail.from_email = Email(settings.FROM_EMAIL)
        self.mail.subject = self.subject
        self.mail.template_id = self.template_id
        personalization = Personalization()
        personalization.add_to(Email(self.user.email))
        self.mail.add_personalization(personalization)

    def send_email(self):
        self.create_email()
        try:
            sg = SendGridAPIClient(settings.SENDGRID_API_KEY)
            sg.send(self.mail)
        except Exception as e:
            logger.error('Error at %s', 'mailer', exc_info=e)
            

class RegisterMailer(BaseMailer):
    def __init__(self, to_email):
        super().__init__(to_email, subject='Welcome!', template_id=1234)

        
class NewOrderMailer(BaseMailer):
    def __init__(self, to_email):
        super().__init__(to_email, subject='New Order', template_id=5678)
```

请注意你必须在配置文件中设置 Sendgrid 的 api 密钥，以及指定需要被使用的模板的 ID，Sendrid 会直接从自己的页面中根据这个 ID 来加载指定的 html 邮件模版。

太好了！这并不困难，而且我们不用去修改发送邮件的每一行代码。

现在让我们的步子再迈大一点。

## 根据域信息定制邮件内容

当然我们发送邮件的时候，有时候可能也会使用一些域信息来填充模板。比如说，如果在欢迎邮件里面能有新用户的名字，那肯定会显得更友好。Sendgrid 允许你在邮件模板中定义变量，这些变量将替换为从我们这里接收的实际信息。所以现在让我们来添加这部分数据吧！

```Python
import logging

from django.conf import settings
from sendgrid import SendGridAPIClient, Email, Personalization
from sendgrid.helpers.mail import Mail

from users.models import User

logger = logging.getLogger('django')


class BaseMailer():
    def __init__(self, email, subject, template_id):
        self.mail = Mail()
        self.user = User.objects.get(email=email)
        self.subject = subject
        self.template_id = template_id
        self.substitutions = {
            'user_name': self.user.first_name,
            'user_surname': self.user.last_name
        }


    def create_email(self):
        self.mail.from_email = Email(settings.FROM_EMAIL)
        self.mail.subject = self.subject
        self.mail.template_id = self.template_id
        personalization = Personalization()
        personalization.add_to(Email(self.user.email))
        personalization.dynamic_template_data = self.substitutions
        self.mail.add_personalization(personalization)

    def send_email(self):
        self.create_email()
        try:
            sg = SendGridAPIClient(settings.SENDGRID_API_KEY)
            sg.send(self.mail)
        except Exception as e:
            logger.error('Error at %s', 'mailer', exc_info=e)
            

class RegisterMailer(BaseMailer):
    def __init__(self, to_email):
        super().__init__(to_email, subject='Welcome!', template_id=1234)

        
class NewOrderMailer(BaseMailer):
    def __init__(self, to_email):
        super().__init__(to_email, subject='New Order', template_id=5678)
```

这里我看到的唯一一个问题是替换方案不那么灵活。很可能会发生的情况是，我们传递的数据可能是用户根据请求的上下文访问不到的。比如说，新的订单编号、重置密码的链接等等。这些变量参数可能很多，把它们作为命名参数传递可能会让代码变得比较脏乱。我们希望的是一个基于关键字，并且长度可变的参数列表，一般来说会被定义为 **kwargs，但在此我们命名它为 **substitutions，让这个表达会更形象：

```Python
import logging

from django.conf import settings
from sendgrid import SendGridAPIClient, Email, Personalization
from sendgrid.helpers.mail import Mail

from users.models import User

logger = logging.getLogger('django')


class BaseMailer():
    def __init__(self, email, subject, template_id, **substitutions):
        self.mail = Mail()
        self.user = User.objects.get(email=email)
        self.subject = subject
        self.template_id = template_id
        self.substitutions = {
            'user_name': self.user.first_name,
            'user_surname': self.user.last_name
        }
        
        for key in substitutions:
            self.substitutions.update({key: substitutions[key]})

    def create_email(self):
        self.mail.from_email = Email(settings.FROM_EMAIL)
        self.mail.subject = self.subject
        self.mail.template_id = self.template_id
        personalization = Personalization()
        personalization.add_to(Email(self.user.email))
        personalization.dynamic_template_data = self.substitutions
        self.mail.add_personalization(personalization)

    def send_email(self):
        self.create_email()
        try:
            sg = SendGridAPIClient(settings.SENDGRID_API_KEY)
            sg.send(self.mail)
        except Exception as e:
            logger.error('Error at %s', 'mailer', exc_info=e)
            

class RegisterMailer(BaseMailer):
    def __init__(self, to_email, **substitutions):
        super().__init__(to_email, subject='Welcome!', template_id=1234, **substitutions)

        
class NewOrderMailer(BaseMailer):
    def __init__(self, to_email):
        super().__init__(to_email, subject='New Order', template_id=5678, **substitutions)
```

如果希望将额外信息传递给 mailer 类，就需要按如下编码：

```
NewOrderMailer(user.email, order_id=instance.id).send_email()
PasswordResetMailer(user.email, key=password_token.key).send_email()
```

## 总结

我们已经创建了一个灵活的 mailer 类，它将所有与电子邮件相关的代码封装在一个单独的地方，使代码维护变得更容易，并且还接收可变的上下文参数来填充电子邮件内容！一下子设计这整个方案肯定会很困难，但是我们一步一步的去实现就会简单得多，并且会在这个过程中受益良多。**我鼓励你基于这个设计，继续开发邮件附件的功能！**

非常感谢你阅读这篇文章，我希望它能对你的项目有所帮助。也请关注我即将发布的帖子，祝你人生幸运，编码愉快。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
