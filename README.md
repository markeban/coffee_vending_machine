# Barista-matic

# Setup
There exists a bundler to (1) ensure the correct ruby version and (2) the rspec gem for running tests. In the root directory, run:
```sh
bundle install
```
You may need to install [bunder](https://bundler.io/) first.

# Start
There is a `runner.rb` file that instantiates a machine with an initial configuration. Run in the root directory:
```sh
ruby runner.rb
```

# Tests
To run the tests, in the root directory run:
```sh
rspec
```

# Technical Considerations
Before a machine dispenses a drink, the machine iterates through all base ingredients, before iterating again to use the neccessary base ingredients. This implementation was chosen over a Database like "transaction" style, where if while making a drink a base ingredient was insufficent, any already dispensed base ingredient would be put back in inventory. I thought this was impractical from a physical machine prospective - especially if the machine had already mixed some ingredients together!
