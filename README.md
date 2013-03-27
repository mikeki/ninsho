#Ninsho

Ninsho is an easy flexible authentication solution when using providers

* Is a complete MVC solution based on Rails Engines;
* Works with most providers out there, Github, Facebook, Twitter, Linkedin


## Getting started

Ninsho 0.1.0 works with rails 3.1 onwards. You can add it to your Gemfile with:

```ruby
gem 'ninsho'
```

Then run the bundle command to install it.

After you install Ninsho and add it to your Gemfile, you need to run the generator:

```console
rails g ninsho:install
```

The generator will install in initializer which describes all the Ninsho's configuration options, so we recommend you take a look at it. When you are done you are ready to start the ninsho process, first you need to generate an authentications model or so:

```console
rails g ninsho MODEL
```

Before yout start generating, we are assuming you have a model to relate to, in most cases a 'User' class, just for you to be aware and that it has an email attribute.

Replace MODEL by the class name used for the app authentications, it is commonly 'Authentication'. This will create a model(if one does not exists), and add the belongs_to_ninsho method (it's commented don't worry). 

Next you'll probably want to run the migrations "rake db:migrate", as the generator will create a migration file (open it modify if you need). This generator also configures your config/routes.rb file to point to the Ninsho Controller.

### Stop right here!

Once you have the 'User' model and the 'Authentication' model, you just have to relate them:

\> app/models/user.rb

```ruby
has_many :authentications
```

\> app/models/authentication.rb

```ruby
belongs_to_ninsho :user
```

### Controller and helpers

Ninsho will create some helpers to use inside your controllers and views.

```ruby
before_filter :authenticate_user!
```

To check if the user is signed in

```ruby
user_signed_in?
```

```ruby
current_user
```

After user is signed in or signed out it will be redirected to the root_path, but you can always change this by overwriting the `redirect_on_sign_in_path` or `redirect_on_sign_out_path`

Notice if you relate the ninsho model with for example a member model, then the helpers you should use are:


```ruby
before_filter :authenticate_member!
```

To check if the user is signed in

```ruby
member_signed_in?
```

```ruby
current_member
```

### Configuring views

Since Ninsho is a Rails Engine it provides a simple view for handling the session, it is very basic so you might want to change them. In this case you can run the generator and it will copy all views to your app:

```console
rails g ninsho:views
```

### Omniauth

Ninsho plays good with many providers (some test would not hurt), such as github, facebook, twitter, linkedin, and to configure them you just need to add the omniauth-provider gem to your Gemfile like so:

```ruby
gem 'omniauth-facebook'
```

And after that if you want ninsho to respond to that, you just need to add the provider in `config/initializers/ninsho.rb`:

```ruby
config.omniauth :facebook, "APP_ID", "APP_SECRET", :scope => 'email'
```

###Custom fields

Now you have access to the hash provided by any of the omniauth providers gem, as an instance method under:

```ruby
self.auth_hash
```

So if you need to add an extra field to your ninsho model (commonly 'Authentication'), it's as easy as adding a ```before_save``` callback and handle the extra stuff by yourself. Don't get it?, here ir a quick example:

Let's say we want to save the nickname from the hash into our ninsho model:

i. Add the migration to the ninsho model

```console
rails g migration add_nickname_to_MODEL nickname:string
```
ii. Run the migration and add the callback which should look like:

```ruby
before_save :set_nickname
```

```ruby
def set_nickname
	self.nickname = self.auth_hash.info.nickname
end
```
iii. You are good to go, and any time the user changes the nickname yours will too!


### I18n

You can overwrite the ninsho locale and customize the flash messages:

```yaml
en:
  ninsho:
    sessions:
      signed_in: "Signed in successfully"
      signed_out: "Signed out successfully"            
```

###Psst! Here is a live example in rails

[Rails ninsho example](https://github.com/IcaliaLabs/ninsho_example)

### Changelog

* Current gem version 0.1.0
* Add more documentation on code
* Add aouth token for Facebook friends
* Add more flexibility to handle authentications and save to multiple fields
* Add handy helpers
* Add rails live example
* Released gem version 0.0.3
* Released gem version 0.0.2
* Released gem version 0.0.1

### Devs

* Abraham Kuri (https://github.com/kurenn)

### Future

* Add tests
* Support for Mongoid
* Add wiki



## Credits
Icalia Labs - weare@icalialabs.com

[Follow us](http://twitter.com/icalialabs "Follow us")


[Like us on Facebook](https://www.facebook.com/icalialab "Like us on Facebook")

### Special thanks

Inspired by the plataformatec guys, and pieces of code based on you! Thanks!

https://github.com/plataformatec/

### License

MIT License. Copyright 2012-2013 IcaliaLabs. http://icalialabs.com





