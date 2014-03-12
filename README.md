# <a name="title"></a> graphite_aws

## <a name="description"></a> Description

An opinated set of recipes for installing [Graphite][graphite] & [StatsD][statsd] on an EC2 instance via AWS OpsWorks

## <a name="instructions"></a> Instructions

### Create a new OpsWorks Stack with default options

![add_stack](https://f.cloud.github.com/assets/14196/2393403/98501c40-a990-11e3-903a-890389eb3618.png)

#### Set a custom cookbook

Point the repository url to `https://github.com/coffeeworks/graphite_aws.git`

![set_cookbook](https://f.cloud.github.com/assets/14196/2393426/6e0aef86-a991-11e3-9001-7f366f9c9b5c.png)

#### Set the statsd & graphite recipes on Deploy

![set_deploy](https://f.cloud.github.com/assets/14196/2393462/5596427e-a992-11e3-944a-609b9161e721.png)

### Add a custom Layer

![add_layer](https://f.cloud.github.com/assets/14196/2393415/01e917b0-a991-11e3-86bd-4ec3467426aa.png)

#### Add an EBS volume

![add_volume](https://f.cloud.github.com/assets/14196/2393483/ecf83f78-a992-11e3-8a4a-77d0cf6cb8f3.png)

### Add an Instance

![add_instance](https://f.cloud.github.com/assets/14196/2393471/74ccc7da-a992-11e3-9e18-1018ac2d215b.png)

(It can be as small as a t1.micro)

#### Start the instance

Graphite Web will be available on port 80.

StatsD will listen for UDP packages on port 8125.

[graphite]: http://graphite.wikidot.com/
[statsd]:   https://github.com/etsy/statsd/