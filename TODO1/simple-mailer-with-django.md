> * 原文地址：[Build a Simple Mailing Service with Django](https://medium.com/python-in-plain-english/simple-mailer-with-django-2a7e2ad34b34)
> * 原文作者：[Juli Colombo](https://medium.com/@julietanataliacolombo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/simple-mailer-with-django.md](https://github.com/xitu/gold-miner/blob/master/TODO1/simple-mailer-with-django.md)
> * 译者：
> * 校对者：

# Build a Simple Mailing Service with Django

![](https://cdn-images-1.medium.com/max/3840/1*vXc5t2OrAan1o9viF-MkBQ.png)

When creating a web application, it is frequently requested to send emails: no matter if it has to be done when users sign up in our platform, or if they forget their password, or if a payment confirmation has to be sent after a purchase. The email requirement is actually very important and it can be messy if we don’t structure an email service from the beginning.

This post aims not only to help you define a flexible email service from scratch that allows you to change the email delivery platform easily, but also to be supple in terms of the content of the actual email.

I will be using [Django](https://www.djangoproject.com/) to show an example this time, but I hope the main idea can be spread to other frameworks and programming languages you might be using.

Let’s start!

## Sending a basic email

Suppose we want to send an email to a user after he or she signs up to our web application. We can use [Django’s documentation](https://docs.djangoproject.com/en/3.0/topics/email/) to send that email in the view after all validations were run and the user was created. We will come up with something like this:

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

Of course you must set up some important configurations in your settings like EMAIL_HOST and EMAIL_PORT, as the documentation says.

Great! We are already sending our welcome email!

## Create a mailer

As I said before, we will probably need to send emails in several parts of our application, so it would be nice to have an email service or mailer who handles all the email requests, making it easier to add fixes or changes, because we won’t have to search through the whole code.

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

Let’s see how our register view will look like after this change:

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

## Subclass mailers

Now that we have moved all the “email code” to a single place, we can take advantage of that! How about creating specific mailers that know what content to send when they are called? Let’s add a mailer that will get into action everytime new users sign up and another one that sends orders’ confirmations!

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

This shows that it is very easy to incorporate more mailers for different situations. You just have to let the basic mailer handle the implementation, and the subclasses set the content.

Now our register view will look much cleaner, because it doesn’t have to handle all the email stuff:

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

## Using Sendgrid

Suppose that we have to move our email backend to [Sendgrid](https://sendgrid.com/) (a customer communication platform for transactional and marketing email) using its official [python library](https://github.com/sendgrid/sendgrid-python). We won’t be using Django’s **send_email** any longer. Instead we will have to use the new library’s syntax. Well… We are lucky! We have all the code related to email management in just one place and it will be easier for us to do this refactor 😉

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

Be aware that you must set Sendgrid’s api key in your settings and also note that html templates will be managed directly from Sendrid’s web page, and you will need to have the templates’ ids to specify which one should be used.

Great! It was not so difficult and we don’t have to modify each line of code where we want to send an email!

Let’s get a little bit further now.

## Personalize email’s content with domain data

Of course when we send emails, it is likely to use some domain data to fill in the email’s template. For example, it would be friendlier if our welcome email had the new user’s name in it. Sendgrid allows you to define variables in the template that will be replaced with the actual information that receives from us. So let’s add this data!

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

The only problem I see here is that this substitutions scheme isn’t very flexible. It is likely to happen that we have to pass other data depending on the context that cannot be accessed via the user, for instance: new order’s number, reset password link, etc. There can be quite a lot of these variables and passing them as named parameters could make the code messier and dirtier. We want a keyworded, variable-length argument list, usually called ****kwargs, **but let’s name them** **substitutions** to make it more expressive:

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

In case you have to pass extra information to the mailer, you will do something like this:

```
NewOrderMailer(user.email, order_id=instance.id).send_email()
PasswordResetMailer(user.email, key=password_token.key).send_email()
```

## Summing up

We have created a flexible mailer which encapsulates all the code related to emails in one place, making it easier to maintain, and that also receives variable context parameters to fill in the email content! Thinking of the whole approach at once could be difficult, but making it step by step is simpler and the benefits are a lot. **I encourage you to add the feature of attaching files to an email using this design!**

Thank you very much for reading this post and I hope it helps you for your projects. Follow me for upcoming posts, and I wish you good luck and happy coding!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
