
Le module function signale un point d'entré unique vers une méthode indépendante
et indenpotente :

- Indépendante, aucune dépendance à une méthode héritée ou issue d'un objet mixé
  (par include / extend).
- Indenpotente, son exécution n'a pas d'effet de bord. Son résultat est
  conditionné à ses seuls arguments.

Le seul accès à un "module function" impose d'utiliser le namespace complet. Ce
style de programmation s'apparente à du procédural en environnement objet.

Tout "module function" dispose de deux accès : l'un au niveau du singleton
en visibilité publique. C'est l'accès principal à la fonction. L'autre au
niveau du module lui-même, mais en visibilité privée. Son usage est reservé à
du traitement interne auprès de l'objet vers lequel il sera mixé (include /
extend).

En aucun cas l'objet (classe ou module) qui reçoit un "module function" par
mixin (include) n'est destiné à exposer celui-ci. On garanti ainsi que l'API
publique aura une seule entrée pour cette fonction: le module (singleton) dans
lequel il est associé.


Exemples:

```ruby
module Foo
  def hello
    say_world("Hello")
  end

  # Enforce methods "as" functions. Only Foo should expose them publicly
  module_function

  def say_world(prefix)
    say_with_prefix(prefix, "World")
  end

  def say_with_prefix(first_word, second_word)
    first_word + " " + second_word
  end
end

# Normal usage, you get the singleton methods from Foo:

Foo.say_world("Hello")
# => "Hello World"

Foo.say_with_prefix("Hello", "World")
# => "Hello World"


class Bar
  include Foo
end

Bar.new.hello
# => "Hello World"

# Do I have a leak of Foo module functions? No, everything is ok!

Bar.new.say_world
# => No! You cant use it (private method from Foo)

Bar.new.say_with_prefix
# => No! You cant use it (private method from Foo)
```

What happen when use inheritance with module having _module function_ ?

```ruby
module FooBar
  include Foo
end

# Do I have a leak of Foo module functions? No, everything is ok!

FooBar.say_world
# => No! You cant use it (singleton method exist only on Foo)

FooBar.say_with_prefix
# => No! You cant use it (singleton method exist only on Foo)


class Baz
  include FooBar

  def speak
    "I will speak now: " + hello
  end
end

Baz.new.speak
# => "I will speak now: Hello World"

Baz.new.hello
# => "Hello World"

# Do I have a leak of Foo module functions? No, everything is ok!

Baz.new.say_world
# => No! You cant use it (private method from Foo)

Baz.new.say_with_prefix
# => No! You cant use it (private method from Foo)
```

Le but premier d'un "module function" n'est pas d'être utilisé en extension
d'un singleton (extend). Il n'y pas vraiment d'interêt à en faire usage, car
les méthodes ne seront pas accessibles en public de toute façon.

```ruby
module Toto
  extend Foo
end

# Do I have a leak of Foo module functions? No, everything is ok!

Toto.say_world
# => No! You cant use it (private method from Foo)

Toto.say_with_prefix
# => No! You cant use it (private method from Foo)
```




















---

Il est possible d'inclue un module contenant des module functions. Celles-ci
sont utilisable en interne uniquement. L'objet qui inclus

Si c'est une module qui inclus des modules fonctions externes, celles-ci seront
uniquement disponible à l'instanciation pour un usage interne.

Si c'est une classe qui inclus des modules functions, celles-ci seront


Par exemple, une classe qui inclus des modules functions peut les utiliser
directement (sans namespace) mais ne les exposera pas publiquement.

De même, un module qui inclus des modules functions externes pourra les utiliser
(ainsi que la classe qui l'inclus à son tour), mais n'exposera pas les fonctions
publiquement.


 des méthodes sans effet de bord et
totalement autonomes (aucune modification d'état) utilisable via le module
directement.


A _module function_ is a way to declare a method to be exclusive to a module in
a procedural way. To use it, always call the function with the module name
(namespace).

Following this paradigsme, a _module function_ should never interact with
internal state of objects (eg: instance variable), nor be mixed with other
_module functions_ using include / extend (avoid inheritance).

~~~ PAS SURE
A _module function_ should always call other _module function_ using the module
name (full namespace), even within the module itself.
~~~

When use a _module function_ ?

Independant logic widely shared in your program, exposed as public API but apart
from OOP concepts, understand: don't require instance and never used with
inheritance.

In contrast to standard modules, usage of `mixin` (extend / include) don't
expose those behaviors publicly but simply give access to it internally from
your code. This enforce the rule: the _module function_ will always be
referenced to the module which declare it, and never leak throught a class as
public method.

It is common in the Ruby community to use 3 other ways to reach the same goal,
but all 3 methods have they drawbacks.

First, using a Class Utility, understand: a Class with only class methods. It's
not the best way because the class can be instanciated but provide nothing.
Despite this, the approach is widely accepted in the Ruby community.

Second, using module with only self methods. It suffer from a similar issue but
on the inheritance topic. It's possible to include / extend a module but get
nothing because there is no method in it. In this case, you pollute your
inheritance chain.

Third, the last approach to answer the same goal is to use a standard module
which extend itself. Again, the main drawback fall in the public access to the
methods. If the module is mixed into a class (or other module), the methods leak
and your API is burred because, sudenly, your methods appear twice in the API
documentation.

It's not possible to have a method with public & private access depending it's
usage. For this, simply use a _module function_ which take care of details for
you.

Internally, _module function_ will duplicate your method. On the singleton
level, your duplicated method is public. On the object level, your method become
private.


When don't use _module function_ ?

Using _module function_ cut you off from POO (at least, without abuse of include
/ extend and deal with unwanted effects). If you need inheritance, you must keep
close with normal Module or Class Utility. In this case, document its usage
carefully.


Example

By example, to use the _module function_ nammed `say_world`, I must use the
full name `Foo.say_world`.

```ruby
module Foo
  def hello
    say_world("Hello")
  end

  # Enforce methods "as" functions. Only Foo should expose them publicly
  module_function

  def say_world(prefix)
    say_with_prefix(prefix, "World")
  end

  def say_with_prefix(first_word, second_word)
    first_word + " " + second_word
  end
end

# Normal usage, you get the singleton methods from Foo:

Foo.say_world("Hello")
# => "Hello World"

Foo.say_with_prefix("Hello", "World")
# => "Hello World"


class Bar
  include Foo
end

Bar.new.hello
# => "Hello World"

# Do I have a leak of Foo module functions? No, everything is ok!

Bar.new.say_world
# => No! You cant use it (private method from Foo)

Bar.new.say_with_prefix
# => No! You cant use it (private method from Foo)
```

What happen when use inheritance with module having _module function_ ?

```ruby
module FooBar
  include Foo
end

# Do I have a leak of Foo module functions? No, everything is ok!

FooBar.say_world
# => No! You cant use it (singleton method exist only on Foo)

FooBar.say_with_prefix
# => No! You cant use it (singleton method exist only on Foo)


class Baz
  include FooBar

  def speak
    "I will speak now: " + hello
  end
end

Baz.new.speak
# => "I will speak now: Hello World"

Baz.new.hello
# => "Hello World"

# Do I have a leak of Foo module functions? No, everything is ok!

Baz.new.say_world
# => No! You cant use it (private method from Foo)

Baz.new.say_with_prefix
# => No! You cant use it (private method from Foo)
```

And for thoses who say "Hey, test with an extend". Same. Rule is enforced.

```ruby
module Toto
  extend Foo
end

# Do I have a leak of Foo module functions? No, everything is ok!

Toto.say_world
# => No! You cant use it (private method from Foo)

Toto.say_with_prefix
# => No! You cant use it (private method from Foo)
```
