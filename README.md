# Ruby Agent (Autoscale.app)

Provides [Autoscale.app] with the necessary metrics for autoscaling web and worker processes.

## Installation

Add the gem to your `Gemfile`:

    bundle add autoscale-agent --version "~> 0"

## Usage

This gem may be used as a stand-alone agent, or as [Rack] middleware that integrates with any Rack-based web frameworks, including [Rails], [Sinatra] and [Hanami]).

Installation instructions are provided during the autoscaler setup process on [Autoscale.app].

## Related Packages

The following gems are currently available.

#### Queues (Worker Metric Functions)

| Worker Library | Repository                                              |
|----------------|---------------------------------------------------------|
| Sidekiq        | https://github.com/autoscale-app/ruby-queue-sidekiq     |
| Delayed Job    | https://github.com/autoscale-app/ruby-queue-delayed-job |
| Good Job       | https://github.com/autoscale-app/ruby-queue-good_job    |

Let us know if your preferred worker library isn't available and we'll see if we can add support.

## Development

Prepare environment:

    bin/setup

See Rake for relevant tasks:

    bin/rake -T

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/autoscale-app/ruby-agent

[Autoscale.app]: https://autoscale.app
[Agent]: https://github.com/autoscale-app/ruby-agent
[Rack]: https://github.com/rack/rack
[Rails]: https://rubyonrails.org
[Sinatra]: https://sinatrarb.com
[Hanami]: https://hanamirb.org
