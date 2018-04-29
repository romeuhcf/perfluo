# Perfluo

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/perfluo`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'perfluo'

    bot.listen /\A\z/ do
      say [
        "opa, diga lá?",
        "opa",
        "fala",
        "?"
      ].sample
    end


    bot.listen /(tu?do? b.*|vo?ce? est.*|blz).*\?/i do
      if n = remember_that?('disse_que_to_bem')
        if n > 2
          say "ja disse que to bem #{n} vezes, vc é surdo?"
        else
          say "ja disse que to bem"
        end
      else
        if remember_that?('perguntei_como_está')
          say "tudo bem"
        else
          say "td bem, e vc?"
          remember_that!('perguntei_como_está')
        end
      end
      remember_that!('disse_que_to_bem')
    end

    bot.listen /e?s?tou? bem/ do
      say "que bom"
    end

    bot.listen /\?\z/ do
      say ["oi?", "sei lá, procura do google"]
    end

    bot.listen [/bolet/, /(atra[sz]|via|novo)\//], case: :all do
      confirm("Posso emitir um boleto agora pra vc. Vc quer?", :emitir_boleto)
    end

    bot.listen // do
      say ["mano, to ocupado!", ["faz o seguinte,...", "me chama depois"] ].sample
    end

```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install perfluo

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/perfluo.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
