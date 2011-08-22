---
title: System Metrics Documentation
subtitle: Performance metrics for your Rails 3 app by simply installing a gem
layout: default
---
System Metrics is not intended to be a replacement for performance monitoring solutions such as [New Relic](http://newrelic.com/). However, it is especially handy for quickly identifying performance problems in a development environment. It's also a great alternative for private networks disconnected from the Internet.

Installation
============

To install the System Metrics gem in your Rails 3 app, add the following line to your Gemfile

{% highlight ruby %}
gem 'system-metrics'
{% endhighlight %}

You'll then need to move the System Metrics migration into your project and run it.

{% highlight ruby %}
rails generate system_metrics:migration
rake db:migrate
{% endhighlight %}

Lastly, the public assets from the System Metrics gem need to be moved into your app

{% highlight ruby %}
rails generate system_metrics:install
{% endhighlight %}

After the above setup, you can reach the System Metrics interface at /system/metrics within your app.

Setup
=====

Out of the box, System Metrics collects the more interesting performance notifications built into Rails with no configuration. However, there are a few options available to fine tune it and add your own instrumentations.

Path Exclusion Patterns
-----------------------

You can append patterns to the `path_exclude_patterns` setting if there are URLs you don't care to collect metrics about.

{% highlight ruby %}
# config/application.rb
config.system_metrics.path_exclude_patterns << /^\/admin/
{% endhighlight %}

Adding the `/^\/admin/` exclusion pattern will ensure that no metrics are collected for any path beginning with `/admin`.

Notification Exclusion Patterns
-------------------------------

You can append patterns to the `notification_exclude_patterns` setting if you notice metrics in the System Metrics interface that you don't care about. The patterns are matched against the `ActiveSupport::Notifications::Event#name`.

{% highlight ruby %}
# config/application.rb
config.system_metrics.notification_exclude_patterns << /annoying$/
{% endhighlight %}

Adding the `/annoying$/` exclusion pattern will prevent notifications whose name ends with `annoying` from being collected by System Metrics.

Instruments
-----------

Instruments are responsible for the decision to collect a notification as a metric and processing it before storage. By default, system metrics add instruments for ActionController, ActionMailer, ActionView, ActiveRecord, and a high level Rack request. However, you can easily add additional instruments to the configuration.

{% highlight ruby %}
# config/application.rb
config.system_metrics.instruments << MyCustomInstrument.new
{% endhighlight %}

Custom Instruments
==================

By default, System Metrics will collect all notifications it has not been specifically configured not to collect. Therefore, simply adding ActiveSupport::Notifications#instrument calls to your code is normally good enough. System Metrics will just start collecting these new notifications. However, if you'd like to modify the notification event payloads or be more selective about which types of notifications get collected, you'll want to write a custom instrument.

Instrument implementations require three methods, #handles?(event), #ignore?(event), and #process(event). If your needs are fairly simple, you may be able to extend SystemMetrics::Instrument::Base. Check its RDoc for details.

Below is a custom instrument for timing Sunspot searches:

{% highlight ruby %}
class SunspotInstrument
  def handles?(event)
    event.name =~ /sunspot$/
  end
  
  def ignore?(event)
    User.current.admin?
  end
  
  def process(event)
    event.payload[:user] = User.current.name
  end
end
{% endhighlight %}

This example instrument illustrates three concepts

1. It will handle any event whose name ends with sunspot.
2. It will inform SystemMetrics that the event should not be collected if the current user is an administrator.
3. It will add the current user's name to the event payload

Date/Time Ranges
================

You can change the time range of metrics shown on the dashboard and category screens using two query parameters; from and to. Consider the following examples:

{% highlight ruby %}
Show dashboard metrics from three hours ago until now
http://localhost:3000/system/metrics?from=3.hours

Show one day of dashboard metrics beginning two days ago
http://localhost:3000/system/metrics?from=2.days&to=1.day

Show one hour of category metrics ending 30 minutes ago
http://localhost:3000/system/metrics/category/active_record?from=90.minutes&to=30.minutes
{% endhighlight %}

As you might have guessed, the 'from' and 'to' query parameters take an integer and any valid method added by ActiveSupport::CoreExtensions::Numeric::Time to create a time in the past. The default 'from' time is 30 minutes and 'to' is 0 minutes (current time).

Authorization
=============

Since SystemMetrics is not recommended for production use, the lack of authorization is not likely a problem. However, it should be rather straightforward to add your own. Consider the following example implementation:

{% highlight ruby %}
# config/initializers/system_metrics_authorization.rb
module SystemMetricsAuthorization
  def self.included(base)
    base.send(:before_filter, :authorize)
  end
  
  def authorize
    # Do your authorization thing
  end
end

SystemMetrics::MetricsController.send(:include, SystemMetricsAuthorization)
{% endhighlight %}

Caveats
=======

I would not currently recommend using SystemMetrics in a production environment. There are far too many database inserts of the collected metrics to confidently say that it wouldn't impact your application's performance.

Contributing
============

System Metrics is a young project and there's still plenty to do. If you're interested in helping out, please take a look at the open issues and follow the steps described for [contributing to a project](http://help.github.com/fork-a-repo/). Your help is greatly appreciated.

Credits
=======

The idea behind System Metrics and the inspiration and source for a good portion of its code comes from José Valim's Rails Metrics project.

License
=======

System Metrics is released under the MIT license.

